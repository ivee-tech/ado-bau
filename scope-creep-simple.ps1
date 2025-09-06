# Simple PowerShell script for scope creep detection - easier to test
param(
    [string]$organization = "your-org",
    [string]$project = "your-project",
    [string]$pat = "your-pat-token",
    [string]$sprintPath = "Project\Sprint X",
    [datetime]$sprintStartDate = "2025-08-26",
    [switch]$Debug
)

$headers = @{
    'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))
    'Content-Type' = 'application/json'
}

Write-Output "Testing Azure DevOps connection..."

try {
    # Test connection first with a simple query
    $testQuery = @"
SELECT [System.Id]
FROM WorkItems
WHERE [System.IterationPath] = '$sprintPath'
"@

    $testResult = Invoke-RestMethod -Uri "https://dev.azure.com/$organization/$project/_apis/wit/wiql?api-version=6.0" -Method POST -Headers $headers -Body (@{query=$testQuery} | ConvertTo-Json)
    Write-Output "✓ Connection successful. Found $($testResult.workItems.Count) items in sprint."

    if ($testResult.workItems.Count -eq 0) {
        Write-Warning "No work items found in sprint '$sprintPath'. Please verify the sprint path."
        return
    }

    # Get all items in sprint with details
    $allIds = $testResult.workItems.id -join ','
    $allItemsDetails = Invoke-RestMethod -Uri "https://dev.azure.com/$organization/$project/_apis/wit/workitems?ids=$allIds&fields=Microsoft.VSTS.Scheduling.StoryPoints,System.WorkItemType,System.CreatedDate,System.Title&api-version=6.0" -Headers $headers

    if ($Debug) {
        Write-Output "`n=== All Sprint Items Debug Info ==="
        $allItemsDetails.value | ForEach-Object {
            $createdDate = [DateTime]::Parse($_.fields.'System.CreatedDate')
            $storyPoints = $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints'
            $workItemType = $_.fields.'System.WorkItemType'
            $title = $_.fields.'System.Title'
            Write-Output "ID: $($_.id), Type: $workItemType, Created: $($createdDate.ToString('yyyy-MM-dd')), Story Points: $storyPoints, Title: $title"
        }
    }

    # Split items by creation date
    $initialItems = $allItemsDetails.value | Where-Object { 
        $createdDate = [DateTime]::Parse($_.fields.'System.CreatedDate')
        $createdDate -le $sprintStartDate
    }

    $addedItems = $allItemsDetails.value | Where-Object { 
        $createdDate = [DateTime]::Parse($_.fields.'System.CreatedDate')
        $createdDate -gt $sprintStartDate
    }

    # Calculate Story Points for User Stories only
    $initialStoryPoints = ($initialItems | Where-Object { 
        $_.fields.'System.WorkItemType' -eq 'User Story' -and 
        $null -ne $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints' 
    } | ForEach-Object { $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints' } | Measure-Object -Sum).Sum

    $addedStoryPoints = ($addedItems | Where-Object { 
        $_.fields.'System.WorkItemType' -eq 'User Story' -and 
        $null -ne $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints' 
    } | ForEach-Object { $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints' } | Measure-Object -Sum).Sum

    # Handle null values
    if ($null -eq $initialStoryPoints) { $initialStoryPoints = 0 }
    if ($null -eq $addedStoryPoints) { $addedStoryPoints = 0 }

    # Calculate scope creep
    $scopeCreepPercentage = if ($initialStoryPoints -gt 0) { ($addedStoryPoints / $initialStoryPoints) * 100 } else { 0 }

    # Generate alert
    $alert = switch ($scopeCreepPercentage) {
        {$_ -gt 30} { "🔴 High scope creep detected ($([math]::Round($scopeCreepPercentage,1))%) - Review sprint planning process" }
        {$_ -gt 15} { "🟡 Moderate scope creep ($([math]::Round($scopeCreepPercentage,1))%) - Monitor capacity impact" }
        {$_ -gt 5}  { "🟢 Minor scope changes ($([math]::Round($scopeCreepPercentage,1))%) - Within acceptable range" }
        default     { "✅ Stable sprint scope maintained ($([math]::Round($scopeCreepPercentage,1))%)" }
    }

    # Output results
    Write-Output "`n=== Sprint Scope Analysis ==="
    Write-Output "Sprint: $sprintPath"
    Write-Output "Sprint Start Date: $($sprintStartDate.ToString('yyyy-MM-dd'))"
    Write-Output ""
    Write-Output "Total Items in Sprint: $($allItemsDetails.value.Count)"
    Write-Output "Initial Items (created before sprint): $($initialItems.Count)"
    Write-Output "Added Items (created during sprint): $($addedItems.Count)"
    Write-Output ""
    Write-Output "Initial Story Points: $initialStoryPoints"
    Write-Output "Added Story Points: $addedStoryPoints"
    Write-Output "Scope Creep: $alert"

    # Show breakdown by work item type
    Write-Output "`n=== Work Item Type Breakdown ==="
    $allItemsDetails.value | Group-Object { $_.fields.'System.WorkItemType' } | ForEach-Object {
        $typeStoryPoints = ($_.Group | Where-Object { $null -ne $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints' } | ForEach-Object { $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints' } | Measure-Object -Sum).Sum
        if ($null -eq $typeStoryPoints) { $typeStoryPoints = 0 }
        Write-Output "$($_.Name): $($_.Count) items, $typeStoryPoints story points"
    }

} catch {
    Write-Error "Failed to connect to Azure DevOps: $($_.Exception.Message)"
    Write-Output "Please verify:"
    Write-Output "1. Organization name: $organization"
    Write-Output "2. Project name: $project"
    Write-Output "3. Personal Access Token (PAT) has correct permissions"
    Write-Output "4. Sprint path format: $sprintPath"
}
