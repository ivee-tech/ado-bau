# Azure DevOps Queries for Scope Creep Detection

This document contains Azure DevOps Work Item Query Language (WIQL) queries converted from the PowerShell script for detecting scope creep in sprints.

## Prerequisites

Before using these queries, ensure you have:
- A custom field `AddedToIterationDate` to track when items were added to the iteration
- Access to create and save queries in Azure DevOps
- Appropriate permissions to view work items in the project

## WIQL Macros and Date Handling

These queries use Azure DevOps WIQL macros for dynamic iteration handling:

- **`@CurrentIteration`** - Automatically resolves to the current iteration path for your team
- **`@CurrentIteration('[Team Name]')`** - Resolves to current iteration for a specific team

**Important Note about @CurrentIteration:**
The @CurrentIteration macro requires a team context. You have several options:

1. **Team-specific queries** - Use `@CurrentIteration('[Team Name]')` with your team name
2. **Manual iteration path** - Use explicit iteration path like `'Project\Sprint 1'`
3. **Parameterized iteration** - Use `@IterationPath` parameter

**Note on Date Handling:**
Azure DevOps WIQL doesn't have a built-in macro for iteration start dates. You have several options:

1. **Use a parameter/variable** - Define the sprint start date as a query parameter
2. **Use relative date macros** - Like `@Today-7` for a week ago
3. **Manually update the date** - Update the date when setting up queries for each sprint
4. **Use iteration field comparisons** - Compare against iteration-related system fields

**Benefits of using iteration macros:**
- No need to manually update iteration paths
- Queries automatically work for different teams
- Reusable across team members without modification

## Query 1: Initial Sprint Items (Baseline)

**Purpose:** Find all work items that were added to the sprint before the sprint start date.

**Using team-specific current iteration (Recommended)**
```wiql
SELECT [System.Id],
       [System.Title],
       [System.WorkItemType],
       [System.State],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [System.IterationPath],
       [Custom.AddedToIterationDate]
FROM WorkItems
WHERE [System.IterationPath] = @CurrentIteration('[Your Team Name]')
  AND [Custom.AddedToIterationDate] <= @SprintStartDate
  AND [System.WorkItemType] IN ('User Story', 'Issue', 'Support Request', 'Bug')
ORDER BY [System.WorkItemType], [System.Id]
```

## Query 2: Items Added During Sprint (Scope Creep)

**Purpose:** Find all work items that were added to the sprint after the sprint started.

**Using team-specific current iteration (Recommended)**
```wiql
SELECT [System.Id],
       [System.Title],
       [System.WorkItemType],
       [System.State],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [System.IterationPath],
       [Custom.AddedToIterationDate]
FROM WorkItems
WHERE [System.IterationPath] = @CurrentIteration('[Your Team Name]')
  AND [Custom.AddedToIterationDate] > @SprintStartDate
  AND [System.WorkItemType] IN ('User Story', 'Issue', 'Support Request', 'Bug')
ORDER BY [Custom.AddedToIterationDate], [System.WorkItemType]
```


**Option B: Using relative date macro**
```wiql
SELECT [System.Id],
       [System.Title],
       [System.WorkItemType],
       [System.State],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [System.IterationPath],
       [Custom.AddedToIterationDate]
FROM WorkItems
WHERE [System.IterationPath] = @CurrentIteration('[Your Team Name]')
  AND [Custom.AddedToIterationDate] > @Today-14
  AND [System.WorkItemType] IN ('User Story', 'Issue', 'Support Request', 'Bug')
ORDER BY [Custom.AddedToIterationDate], [System.WorkItemType]
```

## Query 3: All Sprint Items with Addition Timeline

**Purpose:** Get a complete view of all sprint items with their addition dates for analysis.

```wiql
SELECT [System.Id],
       [System.Title],
       [System.WorkItemType],
       [System.State],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [System.IterationPath],
       [Custom.AddedToIterationDate],
       [System.CreatedDate]
FROM WorkItems
WHERE [System.IterationPath] = @CurrentIteration('[Your Team Name]')
  AND [System.WorkItemType] IN ('User Story', 'Issue', 'Support Request', 'Bug')
ORDER BY [Custom.AddedToIterationDate], [System.WorkItemType]
```

## Query 4: User Stories Only - Initial vs Added

**Purpose:** Focus specifically on User Stories for story point-based scope creep analysis.

### Initial User Stories:
```wiql
SELECT [System.Id],
       [System.Title],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [System.State],
       [Custom.AddedToIterationDate]
FROM WorkItems
WHERE [System.IterationPath] = @CurrentIteration('[Your Team Name]')
  AND [Custom.AddedToIterationDate] <= @SprintStartDate
  AND [System.WorkItemType] IN ('User Story', 'Issue', 'Support Request', 'Bug')
ORDER BY [Microsoft.VSTS.Scheduling.StoryPoints] DESC
```

### Added User Stories:
```wiql
SELECT [System.Id],
       [System.Title],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [System.State],
       [Custom.AddedToIterationDate]
FROM WorkItems
WHERE [System.IterationPath] = @CurrentIteration('[Your Team Name]')
  AND [Custom.AddedToIterationDate] > @SprintStartDate
  AND [System.WorkItemType] IN ('User Story', 'Issue', 'Support Request', 'Bug')
ORDER BY [Custom.AddedToIterationDate], [Microsoft.VSTS.Scheduling.StoryPoints] DESC
```

## Query 5: Scope Creep Dashboard Query

**Purpose:** Combined query to show scope creep metrics in a single view.

```wiql
SELECT [System.Id],
       [System.Title],
       [System.WorkItemType],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [Custom.AddedToIterationDate],
       [System.State]
FROM WorkItems
WHERE [System.IterationPath] = @CurrentIteration('[Your Team Name]')
  AND [System.WorkItemType] IN ('User Story', 'Issue', 'Support Request', 'Bug')
ORDER BY [Custom.AddedToIterationDate], [Microsoft.VSTS.Scheduling.StoryPoints] DESC
```

## How to Use These Queries

### Step 1: Create the Queries in Azure DevOps

1. Navigate to **Boards** > **Queries** in your Azure DevOps project
2. Click **New query**
3. Select **Work items and direct links** or **Work items only**
4. Switch to **Query Editor** mode
5. Paste one of the queries above
6. **For @CurrentIteration('[Your Team Name]') queries:**
   - Replace `[Your Team Name]` with your actual team name (e.g., `'Dev Team Alpha'`)
   - Ensure the team name matches exactly as it appears in Azure DevOps
7. **For parameterized queries:**
   - **@SprintStartDate parameter:**
     - Click **New** under Parameters
     - Add parameter name: `SprintStartDate`
     - Set data type: `DateTime`
     - Set default value: your sprint start date (e.g., `2025-08-26`)
   - **@IterationPath parameter (alternative to team-specific @CurrentIteration):**
     - Click **New** under Parameters
     - Add parameter name: `IterationPath`
     - Set data type: `String`
     - Set default value: your iteration path (e.g., `'YourProject\Sprint 1'`)
8. Replace the following placeholders:
   - `Custom.AddedToIterationDate` with your actual custom field name (if different)
   - Adjust work item types if using different process templates

### Handling @CurrentIteration Team Requirement

The `@CurrentIteration` macro requires team context. Choose one of these approaches:

**Option 1: Team-Specific Queries (Recommended)**
- Use `@CurrentIteration('[Your Team Name]')`
- Replace `[Your Team Name]` with your exact team name
- Example: `@CurrentIteration('Velocity Crew')`

**Option 2: Parameterized Iteration Path**
- Use `@IterationPath` parameter instead of `@CurrentIteration`
- Set up the parameter as described above
- More flexible for cross-team usage

**Option 3: Explicit Iteration Path**
- Replace `@CurrentIteration` with explicit path like `'Project\Sprint 1'`
- Update manually for each sprint

### Using Query Parameters

When using `@SprintStartDate` parameter:
1. Save the query with the parameter defined
2. When running the query, you'll be prompted to enter the sprint start date
3. The parameter value will be remembered for future runs
4. You can update the parameter value for different sprints

### Step 2: Save and Run

1. Click **Save query**
2. Give it a descriptive name (e.g., "Sprint Scope Creep - Initial Items")
3. Choose a folder location
4. Run the query to see results

### Step 3: Create a Dashboard

1. Create a dashboard in Azure DevOps
2. Add **Query tile** widgets
3. Configure each widget to use your saved queries
4. Add **Chart** widgets to visualize story point distribution

## Scope Creep Analysis Guidelines

### Calculate Scope Creep Percentage:
```
Scope Creep % = (Added Story Points / Initial Story Points) × 100
```

### Alert Thresholds:
- **🔴 High (>30%):** Review sprint planning process
- **🟡 Moderate (15-30%):** Monitor capacity impact  
- **🟢 Minor (5-15%):** Within acceptable range
- **✅ Stable (<5%):** Sprint scope maintained

### Additional Metrics to Track:
- Number of items added vs initial count
- Story points added vs initial story points
- Types of work items being added (User Stories vs Bugs vs Tasks)
- Timeline of additions throughout the sprint
- Correlation with sprint velocity and completion rates

## Alternative WIQL Macros

### Valid Azure DevOps WIQL Date Macros:

```wiql
-- Use relative date macros (these are valid)
WHERE [Custom.AddedToIterationDate] > @Today-14        -- 14 days ago
WHERE [Custom.AddedToIterationDate] > @Today-7         -- 1 week ago  
WHERE [System.CreatedDate] >= @Today-30                -- 30 days ago

-- For previous iteration analysis
WHERE [System.IterationPath] = @CurrentIteration - 1

-- For next iteration planning  
WHERE [System.IterationPath] = @CurrentIteration + 1

-- For current and future iterations
WHERE [System.IterationPath] IN (@CurrentIteration, @CurrentIteration + 1, @CurrentIteration + 2)
```

### Parameter-Based Approach (Recommended):

Create queries with parameters that can be set when running:

```wiql
-- Define @SprintStartDate as a parameter when creating the query
WHERE [Custom.AddedToIterationDate] <= @SprintStartDate
WHERE [Custom.AddedToIterationDate] > @SprintStartDate
```

## Alternative Implementations

### For Teams Without Custom Date Field

If you don't have a custom `AddedToIterationDate` field, you can use these alternative approaches:

#### Option 1: Use Created Date (Less Accurate)
```wiql
SELECT [System.Id],
       [System.Title],
       [System.WorkItemType],
       [Microsoft.VSTS.Scheduling.StoryPoints],
       [System.CreatedDate]
FROM WorkItems
WHERE [System.IterationPath] = @CurrentIteration
  AND [System.CreatedDate] > @SprintStartDate
  AND [System.WorkItemType] = 'User Story'
```

#### Option 2: Use Iteration Changed Date (Requires History Tracking)
This would require a more complex approach using Azure DevOps REST API to track iteration path changes.

## Notes and Limitations

1. **Custom Field Requirement:** The primary limitation is the need for a custom field to track when items were added to iterations
2. **Historical Data:** These queries work best when you have historical data in the custom field
3. **Work Item Types:** Adjust the work item types in the `IN` clause based on your process template
4. **Date Format:** Ensure dates are in YYYY-MM-DD format
5. **Permissions:** Users need appropriate permissions to run queries and view work items

## Next Steps

1. Implement the custom field `AddedToIterationDate` if not already present
2. Create a process to populate this field when items are added to iterations
3. Set up these queries as saved queries in Azure DevOps
4. Create dashboards to visualize scope creep trends
5. Establish team agreements on acceptable scope creep thresholds
