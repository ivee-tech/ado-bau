# Azure DevOps Work Item Creation Script
# Based on User Story Templates and Examples
# Requires PowerShell 5.1 or later

param(
    [Parameter(Mandatory = $true)]
    [string]$Organization,
    
    [Parameter(Mandatory = $true)]
    [string]$Project,
    
    [Parameter(Mandatory = $true)]
    [string]$PersonalAccessToken,
    
    [Parameter(Mandatory = $false)]
    [string]$ApiVersion = "7.1-preview.3"
)

# Set up authentication headers
$Headers = @{
    'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$PersonalAccessToken"))
    'Content-Type' = 'application/json-patch+json'
}

$BaseUri = "https://dev.azure.com/$Organization/$Project/_apis/wit/workitems"

# Function to create a User Story work item
function New-UserStoryWorkItem {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        
        [Parameter(Mandatory = $true)]
        [string]$UserRole,
        
        [Parameter(Mandatory = $true)]
        [string]$Goal,
        
        [Parameter(Mandatory = $true)]
        [string]$Benefit,
        
        [Parameter(Mandatory = $false)]
        [string]$BackgroundContext = "",
        
        [Parameter(Mandatory = $true)]
        [string[]]$AcceptanceCriteria,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("1", "2", "3", "4")]
        [string]$Priority = "2",
        
        [Parameter(Mandatory = $false)]
        [int]$StoryPoints = 0,
        
        [Parameter(Mandatory = $false)]
        [string]$Dependencies = "",
        
        [Parameter(Mandatory = $false)]
        [string]$Notes = "",
        
        [Parameter(Mandatory = $false)]
        [string]$AssignedTo = "",
        
        [Parameter(Mandatory = $false)]
        [string]$AreaPath = "",
        
        [Parameter(Mandatory = $false)]
        [string]$IterationPath = ""
    )
    
    # Construct the description
    $Description = "As a $UserRole`nI want $Goal`nSo that $Benefit"
    
    if ($BackgroundContext) {
        $Description += "`n`n**Background/Context:**`n$BackgroundContext"
    }
    
    # Format acceptance criteria
    $AcceptanceCriteriaFormatted = "**Acceptance Criteria:**`n" + ($AcceptanceCriteria -join "`n`n")
    
    if ($Dependencies) {
        $AcceptanceCriteriaFormatted += "`n`n**Dependencies:**`n$Dependencies"
    }
    
    if ($Notes) {
        $AcceptanceCriteriaFormatted += "`n`n**Notes:**`n$Notes"
    }
    
    # Build the work item body
    $WorkItemBody = @(
        @{
            op = "add"
            path = "/fields/System.WorkItemType"
            value = "User Story"
        },
        @{
            op = "add"
            path = "/fields/System.Title"
            value = $Title
        },
        @{
            op = "add"
            path = "/fields/System.Description"
            value = $Description
        },
        @{
            op = "add"
            path = "/fields/Microsoft.VSTS.Common.AcceptanceCriteria"
            value = $AcceptanceCriteriaFormatted
        },
        @{
            op = "add"
            path = "/fields/Microsoft.VSTS.Common.Priority"
            value = $Priority
        }
    )
    
    # Add optional fields
    if ($StoryPoints -gt 0) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/Microsoft.VSTS.Scheduling.StoryPoints"
            value = $StoryPoints
        }
    }
    
    if ($AssignedTo) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.AssignedTo"
            value = $AssignedTo
        }
    }
    
    if ($AreaPath) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.AreaPath"
            value = $AreaPath
        }
    }
    
    if ($IterationPath) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.IterationPath"
            value = $IterationPath
        }
    }
    
    try {
        $Uri = "$BaseUri/`$User Story?api-version=$ApiVersion"
        $Response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $Headers -Body ($WorkItemBody | ConvertTo-Json -Depth 10)
        Write-Host "✅ Created User Story: $Title (ID: $($Response.id))" -ForegroundColor Green
        return $Response
    }
    catch {
        Write-Error "❌ Failed to create User Story '$Title': $($_.Exception.Message)"
        return $null
    }
}

# Function to create an Epic work item
function New-EpicWorkItem {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        
        [Parameter(Mandatory = $true)]
        [string]$Stakeholder,
        
        [Parameter(Mandatory = $true)]
        [string]$HighLevelGoal,
        
        [Parameter(Mandatory = $true)]
        [string]$BusinessOutcome,
        
        [Parameter(Mandatory = $true)]
        [string]$BusinessValue,
        
        [Parameter(Mandatory = $true)]
        [string[]]$SuccessCriteria,
        
        [Parameter(Mandatory = $false)]
        [string[]]$UserStories = @(),
        
        [Parameter(Mandatory = $false)]
        [string]$AcceptanceCriteria = "",
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("XS", "S", "M", "L", "XL")]
        [string]$EstimatedSize = "M",
        
        [Parameter(Mandatory = $false)]
        [string]$TargetTimeline = "",
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("1", "2", "3", "4")]
        [string]$Priority = "2",
        
        [Parameter(Mandatory = $false)]
        [string]$AssignedTo = "",
        
        [Parameter(Mandatory = $false)]
        [string]$AreaPath = "",
        
        [Parameter(Mandatory = $false)]
        [string]$IterationPath = ""
    )
    
    # Construct the description
    $Description = "As a $Stakeholder`nI want $HighLevelGoal`nSo that $BusinessOutcome"
    $Description += "`n`n**Business Value:**`n$BusinessValue"
    $Description += "`n`n**Success Criteria:**`n" + ($SuccessCriteria -join "`n")
    
    if ($UserStories.Count -gt 0) {
        $Description += "`n`n**Related User Stories:**`n" + ($UserStories -join "`n")
    }
    
    if ($AcceptanceCriteria) {
        $Description += "`n`n**Acceptance Criteria:**`n$AcceptanceCriteria"
    }
    
    if ($TargetTimeline) {
        $Description += "`n`n**Target Timeline:** $TargetTimeline"
    }
    
    $Description += "`n`n**Estimated Size:** $EstimatedSize"
    
    # Build the work item body
    $WorkItemBody = @(
        @{
            op = "add"
            path = "/fields/System.WorkItemType"
            value = "Epic"
        },
        @{
            op = "add"
            path = "/fields/System.Title"
            value = $Title
        },
        @{
            op = "add"
            path = "/fields/System.Description"
            value = $Description
        },
        @{
            op = "add"
            path = "/fields/Microsoft.VSTS.Common.Priority"
            value = $Priority
        }
    )
    
    # Add optional fields
    if ($AssignedTo) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.AssignedTo"
            value = $AssignedTo
        }
    }
    
    if ($AreaPath) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.AreaPath"
            value = $AreaPath
        }
    }
    
    if ($IterationPath) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.IterationPath"
            value = $IterationPath
        }
    }
    
    try {
        $Uri = "$BaseUri/`$Epic?api-version=$ApiVersion"
        $Response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $Headers -Body ($WorkItemBody | ConvertTo-Json -Depth 10)
        Write-Host "✅ Created Epic: $Title (ID: $($Response.id))" -ForegroundColor Green
        return $Response
    }
    catch {
        Write-Error "❌ Failed to create Epic '$Title': $($_.Exception.Message)"
        return $null
    }
}

# Function to create a Task work item
function New-TaskWorkItem {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        
        [Parameter(Mandatory = $true)]
        [string]$Description,
        
        [Parameter(Mandatory = $false)]
        [int]$ParentId = 0,
        
        [Parameter(Mandatory = $false)]
        [string[]]$AcceptanceCriteria = @(),
        
        [Parameter(Mandatory = $false)]
        [double]$EstimatedHours = 0,
        
        [Parameter(Mandatory = $false)]
        [string]$AssignedTo = "",
        
        [Parameter(Mandatory = $false)]
        [string]$Dependencies = "",
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("1", "2", "3", "4")]
        [string]$Priority = "2",
        
        [Parameter(Mandatory = $false)]
        [string]$AreaPath = "",
        
        [Parameter(Mandatory = $false)]
        [string]$IterationPath = ""
    )
    
    # Format the full description
    $FullDescription = $Description
    
    if ($AcceptanceCriteria.Count -gt 0) {
        $FullDescription += "`n`n**Acceptance Criteria:**`n" + ($AcceptanceCriteria -join "`n")
    }
    
    if ($Dependencies) {
        $FullDescription += "`n`n**Dependencies:**`n$Dependencies"
    }
    
    # Build the work item body
    $WorkItemBody = @(
        @{
            op = "add"
            path = "/fields/System.WorkItemType"
            value = "Task"
        },
        @{
            op = "add"
            path = "/fields/System.Title"
            value = $Title
        },
        @{
            op = "add"
            path = "/fields/System.Description"
            value = $FullDescription
        },
        @{
            op = "add"
            path = "/fields/Microsoft.VSTS.Common.Priority"
            value = $Priority
        }
    )
    
    # Add optional fields
    if ($EstimatedHours -gt 0) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/Microsoft.VSTS.Scheduling.OriginalEstimate"
            value = $EstimatedHours
        }
    }
    
    if ($AssignedTo) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.AssignedTo"
            value = $AssignedTo
        }
    }
    
    if ($AreaPath) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.AreaPath"
            value = $AreaPath
        }
    }
    
    if ($IterationPath) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.IterationPath"
            value = $IterationPath
        }
    }
    
    try {
        $Uri = "$BaseUri/`$Task?api-version=$ApiVersion"
        $Response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $Headers -Body ($WorkItemBody | ConvertTo-Json -Depth 10)
        
        # Link to parent if specified
        if ($ParentId -gt 0) {
            Add-WorkItemLink -SourceId $Response.id -TargetId $ParentId -LinkType "System.LinkTypes.Hierarchy-Reverse"
        }
        
        Write-Host "✅ Created Task: $Title (ID: $($Response.id))" -ForegroundColor Green
        return $Response
    }
    catch {
        Write-Error "❌ Failed to create Task '$Title': $($_.Exception.Message)"
        return $null
    }
}

# Function to create a Bug work item
function New-BugWorkItem {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        
        [Parameter(Mandatory = $true)]
        [string]$Description,
        
        [Parameter(Mandatory = $true)]
        [string[]]$StepsToReproduce,
        
        [Parameter(Mandatory = $true)]
        [string]$ExpectedBehavior,
        
        [Parameter(Mandatory = $true)]
        [string]$ActualBehavior,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("1", "2", "3", "4")]
        [string]$Priority = "3",
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("1 - Critical", "2 - High", "3 - Medium", "4 - Low")]
        [string]$Severity = "3 - Medium",
        
        [Parameter(Mandatory = $false)]
        [string]$Environment = "",
        
        [Parameter(Mandatory = $false)]
        [string]$Browser = "",
        
        [Parameter(Mandatory = $false)]
        [string]$OS = "",
        
        [Parameter(Mandatory = $false)]
        [string]$Version = "",
        
        [Parameter(Mandatory = $false)]
        [string]$Screenshots = "",
        
        [Parameter(Mandatory = $false)]
        [string[]]$AcceptanceCriteriaForFix = @(),
        
        [Parameter(Mandatory = $false)]
        [string]$AssignedTo = "",
        
        [Parameter(Mandatory = $false)]
        [string]$AreaPath = "",
        
        [Parameter(Mandatory = $false)]
        [string]$IterationPath = ""
    )
    
    # Format the full description
    $FullDescription = $Description
    $FullDescription += "`n`n**Steps to Reproduce:**"
    for ($i = 0; $i -lt $StepsToReproduce.Count; $i++) {
        $FullDescription += "`n$($i + 1). $($StepsToReproduce[$i])"
    }
    
    $FullDescription += "`n`n**Expected Behavior:**`n$ExpectedBehavior"
    $FullDescription += "`n`n**Actual Behavior:**`n$ActualBehavior"
    
    if ($Environment -or $Browser -or $OS -or $Version) {
        $FullDescription += "`n`n**Environment:**"
        if ($Browser) { $FullDescription += "`n- Browser: $Browser" }
        if ($OS) { $FullDescription += "`n- OS: $OS" }
        if ($Version) { $FullDescription += "`n- Version: $Version" }
        if ($Environment) { $FullDescription += "`n- Environment: $Environment" }
    }
    
    if ($Screenshots) {
        $FullDescription += "`n`n**Screenshots/Logs:**`n$Screenshots"
    }
    
    if ($AcceptanceCriteriaForFix.Count -gt 0) {
        $FullDescription += "`n`n**Acceptance Criteria for Fix:**`n" + ($AcceptanceCriteriaForFix -join "`n")
    }
    
    # Build the work item body
    $WorkItemBody = @(
        @{
            op = "add"
            path = "/fields/System.WorkItemType"
            value = "Bug"
        },
        @{
            op = "add"
            path = "/fields/System.Title"
            value = $Title
        },
        @{
            op = "add"
            path = "/fields/System.Description"
            value = $FullDescription
        },
        @{
            op = "add"
            path = "/fields/Microsoft.VSTS.Common.Priority"
            value = $Priority
        },
        @{
            op = "add"
            path = "/fields/Microsoft.VSTS.Common.Severity"
            value = $Severity
        }
    )
    
    # Add optional fields
    if ($AssignedTo) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.AssignedTo"
            value = $AssignedTo
        }
    }
    
    if ($AreaPath) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.AreaPath"
            value = $AreaPath
        }
    }
    
    if ($IterationPath) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.IterationPath"
            value = $IterationPath
        }
    }
    
    try {
        $Uri = "$BaseUri/`$Bug?api-version=$ApiVersion"
        $Response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $Headers -Body ($WorkItemBody | ConvertTo-Json -Depth 10)
        Write-Host "✅ Created Bug: $Title (ID: $($Response.id))" -ForegroundColor Green
        return $Response
    }
    catch {
        Write-Error "❌ Failed to create Bug '$Title': $($_.Exception.Message)"
        return $null
    }
}

# Function to create an Issue work item
function New-IssueWorkItem {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        
        [Parameter(Mandatory = $true)]
        [string]$Description,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("1", "2", "3", "4")]
        [string]$Priority = "3",
        
        [Parameter(Mandatory = $false)]
        [string]$IssueType = "General",
        
        [Parameter(Mandatory = $false)]
        [string[]]$AcceptanceCriteria = @(),
        
        [Parameter(Mandatory = $false)]
        [double]$EstimatedEffort = 0,
        
        [Parameter(Mandatory = $false)]
        [string]$AssignedTo = "",
        
        [Parameter(Mandatory = $false)]
        [string]$AreaPath = "",
        
        [Parameter(Mandatory = $false)]
        [string]$IterationPath = ""
    )
    
    # Format the full description
    $FullDescription = $Description
    
    if ($IssueType -ne "General") {
        $FullDescription = "**Issue Type:** $IssueType`n`n$Description"
    }
    
    if ($AcceptanceCriteria.Count -gt 0) {
        $FullDescription += "`n`n**Acceptance Criteria:**`n" + ($AcceptanceCriteria -join "`n")
    }
    
    if ($EstimatedEffort -gt 0) {
        $FullDescription += "`n`n**Estimated Effort:** $EstimatedEffort hours"
    }
    
    # Build the work item body
    $WorkItemBody = @(
        @{
            op = "add"
            path = "/fields/System.WorkItemType"
            value = "Issue"
        },
        @{
            op = "add"
            path = "/fields/System.Title"
            value = $Title
        },
        @{
            op = "add"
            path = "/fields/System.Description"
            value = $FullDescription
        },
        @{
            op = "add"
            path = "/fields/Microsoft.VSTS.Common.Priority"
            value = $Priority
        }
    )
    
    # Add optional fields
    if ($AssignedTo) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.AssignedTo"
            value = $AssignedTo
        }
    }
    
    if ($AreaPath) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.AreaPath"
            value = $AreaPath
        }
    }
    
    if ($IterationPath) {
        $WorkItemBody += @{
            op = "add"
            path = "/fields/System.IterationPath"
            value = $IterationPath
        }
    }
    
    try {
        $Uri = "$BaseUri/`$Issue?api-version=$ApiVersion"
        $Response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $Headers -Body ($WorkItemBody | ConvertTo-Json -Depth 10)
        Write-Host "✅ Created Issue: $Title (ID: $($Response.id))" -ForegroundColor Green
        return $Response
    }
    catch {
        Write-Error "❌ Failed to create Issue '$Title': $($_.Exception.Message)"
        return $null
    }
}

# Function to create a Support Request work item (custom work item type)
function New-SupportRequestWorkItem {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        
        [Parameter(Mandatory = $true)]
        [ValidateSet("Investigation", "Configuration", "Maintenance", "Training")]
        [string]$RequestType,
        
        [Parameter(Mandatory = $true)]
        [ValidateSet("1", "2", "3", "4")]
        [string]$Priority,
        
        [Parameter(Mandatory = $true)]
        [string]$Description,
        
        [Parameter(Mandatory = $true)]
        [string]$BusinessImpact,
        
        [Parameter(Mandatory = $true)]
        [string]$RequestedBy,
        
        [Parameter(Mandatory = $false)]
        [DateTime]$DueDate,
        
        [Parameter(Mandatory = $false)]
        [string[]]$AcceptanceCriteria = @(),
        
        [Parameter(Mandatory = $false)]
        [double]$EstimatedEffort = 0,
        
        [Parameter(Mandatory = $false)]
        [string]$AssignedTo = "",
        
        [Parameter(Mandatory = $false)]
        [string]$AreaPath = "",
        
        [Parameter(Mandatory = $false)]
        [string]$IterationPath = ""
    )
    
    # Format the full description
    $FullDescription = "**Request Type:** $RequestType`n`n"
    $FullDescription += "**Description:**`n$Description`n`n"
    $FullDescription += "**Business Impact:**`n$BusinessImpact`n`n"
    $FullDescription += "**Requested By:** $RequestedBy"
    
    if ($DueDate) {
        $FullDescription += "`n**Due Date:** $($DueDate.ToString('yyyy-MM-dd'))"
    }
    
    if ($AcceptanceCriteria.Count -gt 0) {
        $FullDescription += "`n`n**Acceptance Criteria:**`n" + ($AcceptanceCriteria -join "`n")
    }
    
    if ($EstimatedEffort -gt 0) {
        $FullDescription += "`n`n**Estimated Effort:** $EstimatedEffort hours"
    }
    
    # Try to create as Support Request, fall back to Issue if not available
    $WorkItemTypes = @("Support Request", "Issue")
    $CreatedWorkItem = $null
    
    foreach ($WorkItemType in $WorkItemTypes) {
        # Build the work item body
        $WorkItemBody = @(
            @{
                op = "add"
                path = "/fields/System.WorkItemType"
                value = $WorkItemType
            },
            @{
                op = "add"
                path = "/fields/System.Title"
                value = "$RequestType - $Title"
            },
            @{
                op = "add"
                path = "/fields/System.Description"
                value = $FullDescription
            },
            @{
                op = "add"
                path = "/fields/Microsoft.VSTS.Common.Priority"
                value = $Priority
            }
        )
        
        # Add optional fields
        if ($AssignedTo) {
            $WorkItemBody += @{
                op = "add"
                path = "/fields/System.AssignedTo"
                value = $AssignedTo
            }
        }
        
        if ($AreaPath) {
            $WorkItemBody += @{
                op = "add"
                path = "/fields/System.AreaPath"
                value = $AreaPath
            }
        }
        
        if ($IterationPath) {
            $WorkItemBody += @{
                op = "add"
                path = "/fields/System.IterationPath"
                value = $IterationPath
            }
        }
        
        try {
            $Uri = "$BaseUri/`$$($WorkItemType.Replace(' ', '%20'))?api-version=$ApiVersion"
            $Response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $Headers -Body ($WorkItemBody | ConvertTo-Json -Depth 10)
            Write-Host "✅ Created $WorkItemType`: $Title (ID: $($Response.id))" -ForegroundColor Green
            return $Response
        }
        catch {
            if ($WorkItemType -eq "Support Request") {
                Write-Warning "⚠️ Support Request work item type not available, trying Issue type..."
                continue
            }
            else {
                Write-Error "❌ Failed to create Support Request '$Title': $($_.Exception.Message)"
                return $null
            }
        }
    }
    
    return $null
}

# Function to add links between work items
function Add-WorkItemLink {
    param(
        [Parameter(Mandatory = $true)]
        [int]$SourceId,
        
        [Parameter(Mandatory = $true)]
        [int]$TargetId,
        
        [Parameter(Mandatory = $false)]
        [string]$LinkType = "System.LinkTypes.Related"
    )
    
    $LinkBody = @(
        @{
            op = "add"
            path = "/relations/-"
            value = @{
                rel = $LinkType
                url = "https://dev.azure.com/$Organization/$Project/_apis/wit/workItems/$TargetId"
            }
        }
    )
    
    try {
        $Uri = "https://dev.azure.com/$Organization/$Project/_apis/wit/workItems/$SourceId" + "?api-version=$ApiVersion"
        $Response = Invoke-RestMethod -Uri $Uri -Method Patch -Headers $Headers -Body ($LinkBody | ConvertTo-Json -Depth 10)
        Write-Host "✅ Linked work item $SourceId to $TargetId" -ForegroundColor Green
        return $Response
    }
    catch {
        Write-Error "❌ Failed to link work items: $($_.Exception.Message)"
        return $null
    }
}

function Get-WorkItemTypes {
    try {
        $v = $ApiVersion
        $v = '7.1'
        $WorkItemTypesUri = "https://dev.azure.com/$Organization/$Project/_apis/wit/workitemtypes?api-version=$v"
        Write-Host $WorkItemTypesUri
        $Response = Invoke-RestMethod -Uri $WorkItemTypesUri -Method Get -Headers $Headers
        
        return $Response
    }
    catch {
        Write-Warning "Could not check work item types: $($_.Exception.Message)"
        return $false
    }
}

# Export functions for use in other scripts
# Export-ModuleMember -Function New-UserStoryWorkItem, New-EpicWorkItem, New-TaskWorkItem, New-BugWorkItem, New-SupportRequestWorkItem, New-IssueWorkItem, Add-WorkItemLink, Get-WorkItemTypes

Write-Host "🚀 Azure DevOps Work Item Creation Functions Loaded Successfully!" -ForegroundColor Cyan
Write-Host "Available functions:" -ForegroundColor Yellow
Write-Host "  - New-UserStoryWorkItem" -ForegroundColor White
Write-Host "  - New-EpicWorkItem" -ForegroundColor White
Write-Host "  - New-TaskWorkItem" -ForegroundColor White
Write-Host "  - New-BugWorkItem" -ForegroundColor White
Write-Host "  - New-SupportRequestWorkItem" -ForegroundColor White
Write-Host "  - New-IssueWorkItem" -ForegroundColor White
Write-Host "  - Add-WorkItemLink" -ForegroundColor White
Write-Host "  - Get-WorkItemTypes" -ForegroundColor White
Write-Host ""
Write-Host "Usage example:" -ForegroundColor Yellow
Write-Host '  New-UserStoryWorkItem -Title "User Login" -UserRole "registered user" -Goal "log in with email and password" -Benefit "I can access my dashboard" -AcceptanceCriteria @("Given valid credentials, when I login, then I see my dashboard")' -ForegroundColor White
