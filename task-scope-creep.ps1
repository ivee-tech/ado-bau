# PowerShell script for task-based scope creep detection using work effort metrics
param(
    [string]$organization = "your-org",
    [string]$project = "your-project",
    [string]$pat = "your-pat-token",
    [string]$sprintPath = "Project\Sprint X",
    [datetime]$sprintStartDate = "2025-08-26"
)

$headers = @{
    'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))
    'Content-Type' = 'application/json'
}

# Get all tasks in the sprint first, then we'll filter them based on parent information
$allTasksQuery = @"
SELECT [System.Id], [System.Parent]
FROM WorkItems
WHERE [System.WorkItemType] = 'Task'
  AND [System.IterationPath] = '$sprintPath'
"@

# Execute query to get all tasks
try {
    $allTasksResult = Invoke-RestMethod -Uri "https://dev.azure.com/$organization/$project/_apis/wit/wiql?api-version=6.0" -Method POST -Headers $headers -Body (@{query=$allTasksQuery} | ConvertTo-Json)
}
catch {
    Write-Error "Failed to execute task query: $($_.Exception.Message)"
    exit 1
}

# Get all unique parent IDs to query their AddedToIterationDate
$parentIds = @()
if ($allTasksResult.workItems.Count -gt 0) {
    $allTaskIds = $allTasksResult.workItems.id -join ','
    $allTasksDetails = Invoke-RestMethod -Uri "https://dev.azure.com/$organization/$project/_apis/wit/workitems?ids=$allTaskIds&fields=System.Parent,Microsoft.VSTS.Scheduling.OriginalEstimate,Microsoft.VSTS.Scheduling.RemainingWork,Microsoft.VSTS.Scheduling.CompletedWork,System.Title,System.State&api-version=6.0" -Headers $headers
    
    # Get unique parent IDs
    $parentIds = $allTasksDetails.value | Where-Object { $_.fields.'System.Parent' } | ForEach-Object { $_.fields.'System.Parent' } | Sort-Object -Unique
}

# Get parent work items with their AddedToIterationDate
$parentDetails = @{}
if ($parentIds.Count -gt 0) {
    $parentIdsString = $parentIds -join ','
    $parentWorkItems = Invoke-RestMethod -Uri "https://dev.azure.com/$organization/$project/_apis/wit/workitems?ids=$parentIdsString&fields=Custom.AddedToIterationDate&api-version=6.0" -Headers $headers
    
    foreach ($parent in $parentWorkItems.value) {
        $addedDate = $parent.fields.'Custom.AddedToIterationDate'
        $parentDetails[$parent.id] = if ($addedDate) { [datetime]$addedDate } else { $sprintStartDate.AddDays(-1) } # Treat null as before sprint start
    }
}

# Categorize tasks based on parent's AddedToIterationDate
$initialTasks = @()
$addedTasks = @()

foreach ($task in $allTasksDetails.value) {
    $parentId = $task.fields.'System.Parent'
    if ($parentId -and $parentDetails.ContainsKey($parentId)) {
        $parentAddedDate = $parentDetails[$parentId]
        if ($parentAddedDate -le $sprintStartDate) {
            $initialTasks += $task
        } else {
            $addedTasks += $task
        }
    } else {
        # If no parent or parent info not found, treat as initial
        $initialTasks += $task
    }
}

# Function to safely get numeric value from field
function Get-SafeNumericValue($task, $fieldName) {
    $value = $task.fields.$fieldName
    if ($null -eq $value -or $value -eq "") { return 0 }
    return [double]$value
}

# Calculate work metrics for initial tasks
$initialMetrics = @{
    OriginalEstimate = 0
    RemainingWork = 0
    CompletedWork = 0
    TotalWork = 0
}

foreach ($task in $initialTasks) {
    $originalEstimate = Get-SafeNumericValue $task 'Microsoft.VSTS.Scheduling.OriginalEstimate'
    $remainingWork = Get-SafeNumericValue $task 'Microsoft.VSTS.Scheduling.RemainingWork'
    $completedWork = Get-SafeNumericValue $task 'Microsoft.VSTS.Scheduling.CompletedWork'
    
    $initialMetrics.OriginalEstimate += $originalEstimate
    $initialMetrics.RemainingWork += $remainingWork
    $initialMetrics.CompletedWork += $completedWork
    $initialMetrics.TotalWork += ($remainingWork + $completedWork)
}

# Calculate work metrics for added tasks
$addedMetrics = @{
    OriginalEstimate = 0
    RemainingWork = 0
    CompletedWork = 0
    TotalWork = 0
}

foreach ($task in $addedTasks) {
    $originalEstimate = Get-SafeNumericValue $task 'Microsoft.VSTS.Scheduling.OriginalEstimate'
    $remainingWork = Get-SafeNumericValue $task 'Microsoft.VSTS.Scheduling.RemainingWork'
    $completedWork = Get-SafeNumericValue $task 'Microsoft.VSTS.Scheduling.CompletedWork'
    
    $addedMetrics.OriginalEstimate += $originalEstimate
    $addedMetrics.RemainingWork += $remainingWork
    $addedMetrics.CompletedWork += $completedWork
    $addedMetrics.TotalWork += ($remainingWork + $completedWork)
}

# Calculate scope creep percentages
function Calculate-ScopeCreep($initial, $added) {
    if ($initial -gt 0) {
        return ($added / $initial) * 100
    } elseif ($added -gt 0) {
        return 100  # If no initial work but added work exists, consider it 100% increase
    } else {
        return 0
    }
}

$originalEstimateCreep = Calculate-ScopeCreep $initialMetrics.OriginalEstimate $addedMetrics.OriginalEstimate
$remainingWorkCreep = Calculate-ScopeCreep $initialMetrics.RemainingWork $addedMetrics.RemainingWork
$completedWorkCreep = Calculate-ScopeCreep $initialMetrics.CompletedWork $addedMetrics.CompletedWork
$totalWorkCreep = Calculate-ScopeCreep $initialMetrics.TotalWork $addedMetrics.TotalWork

# Generate alerts based on total work scope creep
function Get-ScopeCreepAlert($percentage) {
    switch ($percentage) {
        {$_ -gt 50} { return "🔴 Critical scope creep detected ($([math]::Round($percentage,1))%) - Immediate action required" }
        {$_ -gt 25} { return "🟠 High scope creep ($([math]::Round($percentage,1))%) - Review sprint planning and capacity" }
        {$_ -gt 10} { return "🟡 Moderate scope creep ($([math]::Round($percentage,1))%) - Monitor team capacity" }
        {$_ -gt 5}  { return "🟢 Minor scope changes ($([math]::Round($percentage,1))%) - Within acceptable range" }
        default     { return "✅ Stable sprint scope maintained ($([math]::Round($percentage,1))%)" }
    }
}

$alert = Get-ScopeCreepAlert $totalWorkCreep

# Display results
Write-Output "=== Task-Based Sprint Scope Analysis ==="
Write-Output "Sprint: $sprintPath"
Write-Output "Sprint Start Date: $($sprintStartDate.ToString('yyyy-MM-dd'))"
Write-Output "Analysis Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
Write-Output ""

Write-Output "=== Task Count Summary ==="
Write-Output "Initial Sprint Tasks: $($initialTasks.Count)"
Write-Output "Added Sprint Tasks: $($addedTasks.Count)"
Write-Output "Total Tasks: $($initialTasks.Count + $addedTasks.Count)"
Write-Output ""

Write-Output "=== Work Effort Analysis (Hours) ==="
Write-Output "┌─────────────────────┬─────────────┬─────────────┬─────────────┬──────────────┐"
Write-Output "│ Metric              │ Initial     │ Added       │ Total       │ Scope Creep │"
Write-Output "├─────────────────────┼─────────────┼─────────────┼─────────────┼──────────────┤"
Write-Output "│ Original Estimate   │ $($initialMetrics.OriginalEstimate.ToString().PadLeft(11)) │ $($addedMetrics.OriginalEstimate.ToString().PadLeft(11)) │ $((($initialMetrics.OriginalEstimate + $addedMetrics.OriginalEstimate)).ToString().PadLeft(11)) │ $("$([math]::Round($originalEstimateCreep,1))%".PadLeft(12)) │"
Write-Output "│ Remaining Work      │ $($initialMetrics.RemainingWork.ToString().PadLeft(11)) │ $($addedMetrics.RemainingWork.ToString().PadLeft(11)) │ $((($initialMetrics.RemainingWork + $addedMetrics.RemainingWork)).ToString().PadLeft(11)) │ $("$([math]::Round($remainingWorkCreep,1))%".PadLeft(12)) │"
Write-Output "│ Completed Work      │ $($initialMetrics.CompletedWork.ToString().PadLeft(11)) │ $($addedMetrics.CompletedWork.ToString().PadLeft(11)) │ $((($initialMetrics.CompletedWork + $addedMetrics.CompletedWork)).ToString().PadLeft(11)) │ $("$([math]::Round($completedWorkCreep,1))%".PadLeft(12)) │"
Write-Output "│ Total Work          │ $($initialMetrics.TotalWork.ToString().PadLeft(11)) │ $($addedMetrics.TotalWork.ToString().PadLeft(11)) │ $((($initialMetrics.TotalWork + $addedMetrics.TotalWork)).ToString().PadLeft(11)) │ $("$([math]::Round($totalWorkCreep,1))%".PadLeft(12)) │"
Write-Output "└─────────────────────┴─────────────┴─────────────┴─────────────┴──────────────┘"
Write-Output ""

Write-Output "=== Scope Creep Assessment ==="
Write-Output $alert
Write-Output ""

# Calculate sprint progress metrics
$totalOriginalEstimate = $initialMetrics.OriginalEstimate + $addedMetrics.OriginalEstimate
$totalCompletedWork = $initialMetrics.CompletedWork + $addedMetrics.CompletedWork
$totalRemainingWork = $initialMetrics.RemainingWork + $addedMetrics.RemainingWork
$totalCurrentWork = $totalCompletedWork + $totalRemainingWork

if ($totalOriginalEstimate -gt 0) {
    $estimateAccuracy = ($totalOriginalEstimate / $totalCurrentWork) * 100
    Write-Output "=== Sprint Progress & Estimation Accuracy ==="
    Write-Output "Progress: $([math]::Round(($totalCompletedWork / $totalCurrentWork) * 100, 1))% completed"
    Write-Output "Estimate Accuracy: $([math]::Round($estimateAccuracy, 1))% (Original estimate vs. actual work)"
    
    if ($estimateAccuracy -lt 80) {
        Write-Output "⚠️  Estimation accuracy is low - consider reviewing estimation practices"
    } elseif ($estimateAccuracy -gt 120) {
        Write-Output "ℹ️  Work is taking less time than estimated - good estimation or scope reduction"
    } else {
        Write-Output "✅ Estimation accuracy is within acceptable range"
    }
    Write-Output ""
}

# Detailed breakdown of added tasks
if ($addedTasks.Count -gt 0) {
    Write-Output "=== Detailed Breakdown of Added Tasks ==="
    foreach ($task in $addedTasks) {
        $originalEstimate = Get-SafeNumericValue $task 'Microsoft.VSTS.Scheduling.OriginalEstimate'
        $remainingWork = Get-SafeNumericValue $task 'Microsoft.VSTS.Scheduling.RemainingWork'
        $completedWork = Get-SafeNumericValue $task 'Microsoft.VSTS.Scheduling.CompletedWork'
        
        Write-Output "Task ID: $($task.id) - $($task.fields.'System.Title')"
        Write-Output "  State: $($task.fields.'System.State')"
        Write-Output "  Original Estimate: $originalEstimate hours"
        Write-Output "  Remaining Work: $remainingWork hours"
        Write-Output "  Completed Work: $completedWork hours"
        Write-Output ""
    }
}

# Recommendations based on scope creep level
Write-Output "=== Recommendations ==="
if ($totalWorkCreep -gt 25) {
    Write-Output "• Conduct immediate sprint review with stakeholders"
    Write-Output "• Consider moving non-critical added tasks to next sprint"
    Write-Output "• Review and strengthen sprint commitment process"
    Write-Output "• Implement stricter change control procedures"
} elseif ($totalWorkCreep -gt 10) {
    Write-Output "• Monitor team capacity and burndown closely"
    Write-Output "• Document reasons for scope changes"
    Write-Output "• Consider adjusting sprint goals if necessary"
} elseif ($totalWorkCreep -gt 5) {
    Write-Output "• Continue monitoring scope changes"
    Write-Output "• Ensure team awareness of added work"
} else {
    Write-Output "• Sprint scope is well-controlled"
    Write-Output "• Continue current sprint management practices"
}

Write-Output ""
Write-Output "=== Analysis Complete ==="
Write-Output "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
