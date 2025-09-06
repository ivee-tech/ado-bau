# Example script demonstrating New-IssueWorkItem and improved New-SupportRequestWorkItem

# Import the main module with specific organization details
$org = 'ZipZappAus'
$proj = 'BAU'
$pat = $env:ZZ_BAU_PAT
. ".\Create-AzureDevOpsWorkItems.ps1" -Organization $org -Project $proj -PersonalAccessToken $pat

# Preview what would be converted
.\Convert-IssuesToSupportRequests.ps1 -Organization $org -Project $proj -PersonalAccessToken $pat -WhatIf
$Response = Get-Content -Path ./workitemtypes.json -Raw | ConvertFrom-Json -Depth 20 -AsHashtable
$SupportRequestType = $Response.value | Where-Object { $_.name -eq "Support Request" }
$SupportRequestType

# Actually convert them
.\Convert-IssuesToSupportRequests.ps1 -Organization $org -Project $proj -PersonalAccessToken $pat

. .\Convert-IssuesToSupportRequests.ps1
Get-WorkItemTypes

Write-Host "🚀 Demonstrating New-IssueWorkItem and New-SupportRequestWorkItem cmdlets" -ForegroundColor Cyan

# ============================================================================
# ISSUES (3) - Using the new New-IssueWorkItem function
# ============================================================================

Write-Host "`n=== Creating Issues with New-IssueWorkItem ===" -ForegroundColor Magenta

# Issue 1: Technical Debt
$IssueParams1 = @{
    Title = "Refactor legacy authentication module"
    Description = "The current authentication module uses outdated practices and needs refactoring to improve security and maintainability. This technical debt is impacting development velocity."
    Priority = "2"
    IssueType = "Technical Debt"
    AcceptanceCriteria = @(
        "Authentication module refactored using modern security practices",
        "Unit tests added with 90%+ code coverage",
        "Documentation updated to reflect new implementation",
        "Performance benchmarks show no regression"
    )
    EstimatedEffort = 32
}

$Issue1 = New-IssueWorkItem @IssueParams1

# Issue 2: Process Improvement
$IssueParams2 = @{
    Title = "Implement automated code review checklist"
    Description = "Development team needs a standardized, automated code review process to ensure consistency and quality across all pull requests."
    Priority = "3"
    IssueType = "Process Improvement"
    AcceptanceCriteria = @(
        "Automated code review checklist integrated with PR process",
        "Team trained on new review standards",
        "Code quality metrics baseline established",
        "Review time reduced by 25%"
    )
    EstimatedEffort = 16
}

$Issue2 = New-IssueWorkItem @IssueParams2

# Issue 3: General Issue
$IssueParams3 = @{
    Title = "Evaluate new monitoring tools for production systems"
    Description = "Current monitoring solution has limitations in alerting and dashboard capabilities. Need to evaluate alternatives and provide recommendations."
    Priority = "3"
    AcceptanceCriteria = @(
        "At least 3 monitoring solutions evaluated",
        "Comparison matrix created with pros/cons",
        "Cost analysis completed",
        "Migration plan drafted for recommended solution"
    )
    EstimatedEffort = 24
}

$Issue3 = New-IssueWorkItem @IssueParams3

# ============================================================================
# SUPPORT REQUESTS (3) - Using the improved New-SupportRequestWorkItem
# ============================================================================

Write-Host "`n=== Creating Support Requests with Improved New-SupportRequestWorkItem ===" -ForegroundColor Magenta

# Support Request 1: Investigation
$SupportParams1 = @{
    Title = "Analyze unusual network traffic patterns"
    RequestType = "Investigation"
    Priority = "2"
    Description = "Security team has identified unusual network traffic patterns during off-hours. Need immediate investigation to determine if this represents a security threat."
    BusinessImpact = "Potential security breach could compromise sensitive customer data and result in regulatory violations and loss of customer trust."
    RequestedBy = "Security Manager - Alice Johnson"
    DueDate = (Get-Date).AddDays(3)
    AcceptanceCriteria = @(
        "Network traffic logs analyzed for the past 30 days",
        "Unusual patterns documented and explained",
        "Security recommendations provided",
        "Incident response plan activated if threat confirmed"
    )
    EstimatedEffort = 16
}

$SupportRequest1 = New-SupportRequestWorkItem @SupportParams1

# Support Request 2: Configuration
$SupportParams2 = @{
    Title = "Configure disaster recovery site"
    RequestType = "Configuration"
    Priority = "1"
    Description = "New disaster recovery site needs to be configured and tested to ensure business continuity capabilities meet RTO/RPO requirements."
    BusinessImpact = "Without proper disaster recovery, business operations could be severely impacted in case of primary site failure, potentially resulting in significant revenue loss."
    RequestedBy = "Infrastructure Manager - Bob Wilson"
    DueDate = (Get-Date).AddDays(30)
    AcceptanceCriteria = @(
        "DR site hardware and software configured",
        "Data replication established and tested",
        "Failover procedures documented and tested",
        "Recovery time objectives validated"
    )
    EstimatedEffort = 80
}

$SupportRequest2 = New-SupportRequestWorkItem @SupportParams2

# Support Request 3: Maintenance
$SupportParams3 = @{
    Title = "Perform quarterly security patching"
    RequestType = "Maintenance"
    Priority = "2"
    Description = "Quarterly security patching cycle needs to be executed across all production servers to address recently published CVE vulnerabilities."
    BusinessImpact = "Unpatched systems pose security risks and could lead to successful attacks, data breaches, and compliance violations."
    RequestedBy = "System Administrator - Carol Davis"
    DueDate = (Get-Date).AddDays(14)
    AcceptanceCriteria = @(
        "All critical and high-severity patches applied",
        "Systems tested post-patching for functionality",
        "Patch management documentation updated",
        "Vulnerability scan confirms issues addressed"
    )
    EstimatedEffort = 24
}

$SupportRequest3 = New-SupportRequestWorkItem @SupportParams3

# ============================================================================
# DEMONSTRATION OF DIFFERENCES
# ============================================================================

Write-Host "`n=== Key Differences Between Issues and Support Requests ===" -ForegroundColor Yellow

Write-Host "`n📋 Issues are best for:" -ForegroundColor Cyan
Write-Host "  • Technical debt and code improvements" -ForegroundColor White
Write-Host "  • Process improvements and standardization" -ForegroundColor White
Write-Host "  • Research and evaluation tasks" -ForegroundColor White
Write-Host "  • General problems without specific business impact" -ForegroundColor White

Write-Host "`n🎫 Support Requests are best for:" -ForegroundColor Cyan
Write-Host "  • Business-critical operational tasks" -ForegroundColor White
Write-Host "  • Time-sensitive investigations" -ForegroundColor White
Write-Host "  • Infrastructure maintenance and configuration" -ForegroundColor White
Write-Host "  • Requests with clear business impact and stakeholders" -ForegroundColor White

Write-Host "`n🔧 New-SupportRequestWorkItem improvements:" -ForegroundColor Green
Write-Host "  ✅ Tries to create actual 'Support Request' work item type first" -ForegroundColor White
Write-Host "  ✅ Falls back to 'Issue' if Support Request type isn't available" -ForegroundColor White
Write-Host "  ✅ Provides clear feedback on which type was created" -ForegroundColor White
Write-Host "  ✅ Better error handling and logging" -ForegroundColor White

# ============================================================================
# SUMMARY
# ============================================================================

Write-Host "`n🎉 Demonstration completed successfully!" -ForegroundColor Green

$CreatedItems = @()
if ($Issue1) { $CreatedItems += @{Type="Issue"; Item=$Issue1} }
if ($Issue2) { $CreatedItems += @{Type="Issue"; Item=$Issue2} }
if ($Issue3) { $CreatedItems += @{Type="Issue"; Item=$Issue3} }
if ($SupportRequest1) { $CreatedItems += @{Type="Support Request"; Item=$SupportRequest1} }
if ($SupportRequest2) { $CreatedItems += @{Type="Support Request"; Item=$SupportRequest2} }
if ($SupportRequest3) { $CreatedItems += @{Type="Support Request"; Item=$SupportRequest3} }

Write-Host "`n=== CREATED WORK ITEMS ===" -ForegroundColor Yellow
foreach ($Created in $CreatedItems) {
    $WorkItemType = $Created.Item.fields.'System.WorkItemType'
    Write-Host "  • $($Created.Type) (created as $WorkItemType): $($Created.Item.fields.'System.Title') (ID: $($Created.Item.id))" -ForegroundColor White
}

Write-Host "`n📝 Use the Convert-IssuesToSupportRequests.ps1 script to convert any Issues that should be Support Requests!" -ForegroundColor Cyan
