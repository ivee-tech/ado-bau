# Example Usage Script for Azure DevOps Work Item Creation
# This script demonstrates how to use the Create-AzureDevOpsWorkItems.ps1 functions

# Import the main module
$org = 'ZipZappAus'
$proj = 'BAU'
$pat = $env:ZZ_BAU_PAT
. ".\Create-AzureDevOpsWorkItems.ps1" -Organization $org -Project $proj -PersonalAccessToken $pat

Get-WorkItemTypes

# Example 1: Create an Epic (Multi-Factor Authentication)
Write-Host "`n=== Creating Epic: Multi-Factor Authentication ===" -ForegroundColor Magenta

$EpicParams = @{
    Title = "Implement Multi-Factor Authentication (MFA)"
    Stakeholder = "security-conscious organization"
    HighLevelGoal = "implement multi-factor authentication across all applications"
    BusinessOutcome = "we can significantly improve security and protect against unauthorized access"
    BusinessValue = @"
- Enhanced security posture reducing risk of data breaches
- Compliance with industry security standards
- Improved customer trust and confidence
- Reduced liability from security incidents
"@
    SuccessCriteria = @(
        "95% of users successfully enrolled in MFA within 60 days",
        "Zero successful unauthorized access attempts after implementation",
        "Compliance audit score improvement of 25%",
        "User satisfaction score of 4+ out of 5 for MFA experience"
    )
    UserStories = @(
        "User can set up MFA using authenticator app",
        "User can set up MFA using SMS",
        "User can recover access when MFA device is lost",
        "Admin can enforce MFA for specific user groups"
    )
    AcceptanceCriteria = "All user stories completed and deployed, users can use multiple authentication factors, administrators have full control and visibility"
    EstimatedSize = "XL"
    TargetTimeline = "3-4 sprints (6-8 weeks)"
    Priority = "1"
}

$Epic = New-EpicWorkItem @EpicParams

# Example 2: Create User Stories related to the Epic
Write-Host "`n=== Creating User Stories ===" -ForegroundColor Magenta

# User Story 1: Login with Email and Password
$UserStoryParams1 = @{
    Title = "User can log in with email and password"
    UserRole = "registered user"
    Goal = "log in to the system using my email and password"
    Benefit = "I can access my personalized dashboard and account information"
    BackgroundContext = "Users have already registered accounts and need secure access to the system. The login system should integrate with our existing user database."
    AcceptanceCriteria = @(
        "Given I am on the login page, When I enter a valid email and password, Then I should be redirected to my dashboard And I should see my username displayed in the header",
        "Given I am on the login page, When I enter an invalid email or password, Then I should see an error message 'Invalid credentials' And I should remain on the login page",
        "Given I am on the login page, When I leave the email field empty and click login, Then I should see an error message 'Email is required'",
        "Given I am on the login page, When I leave the password field empty and click login, Then I should see an error message 'Password is required'"
    )
    Priority = "1"
    StoryPoints = 5
    Dependencies = "User registration system must be complete"
    Notes = "Consider implementing 'Remember Me' functionality in a future story"
}

$UserStory1 = New-UserStoryWorkItem @UserStoryParams1

# User Story 2: Generate Monthly Reports
$UserStoryParams2 = @{
    Title = "Finance team can generate monthly expense reports"
    UserRole = "finance team member"
    Goal = "generate monthly expense reports with filtering options"
    Benefit = "I can analyze spending patterns and prepare budget reports for management"
    BackgroundContext = "The finance team currently manually compiles expense data from multiple sources. They need an automated way to generate comprehensive reports with various filtering and export options."
    AcceptanceCriteria = @(
        "Given I am logged in as a finance team member, When I navigate to the reports section, Then I should see a 'Generate Monthly Expense Report' option",
        "Given I am on the expense report generation page, When I select a specific month and year And I click 'Generate Report', Then I should see a report showing all expenses for that month And the report should include expense categories, amounts, and dates",
        "Given I have generated an expense report, When I select specific department filters, Then the report should update to show only expenses from selected departments",
        "Given I have a generated report displayed, When I click the 'Export to Excel' button, Then an Excel file should be downloaded with the current report data",
        "Given I try to generate a report without selecting a month, When I click 'Generate Report', Then I should see an error message 'Please select a month and year'"
    )
    Priority = "2"
    StoryPoints = 8
    Dependencies = "Expense data API must be available"
    Notes = "Future enhancements could include automated email delivery of reports"
}

$UserStory2 = New-UserStoryWorkItem @UserStoryParams2

# Example 3: Create Tasks for the first User Story
Write-Host "`n=== Creating Tasks for User Story 1 ===" -ForegroundColor Magenta

if ($UserStory1) {
    # Task 1: Create login form UI
    $TaskParams1 = @{
        Title = "Create login form UI components"
        Description = "Develop the front-end login form with email and password fields, validation, and error message display capabilities."
        ParentId = $UserStory1.id
        AcceptanceCriteria = @(
            "Login form displays email and password input fields",
            "Form includes proper validation for required fields",
            "Error messages display appropriately for validation failures",
            "UI follows company design system and accessibility standards"
        )
        EstimatedHours = 8
        Priority = "1"
    }
    
    $Task1 = New-TaskWorkItem @TaskParams1
    
    # Task 2: Implement authentication API
    $TaskParams2 = @{
        Title = "Implement user authentication API endpoint"
        Description = "Create backend API endpoint for user authentication that validates credentials against the user database and returns appropriate responses."
        ParentId = $UserStory1.id
        AcceptanceCriteria = @(
            "API endpoint accepts email and password parameters",
            "Credentials are validated against existing user database",
            "Returns JWT token for successful authentication",
            "Returns appropriate error codes for invalid credentials",
            "Includes proper security measures (rate limiting, password hashing validation)"
        )
        EstimatedHours = 12
        Priority = "1"
        Dependencies = "User database schema must be finalized"
    }
    
    $Task2 = New-TaskWorkItem @TaskParams2
}

# Example 4: Create a Bug Report
Write-Host "`n=== Creating Bug Report ===" -ForegroundColor Magenta

$BugParams = @{
    Title = "Mobile app crashes when accessing user profile"
    Description = "Users are reporting that the mobile app consistently crashes when they try to access their user profile page. This is affecting user experience and preventing users from updating their information."
    StepsToReproduce = @(
        "Open the mobile app",
        "Log in with valid credentials",
        "Tap on the 'Profile' button in the navigation menu",
        "Observe the app crash"
    )
    ExpectedBehavior = "The profile page should load successfully displaying the user's current profile information."
    ActualBehavior = "The mobile app crashes immediately when the Profile button is tapped."
    Priority = "1"
    Severity = "2 - High"
    Environment = "Production"
    OS = "iOS 16.0+, Android 12+"
    Version = "Mobile App v2.1.3"
    Screenshots = "Crash logs attached showing memory access violation in ProfileViewController"
    AcceptanceCriteriaForFix = @(
        "Given I am using the mobile app, When I tap on the 'Profile' button, Then the profile page should load successfully And I should see my current profile information",
        "Given I am on the profile page, When I scroll through my profile information, Then the app should remain stable and responsive",
        "Given I am on the profile page, When I tap 'Edit Profile', Then the edit form should load without crashing"
    )
}

$Bug = New-BugWorkItem @BugParams

# Example 5: Create a Support Request
Write-Host "`n=== Creating Support Request ===" -ForegroundColor Magenta

$SupportParams = @{
    Title = "Investigate slow database query performance"
    RequestType = "Investigation"
    Priority = "2"
    Description = "Users are reporting slow application response times, particularly when loading dashboard data. Database monitoring shows some queries are taking 10+ seconds to complete."
    BusinessImpact = "Application performance degradation is affecting user productivity and customer satisfaction. Approximately 200+ users are experiencing slow response times during peak hours."
    RequestedBy = "System Administrator - John Smith"
    DueDate = (Get-Date).AddDays(7)
    AcceptanceCriteria = @(
        "Database performance analysis completed with identified bottlenecks",
        "Query optimization recommendations provided",
        "Performance improvements implemented with average query time under 2 seconds",
        "24-hour monitoring report shows stable performance"
    )
    EstimatedEffort = 16
}

$SupportRequest = New-SupportRequestWorkItem @SupportParams

# Example 6: Link User Stories to Epic
Write-Host "`n=== Linking Work Items ===" -ForegroundColor Magenta

if ($Epic -and $UserStory1) {
    Add-WorkItemLink -SourceId $UserStory1.id -TargetId $Epic.id -LinkType "System.LinkTypes.Hierarchy-Reverse"
}

if ($Epic -and $UserStory2) {
    Add-WorkItemLink -SourceId $UserStory2.id -TargetId $Epic.id -LinkType "System.LinkTypes.Hierarchy-Reverse"
}

Write-Host "`n🎉 Example work items created successfully!" -ForegroundColor Green
Write-Host "Check your Azure DevOps project to see the created work items." -ForegroundColor Cyan

# Summary of created work items
Write-Host "`n=== Summary of Created Work Items ===" -ForegroundColor Yellow
if ($Epic) { Write-Host "Epic: $($Epic.fields.'System.Title') (ID: $($Epic.id))" }
if ($UserStory1) { Write-Host "User Story 1: $($UserStory1.fields.'System.Title') (ID: $($UserStory1.id))" }
if ($UserStory2) { Write-Host "User Story 2: $($UserStory2.fields.'System.Title') (ID: $($UserStory2.id))" }
if ($Task1) { Write-Host "Task 1: $($Task1.fields.'System.Title') (ID: $($Task1.id))" }
if ($Task2) { Write-Host "Task 2: $($Task2.fields.'System.Title') (ID: $($Task2.id))" }
if ($Bug) { Write-Host "Bug: $($Bug.fields.'System.Title') (ID: $($Bug.id))" }
if ($SupportRequest) { Write-Host "Support Request: $($SupportRequest.fields.'System.Title') (ID: $($SupportRequest.id))" }
