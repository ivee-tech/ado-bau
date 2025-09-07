# Azure DevOps Work Item Creation

This repository contains PowerShell scripts for creating different types of work items in Azure DevOps using the REST API, based on the User Story Templates and Examples provided.

## 📁 Files Overview

### 1. `Create-AzureDevOpsWorkItems.ps1`
The main module containing functions to create different work item types:
- **New-UserStoryWorkItem** - Creates user stories following the "As a, I want, So that" format
- **New-EpicWorkItem** - Creates epics with business value and success criteria
- **New-TaskWorkItem** - Creates tasks with detailed technical requirements
- **New-BugWorkItem** - Creates bug reports with reproduction steps and environment details
- **New-SupportRequestWorkItem** - Creates support requests for investigations, maintenance, etc.
- **Add-WorkItemLink** - Links work items together (parent-child, related, etc.)

### 2. `Examples-WorkItemCreation.ps1`
Demonstrates how to use all the functions with real examples from the template document:
- Multi-Factor Authentication Epic
- Login functionality User Story
- Finance reporting User Story
- UI and API development Tasks
- Mobile app crash Bug
- Database performance Support Request

### 3. `Bulk-WorkItemCreation.ps1`
Provides bulk creation capabilities:
- **Import-WorkItemsFromCSV** - Create multiple work items from CSV file
- **New-WorkItemCSVTemplate** - Generate a sample CSV template
- **New-FeatureSet** - Create related Epic → User Stories → Tasks in one operation

## 🚀 Quick Start

### Prerequisites
1. Azure DevOps organization and project
2. Personal Access Token (PAT) with work item write permissions
3. PowerShell 5.1 or later

### Basic Usage

```powershell
# Load the main module
. ".\Create-AzureDevOpsWorkItems.ps1" -Organization "your-org" -Project "your-project" -PersonalAccessToken "your-pat"

# Create a simple user story
$UserStory = New-UserStoryWorkItem `
    -Title "User can reset password" `
    -UserRole "registered user" `
    -Goal "reset my forgotten password via email" `
    -Benefit "I can regain access to my account without contacting support" `
    -AcceptanceCriteria @(
        "Given I click 'Forgot Password', When I enter my email, Then I receive a reset link",
        "Given I click the reset link, When I enter a new password, Then my password is updated"
    ) `
    -Priority "2" `
    -StoryPoints 3
```

### Running Examples

```powershell
# Run the examples script
.\Examples-WorkItemCreation.ps1
```

### Bulk Import from CSV

```powershell
# Generate sample CSV template
.\Bulk-WorkItemCreation.ps1 -Organization "your-org" -Project "your-project" -PersonalAccessToken "your-pat"

# Import work items from CSV
.\Bulk-WorkItemCreation.ps1 -Organization "your-org" -Project "your-project" -PersonalAccessToken "your-pat" -CsvFilePath ".\WorkItemTemplate.csv"
```

## 📋 Work Item Types Supported

### Epic
```powershell
New-EpicWorkItem -Title "Epic Title" -Stakeholder "business user" -HighLevelGoal "achieve business objective" -BusinessOutcome "deliver business value" -BusinessValue "Detailed value description" -SuccessCriteria @("Criteria 1", "Criteria 2")
```

### User Story
```powershell
New-UserStoryWorkItem -Title "Story Title" -UserRole "end user" -Goal "accomplish something" -Benefit "receive value" -AcceptanceCriteria @("Given-When-Then criteria") -StoryPoints 5
```

### Task
```powershell
New-TaskWorkItem -Title "Task Title" -Description "Technical work description" -EstimatedHours 8 -ParentId 1234
```

### Bug
```powershell
New-BugWorkItem -Title "Bug Title" -Description "Bug description" -StepsToReproduce @("Step 1", "Step 2") -ExpectedBehavior "What should happen" -ActualBehavior "What actually happens" -Priority "1" -Severity "2 - High"
```

### Support Request
```powershell
New-SupportRequestWorkItem -Title "Support Title" -RequestType "Investigation" -Priority "2" -Description "Support description" -BusinessImpact "Impact description" -RequestedBy "Requester Name"
```

## 🔗 Work Item Linking

Link work items to create hierarchies:

```powershell
# Link User Story to Epic (parent-child)
Add-WorkItemLink -SourceId $UserStoryId -TargetId $EpicId -LinkType "System.LinkTypes.Hierarchy-Reverse"

# Link related work items
Add-WorkItemLink -SourceId $WorkItemId1 -TargetId $WorkItemId2 -LinkType "System.LinkTypes.Related"
```

### Common Link Types
- `System.LinkTypes.Hierarchy-Reverse` - Child to Parent
- `System.LinkTypes.Hierarchy-Forward` - Parent to Child  
- `System.LinkTypes.Related` - Related items
- `System.LinkTypes.Dependency-Forward` - Depends on
- `System.LinkTypes.Dependency-Reverse` - Dependency for

## 📊 CSV Bulk Import Format

The CSV template includes these columns:

| Column | Description | Required |
|--------|-------------|----------|
| Type | WorkItem type (Epic, UserStory, Task, Bug, Support) | Yes |
| Title | Work item title | Yes |
| UserRole | For User Stories - the user role | Conditional |
| Goal | For User Stories - the user goal | Conditional |
| Benefit | For User Stories - the benefit | Conditional |
| AcceptanceCriteria | Separated by semicolons | Yes |
| Priority | 1-4 (1=highest) | Yes |
| StoryPoints | For User Stories | Optional |
| EstimatedHours | For Tasks | Optional |
| AssignedTo | Assigned user email | Optional |
| AreaPath | Project area path | Optional |
| IterationPath | Project iteration path | Optional |

## ⚙️ Configuration

### Parameters
All scripts accept these parameters:
- `Organization` - Azure DevOps organization name
- `Project` - Project name  
- `PersonalAccessToken` - PAT with work item permissions
- `ApiVersion` - API version (defaults to "7.1-preview.3")

### Field Mappings
The scripts map template fields to Azure DevOps work item fields:
- **System.Title** - Work item title
- **System.Description** - Formatted description with context
- **Microsoft.VSTS.Common.AcceptanceCriteria** - Acceptance criteria
- **Microsoft.VSTS.Common.Priority** - Priority (1-4)
- **Microsoft.VSTS.Scheduling.StoryPoints** - Story points for User Stories
- **Microsoft.VSTS.Scheduling.OriginalEstimate** - Estimated hours for Tasks
- **Microsoft.VSTS.Common.Severity** - Bug severity

## 🔧 Customization

### Adding Custom Fields
To add custom fields, modify the `$WorkItemBody` array in each function:

```powershell
$WorkItemBody += @{
    op = "add"
    path = "/fields/Custom.FieldName"
    value = $CustomValue
}
```

### Supporting Custom Work Item Types
To support custom work item types, create new functions following the existing pattern:

```powershell
function New-CustomWorkItem {
    param(
        # Define parameters
    )
    
    $WorkItemBody = @(
        @{
            op = "add"
            path = "/fields/System.WorkItemType"
            value = "CustomType"
        }
        # Add other fields
    )
    
    $Uri = "$BaseUri/`$CustomType?api-version=$ApiVersion"
    # Rest of implementation
}
```

## 🐛 Troubleshooting

### Common Issues

1. **Authentication Errors**
   - Verify PAT has correct permissions
   - Check organization and project names
   - Ensure PAT hasn't expired

2. **Field Validation Errors**
   - Check required fields for your work item types
   - Verify field names match your process template
   - Ensure values match allowed values (e.g., Priority 1-4)

3. **Linking Errors**
   - Verify both work items exist
   - Check link type is valid for your process
   - Ensure you have permissions to link items

### Error Handling
The scripts include error handling that will:
- Display success messages in green
- Show error messages in red
- Continue processing other items if one fails
- Return null for failed operations

## 📝 Best Practices

1. **Test First** - Test with a small number of work items before bulk operations
2. **Use Templates** - Follow the established templates for consistency
3. **Validate Data** - Check CSV data before importing
4. **Backup** - Consider exporting existing work items before major changes
5. **Permissions** - Ensure appropriate permissions for all team members
6. **Linking** - Create parent items (Epics) before child items (User Stories)

## 📚 Additional Resources

- [Azure DevOps REST API Documentation](https://docs.microsoft.com/en-us/rest/api/azure/devops/)
- [Work Item Types and Fields](https://docs.microsoft.com/en-us/azure/devops/boards/work-items/)
- [Personal Access Tokens](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate)

---

## 💡 Example Workflows

### Sprint Planning Workflow
1. Create Epic for major feature
2. Break down into User Stories
3. Estimate and prioritize stories
4. Create Tasks for implementation
5. Link everything together

### Bug Triage Workflow  
1. Create Bug with detailed repro steps
2. Assign priority and severity
3. Link to related User Stories
4. Create Tasks for investigation/fix

### Support Request Workflow
1. Create Support Request with business impact
2. Investigate and create related Tasks
3. Link to any discovered Bugs
4. Update with resolution details

This comprehensive solution provides a complete toolkit for managing Azure DevOps work items using the templates and examples from your documentation.
