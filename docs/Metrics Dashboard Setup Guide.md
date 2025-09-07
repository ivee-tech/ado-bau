# Metrics Dashboard Setup Guide

## Table of Contents
1. [Overview](#overview)
2. [Power BI Dashboard Setup](#power-bi-dashboard-setup)
3. [Azure DevOps Analytics Setup](#azure-devops-analytics-setup)
4. [Key Metrics and Visualizations](#key-metrics-and-visualizations)
5. [Dashboard Templates](#dashboard-templates)
6. [Implementation Guide](#implementation-guide)
7. [Maintenance and Updates](#maintenance-and-u## Key Metrics and Visualizations

### Sprint Summary Dashboard Metrics

### Sprint Scope Management
**Definition**: Tracking scope changes during sprint execution
**Key Metrics**:
- Number of stories at start of sprint
- Number of hours at start of sprint
- Newly introduced scope items mid-sprint (count and hours)
- Items pulled out of sprint (count and hours)
- Percentage increase in scope (hours-based)

**Calculation**: 
```
% Scope Increase = ((Hours Added - Hours Removed) / Initial Hours) × 100
```
**Visualization**: Waterfall chart showing scope changes throughout sprint
**Target**: <10% scope change per sprint

### Sprint Completion Analysis
**Definition**: Comprehensive view of sprint delivery performance
**Key Metrics**:
- Completed items count and hours
- In-progress/carrying forward items
- Percentage completed in sprint
- Items with unestimated remaining hours

**Calculation**: 
```
% Sprint Completion = (Hours Completed / (Initial Hours + Added Hours - Removed Hours)) × 100
```
**Visualization**: Multi-metric dashboard with cards and progress bars
**Target**: 100% completion with minimal carryover

### Delivery Metrics

### Sprint Velocity
**Definition**: Story points completed per sprint
**Calculation**: Sum of story points for completed user stories in a sprint
**Visualization**: Line chart showing velocity over last 6-12 sprints
**Target**: Stable velocity with minimal variation (±20%)

### Sprint Commitment Reliability
**Definition**: Percentage of committed work delivered
**Calculation**: (Delivered story points / Committed story points) × 100
**Visualization**: Gauge chart or percentage card
**Target**: 80%+ consistent delivery

# Overview

## Purpose of Metrics Dashboards

Metrics dashboards provide real-time visibility into team performance, project progress, and delivery predictability. For BAU teams, these dashboards help track both planned work and reactive support activities, enabling data-driven decision making and continuous improvement.

## Key Stakeholder Views

### Executive Dashboard
- **High-level metrics** and trends
- **Business value** delivered
- **Resource utilization**
- **Strategic alignment**

### Team Lead Dashboard  
- **Sprint progress** and velocity
- **Team capacity** utilization
- **Quality metrics**
- **Impediment tracking**

### Team Member Dashboard
- **Individual progress**
- **Task completion**
- **Time tracking**
- **Personal productivity metrics**

### Stakeholder Dashboard
- **Delivery status**
- **Feature progress**
- **Support metrics**
- **Customer satisfaction**

## Dashboard Design Principles

### Clarity and Simplicity
- **Clear visualizations** that tell a story
- **Minimal cognitive load** for users
- **Consistent color schemes** and formatting
- **Logical information hierarchy**

### Actionable Insights
- **Metrics that drive decisions**
- **Trends that indicate problems early**
- **Drill-down capabilities** for details
- **Context for interpretation**

### Real-time and Relevant
- **Frequent data updates** (daily/hourly)
- **Relevant time periods** for analysis
- **Current and historical** comparisons
- **Predictive indicators** when possible

---

# Power BI Dashboard Setup

## Prerequisites

### Required Access
- **Power BI Pro license** or Premium capacity
- **Azure DevOps** project access
- **Analytics views** enabled in Azure DevOps
- **Data connector** permissions

### Initial Setup Steps
1. **Enable Analytics** in Azure DevOps
2. **Create Power BI workspace**
3. **Configure data connections**
4. **Set up refresh schedules**
5. **Configure security** and sharing

## Data Connection Setup

### Azure DevOps Analytics Connector
```
Data Source: Azure DevOps (Boards)
Organization: https://dev.azure.com/{organization}
Project: {project-name}
Authentication: Organizational account
Connection Mode: Import (recommended for performance)
```

### Key Data Tables
- **Work Items**: Stories, tasks, bugs, features
- **Work Item Revisions**: Historical changes
- **Areas**: Team and project areas
- **Iterations**: Sprint and release data
- **Users**: Team member information
- **Teams**: Team configurations

## Power Query Data Transformation

### Work Items Processing
```
// Filter to relevant work item types
let
    Source = AzureDevOps.Analytics("https://dev.azure.com/organization", "ProjectName"),
    WorkItems = Source{[EntitySetName="WorkItems"]}[Data],
    FilteredTypes = Table.SelectRows(WorkItems, each [WorkItemType] = "User Story" 
        or [WorkItemType] = "Task" 
        or [WorkItemType] = "Bug" 
        or [WorkItemType] = "Feature"),
    AddedCustomColumns = Table.AddColumn(FilteredTypes, "Sprint", each 
        if [IterationPath] <> null then 
            Text.AfterDelimiter([IterationPath], "\", {0, RelativePosition.FromEnd})
        else "No Sprint")
in
    AddedCustomColumns
```

### Date Dimension Creation
```
// Create date table for time-based analysis
let
    StartDate = #date(2024, 1, 1),
    EndDate = #date(2025, 12, 31),
    DateList = List.Dates(StartDate, Number.From(EndDate - StartDate) + 1, #duration(1, 0, 0, 0)),
    DateTable = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}),
    AddedColumns = Table.AddColumn(DateTable, "Year", each Date.Year([Date])),
    AddedQuarter = Table.AddColumn(AddedColumns, "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date]))),
    AddedMonth = Table.AddColumn(AddedQuarter, "Month", each Date.MonthName([Date])),
    AddedWeek = Table.AddColumn(AddedMonth, "WeekNumber", each Date.WeekOfYear([Date]))
in
    AddedWeek
```

### Velocity Calculations
```
// Calculate team velocity by sprint
let
    CompletedItems = Table.SelectRows(WorkItems, each [State] = "Closed" or [State] = "Done"),
    GroupedBySprint = Table.Group(CompletedItems, {"Sprint"}, {
        {"StoryPoints", each List.Sum([StoryPoints]), type number},
        {"ItemCount", each Table.RowCount(_), type number},
        {"CompletedDate", each List.Max([ClosedDate]), type datetime}
    })
in
    GroupedBySprint
```

## Dashboard Layout Design

### Executive Dashboard Layout
```
Row 1: Key Metrics Cards (25% height)
├── Total Story Points Delivered
├── Sprint Completion Rate  
├── Team Velocity Trend
└── Customer Satisfaction Score

Row 2: Trend Charts (50% height)
├── Velocity Trend (Line Chart) - 60%
└── Work Type Distribution (Pie Chart) - 40%

Row 3: Detailed Tables (25% height)
├── Current Sprint Status - 50%
└── Top Issues/Risks - 50%
```

### Team Dashboard Layout
```
Row 1: Sprint Metrics (20% height)
├── Sprint Burndown Chart - 60%
└── Sprint Capacity - 40%

Row 2: Team Performance (40% height)
├── Individual Velocity (Bar Chart) - 50%
└── Cycle Time Trend (Line Chart) - 50%

Row 3: Work Status (40% height)
├── Work Item Status (Stacked Bar) - 60%
└── Impediments List (Table) - 40%
```

## Key Visualizations

### Velocity Chart
```
Chart Type: Line Chart with Markers
X-Axis: Sprint Name
Y-Axis: Story Points Completed
Series: 
- Actual Velocity (solid line)
- Average Velocity (dashed line)
- Target Velocity (dotted line)

Formatting:
- Show data labels on points
- Trend line enabled
- Color: Blue for actual, Gray for average
```

### Sprint Burndown Chart
```
Chart Type: Line Chart
X-Axis: Days in Sprint
Y-Axis: Remaining Story Points
Series:
- Ideal Burndown (straight line from start to zero)
- Actual Burndown (daily remaining work)

Formatting:
- Ideal line: Gray dashed
- Actual line: Blue solid
- Show remaining work as area under curve
```

### Cumulative Flow Diagram
```
Chart Type: Area Chart (Stacked)
X-Axis: Date
Y-Axis: Work Item Count
Series (stacked areas):
- Done (Green)
- In Progress (Yellow)  
- Ready (Blue)
- New (Gray)

Formatting:
- Smooth lines enabled
- Semi-transparent fill
- Show trends in work flow
```

### Team Capacity Utilization
```
Chart Type: Gauge Chart
Value: Current Capacity Utilization %
Ranges:
- 0-60%: Red (Under-utilized)
- 60-85%: Green (Optimal)
- 85-100%: Yellow (High utilization)
- 100%+: Red (Over-allocated)

Formatting:
- Show percentage and hours
- Color coding based on ranges
```

## Advanced Measures (DAX)

### Sprint Summary Calculations

### Initial Sprint Scope
```
Initial Stories Count = 
CALCULATE(
    COUNTROWS('Work Items'),
    'Work Items'[Sprint Start Date] <= TODAY(),
    'Work Items'[Added During Sprint] = FALSE,
    'Work Items'[Removed During Sprint] = FALSE
)

// For Agile Process - Use Story Points instead of Original Estimate
Initial Sprint Story Points = 
CALCULATE(
    SUM('Work Items'[Story Points]),
    'Work Items'[Sprint Start Date] <= TODAY(),
    'Work Items'[Added During Sprint] = FALSE,
    'Work Items'[Removed During Sprint] = FALSE,
    'Work Items'[Work Item Type] = "User Story"
)

// Alternative for Task hours (when available)
Initial Sprint Hours = 
CALCULATE(
    SUM('Work Items'[Remaining Work]),
    'Work Items'[Sprint Start Date] <= TODAY(),
    'Work Items'[Added During Sprint] = FALSE,
    'Work Items'[Removed During Sprint] = FALSE,
    'Work Items'[Work Item Type] = "Task"
)
```

### Scope Change Calculations
```
Stories Added Mid Sprint = 
CALCULATE(
    COUNTROWS('Work Items'),
    'Work Items'[Added During Sprint] = TRUE,
    'Work Items'[Date Added] > 'Sprint'[Sprint Start Date]
)

// For Agile Process - Use Story Points for User Stories
Story Points Added Mid Sprint = 
CALCULATE(
    SUM('Work Items'[Story Points]),
    'Work Items'[Added During Sprint] = TRUE,
    'Work Items'[Date Added] > 'Sprint'[Sprint Start Date],
    'Work Items'[Work Item Type] = "User Story"
)

// For Tasks - Use Remaining Work hours
Hours Added Mid Sprint = 
CALCULATE(
    SUM('Work Items'[Remaining Work]),
    'Work Items'[Added During Sprint] = TRUE,
    'Work Items'[Date Added] > 'Sprint'[Sprint Start Date],
    'Work Items'[Work Item Type] = "Task"
)

Stories Removed During Sprint = 
CALCULATE(
    COUNTROWS('Work Items'),
    'Work Items'[Removed During Sprint] = TRUE
)

// Story Points removed (for User Stories)
Story Points Removed During Sprint = 
CALCULATE(
    SUM('Work Items'[Story Points]),
    'Work Items'[Removed During Sprint] = TRUE,
    'Work Items'[Work Item Type] = "User Story"
)

// Hours removed (for Tasks)
Hours Removed During Sprint = 
CALCULATE(
    SUM('Work Items'[Remaining Work]),
    'Work Items'[Removed During Sprint] = TRUE,
    'Work Items'[Work Item Type] = "Task"
)

// Scope increase based on Story Points (primary metric for Agile)
Scope Increase Percentage = 
DIVIDE(
    [Story Points Added Mid Sprint] - [Story Points Removed During Sprint],
    [Initial Sprint Story Points],
    0
) * 100

// Alternative scope increase based on hours (for detailed analysis)
Hours Scope Increase Percentage = 
DIVIDE(
    [Hours Added Mid Sprint] - [Hours Removed During Sprint],
    [Initial Sprint Hours],
    0
) * 100
```

### Sprint Completion Calculations
```
Stories Completed = 
CALCULATE(
    COUNTROWS('Work Items'),
    'Work Items'[State] IN {"Done", "Closed"},
    'Work Items'[Closed Date] >= 'Sprint'[Sprint Start Date],
    'Work Items'[Closed Date] <= 'Sprint'[Sprint End Date]
)

// For Agile Process - Use Completed Work for Tasks
Hours Completed = 
CALCULATE(
    SUM('Work Items'[Completed Work]),
    'Work Items'[State] IN {"Done", "Closed"},
    'Work Items'[Work Item Type] = "Task"
)

// Story Points completed (primary metric for Agile)
Story Points Completed = 
CALCULATE(
    SUM('Work Items'[Story Points]),
    'Work Items'[State] IN {"Done", "Closed"},
    'Work Items'[Work Item Type] = "User Story"
)

Stories In Progress = 
CALCULATE(
    COUNTROWS('Work Items'),
    'Work Items'[State] IN {"Active", "In Progress", "Review"}
)

// Sprint completion based on Story Points (recommended for Agile)
Sprint Completion Percentage = 
VAR AdjustedScopeStoryPoints = [Initial Sprint Story Points] + [Story Points Added Mid Sprint] - [Story Points Removed During Sprint]
RETURN
DIVIDE(
    [Story Points Completed],
    AdjustedScopeStoryPoints,
    0
) * 100

// Alternative completion based on hours (for detailed analysis)
Sprint Hours Completion Percentage = 
VAR AdjustedScopeHours = [Initial Sprint Hours] + [Hours Added Mid Sprint] - [Hours Removed During Sprint]
RETURN
DIVIDE(
    [Hours Completed],
    AdjustedScopeHours,
    0
) * 100

// Unestimated items (missing Story Points or Remaining Work)
Unestimated Items Count = 
CALCULATE(
    COUNTROWS('Work Items'),
    (
        ('Work Items'[Work Item Type] = "User Story" && 'Work Items'[Story Points] = BLANK()) ||
        ('Work Items'[Work Item Type] = "Task" && 'Work Items'[Remaining Work] = BLANK())
    ),
    'Work Items'[State] <> "Done"
)
```

### Velocity Calculation
```
Team Velocity = 
CALCULATE(
    SUM('Work Items'[Story Points]),
    'Work Items'[State] IN {"Done", "Closed"},
    'Work Items'[Closed Date] >= STARTOFMONTH(TODAY()) - 30
)
```

### Sprint Completion Rate
```
Sprint Completion Rate = 
DIVIDE(
    CALCULATE(SUM('Work Items'[Story Points]), 'Work Items'[State] = "Done"),
    CALCULATE(SUM('Work Items'[Story Points]), 'Work Items'[State] <> "Removed"),
    0
) * 100
```

### Cycle Time Average
```
Average Cycle Time = 
AVERAGEX(
    FILTER('Work Items', 'Work Items'[State] = "Done"),
    DATEDIFF('Work Items'[Started Date], 'Work Items'[Closed Date], DAY)
)
```

### Throughput Calculation
```
Weekly Throughput = 
CALCULATE(
    COUNTROWS('Work Items'),
    'Work Items'[State] = "Done",
    'Work Items'[Closed Date] >= TODAY() - 7
)
```

---

# Azure DevOps Analytics Setup

## Analytics Views Configuration

### Creating Custom Analytics Views

#### Sprint Summary Analytics View
```
View Name: Sprint Summary Analytics
Work Item Types: User Story, Task, Bug
Fields:
- Work Item ID
- Title  
- State
- Original Estimate
- Remaining Work
- Completed Work
- Story Points
- Created Date
- Closed Date
- State Change Date
- Iteration Path
- Area Path
- Added During Sprint (Custom field)
- Removed During Sprint (Custom field)
- Scope Change Reason (Custom field)

Filters:
- Iteration Path: Current sprint
- Area Path: Team area
- Include historical revisions for scope tracking
```

#### Scope Change Tracking View
```
View Name: Sprint Scope Changes
Work Item Types: User Story, Bug, Feature
Fields:
- Work Item ID
- Title
- Work Item Type
- Original Estimate  
- Story Points
- State
- Created Date
- Iteration Path Changed Date
- Previous Iteration Path
- Current Iteration Path
- Change Reason
- Changed By

Filters:
- Scope changes during current sprint
- Items added or removed mid-sprint
- Area Path: Team area
```

#### Team Velocity View
```
View Name: Team Velocity Analytics
Work Item Types: User Story, Bug, Feature
Fields:
- Work Item ID
- Title
- State
- Story Points
- Closed Date
- Iteration Path
- Area Path
- Work Item Type

Filters:
- State: Done, Closed
- Iteration Path: Current and last 6 sprints
- Area Path: Team area
```

#### Sprint Progress View
```
View Name: Sprint Progress Analytics  
Work Item Types: User Story, Task, Bug
Fields:
- Work Item ID
- Title
- State
- Original Estimate
- Completed Work
- Remaining Work
- Assigned To
- Created Date
- State Change Date

Filters:
- Iteration Path: Current sprint
- Area Path: Team area
```

### Built-in Analytics Widgets

#### Velocity Widget Configuration
```
Widget: Velocity
Time Period: Last 6 iterations
Teams: [Your Team]
Work Item Types: User Story
Backlog Level: Stories
Show: 
- Planned (light blue)
- Completed (dark blue)
- Completed Late (orange)
- Incomplete (gray)
```

#### Burndown Widget Configuration
```
Widget: Sprint Burndown
Sprint: Current sprint
Team: [Your Team]
Work Item Types: User Story, Task
Plot By: Story Points
Show:
- Scope increase/decrease
- Ideal trend line
- Remaining work trend
```

#### Cumulative Flow Widget
```
Widget: Cumulative Flow Diagram
Time Period: Last 30 days
Teams: [Your Team]
Backlog Level: Stories
Columns:
- New
- Active  
- Resolved
- Closed
```

## Query-based Reports

### How to Create Queries in Azure DevOps

#### Method 1: Using the Query Editor UI
1. **Navigate to Queries**:
   - Go to Azure DevOps → Boards → Queries
   - Click "New query" or "New → Query"

2. **Build Sprint Summary Query**:
   ```
   Step-by-step configuration:
   
   Clause 1: Work Item Type = User Story
   Clause 2: Work Item Type = Bug  
   Clause 3: Work Item Type = Task
   (Use "OR" between these clauses)
   
   Clause 4: Iteration Path Under [Your Project]\Sprint X
   Clause 5: Area Path Under [Your Project]\[Your Team]
   Clause 6: State <> Removed
   
   Columns to Add:
   - ID
   - Title  
   - State
   - Story Points
   - Original Estimate
   - Remaining Work
   - Completed Work
   - Assigned To
   - Created Date
   - Closed Date
   - Changed Date
   
   Sort by: State, then Story Points (descending)
   ```

3. **Save the Query**:
   - Click "Save query"
   - Name: "Sprint Summary Dashboard"
   - Save to: "Shared Queries" or "My Queries"

#### Method 2: Using WIQL Editor (Advanced)
1. **Access WIQL Editor**:
   - Create a new query in the UI first
   - Click the "Editor" tab (next to "Results" tab)
   - This opens the WIQL (Work Item Query Language) editor

2. **Paste WIQL Code**:
   ```wiql
   SELECT [System.Id], [System.Title], [System.State], 
          [Microsoft.VSTS.Scheduling.StoryPoints],
          [Microsoft.VSTS.Scheduling.OriginalEstimate],
          [Microsoft.VSTS.Scheduling.RemainingWork],
          [Microsoft.VSTS.Scheduling.CompletedWork],
          [System.AssignedTo], [System.CreatedDate],
          [System.ClosedDate], [System.ChangedDate]
   FROM WorkItems 
   WHERE [System.IterationPath] UNDER 'ProjectName\Sprint 1'
     AND [System.WorkItemType] IN ('User Story', 'Bug', 'Task')
     AND [System.AreaPath] UNDER 'ProjectName\Team Area'
   ORDER BY [System.State], [Microsoft.VSTS.Scheduling.StoryPoints] DESC
   ```

3. **Replace Placeholders**:
   - Change 'ProjectName' to your actual project name
   - Change 'Sprint 1' to your current sprint name
   - Change 'Team Area' to your team's area path

#### Method 3: Using REST API (PowerShell/Automation)
```powershell
# PowerShell script to create query via REST API
$organization = "your-org"
$project = "your-project"  
$pat = "your-personal-access-token"

$headers = @{
    'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))
    'Content-Type' = 'application/json'
}

$queryBody = @{
    name = "Sprint Summary Dashboard"
    wiql = "SELECT [System.Id], [System.Title], [System.State], [Microsoft.VSTS.Scheduling.StoryPoints] FROM WorkItems WHERE [System.IterationPath] UNDER 'ProjectName\Sprint 1'"
} | ConvertTo-Json

$uri = "https://dev.azure.com/$organization/$project/_apis/wit/queries/My Queries?api-version=6.0"
Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $queryBody
```

### Sprint Summary Query (UI Method)

### Scope Change Analysis Query (UI Method)
```
Query Builder Configuration:
Clause 1: Work Item Type = User Story
Clause 2: Work Item Type = Bug
Clause 3: Work Item Type = Feature
(Use "OR" between clauses)

Clause 4: Iteration Path Under [Your Project]\Current Sprint
Clause 5: Created Date >= [Sprint Start Date] (use date picker)
Clause 6: Area Path Under [Your Project]\[Your Team]

Columns to Add:
- ID
- Title
- Work Item Type
- Original Estimate
- Story Points
- State
- Created Date
- Changed Date
- Iteration Path
- Reason

Sort by: Created Date, Changed Date
```

### Sprint Estimation Accuracy Query (UI Method)
```
Query Builder Configuration:
Clause 1: Iteration Path Under [Your Project]\Current Sprint
Clause 2: Work Item Type = User Story
Clause 3: Work Item Type = Task
(Use "OR" between User Story and Task clauses)

Clause 4: State <> Removed
Clause 5: Area Path Under [Your Project]\[Your Team]

Columns to Add:
- ID
- Title
- State
- Original Estimate
- Remaining Work
- Completed Work

Sort by: Original Estimate (to see unestimated items first - they'll be blank)
```

### Creating Custom Queries for Power BI Integration

#### Query Export for Power BI
1. **Run Your Query** in Azure DevOps
2. **Export Results**:
   - Click "..." (More actions) on query results
   - Select "Export to Excel" or "Copy to clipboard"
   - Use this data to validate your Power BI connection

3. **Get Query URL for Power BI**:
   - Right-click on saved query → "Copy query URL"
   - Use this URL in Power BI's Azure DevOps connector
   - Format: `https://dev.azure.com/{org}/{project}/_queries/query/{queryId}`

#### Setting Up Parameterized Queries
```
For Dynamic Sprint Queries:
1. Create base query with current sprint
2. Use @Today macro for date-based filters
3. Create query folders by sprint/release
4. Use @Project macro for cross-project queries

Example with macros:
- [System.IterationPath] UNDER '@Project\Sprint @CurrentIteration'
- [System.CreatedDate] >= @Today-30 (for last 30 days)
- [System.ChangedDate] >= @StartOfMonth (for current month)
```

### Velocity Trend Query (UI Method)
```
Query Builder Configuration:
Clause 1: Work Item Type = User Story
Clause 2: State = Closed
Clause 3: Closed Date >= [6 months ago] (use date picker)
Clause 4: Area Path Under [Your Project]\[Your Team]

Columns to Add:
- ID
- Iteration Path
- Story Points
- Closed Date

Sort by: Iteration Path, Closed Date
```

### Common Query Issues and Solutions

#### Issue 1: "Field does not exist" Error
**Problem**: Custom fields or wrong field names
**Solution**: 
- Check field names in work item form
- Use "Add column" in query results to see available fields
- Custom fields format: `[Custom.FieldName]` or `[YourCompany.FieldName]`

#### Issue 2: No Results Returned
**Problem**: Incorrect path names or filters too restrictive
**Solution**:
- Verify Area Path: Go to Project Settings → Team configuration → Areas
- Check Iteration Path: Go to Project Settings → Team configuration → Iterations  
- Remove filters one by one to identify the issue
- Use "=" instead of "UNDER" for exact matches

#### Issue 3: Missing Story Points or Estimates
**Problem**: Fields not configured for work item types or using wrong field names
**Solution**:
- Go to Project Settings → Process → Work item types
- Check if Story Points field is added to User Story type
- Verify field mapping by process template:
  - **Agile**: User Stories use "Story Points", Tasks use "Remaining Work"
  - **Scrum**: PBIs use "Effort", Tasks use "Remaining Work"  
  - **CMMI**: Requirements use "Size", Tasks use "Remaining Work"
  - **Basic**: Issues use "Story Points", Tasks use "Remaining Work"
- Add missing fields to work item type definitions

#### Issue 4: "Original Estimate" Field Not Found
**Problem**: Using Original Estimate field which doesn't exist in Agile process for User Stories
**Solution**:
- **For User Stories**: Use "Story Points" field instead
- **For Tasks**: Use "Remaining Work" or "Completed Work" fields
- **Field Reference by Process**:
  ```
  Agile Process:
  - [Microsoft.VSTS.Scheduling.StoryPoints] (User Stories)
  - [Microsoft.VSTS.Scheduling.RemainingWork] (Tasks)
  
  Scrum Process:
  - [Microsoft.VSTS.Scheduling.Effort] (PBIs)
  - [Microsoft.VSTS.Scheduling.RemainingWork] (Tasks)
  
  CMMI Process:
  - [Microsoft.VSTS.Scheduling.Size] (Requirements)
  - [Microsoft.VSTS.Scheduling.RemainingWork] (Tasks)
  ```

#### Issue 5: Mixed Work Item Types in Calculation
**Problem**: Trying to use same field for different work item types
**Solution**:
- Separate calculations by work item type
- Use Story Points for User Stories/PBIs/Issues
- Use Remaining Work for Tasks
- Example WIQL with type-specific fields:
```wiql
SELECT [System.Id], [System.Title], [System.WorkItemType],
       CASE [System.WorkItemType]
         WHEN 'User Story' THEN [Microsoft.VSTS.Scheduling.StoryPoints]
         WHEN 'Task' THEN [Microsoft.VSTS.Scheduling.RemainingWork]
         ELSE 0
       END AS EstimateValue
FROM WorkItems
WHERE [System.IterationPath] = 'ProjectName\Sprint X'
```

#### Issue 4: Query Runs Slow
**Problem**: Large datasets or inefficient filters
**Solution**:
- Add date filters to limit scope
- Use "=" for exact matches instead of "CONTAINS"
- Filter by Area Path early in the clause list
- Consider using Analytics views instead

### Alternative: Using Analytics Views for Power BI

#### Why Use Analytics Views?
- **Better Performance**: Optimized for reporting
- **Historical Data**: Includes work item history
- **Pre-aggregated**: Faster query execution
- **Power BI Friendly**: Designed for business intelligence

#### Creating Analytics View
1. **Navigate to Analytics Views**:
   - Go to Azure DevOps → Analytics views
   - Click "New view"

2. **Configure View**:
   ```
   View Name: Sprint Metrics View
   Work Item Types: User Story, Bug, Task
   
   Filters:
   - Teams: [Your Team]
   - Area Paths: [Your Area]
   - Iterations: Last 6 sprints
   
   Fields:
   - System fields: ID, Title, State, Work Item Type
   - Planning fields: Story Points, Original Estimate, Remaining Work
   - Classification: Area Path, Iteration Path
   - Dates: Created Date, Closed Date, State Change Date
   
   History:
   ☑ Include history (for trend analysis)
   ☑ Include current data
   ```

3. **Connect to Power BI**:
   - Copy the Analytics View URL
   - In Power BI: Get Data → Azure DevOps (Analytics views)
   - Paste the view URL
   - Select your created view

### Quality Metrics Query
```
SELECT [System.Id], [System.Title], [System.CreatedDate], 
       [System.ClosedDate], [Microsoft.VSTS.Common.Severity]
FROM WorkItems
WHERE [System.WorkItemType] = 'Bug'
  AND [System.CreatedDate] >= @startOfMonth
  AND [System.AreaPath] UNDER 'ProjectName\Team Area'
ORDER BY [Microsoft.VSTS.Common.Severity], [System.CreatedDate] DESC
```

---

# Key Metrics and Visualizations

## Delivery Metrics

### Sprint Velocity
**Definition**: Story points completed per sprint
**Calculation**: Sum of story points for completed user stories in a sprint
**Visualization**: Line chart showing velocity over last 6-12 sprints
**Target**: Stable velocity with minimal variation (±20%)

### Sprint Commitment Reliability
**Definition**: Percentage of committed work delivered
**Calculation**: (Delivered story points / Committed story points) × 100
**Visualization**: Gauge chart or percentage card
**Target**: 80%+ consistent delivery

### Throughput
**Definition**: Number of work items completed per time period
**Calculation**: Count of completed items per week/sprint
**Visualization**: Bar chart showing weekly/sprint throughput
**Target**: Increasing or stable trend

### Cycle Time
**Definition**: Time from work start to completion
**Calculation**: Average days from "Active" to "Done" state
**Visualization**: Line chart showing trend over time
**Target**: Decreasing trend, consistent performance

### Lead Time
**Definition**: Time from request to delivery
**Calculation**: Average days from "New" to "Done" state
**Visualization**: Histogram showing distribution
**Target**: Predictable, minimal variation

## Quality Metrics

### Defect Rate
**Definition**: Bugs per story point delivered
**Calculation**: Bug count / Story points delivered
**Visualization**: Line chart with trend line
**Target**: Decreasing trend, <0.1 bugs per story point

### Escaped Defects
**Definition**: Production issues found after release
**Calculation**: Count of production bugs by sprint
**Visualization**: Bar chart by sprint/release
**Target**: Minimizing count and trend

### Rework Rate
**Definition**: Percentage of work requiring rework
**Calculation**: (Reworked items / Total completed items) × 100
**Visualization**: Monthly trend line
**Target**: <10% rework rate

### Test Coverage
**Definition**: Percentage of code covered by tests
**Calculation**: (Covered lines / Total lines) × 100
**Visualization**: Gauge chart with color coding
**Target**: >80% coverage for critical paths

## Team Health Metrics

### Velocity Stability
**Definition**: Consistency of team velocity over time
**Calculation**: Standard deviation of velocity over 6 sprints
**Visualization**: Control chart with upper/lower bounds
**Target**: Low variation (±2 standard deviations)

### Capacity Utilization
**Definition**: Percentage of available capacity used
**Calculation**: (Actual hours worked / Available hours) × 100
**Visualization**: Stacked bar chart by team member
**Target**: 70-85% utilization

### Sprint Goal Achievement
**Definition**: Percentage of sprints meeting their goal
**Calculation**: (Sprints with goals met / Total sprints) × 100
**Visualization**: Monthly/quarterly percentage
**Target**: >80% goal achievement rate

### Team Satisfaction
**Definition**: Team member satisfaction with processes
**Calculation**: Average satisfaction score (1-5 scale)
**Visualization**: Trend line with survey periods marked
**Target**: Score >4.0, positive trend

### Sprint Health Metrics

### Scope Stability
**Definition**: Consistency of sprint scope throughout execution
**Calculation**: Standard deviation of scope changes over time
**Visualization**: Control chart with scope change events
**Target**: <15% scope variation per sprint

### Delivery Predictability
**Definition**: Ability to deliver committed scope consistently
**Calculation**: Variance between planned and actual delivery
**Visualization**: Planned vs. Actual comparison chart
**Target**: ±10% variance from commitment

### Sprint Adaptation Score
**Definition**: Team's ability to manage scope changes effectively
**Calculation**: (Delivered value / Adjusted scope) × Adaptation factor
**Visualization**: Multi-factor scorecard
**Target**: Score >0.8 indicating good adaptation

## Key Sprint Summary Insights Implementation

### Automated Insight Generation

#### Scope Creep Detection

**Important Note**: The following DAX expression is for Power BI dashboards, not Azure DevOps queries.

```dax
Scope Creep Alert = 
VAR ScopeIncrease = [Scope Increase Percentage]
RETURN
SWITCH(
    TRUE(),
    ScopeIncrease > 30, "High scope creep detected - Review sprint planning process",
    ScopeIncrease > 15, "Moderate scope creep - Monitor capacity impact", 
    ScopeIncrease > 5, "Minor scope changes - Within acceptable range",
    "Stable sprint scope maintained"
)
```

#### Azure DevOps Query Approach for Scope Creep Detection

Since Azure DevOps WIQL doesn't support complex calculations like DAX, you need to create multiple queries and combine the results manually or in Power BI:

##### Query 1: Items Added During Sprint (WIQL)
```wiql
SELECT [System.Id], [System.Title], [System.WorkItemType],
       [Microsoft.VSTS.Scheduling.OriginalEstimate],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [System.CreatedDate], [System.IterationPath]
FROM WorkItems
WHERE [System.IterationPath] = 'ProjectName\Sprint X'
  AND [System.CreatedDate] > '2025-08-26' -- Sprint start date
  AND [System.AreaPath] UNDER 'ProjectName\Team Area'
  AND [System.WorkItemType] IN ('User Story', 'Bug', 'Task')
ORDER BY [System.CreatedDate] DESC
```

##### Query 2: Items Moved Into Sprint (WIQL with History)
```wiql
SELECT [System.Id], [System.Title], 
       [System.IterationPath], [System.ChangedDate],
       [Microsoft.VSTS.Scheduling.OriginalEstimate]
FROM WorkItemLinks
WHERE [System.LinkType] = 'System.LinkTypes.Hierarchy'
  AND [Target].[System.IterationPath] = 'ProjectName\Sprint X'
  AND [Target].[System.ChangedDate] > '2025-08-26' -- Sprint start date
  AND [Source].[System.IterationPath] <> 'ProjectName\Sprint X'
ORDER BY [System.ChangedDate] DESC
```

##### Query 3: Items Removed from Sprint
```wiql
SELECT [System.Id], [System.Title], [System.State],
       [Microsoft.VSTS.Scheduling.OriginalEstimate],
       [System.ChangedDate]
FROM WorkItems
WHERE [System.State] = 'Removed'
  AND [System.ChangedDate] >= '2025-08-26' -- Sprint start date
  AND [System.AreaPath] UNDER 'ProjectName\Team Area'
  AND ([System.IterationPath] = 'ProjectName\Sprint X'
       OR [System.IterationPath] WAS 'ProjectName\Sprint X')
ORDER BY [System.ChangedDate] DESC
```

#### Alternative: Using Azure DevOps REST API

For more complex scope creep analysis, you can use PowerShell with the REST API:

```powershell
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
SELECT [System.Id], [Microsoft.VSTS.Scheduling.StoryPoints]
FROM WorkItems
WHERE [System.IterationPath] = '$sprintPath'
  AND [System.CreatedDate] <= '$($sprintStartDate.ToString('yyyy-MM-dd'))'
"@

# Get items added during sprint
$addedItemsQuery = @"
SELECT [System.Id], [Microsoft.VSTS.Scheduling.StoryPoints]
FROM WorkItems  
WHERE [System.IterationPath] = '$sprintPath'
  AND [System.CreatedDate] > '$($sprintStartDate.ToString('yyyy-MM-dd'))'
"@

# Execute queries and calculate scope creep
$initialItems = Invoke-RestMethod -Uri "https://dev.azure.com/$organization/$project/_apis/wit/wiql?api-version=6.0" -Method POST -Headers $headers -Body (@{query=$initialItemsQuery} | ConvertTo-Json)
$addedItems = Invoke-RestMethod -Uri "https://dev.azure.com/$organization/$project/_apis/wit/wiql?api-version=6.0" -Method POST -Headers $headers -Body (@{query=$addedItemsQuery} | ConvertTo-Json)

# Calculate scope creep percentage using Story Points (Agile process)
# Note: Azure DevOps Agile process uses Story Points, not Original Estimate for User Stories
$initialStoryPoints = ($initialItems.workItems | Measure-Object -Property storyPoints -Sum).Sum
$addedStoryPoints = ($addedItems.workItems | Measure-Object -Property storyPoints -Sum).Sum
$scopeCreepPercentage = if ($initialStoryPoints -gt 0) { ($addedStoryPoints / $initialStoryPoints) * 100 } else { 0 }

# Generate alert based on percentage
$alert = switch ($scopeCreepPercentage) {
    {$_ -gt 30} { "🔴 High scope creep detected ($([math]::Round($scopeCreepPercentage,1))%) - Review sprint planning process" }
    {$_ -gt 15} { "🟡 Moderate scope creep ($([math]::Round($scopeCreepPercentage,1))%) - Monitor capacity impact" }
    {$_ -gt 5}  { "🟢 Minor scope changes ($([math]::Round($scopeCreepPercentage,1))%) - Within acceptable range" }
    default     { "✅ Stable sprint scope maintained ($([math]::Round($scopeCreepPercentage,1))%)" }
}

Write-Output "Sprint Scope Analysis (Story Points Based):"
Write-Output "Initial Sprint Story Points: $initialStoryPoints"
Write-Output "Added Story Points: $addedStoryPoints"
Write-Output "Scope Creep: $alert"

# Alternative calculation using Effort (for Scrum process) or Remaining Work (for Tasks)
# Uncomment the section below if you need effort-based calculations

<# Alternative for Scrum Process (using Effort field):
$initialEffort = ($initialItems.workItems | Measure-Object -Property effort -Sum).Sum
$addedEffort = ($addedItems.workItems | Measure-Object -Property effort -Sum).Sum
$effortScopeCreep = if ($initialEffort -gt 0) { ($addedEffort / $initialEffort) * 100 } else { 0 }
Write-Output "Effort-based Scope Creep: $([math]::Round($effortScopeCreep,1))%"
#>

<# Alternative for Task-based calculation (using Remaining Work):
$initialWork = ($initialItems.workItems | Measure-Object -Property remainingWork -Sum).Sum
$addedWork = ($addedItems.workItems | Measure-Object -Property remainingWork -Sum).Sum
$workScopeCreep = if ($initialWork -gt 0) { ($addedWork / $initialWork) * 100 } else { 0 }
Write-Output "Work Hours-based Scope Creep: $([math]::Round($workScopeCreep,1))%"
#>
```

#### Field Mapping by Azure DevOps Process Template

Different Azure DevOps process templates use different fields for estimation:

##### Agile Process Template
```
User Stories: Use "Story Points" field
Tasks: Use "Remaining Work" (hours) field
Bugs: Use "Story Points" or "Remaining Work"

WIQL Field Names:
- Story Points: [Microsoft.VSTS.Scheduling.StoryPoints]
- Remaining Work: [Microsoft.VSTS.Scheduling.RemainingWork]
```

##### Scrum Process Template
```
Product Backlog Items (PBIs): Use "Effort" field
Tasks: Use "Remaining Work" (hours) field
Bugs: Use "Effort" field

WIQL Field Names:
- Effort: [Microsoft.VSTS.Scheduling.Effort]
- Remaining Work: [Microsoft.VSTS.Scheduling.RemainingWork]
```

##### CMMI Process Template
```
Requirements: Use "Size" field
Tasks: Use "Remaining Work" (hours) field
Bugs: Use "Size" field

WIQL Field Names:
- Size: [Microsoft.VSTS.Scheduling.Size]
- Remaining Work: [Microsoft.VSTS.Scheduling.RemainingWork]
```

##### Basic Process Template
```
Issues: Use "Story Points" field
Tasks: Use "Remaining Work" (hours) field

WIQL Field Names:
- Story Points: [Microsoft.VSTS.Scheduling.StoryPoints]
- Remaining Work: [Microsoft.VSTS.Scheduling.RemainingWork]
```

#### Updated WIQL Queries for Agile Process

##### Query 1: Items Added During Sprint (Story Points)
```wiql
SELECT [System.Id], [System.Title], [System.WorkItemType],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [Microsoft.VSTS.Scheduling.RemainingWork],
       [System.CreatedDate], [System.IterationPath]
FROM WorkItems
WHERE [System.IterationPath] = 'ProjectName\Sprint X'
  AND [System.CreatedDate] > '2025-08-26' -- Sprint start date
  AND [System.AreaPath] UNDER 'ProjectName\Team Area'
  AND [System.WorkItemType] IN ('User Story', 'Bug', 'Task')
ORDER BY [System.CreatedDate] DESC
```

##### Mixed Calculation Approach (Story Points + Hours)
```powershell
# PowerShell script with mixed calculation for Agile process
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
SELECT [System.Id], [System.WorkItemType],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [Microsoft.VSTS.Scheduling.RemainingWork]
FROM WorkItems
WHERE [System.IterationPath] = '$sprintPath'
  AND [System.CreatedDate] <= '$($sprintStartDate.ToString('yyyy-MM-dd'))'
"@

# Get items added during sprint
$addedItemsQuery = @"
SELECT [System.Id], [System.WorkItemType],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [Microsoft.VSTS.Scheduling.RemainingWork]
FROM WorkItems  
WHERE [System.IterationPath] = '$sprintPath'
  AND [System.CreatedDate] > '$($sprintStartDate.ToString('yyyy-MM-dd'))'
"@

# Execute queries
$initialItems = Invoke-RestMethod -Uri "https://dev.azure.com/$organization/$project/_apis/wit/wiql?api-version=6.0" -Method POST -Headers $headers -Body (@{query=$initialItemsQuery} | ConvertTo-Json)
$addedItems = Invoke-RestMethod -Uri "https://dev.azure.com/$organization/$project/_apis/wit/wiql?api-version=6.0" -Method POST -Headers $headers -Body (@{query=$addedItemsQuery} | ConvertTo-Json)

# Calculate scope creep using appropriate fields
$initialStoryPoints = ($initialItems.workItems | Where-Object {$_.workItemType -eq "User Story"} | Measure-Object -Property storyPoints -Sum).Sum
$addedStoryPoints = ($addedItems.workItems | Where-Object {$_.workItemType -eq "User Story"} | Measure-Object -Property storyPoints -Sum).Sum

$initialTaskHours = ($initialItems.workItems | Where-Object {$_.workItemType -eq "Task"} | Measure-Object -Property remainingWork -Sum).Sum
$addedTaskHours = ($addedItems.workItems | Where-Object {$_.workItemType -eq "Task"} | Measure-Object -Property remainingWork -Sum).Sum

# Calculate scope creep percentages
$storyPointScopeCreep = if ($initialStoryPoints -gt 0) { ($addedStoryPoints / $initialStoryPoints) * 100 } else { 0 }
$taskHourScopeCreep = if ($initialTaskHours -gt 0) { ($addedTaskHours / $initialTaskHours) * 100 } else { 0 }

Write-Output "=== Sprint Scope Analysis ==="
Write-Output "Story Points - Initial: $initialStoryPoints, Added: $addedStoryPoints, Scope Creep: $([math]::Round($storyPointScopeCreep,1))%"
Write-Output "Task Hours - Initial: $initialTaskHours, Added: $addedTaskHours, Scope Creep: $([math]::Round($taskHourScopeCreep,1))%"
```

Write-Output "Sprint Scope Analysis:"
Write-Output "Initial Sprint Hours: $initialHours"
Write-Output "Added Hours: $addedHours"
Write-Output "Scope Creep: $alert"
```

#### Setting Up Custom Fields for Better Scope Tracking

To make scope creep detection easier, consider adding custom fields to your work items:

##### Custom Field Setup in Azure DevOps
1. **Navigate to Process Settings**:
   - Go to Organization Settings → Processes
   - Select your process (Agile, Scrum, etc.)
   - Click on work item type (User Story)

2. **Add Custom Fields**:
   ```
   Field Name: "Added During Sprint"
   Type: Boolean (True/False)
   Default: False
   Description: Indicates if item was added after sprint planning
   
   Field Name: "Scope Change Reason"
   Type: Text (Single line)
   Description: Reason why item was added/removed from sprint
   
   Field Name: "Original Sprint"
   Type: Text (Single line)
   Description: The sprint this item was originally planned for
   ```

3. **Add Fields to Form Layout**:
   - Drag fields to appropriate sections
   - Set visibility rules if needed
   - Update field labels and help text

##### Automated Field Updates with Rules

Create Azure DevOps rules to automatically update these fields:

```
Rule 1: Mark items added during sprint
Conditions: 
- Work item type = User Story
- Iteration Path changed
- Changed Date > Sprint Start Date

Actions:
- Set "Added During Sprint" = True
- Set "Scope Change Reason" = "Added mid-sprint"

Rule 2: Track original sprint
Conditions:
- Work item type = User Story  
- Iteration Path changed FROM any value

Actions:
- Set "Original Sprint" = [Previous Iteration Path]
```

##### Enhanced WIQL Queries with Custom Fields

With custom fields, your scope creep queries become much simpler:

```wiql
-- Items added during current sprint
SELECT [System.Id], [System.Title], 
       [Microsoft.VSTS.Scheduling.OriginalEstimate],
       [Custom.ScopeChangeReason]
FROM WorkItems
WHERE [System.IterationPath] = 'ProjectName\Sprint X'
  AND [Custom.AddedDuringSprint] = True
  AND [System.AreaPath] UNDER 'ProjectName\Team Area'
ORDER BY [System.CreatedDate] DESC

-- Scope change summary by reason
SELECT [Custom.ScopeChangeReason], 
       COUNT([System.Id]) AS ItemCount,
       SUM([Microsoft.VSTS.Scheduling.OriginalEstimate]) AS TotalHours
FROM WorkItems
WHERE [System.IterationPath] = 'ProjectName\Sprint X'
  AND [Custom.AddedDuringSprint] = True
GROUP BY [Custom.ScopeChangeReason]
```

#### Using Analytics Views for Scope Creep Tracking

Analytics Views provide better historical tracking and are easier to connect to Power BI:

##### Create Scope Change Analytics View
1. **Go to Analytics Views** in Azure DevOps
2. **Create New View** with these settings:
   ```
   View Name: Sprint Scope Changes
   Work Item Types: User Story, Bug, Task
   
   Filters:
   - Area Path: Your team area
   - Iteration Path: Current sprint
   
   Fields to Include:
   - System: ID, Title, Work Item Type, State
   - Planning: Story Points, Original Estimate, Remaining Work
   - Classification: Area Path, Iteration Path
   - Dates: Created Date, Changed Date, State Change Date
   - Custom: Added To Iteration Date, Scope Change Reason
   
   History Options:
   ☑ Include history for trending
   ☑ Include current values
   ☑ Include revisions for iteration path changes
   ```

##### Power BI Connection for Real-time Alerts
Once you have the Analytics View, connect it to Power BI for automated alerting:

```dax
-- Power BI measure for scope creep detection
Scope Creep Status = 
VAR InitialHours = 
    CALCULATE(
        SUM('Work Items'[Original Estimate]),
        'Work Items'[Added During Sprint] = FALSE
    )
VAR AddedHours = 
    CALCULATE(
        SUM('Work Items'[Original Estimate]),
        'Work Items'[Added During Sprint] = TRUE
    )
VAR ScopeIncrease = DIVIDE(AddedHours, InitialHours, 0) * 100
RETURN
    SWITCH(
        TRUE(),
        ScopeIncrease > 30, "🔴 High Scope Creep (" & FORMAT(ScopeIncrease, "0.0") & "%)",
        ScopeIncrease > 15, "🟡 Moderate Scope Creep (" & FORMAT(ScopeIncrease, "0.0") & "%)",
        ScopeIncrease > 5, "🟢 Minor Changes (" & FORMAT(ScopeIncrease, "0.0") & "%)",
        "✅ Stable Scope (" & FORMAT(ScopeIncrease, "0.0") & "%)"
    )
```

##### Setting Up Power Automate Alerts

You can also set up automated notifications using Power Automate:

```
Trigger: When data refresh completes in Power BI
Condition: Scope Creep Percentage > 15%
Actions:
- Send Teams message to Sprint Team channel
- Create item in Azure DevOps backlog for retrospective
- Send email to Scrum Master and Product Owner
```

#### Over-delivery Analysis
```
Delivery Performance Insight = 
VAR CompletionRate = [Sprint Completion Percentage]
VAR ScopeChanges = [Scope Increase Percentage]
RETURN
SWITCH(
    TRUE(),
    CompletionRate > 120 && ScopeChanges > 20, 
        "Exceptional delivery despite significant scope changes - Review capacity planning",
    CompletionRate > 110, 
        "Over-delivery achieved - Consider increasing sprint capacity",
    CompletionRate >= 90, 
        "Target delivery met - Good sprint execution",
    CompletionRate >= 70, 
        "Partial delivery - Review impediments and capacity",
    "Under-delivery - Immediate review required"
)
```

#### Estimation Quality Assessment
```
Estimation Quality Insight = 
VAR UnestimatedCount = [Unestimated Items Count]
VAR TotalItems = [Total Sprint Items]
VAR UnestimatedPercentage = DIVIDE(UnestimatedCount, TotalItems, 0) * 100
RETURN
SWITCH(
    TRUE(),
    UnestimatedPercentage > 10, 
        "Significant estimation gaps - Review estimation process",
    UnestimatedPercentage > 5, 
        "Minor estimation issues - Address in retrospective",
    "Good estimation coverage - Maintain current practices"
)
```

### Dashboard Alert Configuration

#### Critical Alerts (Red)
- Scope increase >30% during sprint
- Sprint completion <70%
- >15% of items without estimates
- Sprint velocity variance >40% from average

#### Warning Alerts (Yellow)  
- Scope increase 15-30% during sprint
- Sprint completion 70-90%
- 5-15% of items without estimates
- Sprint velocity variance 20-40% from average

#### Success Indicators (Green)
- Scope increase <15% during sprint
- Sprint completion >90%
- <5% of items without estimates
- Sprint velocity within ±20% of average

## BAU-Specific Metrics

### Reactive Work Percentage
**Definition**: Percentage of capacity spent on unplanned work
**Calculation**: (Reactive work hours / Total work hours) × 100
**Visualization**: Stacked bar chart showing planned vs reactive
**Target**: <30% reactive work

### Support Request Response Time
**Definition**: Time to first response on support requests
**Calculation**: Average hours from creation to first response
**Visualization**: Line chart with SLA target line
**Target**: <4 hours for high priority, <24 hours for normal

### Support Resolution Time
**Definition**: Time to resolve support requests
**Calculation**: Average hours from creation to resolution
**Visualization**: Box plot showing distribution by priority
**Target**: <8 hours high priority, <72 hours normal

### Service Level Achievement
**Definition**: Percentage of requests meeting SLA targets
**Calculation**: (Requests meeting SLA / Total requests) × 100
**Visualization**: Monthly percentage with trend
**Target**: >95% SLA achievement

---

# Dashboard Templates

## Sprint Summary Dashboard Template

### Sprint Scope Management Section (40% height)
```
Scope Changes Waterfall Chart (70% width):
- Type: Waterfall chart
- Start: Initial hours/stories at sprint start
- Additions: New scope items (green bars)
- Removals: Removed items (red bars)  
- End: Final scope
- Data labels: Show exact values
- Color coding: Green for additions, Red for removals

Sprint Scope Metrics Cards (30% width):
Card 1: Scope Change %
- Value: [X]% increase in planned work
- Calculation: (Net hours added / Initial hours) × 100
- Color: Green (<10%), Yellow (10-25%), Red (>25%)

Card 2: Stories Added/Removed
- Value: +[X] added, -[Y] removed
- Net: [Z] net change
- Color based on net impact
```

### Sprint Completion Analysis (35% height)
```
Completion Metrics Cards Row:
Card 1: Stories Completed
- Value: [X] of [Y] stories (Z%)
- Progress bar showing completion
- Color: Green (>90%), Yellow (70-90%), Red (<70%)

Card 2: Hours Completed  
- Value: [X] of [Y] hours (Z%)
- Actual vs. adjusted target
- Show over/under delivery clearly

Card 3: Carryover Items
- Value: [X] stories carrying forward
- Hours: [Y] hours of work
- Impact on next sprint capacity

Card 4: Estimation Accuracy
- Value: [X] items with missing estimates
- Percentage of total items
- Data quality indicator
```

### Sprint Performance Summary (25% height)
```
Key Insights Panel:
- Scope Creep Analysis: Text summary of scope changes
- Delivery Performance: Commentary on over/under delivery  
- Quality Indicators: Estimation gaps and process issues
- Recommendations: Actionable insights for next sprint

Sprint Timeline (if space allows):
- Gantt-style view showing when scope changes occurred
- Milestone markers for key events
- Color coding for different types of work
```

## Executive Dashboard Template

### KPI Cards Row
```
Card 1: Sprint Velocity
- Current: [X] story points
- Previous: [Y] story points  
- Trend: [↑/↓] [%] change
- Color: Green/Red based on trend

Card 2: Delivery Reliability
- Value: [X]% of commitments delivered
- Target: 80%
- Status: On Track/At Risk/Off Track
- Color: Green/Yellow/Red

Card 3: Team Utilization
- Value: [X]% capacity utilization
- Target: 70-85%
- Status: Optimal/Under/Over utilized
- Color: Green/Blue/Red

Card 4: Quality Score
- Value: [X] defects per story point
- Target: <0.1
- Trend: [↑/↓] from last sprint
- Color: Green/Red based on trend
```

### Charts Section
```
Chart 1: Velocity Trend (60% width)
- Type: Line chart with markers
- Data: Last 12 sprints velocity
- Show: Actual, Average, Trend line
- Y-axis: Story Points
- X-axis: Sprint names

Chart 2: Work Distribution (40% width)
- Type: Donut chart
- Data: Current quarter work types
- Slices: Features, Bugs, Support, Tech Debt
- Show: Percentages and counts
```

### Details Table
```
Current Sprint Status:
Columns: Story Title | Status | Assigned To | Story Points | Days Remaining
Sorting: By status (In Progress first)
Highlighting: Overdue items in red
Filters: Show only current sprint items
```

## Team Lead Dashboard Template

### Sprint Metrics Row (25% height)
```
Burndown Chart (60% width):
- Type: Line chart
- Lines: Ideal burndown, Actual remaining work
- X-axis: Sprint days (1-10)
- Y-axis: Remaining story points
- Annotations: Weekends marked

Capacity Gauge (40% width):
- Type: Gauge chart  
- Value: Current sprint capacity used
- Ranges: 0-70% (Blue), 70-85% (Green), 85-100% (Yellow), 100%+ (Red)
- Show: Percentage and hours
```

### Team Performance Row (50% height)
```
Individual Performance (50% width):
- Type: Clustered bar chart
- X-axis: Team member names
- Y-axis: Story points completed
- Series: This sprint, Last sprint, Average
- Colors: Blue, Light blue, Gray

Cycle Time Trend (50% width):
- Type: Line chart with markers
- X-axis: Last 8 weeks
- Y-axis: Average cycle time (days)
- Lines: Cycle time, Target (3 days)
- Show: Data labels on points
```

### Work Status Row (25% height)
```
Status Distribution (60% width):
- Type: Stacked horizontal bar
- Categories: Stories, Tasks, Bugs
- Status: New, Active, Review, Done
- Colors: Gray, Blue, Orange, Green

Active Impediments (40% width):
- Type: Table
- Columns: Item, Blocker, Days Blocked, Owner
- Sorting: By days blocked (desc)
- Highlighting: >3 days in red
```

## Team Member Dashboard Template

### Personal Metrics Cards
```
Card 1: My Current Work
- Value: [X] active items
- Detail: [Y] story points in progress
- Link: Click to see item list

Card 2: This Sprint Completed  
- Value: [X] story points done
- Target: Personal velocity target
- Status: On track/Behind/Ahead

Card 3: Time Tracking
- Value: [X]% of time logged daily
- Target: 100% daily logging
- Status: Good/Needs attention

Card 4: Cycle Time
- Value: [X] days average
- Target: Team target (3 days)
- Trend: Improving/Consistent/Declining
```

### Personal Work Views
```
My Active Work:
- Type: Kanban board view
- Columns: To Do, In Progress, Review, Done
- Cards: Show title, story points, time remaining
- Filters: Assigned to current user

My Time This Week:
- Type: Stacked bar chart
- X-axis: Days of week
- Y-axis: Hours logged
- Series: Development, Testing, Meetings, Admin
- Target line: 8 hours per day
```

## Stakeholder Dashboard Template

### High-Level Status Cards
```
Card 1: Features Delivered
- Value: [X] features completed this quarter
- Plan: [Y] features planned
- Status: [X/Y] with progress bar

Card 2: Support Response
- Value: [X] hours average response time
- Target: <4 hours
- Status: Meeting/Missing SLA

Card 3: Upcoming Deliveries
- Value: [X] features in next 2 sprints
- Detail: Expected delivery dates
- Risk: Green/Yellow/Red status
```

### Progress Visualizations
```
Feature Progress Timeline:
- Type: Gantt chart view
- Rows: Major features/epics
- Columns: Timeline (months)
- Status: Not started, In progress, Complete
- Milestones: Major release dates

Support Metrics:
- Type: Multi-line chart
- Lines: Requests received, Requests resolved
- X-axis: Weekly periods
- Y-axis: Count of requests
- Show: Backlog accumulation
```

---

# Implementation Guide

## Phase 1: Foundation Setup (Week 1-2)

### Prerequisites Checklist
- [ ] Azure DevOps Analytics enabled
- [ ] Power BI licenses acquired
- [ ] Team members identified and trained
- [ ] Data governance policies established
- [ ] Security and access controls defined

### Initial Setup Tasks
- [ ] Create Power BI workspace
- [ ] Configure Azure DevOps analytics views
- [ ] Set up data connections and refresh schedules
- [ ] Create basic executive dashboard
- [ ] Test data accuracy and refresh processes

### Validation Steps
- [ ] Verify data accuracy against manual calculations
- [ ] Test refresh schedules and error handling
- [ ] Confirm dashboard loading times are acceptable
- [ ] Validate security and access controls
- [ ] Get stakeholder approval on initial views

## Phase 2: Core Dashboard Development (Week 3-6)

### Team Dashboard Creation
- [ ] Build sprint burndown and velocity charts
- [ ] Create team capacity utilization views
- [ ] Implement cycle time and throughput metrics
- [ ] Add work item status and impediment tracking
- [ ] Create drill-through capabilities for details

### Individual Dashboard Development  
- [ ] Build personal productivity metrics
- [ ] Create individual work item views
- [ ] Implement time tracking dashboards
- [ ] Add personal goal tracking
- [ ] Enable self-service capabilities

### Quality Assurance
- [ ] Test all visualizations with real data
- [ ] Verify calculations and formulas
- [ ] Ensure mobile responsiveness
- [ ] Test performance with large datasets
- [ ] Conduct user acceptance testing

## Phase 3: Advanced Features (Week 7-10)

### Enhanced Analytics
- [ ] Implement predictive analytics for velocity
- [ ] Create trend analysis and forecasting
- [ ] Add comparative analysis across teams
- [ ] Implement automated alerts and notifications
- [ ] Create executive summary reports

### Integration and Automation
- [ ] Set up automated report distribution
- [ ] Integrate with Microsoft Teams notifications
- [ ] Create PowerAutomate workflows
- [ ] Implement data quality monitoring
- [ ] Set up backup and disaster recovery

### User Training and Adoption
- [ ] Create user guides and documentation
- [ ] Conduct training sessions for different user groups
- [ ] Establish dashboard governance and maintenance
- [ ] Create feedback collection mechanisms
- [ ] Plan for ongoing support and enhancement

## Implementation Best Practices

### Data Quality Management
1. **Establish data standards** for work item creation and updates
2. **Implement validation rules** in Azure DevOps
3. **Create data quality dashboards** to monitor completeness
4. **Train team members** on proper data entry
5. **Regular data audits** and cleanup processes

### Performance Optimization
1. **Use import mode** instead of DirectQuery when possible
2. **Implement incremental refresh** for large datasets
3. **Optimize DAX measures** for better performance
4. **Use aggregations** for frequently accessed data
5. **Monitor and optimize** refresh times regularly

### User Adoption Strategies
1. **Start with simple dashboards** and add complexity gradually
2. **Provide relevant views** for different user types
3. **Make dashboards actionable** with clear next steps
4. **Regular training sessions** and office hours
5. **Celebrate wins** and share success stories

---

# Maintenance and Updates

## Regular Maintenance Tasks

### Daily Tasks
- [ ] Monitor data refresh status and resolve any failures
- [ ] Check dashboard performance and user feedback
- [ ] Review automated alerts and notifications
- [ ] Respond to user questions and support requests

### Weekly Tasks  
- [ ] Review data quality metrics and address issues
- [ ] Update dashboard content based on user feedback
- [ ] Check security access and permissions
- [ ] Backup dashboard definitions and data sources
- [ ] Review usage analytics and adoption metrics

### Monthly Tasks
- [ ] Conduct comprehensive data quality audit
- [ ] Review and update dashboard designs based on needs
- [ ] Analyze user adoption and engagement metrics
- [ ] Update documentation and training materials
- [ ] Plan enhancements and new feature development

### Quarterly Tasks
- [ ] Review dashboard strategy and alignment with business goals
- [ ] Conduct user satisfaction surveys
- [ ] Evaluate new Power BI features and capabilities
- [ ] Update disaster recovery and business continuity plans
- [ ] Assess cost and licensing optimization opportunities

## Version Control and Change Management

### Dashboard Version Control
- [ ] Use Power BI deployment pipelines for environment management
- [ ] Maintain documentation of all dashboard changes
- [ ] Implement approval process for major changes
- [ ] Keep backup copies of previous versions
- [ ] Test changes in development environment first

### Change Communication Process
1. **Assess impact** of proposed changes
2. **Get stakeholder approval** for significant changes  
3. **Schedule changes** during low-usage periods
4. **Communicate changes** to all users in advance
5. **Provide training** on new features
6. **Monitor adoption** and address issues

## Continuous Improvement

### Performance Monitoring
- [ ] Track dashboard loading times and optimize slow reports
- [ ] Monitor data refresh success rates and durations
- [ ] Analyze user engagement and identify unused features
- [ ] Review error logs and implement preventive measures
- [ ] Benchmark performance against industry standards

### Feature Enhancement Process
1. **Collect user feedback** regularly through surveys and interviews
2. **Prioritize enhancement requests** based on business value
3. **Create development roadmap** with timelines
4. **Test new features** thoroughly before deployment
5. **Measure success** of new features post-deployment

### Knowledge Management
- [ ] Maintain comprehensive documentation library
- [ ] Create video tutorials for complex features
- [ ] Build FAQ database for common issues
- [ ] Establish community of practice for power users
- [ ] Regular knowledge sharing sessions

This comprehensive guide provides the foundation for implementing effective metrics dashboards that will support data-driven decision making for BAU teams adopting Agile practices. The combination of Power BI and Azure DevOps analytics provides a powerful platform for tracking team performance, delivery predictability, and continuous improvement initiatives.
