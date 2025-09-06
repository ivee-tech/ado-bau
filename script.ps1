<#
# set env var
$n = 'ZZ_BAU_PAT'
$v = '***'
[Environment]::SetEnvironmentVariable($n, $v, 'User')
#>

$organization = "ZipZappAus"
$project = "BAU"  
$sprintPath = "BAU\Release 2025\Q3 2025\Sprint 1" 
$sprintStartDate = [DateTime]"2025-09-01"
$teamName = 'Velocity Crew'
$pat = $env:ZZ_BAU_PAT

$headers = @{
    'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))
    'Content-Type' = 'application/json'
}

$sprint
$n = "Sprint Summary Dashboard"
$q = "SELECT [System.Id], [System.Title], [System.State], [Microsoft.VSTS.Scheduling.StoryPoints] FROM WorkItems WHERE [System.IterationPath] UNDER 'BAU\Release 2025\Q3 2025\Sprint 1'"
$n = 'Current Sprint Baseline Items'
$q = "SELECT [System.Id],
       [System.Title],
       [System.WorkItemType],
       [System.State],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [System.IterationPath],
       [Custom.AddedToIterationDate]
FROM WorkItems
WHERE [System.IterationPath] = @CurrentIteration('$teamName')
  AND [Custom.AddedToIterationDate] <= '$($sprintStartDate.ToString('yyyy-MM-dd'))'
  AND [System.WorkItemType] IN ('User Story', 'Issue', 'Support Request', 'Bug')
ORDER BY [System.WorkItemType], [System.Id]
"
$n = 'Current Sprint Added Items'
$q = "SELECT [System.Id],
       [System.Title],
       [System.WorkItemType],
       [System.State],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [System.IterationPath],
       [Custom.AddedToIterationDate]
FROM WorkItems
WHERE [System.IterationPath] = @CurrentIteration('$teamName')
  AND [Custom.AddedToIterationDate] > '$($sprintStartDate.ToString('yyyy-MM-dd'))'
  AND [System.WorkItemType] IN ('User Story', 'Issue', 'Support Request', 'Bug')
ORDER BY [Custom.AddedToIterationDate], [System.WorkItemType]
"
$queryBody = @{
    name = $n
    wiql = $q
} | ConvertTo-Json

$uri = "https://dev.azure.com/$organization/$project/_apis/wit/queries/Shared Queries?api-version=6.0"
Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $queryBody

$qId = 'd28c9a06-75f1-4136-8f13-12294c4c8f2b'
$uri = "https://dev.azure.com/$organization/$project/$teamName/_apis/wit/wiql/$($qId)?api-version=7.1"
$result = Invoke-RestMethod -Uri $uri -Headers $headers

.\scope-creep.ps1 -organization $organization -project $project -pat $pat -sprintPath $sprintPath -sprintStartDate $sprintStartDate

.\task-scope-creep.ps1 -organization $organization -project $project -pat $pat -sprintPath $sprintPath -sprintStartDate $sprintStartDate