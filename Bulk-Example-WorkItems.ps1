# Bulk Work Items Creation Example Script
# Creates 4 User Stories, 10 Support Requests, 2 Bugs, and 3 Issues

# Import the main module with specific organization details
$org = 'ZipZappAus'
$proj = 'BAU'
$pat = $env:ZZ_BAU_PAT
. ".\Create-AzureDevOpsWorkItems.ps1" -Organization $org -Project $proj -PersonalAccessToken $pat

Write-Host "🚀 Creating Bulk Work Items: 4 User Stories, 10 Support Requests, 2 Bugs, and 3 Issues" -ForegroundColor Cyan

# Arrays to store created work items
$CreatedUserStories = @()
$CreatedSupportRequests = @()
$CreatedBugs = @()
$CreatedIssues = @()

# ============================================================================
# USER STORIES (4)
# ============================================================================

Write-Host "`n=== Creating 4 User Stories ===" -ForegroundColor Magenta

# User Story 1: Customer Profile Management
$UserStoryParams1 = @{
    Title = "Customer can update their profile information"
    UserRole = "registered customer"
    Goal = "update my personal information and preferences"
    Benefit = "I can keep my account details current and receive relevant communications"
    BackgroundContext = "Customers need to maintain current contact information and communication preferences for account security and marketing purposes."
    AcceptanceCriteria = @(
        "Given I am logged in, When I navigate to 'My Profile', Then I can view my current information",
        "Given I am on the profile page, When I update my email address, Then I receive a verification email",
        "Given I am on the profile page, When I change my password, Then I must enter my current password first",
        "Given I update my profile, When I click 'Save Changes', Then I see a confirmation message"
    )
    Priority = "2"
    StoryPoints = 5
    Notes = "Include validation for email format and password strength requirements"
}

$UserStory1 = New-UserStoryWorkItem @UserStoryParams1
if ($UserStory1) { $CreatedUserStories += $UserStory1 }

# User Story 2: Order History and Tracking
$UserStoryParams2 = @{
    Title = "Customer can view order history and track shipments"
    UserRole = "customer"
    Goal = "view my past orders and track current shipments"
    Benefit = "I can monitor my purchases and plan for deliveries"
    BackgroundContext = "Customers frequently need to reference past orders and track current shipments for delivery planning and support inquiries."
    AcceptanceCriteria = @(
        "Given I am logged in, When I go to 'Order History', Then I see a list of my past orders with dates and totals",
        "Given I am viewing an order, When I click 'Track Shipment', Then I see the current shipping status",
        "Given I have multiple orders, When I use the date filter, Then I see only orders from the selected timeframe",
        "Given I am viewing order details, When I click 'Reorder', Then the items are added to my cart"
    )
    Priority = "2"
    StoryPoints = 8
    Dependencies = "Integration with shipping provider APIs required"
    Notes = "Consider including email notifications for shipping updates"
}

$UserStory2 = New-UserStoryWorkItem @UserStoryParams2
if ($UserStory2) { $CreatedUserStories += $UserStory2 }

# User Story 3: Product Search and Filtering
$UserStoryParams3 = @{
    Title = "Customer can search and filter products effectively"
    UserRole = "potential customer"
    Goal = "quickly find products that match my specific requirements"
    Benefit = "I can efficiently locate and compare products without browsing through irrelevant items"
    BackgroundContext = "Customers need advanced search capabilities to handle large product catalogs and find items matching specific criteria."
    AcceptanceCriteria = @(
        "Given I am on the product catalog, When I enter search terms, Then I see relevant products ranked by relevance",
        "Given I am viewing search results, When I apply category filters, Then results are filtered accordingly",
        "Given I am viewing products, When I sort by price or rating, Then products are reordered appropriately",
        "Given my search returns no results, When I see the empty state, Then I receive suggestions for alternative searches"
    )
    Priority = "1"
    StoryPoints = 13
    Dependencies = "Search engine integration and product categorization system"
    Notes = "Consider implementing autocomplete and search suggestions"
}

$UserStory3 = New-UserStoryWorkItem @UserStoryParams3
if ($UserStory3) { $CreatedUserStories += $UserStory3 }

# User Story 4: Shopping Cart Management
$UserStoryParams4 = @{
    Title = "Customer can manage shopping cart across sessions"
    UserRole = "online shopper"
    Goal = "save items in my cart and continue shopping later"
    Benefit = "I don't lose my selected items when I leave the site and can complete purchases at my convenience"
    BackgroundContext = "Customers often browse and add items over multiple sessions before making a purchase decision."
    AcceptanceCriteria = @(
        "Given I add items to my cart, When I log out and log back in, Then my cart items are still there",
        "Given I have items in my cart, When I update quantities, Then the total price updates automatically",
        "Given I have items in my cart, When I remove an item, Then it's removed and the total adjusts",
        "Given my cart has been inactive for 30 days, When I log in, Then I'm notified of expired cart items"
    )
    Priority = "1"
    StoryPoints = 5
    Notes = "Implement cart persistence using secure session management"
}

$UserStory4 = New-UserStoryWorkItem @UserStoryParams4
if ($UserStory4) { $CreatedUserStories += $UserStory4 }

# ============================================================================
# SUPPORT REQUESTS (10)
# ============================================================================

Write-Host "`n=== Creating 10 Support Requests ===" -ForegroundColor Magenta

# Support Request 1: Database Performance Optimization
$SupportParams1 = @{
    Title = "Optimize database queries for product catalog"
    RequestType = "Investigation"
    Priority = "2"
    Description = "Product catalog pages are loading slowly during peak hours. Database monitoring shows several queries taking 5+ seconds to complete."
    BusinessImpact = "Slow page loads are affecting customer experience and potentially impacting sales conversion rates."
    RequestedBy = "Product Manager - Sarah Johnson"
    DueDate = (Get-Date).AddDays(14)
    AcceptanceCriteria = @(
        "Database query performance analysis completed",
        "Slow queries identified and optimized",
        "Page load times reduced to under 2 seconds",
        "Performance improvements documented"
    )
    EstimatedEffort = 20
}

$Support1 = New-SupportRequestWorkItem @SupportParams1
if ($Support1) { $CreatedSupportRequests += $Support1 }

# Support Request 2: Security Audit Preparation
$SupportParams2 = @{
    Title = "Prepare systems for annual security audit"
    RequestType = "Configuration"
    Priority = "1"
    Description = "Annual security audit is scheduled for next month. Need to ensure all systems meet compliance requirements and documentation is current."
    BusinessImpact = "Failed audit could result in compliance issues, customer trust problems, and potential regulatory fines."
    RequestedBy = "Security Manager - Mike Chen"
    DueDate = (Get-Date).AddDays(21)
    AcceptanceCriteria = @(
        "All security policies reviewed and updated",
        "System access logs reviewed and cleaned up",
        "Vulnerability scan completed with issues addressed",
        "Audit documentation package prepared"
    )
    EstimatedEffort = 40
}

$Support2 = New-SupportRequestWorkItem @SupportParams2
if ($Support2) { $CreatedSupportRequests += $Support2 }

# Support Request 3: Email Server Migration
$SupportParams3 = @{
    Title = "Migrate email system to cloud provider"
    RequestType = "Maintenance"
    Priority = "2"
    Description = "Current email server infrastructure is aging and needs migration to cloud-based solution for better reliability and scalability."
    BusinessImpact = "Email downtime affects all business communications. Migration will improve reliability and reduce maintenance overhead."
    RequestedBy = "IT Director - Lisa Rodriguez"
    DueDate = (Get-Date).AddDays(45)
    AcceptanceCriteria = @(
        "Migration plan developed and approved",
        "Email data successfully migrated without loss",
        "All users transitioned to new system",
        "Old infrastructure decommissioned"
    )
    EstimatedEffort = 60
}

$Support3 = New-SupportRequestWorkItem @SupportParams3
if ($Support3) { $CreatedSupportRequests += $Support3 }

# Support Request 4: User Training on New Features
$SupportParams4 = @{
    Title = "Conduct training sessions for new dashboard features"
    RequestType = "Training"
    Priority = "3"
    Description = "New dashboard features have been deployed but user adoption is low. Need to provide training sessions for key user groups."
    BusinessImpact = "Low feature adoption means the investment in new functionality isn't providing expected business value."
    RequestedBy = "Business Analyst - Tom Wilson"
    DueDate = (Get-Date).AddDays(30)
    AcceptanceCriteria = @(
        "Training materials developed for different user roles",
        "Training sessions scheduled and conducted",
        "User feedback collected and documented",
        "Feature adoption metrics show improvement"
    )
    EstimatedEffort = 25
}

$Support4 = New-SupportRequestWorkItem @SupportParams4
if ($Support4) { $CreatedSupportRequests += $Support4 }

# Support Request 5: API Rate Limiting Investigation
$SupportParams5 = @{
    Title = "Investigate and resolve API rate limiting issues"
    RequestType = "Investigation"
    Priority = "2"
    Description = "Several integrations are hitting API rate limits causing service disruptions. Need to analyze usage patterns and implement solutions."
    BusinessImpact = "API rate limiting is causing integration failures and affecting automated business processes."
    RequestedBy = "Integration Developer - Alex Thompson"
    DueDate = (Get-Date).AddDays(10)
    AcceptanceCriteria = @(
        "API usage patterns analyzed and documented",
        "Rate limiting thresholds reviewed and optimized",
        "Retry logic implemented where appropriate",
        "Monitoring alerts configured for future issues"
    )
    EstimatedEffort = 15
}

$Support5 = New-SupportRequestWorkItem @SupportParams5
if ($Support5) { $CreatedSupportRequests += $Support5 }

# Support Request 6: Backup System Verification
$SupportParams6 = @{
    Title = "Verify and test backup system integrity"
    RequestType = "Maintenance"
    Priority = "1"
    Description = "Regular backup verification hasn't been performed in 6 months. Need to test backup integrity and restore procedures."
    BusinessImpact = "Unverified backups pose significant risk to business continuity in case of data loss scenarios."
    RequestedBy = "System Administrator - Jennifer Lee"
    DueDate = (Get-Date).AddDays(7)
    AcceptanceCriteria = @(
        "Backup integrity tests completed successfully",
        "Restore procedures tested and documented",
        "Any backup issues identified and resolved",
        "Backup verification schedule established"
    )
    EstimatedEffort = 12
}

$Support6 = New-SupportRequestWorkItem @SupportParams6
if ($Support6) { $CreatedSupportRequests += $Support6 }

# Support Request 7: Load Testing for Black Friday
$SupportParams7 = @{
    Title = "Perform load testing for Black Friday traffic"
    RequestType = "Investigation"
    Priority = "1"
    Description = "Black Friday is approaching and we need to ensure systems can handle expected traffic spikes. Perform comprehensive load testing."
    BusinessImpact = "System failures during Black Friday could result in significant revenue loss and customer dissatisfaction."
    RequestedBy = "E-commerce Manager - David Park"
    DueDate = (Get-Date).AddDays(35)
    AcceptanceCriteria = @(
        "Load testing scenarios developed based on historical data",
        "Systems tested under expected peak loads",
        "Performance bottlenecks identified and addressed",
        "Capacity planning recommendations provided"
    )
    EstimatedEffort = 30
}

$Support7 = New-SupportRequestWorkItem @SupportParams7
if ($Support7) { $CreatedSupportRequests += $Support7 }

# Support Request 8: SSL Certificate Renewal
$SupportParams8 = @{
    Title = "Renew SSL certificates for all web properties"
    RequestType = "Configuration"
    Priority = "2"
    Description = "Multiple SSL certificates are expiring in the next 60 days. Need to plan and execute renewal process for all web properties."
    BusinessImpact = "Expired SSL certificates will cause security warnings and prevent customer access to web properties."
    RequestedBy = "DevOps Engineer - Maria Garcia"
    DueDate = (Get-Date).AddDays(50)
    AcceptanceCriteria = @(
        "All expiring certificates identified and cataloged",
        "Certificate renewal process executed successfully",
        "Certificate monitoring alerts configured",
        "Documentation updated with new expiration dates"
    )
    EstimatedEffort = 8
}

$Support8 = New-SupportRequestWorkItem @SupportParams8
if ($Support8) { $CreatedSupportRequests += $Support8 }

# Support Request 9: Data Retention Policy Implementation
$SupportParams9 = @{
    Title = "Implement data retention policy across all systems"
    RequestType = "Configuration"
    Priority = "3"
    Description = "New data retention policy has been approved and needs to be implemented across all systems to ensure compliance."
    BusinessImpact = "Non-compliance with data retention policy could result in regulatory issues and increased storage costs."
    RequestedBy = "Compliance Officer - Robert Kim"
    DueDate = (Get-Date).AddDays(60)
    AcceptanceCriteria = @(
        "Data retention rules configured in all systems",
        "Automated cleanup processes implemented",
        "Policy compliance monitoring established",
        "Staff training on new retention procedures completed"
    )
    EstimatedEffort = 35
}

$Support9 = New-SupportRequestWorkItem @SupportParams9
if ($Support9) { $CreatedSupportRequests += $Support9 }

# Support Request 10: Network Infrastructure Upgrade
$SupportParams10 = @{
    Title = "Upgrade network infrastructure in main office"
    RequestType = "Maintenance"
    Priority = "2"
    Description = "Network equipment in main office is end-of-life and needs replacement to maintain security and performance standards."
    BusinessImpact = "Aging network equipment poses security risks and performance limitations affecting daily operations."
    RequestedBy = "Network Administrator - Kevin Brown"
    DueDate = (Get-Date).AddDays(90)
    AcceptanceCriteria = @(
        "Network equipment procurement completed",
        "Installation scheduled during maintenance window",
        "Network upgrade executed with minimal downtime",
        "Performance and security improvements validated"
    )
    EstimatedEffort = 50
}

$Support10 = New-SupportRequestWorkItem @SupportParams10
if ($Support10) { $CreatedSupportRequests += $Support10 }

# ============================================================================
# BUGS (2)
# ============================================================================

Write-Host "`n=== Creating 2 Bugs ===" -ForegroundColor Magenta

# Bug 1: Payment Processing Error
$BugParams1 = @{
    Title = "Payment processing fails for orders over $1000"
    Description = "Customer payments are being rejected for high-value orders even when payment method is valid. This is causing lost sales and customer frustration."
    StepsToReproduce = @(
        "Log in as a customer",
        "Add items totaling more than $1000 to cart",
        "Proceed to checkout",
        "Enter valid payment information",
        "Click 'Complete Order'",
        "Observe payment failure error"
    )
    ExpectedBehavior = "Payment should be processed successfully for valid payment methods regardless of order amount."
    ActualBehavior = "Payment processing fails with error 'Payment could not be processed' for orders over $1000."
    Priority = "1"
    Severity = "1 - Critical"
    Environment = "Production"
    Browser = "Chrome 91+, Firefox 89+, Safari 14+"
    OS = "Windows 10/11, macOS 11+, iOS 14+"
    Version = "E-commerce Platform v3.2.1"
    Screenshots = "Error screenshots and payment gateway logs attached showing timeout errors"
    AcceptanceCriteriaForFix = @(
        "Given I have a cart with items over $1000, When I complete checkout with valid payment, Then the payment processes successfully",
        "Given the payment gateway timeout, When the issue is resolved, Then all pending payments are properly handled",
        "Given the fix is deployed, When customers retry failed payments, Then they complete successfully"
    )
}

$Bug1 = New-BugWorkItem @BugParams1
if ($Bug1) { $CreatedBugs += $Bug1 }

# Bug 2: Mobile App Memory Leak
$BugParams2 = @{
    Title = "Mobile app experiences memory leak causing crashes after extended use"
    Description = "Users report that the mobile app becomes increasingly slow and eventually crashes after 30-45 minutes of continuous use. Memory profiling shows gradual memory consumption increase."
    StepsToReproduce = @(
        "Launch mobile app on device",
        "Browse products for 30+ minutes",
        "Add/remove items from cart multiple times",
        "Navigate between different sections of the app",
        "Continue using app for 45+ minutes",
        "Observe app slowdown and eventual crash"
    )
    ExpectedBehavior = "Mobile app should maintain consistent performance during extended use sessions without memory-related crashes."
    ActualBehavior = "App gradually consumes more memory over time, becomes sluggish after 30 minutes, and crashes after 45+ minutes of use."
    Priority = "2"
    Severity = "2 - High"
    Environment = "Production mobile app"
    Browser = "N/A - Native mobile app"
    OS = "iOS 15+, Android 10+"
    Version = "Mobile App v2.3.4"
    Screenshots = "Memory profiling screenshots showing gradual increase in memory usage and crash logs attached"
    AcceptanceCriteriaForFix = @(
        "Given I use the app for 60+ minutes, When I navigate through different sections, Then memory usage remains stable",
        "Given extended app usage, When I monitor app performance, Then no memory leaks are detected",
        "Given the fix is implemented, When users use the app for extended periods, Then crashes related to memory issues are eliminated"
    )
}

$Bug2 = New-BugWorkItem @BugParams2
if ($Bug2) { $CreatedBugs += $Bug2 }

# ============================================================================
# ISSUES (3) - Using Issue work item type for general problems/improvements
# ============================================================================

Write-Host "`n=== Creating 3 Issues ===" -ForegroundColor Magenta

# Issue 1: Performance Monitoring Enhancement
$IssueParams1 = @{
    Title = "Implement comprehensive application performance monitoring"
    RequestType = "Investigation"
    Priority = "2"
    Description = "Current monitoring solutions provide limited visibility into application performance issues. Need to implement comprehensive APM solution to proactively identify and resolve performance problems."
    BusinessImpact = "Limited monitoring capabilities prevent proactive identification of performance issues, leading to reactive problem-solving and potential customer impact."
    RequestedBy = "Technical Lead - Emma Davis"
    AcceptanceCriteria = @(
        "APM solution evaluated and selected",
        "Performance monitoring implemented across all applications",
        "Alert thresholds configured for key performance metrics",
        "Monitoring dashboards created for different stakeholder groups"
    )
    EstimatedEffort = 40
}

$Issue1 = New-SupportRequestWorkItem @IssueParams1
if ($Issue1) { $CreatedIssues += $Issue1 }

# Issue 2: Customer Feedback System
$IssueParams2 = @{
    Title = "Develop customer feedback collection and analysis system"
    RequestType = "Configuration"
    Priority = "3"
    Description = "Currently lacking systematic approach to collect and analyze customer feedback. Need to implement solution to gather, categorize, and act on customer input."
    BusinessImpact = "Without systematic feedback collection, we're missing opportunities to improve customer satisfaction and identify product enhancement opportunities."
    RequestedBy = "Customer Success Manager - James Miller"
    AcceptanceCriteria = @(
        "Feedback collection mechanisms implemented across all touchpoints",
        "Automated categorization and sentiment analysis configured",
        "Feedback reporting dashboard created for stakeholders",
        "Integration with existing CRM system completed"
    )
    EstimatedEffort = 32
}

$Issue2 = New-SupportRequestWorkItem @IssueParams2
if ($Issue2) { $CreatedIssues += $Issue2 }

# Issue 3: API Documentation and Developer Portal
$IssueParams3 = @{
    Title = "Create comprehensive API documentation and developer portal"
    RequestType = "Configuration"
    Priority = "2"
    Description = "Current API documentation is scattered and incomplete, making it difficult for internal developers and external partners to integrate with our systems."
    BusinessImpact = "Poor API documentation slows down integration projects, increases support burden, and limits adoption of our platform by partners."
    RequestedBy = "API Product Manager - Rachel Green"
    AcceptanceCriteria = @(
        "Comprehensive API documentation created with interactive examples",
        "Developer portal implemented with authentication and testing capabilities",
        "API versioning and changelog processes established",
        "Developer onboarding process streamlined and documented"
    )
    EstimatedEffort = 28
}

$Issue3 = New-SupportRequestWorkItem @IssueParams3
if ($Issue3) { $CreatedIssues += $Issue3 }

# ============================================================================
# SUMMARY AND REPORTING
# ============================================================================

Write-Host "`n🎉 Bulk work item creation completed!" -ForegroundColor Green

# Create summary report
Write-Host "`n=== CREATION SUMMARY ===" -ForegroundColor Yellow
Write-Host "✅ User Stories Created: $($CreatedUserStories.Count)/4" -ForegroundColor Green
Write-Host "✅ Support Requests Created: $($CreatedSupportRequests.Count)/10" -ForegroundColor Green
Write-Host "✅ Bugs Created: $($CreatedBugs.Count)/2" -ForegroundColor Green
Write-Host "✅ Issues Created: $($CreatedIssues.Count)/3" -ForegroundColor Green

Write-Host "`n=== DETAILED WORK ITEM LIST ===" -ForegroundColor Cyan

if ($CreatedUserStories.Count -gt 0) {
    Write-Host "`n📋 User Stories:" -ForegroundColor Magenta
    foreach ($item in $CreatedUserStories) {
        Write-Host "  • ID: $($item.id) - $($item.fields.'System.Title')" -ForegroundColor White
    }
}

if ($CreatedSupportRequests.Count -gt 0) {
    Write-Host "`n🎫 Support Requests:" -ForegroundColor Magenta
    foreach ($item in $CreatedSupportRequests) {
        Write-Host "  • ID: $($item.id) - $($item.fields.'System.Title')" -ForegroundColor White
    }
}

if ($CreatedBugs.Count -gt 0) {
    Write-Host "`n🐛 Bugs:" -ForegroundColor Magenta
    foreach ($item in $CreatedBugs) {
        Write-Host "  • ID: $($item.id) - $($item.fields.'System.Title')" -ForegroundColor White
    }
}

if ($CreatedIssues.Count -gt 0) {
    Write-Host "`n⚠️  Issues:" -ForegroundColor Magenta
    foreach ($item in $CreatedIssues) {
        Write-Host "  • ID: $($item.id) - $($item.fields.'System.Title')" -ForegroundColor White
    }
}

Write-Host "`n🔗 All work items have been created in Azure DevOps project: $proj" -ForegroundColor Cyan
Write-Host "Navigate to your Azure DevOps project to view and manage the created work items." -ForegroundColor Gray

# Calculate total story points and effort
$TotalStoryPoints = ($CreatedUserStories | ForEach-Object { 
    $storyPoints = $_.fields.'Microsoft.VSTS.Scheduling.StoryPoints'
    if ($storyPoints) { [int]$storyPoints } else { 0 }
}) | Measure-Object -Sum | Select-Object -ExpandProperty Sum

$TotalEffortHours = ($CreatedSupportRequests + $CreatedIssues | ForEach-Object {
    # Extract effort from description (this is a simplified approach)
    if ($_.fields.'System.Description' -match 'Estimated Effort.*?(\d+)') {
        [int]$matches[1]
    } else { 0 }
}) | Measure-Object -Sum | Select-Object -ExpandProperty Sum

Write-Host "`n📊 EFFORT SUMMARY:" -ForegroundColor Yellow
Write-Host "  Total Story Points: $TotalStoryPoints" -ForegroundColor White
Write-Host "  Total Estimated Hours: $TotalEffortHours" -ForegroundColor White
Write-Host "  High Priority Items: $((($CreatedUserStories + $CreatedSupportRequests + $CreatedBugs + $CreatedIssues) | Where-Object { $_.fields.'Microsoft.VSTS.Common.Priority' -eq '1' }).Count)" -ForegroundColor White

Write-Host "`n✨ Script execution complete! Check your Azure DevOps project for all created work items." -ForegroundColor Green
