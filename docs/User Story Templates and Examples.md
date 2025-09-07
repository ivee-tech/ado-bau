# User Story Templates and Examples

## User Story Template

```
**Title**: [Descriptive title of the capability]

**Description**: 
As a [type of user/role]
I want [goal/desire]
So that [benefit/business value]

**Background/Context**:
[Additional context, business rules, or background information]

**Acceptance Criteria**:
Given [precondition/context]
When [action/trigger]
Then [expected result]

And [additional conditions if needed]

**Priority**: [Must Have/Should Have/Could Have/Won't Have]
**Story Points**: [To be estimated during planning]
**Dependencies**: [List any dependencies on other stories or external factors]
**Notes**: [Additional information, assumptions, or clarifications]
```

## Epic Template

```
**Epic Title**: [High-level capability or business objective]

**Epic Description**:
As a [stakeholder]
I want [high-level goal]
So that [business outcome]

**Business Value**:
[Description of the business value and impact]

**Success Criteria**:
- [Measurable outcome 1]
- [Measurable outcome 2]
- [Measurable outcome 3]

**User Stories**:
- [List of related user stories]

**Acceptance Criteria for Epic**:
[High-level criteria that define when the epic is complete]

**Estimated Size**: [T-shirt size or story point range]
**Target Timeline**: [Expected completion timeframe]
```

## Task Template

```
**Task Title**: [Specific technical or implementation task]

**Description**:
[Detailed description of the technical work required]

**Parent Story**: [Link to the parent user story]

**Acceptance Criteria**:
- [Specific technical criteria]
- [Testing requirements]
- [Documentation requirements]

**Estimated Hours**: [Hour estimate]
**Assigned To**: [Team member]
**Dependencies**: [Technical dependencies]
```

## Bug Template

```
**Bug Title**: [Brief description of the issue]

**Priority**: [Critical/High/Medium/Low]
**Severity**: [Critical/High/Medium/Low]

**Description**:
[Detailed description of the bug]

**Steps to Reproduce**:
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected Behavior**:
[What should happen]

**Actual Behavior**:
[What actually happens]

**Environment**:
- Browser: [if applicable]
- OS: [if applicable]
- Version: [application version]

**Screenshots/Logs**:
[Attach relevant screenshots or error logs]

**Acceptance Criteria for Fix**:
Given [the same preconditions]
When [the same actions are performed]
Then [the expected behavior should occur]
```

## Support Request Template

```
**Request Title**: [Brief description of the support need]

**Request Type**: [Investigation/Configuration/Maintenance/Training]
**Priority**: [Urgent/High/Medium/Low]

**Description**:
[Detailed description of what support is needed]

**Business Impact**:
[How this impacts business operations]

**Requested By**: [Stakeholder name and role]
**Due Date**: [If time-sensitive]

**Acceptance Criteria**:
- [What constitutes completion]
- [Expected deliverables]
- [Success measures]

**Estimated Effort**: [Initial estimate]
```

---

# User Story Examples

## Example 1: Authentication Feature

```
**Title**: User can log in with email and password

**Description**: 
As a registered user
I want to log in to the system using my email and password
So that I can access my personalized dashboard and account information

**Background/Context**:
Users have already registered accounts and need secure access to the system. The login system should integrate with our existing user database.

**Acceptance Criteria**:
Given I am on the login page
When I enter a valid email and password
Then I should be redirected to my dashboard
And I should see my username displayed in the header

Given I am on the login page
When I enter an invalid email or password
Then I should see an error message "Invalid credentials"
And I should remain on the login page

Given I am on the login page
When I leave the email field empty and click login
Then I should see an error message "Email is required"

Given I am on the login page
When I leave the password field empty and click login
Then I should see an error message "Password is required"

**Priority**: Must Have
**Story Points**: 5
**Dependencies**: User registration system must be complete
**Notes**: Consider implementing "Remember Me" functionality in a future story
```

## Example 2: Reporting Feature

```
**Title**: Finance team can generate monthly expense reports

**Description**: 
As a finance team member
I want to generate monthly expense reports with filtering options
So that I can analyze spending patterns and prepare budget reports for management

**Background/Context**:
The finance team currently manually compiles expense data from multiple sources. They need an automated way to generate comprehensive reports with various filtering and export options.

**Acceptance Criteria**:
Given I am logged in as a finance team member
When I navigate to the reports section
Then I should see a "Generate Monthly Expense Report" option

Given I am on the expense report generation page
When I select a specific month and year
And I click "Generate Report"
Then I should see a report showing all expenses for that month
And the report should include expense categories, amounts, and dates

Given I have generated an expense report
When I select specific department filters
Then the report should update to show only expenses from selected departments

Given I have a generated report displayed
When I click the "Export to Excel" button
Then an Excel file should be downloaded with the current report data

Given I try to generate a report without selecting a month
When I click "Generate Report"
Then I should see an error message "Please select a month and year"

**Priority**: Should Have
**Story Points**: 8
**Dependencies**: Expense data API must be available
**Notes**: Future enhancements could include automated email delivery of reports
```

## Example 3: Bug Fix

```
**Title**: Fix mobile app crash when accessing user profile

**Description**: 
As a mobile app user
I want to be able to access my user profile without the app crashing
So that I can view and edit my personal information

**Background/Context**:
Users are reporting that the mobile app consistently crashes when they try to access their user profile page. This is affecting user experience and preventing users from updating their information.

**Acceptance Criteria**:
Given I am using the mobile app
When I tap on the "Profile" button
Then the profile page should load successfully
And I should see my current profile information

Given I am on the profile page
When I scroll through my profile information
Then the app should remain stable and responsive

Given I am on the profile page
When I tap "Edit Profile"
Then the edit form should load without crashing

**Priority**: Must Have
**Story Points**: 3
**Dependencies**: None
**Notes**: This is affecting approximately 15% of mobile users based on crash reports
```

## Example 4: BAU Support Request

```
**Title**: Investigate slow database query performance

**Description**: 
As a system administrator
I want to investigate and resolve slow database query performance
So that application response times return to acceptable levels

**Background/Context**:
Users are reporting slow application response times, particularly when loading dashboard data. Database monitoring shows some queries are taking 10+ seconds to complete.

**Acceptance Criteria**:
Given the database performance issue exists
When I analyze query execution plans
Then I should identify the queries causing performance problems

Given I have identified problematic queries
When I implement optimization solutions (indexing, query tuning, etc.)
Then query execution times should be reduced to under 2 seconds

Given optimizations have been implemented
When I monitor database performance for 24 hours
Then average query response time should be under 1 second
And there should be no queries taking longer than 5 seconds

**Priority**: High
**Story Points**: 5
**Dependencies**: Database access and monitoring tools
**Notes**: May require temporary maintenance window for index creation
```

## Example 5: Epic Example

```
**Epic Title**: Implement Multi-Factor Authentication (MFA)

**Epic Description**:
As a security-conscious organization
We want to implement multi-factor authentication across all applications
So that we can significantly improve security and protect against unauthorized access

**Business Value**:
- Enhanced security posture reducing risk of data breaches
- Compliance with industry security standards
- Improved customer trust and confidence
- Reduced liability from security incidents

**Success Criteria**:
- 95% of users successfully enrolled in MFA within 60 days
- Zero successful unauthorized access attempts after implementation
- Compliance audit score improvement of 25%
- User satisfaction score of 4+ out of 5 for MFA experience

**User Stories**:
- User can set up MFA using authenticator app
- User can set up MFA using SMS
- User can recover access when MFA device is lost
- Admin can enforce MFA for specific user groups
- Admin can generate MFA compliance reports
- System can send MFA setup reminders
- User can manage backup codes for MFA

**Acceptance Criteria for Epic**:
Given the MFA system is fully implemented
When all user stories are completed and deployed
Then users should be able to use multiple authentication factors
And administrators should have full control and visibility
And the system should meet all security requirements

**Estimated Size**: XL (40-60 story points)
**Target Timeline**: 3-4 sprints (6-8 weeks)
```

---

# Writing Guidelines

## INVEST Principle Application

### Independent
- Each story should be able to be developed separately
- Minimize dependencies between stories
- If dependencies exist, clearly document them

### Negotiable
- Stories are not detailed requirements but conversation starters
- Details should be discussed with the team and stakeholders
- Be open to changes and refinements

### Valuable
- Each story should deliver value to the end user or business
- Clearly articulate the benefit in the "so that" clause
- Avoid purely technical stories (frame them in business value terms)

### Estimable
- Stories should be clear enough to estimate
- If a story can't be estimated, it needs more refinement
- Break down large or unclear stories

### Small
- Stories should be completable within one sprint
- Large stories should be broken into smaller ones
- Aim for stories that are 1-8 story points

### Testable
- Clear acceptance criteria make testing possible
- Acceptance criteria should be specific and measurable
- Consider both positive and negative test scenarios

## Common Pitfalls to Avoid

### Vague Acceptance Criteria
❌ **Poor**: "The system should work correctly"
✅ **Good**: "Given valid input, when the user submits the form, then they should see a success message"

### Technical Implementation Focus
❌ **Poor**: "As a developer, I want to implement caching so that the system performs better"
✅ **Good**: "As a user, I want pages to load quickly (under 2 seconds) so that I can complete my tasks efficiently"

### Too Large or Epic-Sized
❌ **Poor**: "As a user, I want a complete e-commerce system so that I can buy products online"
✅ **Good**: Break into smaller stories like "User can add items to cart", "User can checkout", etc.

### Missing Business Value
❌ **Poor**: "As a user, I want a new button on the page"
✅ **Good**: "As a user, I want a quick access button to my recent orders so that I can reorder items faster"

## Story Refinement Checklist

- [ ] Story follows the "As a, I want, So that" format
- [ ] Acceptance criteria are clear and testable
- [ ] Story is appropriately sized for one sprint
- [ ] Business value is clearly articulated
- [ ] Dependencies are identified and documented
- [ ] Story is independent enough to be developed separately
- [ ] Priority is assigned based on business value and urgency
- [ ] Story has been reviewed by relevant stakeholders

## Template Usage Guidelines

1. **Choose the Right Template**: Use the appropriate template based on the type of work
2. **Adapt as Needed**: Templates are starting points; modify them to fit your context
3. **Be Consistent**: Use the same template format across the team
4. **Review Regularly**: Update templates based on lessons learned
5. **Train the Team**: Ensure everyone understands how to use the templates effectively
