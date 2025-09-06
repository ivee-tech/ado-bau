# Convert Issues to Support Requests Script
# This script finds Issues that should be Support Requests and converts them

param(
    [Parameter(Mandatory = $true)]
    [string]$Organization,
    
    [Parameter(Mandatory = $true)]
    [string]$Project,
    
    [Parameter(Mandatory = $true)]
    [string]$PersonalAccessToken,
    
    [Parameter(Mandatory = $false)]
    [string]$ApiVersion = "7.1-preview.3",
    
    [Parameter(Mandatory = $false)]
    [switch]$WhatIf = $false
)

# Set up authentication headers
$Headers = @{
    'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$PersonalAccessToken"))
    'Content-Type' = 'application/json-patch+json'
}

$BaseUri = "https://dev.azure.com/$Organization/$Project/_apis/wit"

# Function to get work items by query
function Get-WorkItemsByQuery {
    param(
        [string]$WiqlQuery
    )
    
    try {
        $QueryUri = "$BaseUri/wiql?api-version=$ApiVersion"
        $QueryBody = @{
            query = $WiqlQuery
        } | ConvertTo-Json
        
        $QueryResponse = Invoke-RestMethod -Uri $QueryUri -Method Post -Headers $Headers -Body $QueryBody
        
        if ($QueryResponse.workItems.Count -eq 0) {
            Write-Host "No work items found matching the criteria." -ForegroundColor Yellow
            return @()
        }
        
        # Get work item IDs
        $WorkItemIds = $QueryResponse.workItems | ForEach-Object { $_.id }
        $IdsString = $WorkItemIds -join ","
        
        # Get full work item details
        $WorkItemsUri = "$BaseUri/workitems?ids=$IdsString&`$expand=all&api-version=$ApiVersion"
        $WorkItemsResponse = Invoke-RestMethod -Uri $WorkItemsUri -Method Get -Headers $Headers
        
        return $WorkItemsResponse.value
    }
    catch {
        Write-Error "Failed to query work items: $($_.Exception.Message)"
        return @()
    }
}

# Function to check if Support Request work item type exists
function Test-SupportRequestWorkItemType {
    try {
        $v = $ApiVersion
        $v = '7.1'
        $WorkItemTypesUri = "$BaseUri/workitemtypes?api-version=$v"
        Write-Host $WorkItemTypesUri
        $Response = Invoke-RestMethod -Uri $WorkItemTypesUri -Method Get -Headers $Headers
        Write-Host $Response
        $SupportRequestType = $Response.value | Where-Object { $_.name -eq "Support Request" }
        return $SupportRequestType -ne $null
    }
    catch {
        Write-Warning "Could not check work item types: $($_.Exception.Message)"
        return $false
    }
}

# Function to convert Issue to Support Request
function Convert-IssueToSupportRequest {
    param(
        [object]$WorkItem
    )
    
    $WorkItemId = $WorkItem.id
    $CurrentTitle = $WorkItem.fields.'System.Title'
    $CurrentDescription = $WorkItem.fields.'System.Description'
    
    Write-Host "Converting Issue ID $WorkItemId`: $CurrentTitle" -ForegroundColor Cyan
    
    if ($WhatIf) {
        Write-Host "  [WHAT-IF] Would convert to Support Request" -ForegroundColor Yellow
        return $true
    }
    
    try {
        # Update work item type to Support Request
        $UpdateBody = @(
            @{
                op = "replace"
                path = "/fields/System.WorkItemType"
                value = "Support Request" # "Support Request"
            }
        )
        
        $UpdateUri = "$BaseUri/workitems/$WorkItemId" + "?api-version=$ApiVersion"
        $Response = Invoke-RestMethod -Uri $UpdateUri -Method Patch -Headers $Headers -Body ($UpdateBody | ConvertTo-Json -Depth 10)
        
        Write-Host "  ✅ Successfully converted to Support Request" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "  ❌ Failed to convert Issue ID $WorkItemId`: $($_.Exception.Message)"
        return $false
    }
}

# Function to identify Issues that should be Support Requests
function Get-IssuesToConvert {
    # WIQL query to find Issues that look like Support Requests
    $WiqlQuery = @"
SELECT [System.Id], [System.Title], [System.Description], [System.CreatedDate]
FROM WorkItems
WHERE [System.TeamProject] = '$Project'
AND [System.WorkItemType] = 'Issue'
AND (
    [System.Title] CONTAINS 'Investigation'
    OR [System.Title] CONTAINS 'Configuration'
    OR [System.Title] CONTAINS 'Maintenance'
    OR [System.Title] CONTAINS 'Training'
    OR [System.Title] CONTAINS 'Support'
    OR [System.Title] CONTAINS 'Request'
    OR [System.Description] CONTAINS 'Request Type:'
    OR [System.Description] CONTAINS 'Business Impact:'
    OR [System.Description] CONTAINS 'Requested By:'
)
ORDER BY [System.CreatedDate] DESC
"@

    return Get-WorkItemsByQuery -WiqlQuery $WiqlQuery
}

# Main execution
Write-Host "🔄 Azure DevOps Issue to Support Request Conversion Tool" -ForegroundColor Cyan
Write-Host "Organization: $Organization" -ForegroundColor Gray
Write-Host "Project: $Project" -ForegroundColor Gray

if ($WhatIf) {
    Write-Host "Mode: WHAT-IF (No changes will be made)" -ForegroundColor Yellow
} else {
    Write-Host "Mode: EXECUTION (Changes will be made)" -ForegroundColor Red
}

Write-Host ""

# Check if Support Request work item type exists
Write-Host "Checking if 'Support Request' work item type exists..." -ForegroundColor Cyan
$SupportRequestTypeExists = Test-SupportRequestWorkItemType

if (-not $SupportRequestTypeExists) {
    Write-Error "❌ 'Support Request' work item type does not exist in this project."
    Write-Host "You need to add the 'Support Request' work item type to your process template first." -ForegroundColor Yellow
    Write-Host "Alternatively, modify this script to convert to a different work item type." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ 'Support Request' work item type found." -ForegroundColor Green
Write-Host ""

# Find Issues to convert
Write-Host "Searching for Issues that should be Support Requests..." -ForegroundColor Cyan
$IssuesToConvert = Get-IssuesToConvert

if ($IssuesToConvert.Count -eq 0) {
    Write-Host "✅ No Issues found that match Support Request criteria." -ForegroundColor Green
    exit 0
}

Write-Host "Found $($IssuesToConvert.Count) Issues to potentially convert:" -ForegroundColor Yellow

# Display found issues
foreach ($Issue in $IssuesToConvert) {
    $Title = $Issue.fields.'System.Title'
    $CreatedDate = $Issue.fields.'System.CreatedDate'
    $Description = $Issue.fields.'System.Description'
    
    Write-Host "  • ID: $($Issue.id) - $Title" -ForegroundColor White
    Write-Host "    Created: $CreatedDate" -ForegroundColor Gray
    
    # Show snippet of description to help identify
    if ($Description -and $Description.Length -gt 100) {
        $Snippet = $Description.Substring(0, 100) + "..."
    } else {
        $Snippet = $Description
    }
    Write-Host "    Preview: $Snippet" -ForegroundColor Gray
    Write-Host ""
}

if (-not $WhatIf) {
    # Confirm before proceeding
    $Confirmation = Read-Host "Do you want to proceed with converting these $($IssuesToConvert.Count) Issues to Support Requests? (y/N)"
    if ($Confirmation -notmatch '^[Yy]') {
        Write-Host "❌ Conversion cancelled by user." -ForegroundColor Red
        exit 0
    }
    Write-Host ""
}

# Convert the issues
Write-Host "Converting Issues to Support Requests..." -ForegroundColor Magenta
$SuccessCount = 0
$FailCount = 0

foreach ($Issue in $IssuesToConvert) {
    if (Convert-IssueToSupportRequest -WorkItem $Issue) {
        $SuccessCount++
    } else {
        $FailCount++
    }
}

Write-Host ""
Write-Host "=== CONVERSION SUMMARY ===" -ForegroundColor Yellow
Write-Host "✅ Successfully converted: $SuccessCount" -ForegroundColor Green
Write-Host "❌ Failed conversions: $FailCount" -ForegroundColor Red
Write-Host "📊 Total processed: $($IssuesToConvert.Count)" -ForegroundColor Cyan

if ($WhatIf) {
    Write-Host ""
    Write-Host "This was a WHAT-IF run. No actual changes were made." -ForegroundColor Yellow
    Write-Host "Run the script without -WhatIf to perform the actual conversions." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✨ Conversion process complete!" -ForegroundColor Green
