# Azure DevOps Work Item Batch Creation Script
# This script demonstrates bulk creation of work items from structured data

# Import the main module
param(
    [Parameter(Mandatory = $true)]
    [string]$Organization,
    
    [Parameter(Mandatory = $true)]
    [string]$Project,
    
    [Parameter(Mandatory = $true)]
    [string]$PersonalAccessToken,
    
    [Parameter(Mandatory = $false)]
    [string]$CsvFilePath = ""
)

. ".\Create-AzureDevOpsWorkItems.ps1" -Organization $Organization -Project $Project -PersonalAccessToken $PersonalAccessToken

# Function to create work items from CSV data
function Import-WorkItemsFromCSV {
    param(
        [Parameter(Mandatory = $true)]
        [string]$CsvPath
    )
    
    if (-not (Test-Path $CsvPath)) {
        Write-Error "CSV file not found: $CsvPath"
        return
    }
    
    $WorkItems = Import-Csv $CsvPath
    $CreatedItems = @()
    
    foreach ($Item in $WorkItems) {
        try {
            switch ($Item.Type.ToLower()) {
                "epic" {
                    $EpicParams = @{
                        Title = $Item.Title
                        Stakeholder = $Item.Stakeholder
                        HighLevelGoal = $Item.Goal
                        BusinessOutcome = $Item.Outcome
                        BusinessValue = $Item.BusinessValue
                        SuccessCriteria = ($Item.SuccessCriteria -split ';')
                        Priority = $Item.Priority
                    }
                    
                    if ($Item.AssignedTo) { $EpicParams.AssignedTo = $Item.AssignedTo }
                    if ($Item.AreaPath) { $EpicParams.AreaPath = $Item.AreaPath }
                    if ($Item.IterationPath) { $EpicParams.IterationPath = $Item.IterationPath }
                    
                    $Result = New-EpicWorkItem @EpicParams
                    $CreatedItems += @{ Type = "Epic"; Id = $Result.id; Title = $Item.Title; Object = $Result }
                }
                
                "userstory" {
                    $UserStoryParams = @{
                        Title = $Item.Title
                        UserRole = $Item.UserRole
                        Goal = $Item.Goal
                        Benefit = $Item.Benefit
                        AcceptanceCriteria = ($Item.AcceptanceCriteria -split ';')
                        Priority = $Item.Priority
                    }
                    
                    if ($Item.BackgroundContext) { $UserStoryParams.BackgroundContext = $Item.BackgroundContext }
                    if ($Item.StoryPoints) { $UserStoryParams.StoryPoints = [int]$Item.StoryPoints }
                    if ($Item.Dependencies) { $UserStoryParams.Dependencies = $Item.Dependencies }
                    if ($Item.Notes) { $UserStoryParams.Notes = $Item.Notes }
                    if ($Item.AssignedTo) { $UserStoryParams.AssignedTo = $Item.AssignedTo }
                    if ($Item.AreaPath) { $UserStoryParams.AreaPath = $Item.AreaPath }
                    if ($Item.IterationPath) { $UserStoryParams.IterationPath = $Item.IterationPath }
                    
                    $Result = New-UserStoryWorkItem @UserStoryParams
                    $CreatedItems += @{ Type = "UserStory"; Id = $Result.id; Title = $Item.Title; Object = $Result }
                }
                
                "task" {
                    $TaskParams = @{
                        Title = $Item.Title
                        Description = $Item.Description
                        AcceptanceCriteria = ($Item.AcceptanceCriteria -split ';')
                        Priority = $Item.Priority
                    }
                    
                    if ($Item.EstimatedHours) { $TaskParams.EstimatedHours = [double]$Item.EstimatedHours }
                    if ($Item.Dependencies) { $TaskParams.Dependencies = $Item.Dependencies }
                    if ($Item.AssignedTo) { $TaskParams.AssignedTo = $Item.AssignedTo }
                    if ($Item.AreaPath) { $TaskParams.AreaPath = $Item.AreaPath }
                    if ($Item.IterationPath) { $TaskParams.IterationPath = $Item.IterationPath }
                    if ($Item.ParentId) { $TaskParams.ParentId = [int]$Item.ParentId }
                    
                    $Result = New-TaskWorkItem @TaskParams
                    $CreatedItems += @{ Type = "Task"; Id = $Result.id; Title = $Item.Title; Object = $Result }
                }
                
                "bug" {
                    $BugParams = @{
                        Title = $Item.Title
                        Description = $Item.Description
                        StepsToReproduce = ($Item.StepsToReproduce -split ';')
                        ExpectedBehavior = $Item.ExpectedBehavior
                        ActualBehavior = $Item.ActualBehavior
                        Priority = $Item.Priority
                    }
                    
                    if ($Item.Severity) { $BugParams.Severity = $Item.Severity }
                    if ($Item.Environment) { $BugParams.Environment = $Item.Environment }
                    if ($Item.Browser) { $BugParams.Browser = $Item.Browser }
                    if ($Item.OS) { $BugParams.OS = $Item.OS }
                    if ($Item.Version) { $BugParams.Version = $Item.Version }
                    if ($Item.Screenshots) { $BugParams.Screenshots = $Item.Screenshots }
                    if ($Item.AcceptanceCriteriaForFix) { $BugParams.AcceptanceCriteriaForFix = ($Item.AcceptanceCriteriaForFix -split ';') }
                    if ($Item.AssignedTo) { $BugParams.AssignedTo = $Item.AssignedTo }
                    if ($Item.AreaPath) { $BugParams.AreaPath = $Item.AreaPath }
                    if ($Item.IterationPath) { $BugParams.IterationPath = $Item.IterationPath }
                    
                    $Result = New-BugWorkItem @BugParams
                    $CreatedItems += @{ Type = "Bug"; Id = $Result.id; Title = $Item.Title; Object = $Result }
                }
                
                "support" {
                    $SupportParams = @{
                        Title = $Item.Title
                        RequestType = $Item.RequestType
                        Priority = $Item.Priority
                        Description = $Item.Description
                        BusinessImpact = $Item.BusinessImpact
                        RequestedBy = $Item.RequestedBy
                    }
                    
                    if ($Item.DueDate) { $SupportParams.DueDate = [DateTime]::Parse($Item.DueDate) }
                    if ($Item.AcceptanceCriteria) { $SupportParams.AcceptanceCriteria = ($Item.AcceptanceCriteria -split ';') }
                    if ($Item.EstimatedEffort) { $SupportParams.EstimatedEffort = [double]$Item.EstimatedEffort }
                    if ($Item.AssignedTo) { $SupportParams.AssignedTo = $Item.AssignedTo }
                    if ($Item.AreaPath) { $SupportParams.AreaPath = $Item.AreaPath }
                    if ($Item.IterationPath) { $SupportParams.IterationPath = $Item.IterationPath }
                    
                    $Result = New-SupportRequestWorkItem @SupportParams
                    $CreatedItems += @{ Type = "Support"; Id = $Result.id; Title = $Item.Title; Object = $Result }
                }
                
                default {
                    Write-Warning "Unknown work item type: $($Item.Type)"
                }
            }
        }
        catch {
            Write-Error "Failed to create work item '$($Item.Title)': $($_.Exception.Message)"
        }
    }
    
    return $CreatedItems
}

# Function to create sample CSV template
function New-WorkItemCSVTemplate {
    param(
        [Parameter(Mandatory = $true)]
        [string]$OutputPath
    )
    
    $SampleData = @"
Type,Title,UserRole,Stakeholder,Goal,Benefit,Outcome,Description,BusinessValue,SuccessCriteria,AcceptanceCriteria,StepsToReproduce,ExpectedBehavior,ActualBehavior,RequestType,BusinessImpact,RequestedBy,Priority,StoryPoints,EstimatedHours,EstimatedEffort,Dependencies,Notes,AssignedTo,AreaPath,IterationPath,BackgroundContext,Severity,Environment,Browser,OS,Version,Screenshots,AcceptanceCriteriaForFix,DueDate,ParentId
Epic,"Implement Multi-Factor Authentication","","security-conscious organization","implement multi-factor authentication across all applications","","significantly improve security and protect against unauthorized access","","Enhanced security posture reducing risk of data breaches; Compliance with industry security standards","95% of users successfully enrolled in MFA within 60 days; Zero successful unauthorized access attempts","","","","","","","","1","","","","","","","","","","","","","","","","","",""
UserStory,"User can log in with email and password","registered user","","log in to the system using my email and password","I can access my personalized dashboard and account information","","","","","Given I am on the login page When I enter a valid email and password Then I should be redirected to my dashboard; Given invalid credentials Then I should see error message","","","","","","","1","5","","","User registration system must be complete","Consider implementing Remember Me functionality","","","","Users have registered accounts and need secure access","","","","","","","","",""
Task,"Create login form UI components","","","","","","Develop the front-end login form with email and password fields validation and error message display capabilities","","","Login form displays email and password input fields; Form includes proper validation; Error messages display appropriately","","","","","","","2","","8","","","","","","","","","","","","","","","",""
Bug,"Mobile app crashes when accessing user profile","","","","","","Users are reporting that the mobile app consistently crashes when they try to access their user profile page","","","","Open the mobile app; Log in with valid credentials; Tap on Profile button; Observe crash","Profile page should load successfully displaying user information","Mobile app crashes immediately when Profile button is tapped","","","","1","","","","","","","","","","2 - High","Production","","iOS 16.0+ Android 12+","Mobile App v2.1.3","Crash logs attached","Given I tap Profile button Then profile page should load successfully","",""
Support,"Investigate slow database query performance","","","","","","Users are reporting slow application response times particularly when loading dashboard data","","","Database performance analysis completed; Query optimization recommendations provided","","","","Investigation","Application performance degradation affecting user productivity","System Administrator - John Smith","2","","","16","","","","","","","","","","","","","2025-09-08",""
"@
    
    $SampleData | Out-File -FilePath $OutputPath -Encoding UTF8
    Write-Host "✅ Sample CSV template created: $OutputPath" -ForegroundColor Green
}

# Main execution logic
if ($CsvFilePath -and (Test-Path $CsvFilePath)) {
    Write-Host "📥 Importing work items from CSV: $CsvFilePath" -ForegroundColor Cyan
    $ImportedItems = Import-WorkItemsFromCSV -CsvPath $CsvFilePath
    
    Write-Host "`n📊 Import Summary:" -ForegroundColor Yellow
    $ImportedItems | Group-Object Type | ForEach-Object {
        Write-Host "  $($_.Name): $($_.Count) items" -ForegroundColor White
    }
}
else {
    Write-Host "ℹ️  No CSV file provided. Use -CsvFilePath parameter to import from CSV." -ForegroundColor Yellow
    Write-Host "Creating sample CSV template..." -ForegroundColor Cyan
    New-WorkItemCSVTemplate -OutputPath ".\WorkItemTemplate.csv"
    Write-Host "Edit the CSV file and run the script again with -CsvFilePath parameter." -ForegroundColor Cyan
}

# Function to bulk create related work items (Epic -> User Stories -> Tasks)
function New-FeatureSet {
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$EpicData,
        
        [Parameter(Mandatory = $true)]
        [hashtable[]]$UserStoriesData,
        
        [Parameter(Mandatory = $false)]
        [hashtable[]]$TasksData = @()
    )
    
    # Create Epic
    Write-Host "Creating Epic: $($EpicData.Title)" -ForegroundColor Magenta
    $Epic = New-EpicWorkItem @EpicData
    
    if (-not $Epic) {
        Write-Error "Failed to create Epic. Aborting feature set creation."
        return
    }
    
    $CreatedUserStories = @()
    
    # Create User Stories and link to Epic
    foreach ($UserStoryData in $UserStoriesData) {
        Write-Host "Creating User Story: $($UserStoryData.Title)" -ForegroundColor Cyan
        $UserStory = New-UserStoryWorkItem @UserStoryData
        
        if ($UserStory) {
            $CreatedUserStories += $UserStory
            # Link to Epic
            Add-WorkItemLink -SourceId $UserStory.id -TargetId $Epic.id -LinkType "System.LinkTypes.Hierarchy-Reverse"
        }
    }
    
    # Create Tasks and link to User Stories
    foreach ($TaskData in $TasksData) {
        if ($TaskData.ContainsKey('UserStoryTitle')) {
            $ParentUserStory = $CreatedUserStories | Where-Object { $_.fields.'System.Title' -eq $TaskData.UserStoryTitle }
            if ($ParentUserStory) {
                $TaskData.ParentId = $ParentUserStory.id
            }
            $TaskData.Remove('UserStoryTitle')
        }
        
        Write-Host "Creating Task: $($TaskData.Title)" -ForegroundColor Gray
        $Task = New-TaskWorkItem @TaskData
    }
    
    return @{
        Epic = $Epic
        UserStories = $CreatedUserStories
    }
}

# Export additional functions
Export-ModuleMember -Function Import-WorkItemsFromCSV, New-WorkItemCSVTemplate, New-FeatureSet
