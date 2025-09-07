# PowerShell script for scope creep detection
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

# Get initial sprint items (created before sprint start)
$initialItemsQuery = @"
SELECT [System.Id],
       [System.Title],
       [System.WorkItemType],
       [System.State],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [System.IterationPath],
       [Custom.AddedToIterationDate]
FROM WorkItems
WHERE [System.IterationPath] = @CurrentIteration('[$project]\$teamName')
  AND [Custom.AddedToIterationDate] <= '$($sprintStartDate.ToString('yyyy-MM-dd'))'
  AND [System.WorkItemType] IN ('User Story', 'Issue', 'Support Request', 'Bug')
ORDER BY [System.WorkItemType], [System.Id]
"@

# Get items added during sprint
$addedItemsQuery = @"
SELECT [System.Id],
       [System.Title],
       [System.WorkItemType],
       [System.State],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [System.IterationPath],
       [Custom.AddedToIterationDate]
FROM WorkItems
WHERE [System.IterationPath] = @CurrentIteration('[$project]\$teamName')
  AND [Custom.AddedToIterationDate] > '$($sprintStartDate.ToString('yyyy-MM-dd'))'
  AND [System.WorkItemType] IN ('User Story', 'Issue', 'Support Request', 'Bug')
ORDER BY [Custom.AddedToIterationDate], [System.WorkItemType]
"@

# Execute queries and get work item details
$initialItemsResult = Invoke-RestMethod -Uri "https://dev.azure.com/$organization/$project/_apis/wit/wiql?api-version=6.0" -Method POST -Headers $headers -Body (@{query=$initialItemsQuery} | ConvertTo-Json)
$addedItemsResult = Invoke-RestMethod -Uri "https://dev.azure.com/$organization/$project/_apis/wit/wiql?api-version=6.0" -Method POST -Headers $headers -Body (@{query=$addedItemsQuery} | ConvertTo-Json)

# Get detailed work item information including Story Points
$initialItems = @()
$addedItems = @()

if ($initialItemsResult.workItems.Count -gt 0) {
    $initialIds = $initialItemsResult.workItems.id -join ','
    $initialItemsDetails = Invoke-RestMethod -Uri "https://dev.azure.com/$organization/$project/_apis/wit/workitems?ids=$initialIds&fields=Microsoft.VSTS.Scheduling.StoryPoints,System.WorkItemType&api-version=6.0" -Headers $headers
    $initialItems = $initialItemsDetails.value
}

if ($addedItemsResult.workItems.Count -gt 0) {
    $addedIds = $addedItemsResult.workItems.id -join ','
    $addedItemsDetails = Invoke-RestMethod -Uri "https://dev.azure.com/$organization/$project/_apis/wit/workitems?ids=$addedIds&fields=Microsoft.VSTS.Scheduling.StoryPoints,System.WorkItemType&api-version=6.0" -Headers $headers
    $addedItems = $addedItemsDetails.value
}

# Calculate scope creep percentage using Story Points (Agile process)
# Filter for User Stories and sum their Story Points
# $initialStoryPoints = ($initialItems | Where-Object { $_.fields.'System.WorkItemType' -eq 'User Story' } | ForEach-Object { $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints' } | Where-Object { $_ -ne $null } | Measure-Object -Sum).Sum
# $addedStoryPoints = ($addedItems | Where-Object { $_.fields.'System.WorkItemType' -eq 'User Story' } | ForEach-Object { $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints' } | Where-Object { $_ -ne $null } | Measure-Object -Sum).Sum
$initialStoryPoints = ($initialItems | ForEach-Object { $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints' } | Where-Object { $_ -ne $null } | Measure-Object -Sum).Sum
$addedStoryPoints = ($addedItems  | ForEach-Object { $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints' } | Where-Object { $_ -ne $null } | Measure-Object -Sum).Sum

# Handle null values
if ($null -eq $initialStoryPoints) { $initialStoryPoints = 0 }
if ($null -eq $addedStoryPoints) { $addedStoryPoints = 0 }
$scopeCreepPercentage = if ($initialStoryPoints -gt 0) { ($addedStoryPoints / $initialStoryPoints) * 100 } else { 0 }

# Generate alert based on percentage
$alert = switch ($scopeCreepPercentage) {
    {$_ -gt 30} { "🔴 High scope creep detected ($([math]::Round($scopeCreepPercentage,1))%) - Review sprint planning process" }
    {$_ -gt 15} { "🟡 Moderate scope creep ($([math]::Round($scopeCreepPercentage,1))%) - Monitor capacity impact" }
    {$_ -gt 5}  { "🟢 Minor scope changes ($([math]::Round($scopeCreepPercentage,1))%) - Within acceptable range" }
    default     { "✅ Stable sprint scope maintained ($([math]::Round($scopeCreepPercentage,1))%)" }
}

Write-Output "=== Sprint Scope Analysis (Story Points Based) ==="
Write-Output "Sprint: $sprintPath"
Write-Output "Sprint Start Date: $($sprintStartDate.ToString('yyyy-MM-dd'))"
Write-Output ""
Write-Output "Initial Sprint Items: $($initialItems.Count) work items"
Write-Output "Added Sprint Items: $($addedItems.Count) work items"
Write-Output ""
Write-Output "Initial Sprint Story Points: $initialStoryPoints"
Write-Output "Added Story Points: $addedStoryPoints"
Write-Output "Scope Creep: $alert"

# Debug information - show breakdown by work item type
if ($initialItems.Count -gt 0) {
    Write-Output ""
    Write-Output "=== Initial Items Breakdown ==="
    $initialItems | Group-Object { $_.fields.'System.WorkItemType' } | ForEach-Object {
        $storyPointsSum = ($_.Group | ForEach-Object { $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints' } | Where-Object { $_ -ne $null } | Measure-Object -Sum).Sum
        if ($storyPointsSum -eq $null) { $storyPointsSum = 0 }
        Write-Output "$($_.Name): $($_.Count) items, $storyPointsSum story points"
    }
}

if ($addedItems.Count -gt 0) {
    Write-Output ""
    Write-Output "=== Added Items Breakdown ==="
    $addedItems | Group-Object { $_.fields.'System.WorkItemType' } | ForEach-Object {
        $storyPointsSum = ($_.Group | ForEach-Object { $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints' } | Where-Object { $_ -ne $null } | Measure-Object -Sum).Sum
        if ($storyPointsSum -eq $null) { $storyPointsSum = 0 }
        Write-Output "$($_.Name): $($_.Count) items, $storyPointsSum story points"
    }
}

