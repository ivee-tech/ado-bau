# Sprint Planning and Backlog Management Guide

## Table of Contents
1. [Product Backlog Management](#product-backlog-management)
2. [Backlog Refinement Process](#backlog-refinement-process)
3. [Sprint Planning Guide](#sprint-planning-guide)
4. [Azure DevOps Setup](#azure-devops-setup)
5. [BAU-Specific Considerations](#bau-specific-considerations)
6. [Templates and Checklists](#templates-and-checklists)

---

# Product Backlog Management

## What is a Product Backlog?

The Product Backlog is a prioritized list of features, enhancements, bug fixes, and technical work that needs to be done for a product or system. For BAU (Business As Usual) teams, this includes both planned development work and reactive support tasks.

## Backlog Characteristics

### Single Source of Truth
- **Centralized location** for all work items
- **One authoritative list** that everyone refers to
- **Visible to all stakeholders**
- **Maintained in Azure DevOps**

### Dynamic and Evolving
- **Constantly changing** based on business needs
- **Items added, removed, and reprioritized**
- **Refined through ongoing collaboration**
- **Reflects current understanding and priorities**

### Prioritized
- **Items ordered by value and urgency**
- **Highest priority items at the top**
- **Regular reprioritization based on feedback**
- **Clear rationale for priority decisions**

## Types of Backlog Items

### 1. Epics
Large bodies of work that span multiple sprints
- **Example**: "Implement new customer portal"
- **Size**: 20+ story points
- **Duration**: Multiple sprints

### 2. Features
Significant functionality that provides value
- **Example**: "User authentication system"
- **Size**: 8-20 story points
- **Duration**: 1-2 sprints

### 3. User Stories
Specific capabilities from user perspective
- **Example**: "User can reset password via email"
- **Size**: 1-8 story points
- **Duration**: Within one sprint

### 4. Tasks
Technical work or implementation details
- **Example**: "Configure SSL certificate"
- **Size**: 1-4 hours
- **Duration**: Part of a sprint

### 5. Bugs
Defects that need to be resolved
- **Example**: "Login page crashes on mobile"
- **Priority**: Based on severity and impact
- **Size**: Varies

### 6. Technical Debt
Code quality improvements
- **Example**: "Refactor legacy authentication code"
- **Justification**: Performance or maintainability
- **Size**: Varies

### 7. Support Requests (BAU-specific)
Operational and maintenance work
- **Example**: "Investigate slow database queries"
- **Urgency**: Often time-sensitive
- **Size**: Varies

## Backlog Prioritization

### Prioritization Frameworks

#### MoSCoW Method
- **M**ust Have: Critical for success
- **S**hould Have: Important but not critical
- **C**ould Have: Nice to have if time permits
- **W**on't Have: Not in this iteration

#### Value vs. Effort Matrix
```
High Value, Low Effort  → Quick Wins (Do First)
High Value, High Effort → Major Projects (Do Second)
Low Value, Low Effort   → Fill-ins (Do Third)
Low Value, High Effort  → Thankless Tasks (Don't Do)
```

#### Weighted Scoring
Factors to consider:
- **Business Value** (1-10)
- **Urgency** (1-10)
- **Effort** (1-10, inversely weighted)
- **Risk** (1-10, inversely weighted)
- **Dependencies** (1-10, inversely weighted)

### BAU Prioritization Considerations
- **Production issues**: Highest priority
- **Security vulnerabilities**: High priority
- **Regulatory compliance**: High priority
- **Business process improvements**: Medium priority
- **Technical debt**: Ongoing, balanced with features
- **Nice-to-have features**: Lower priority

## Backlog Management Best Practices

### Regular Maintenance
- **Weekly backlog review** with Product Owner
- **Monthly stakeholder review** for major priorities
- **Quarterly strategic alignment** check
- **Continuous refinement** as needs change

### Clear Ownership
- **Product Owner** owns the backlog
- **Stakeholders** provide input and feedback
- **Development Team** provides technical input
- **Scrum Master** facilitates the process

### Transparency
- **Visible to all team members** and stakeholders
- **Clear rationale** for prioritization decisions
- **Regular communication** about changes
- **Open discussion** about priorities

---

# Backlog Refinement Process

## What is Backlog Refinement?

Backlog refinement (formerly called "grooming") is the ongoing process of reviewing items in the product backlog to ensure they are appropriately prepared, estimated, and prioritized for upcoming sprints.

## Refinement Activities

### 1. Clarification
- **Add missing details** to user stories
- **Define acceptance criteria** clearly
- **Resolve ambiguities** and assumptions
- **Gather stakeholder input**

### 2. Estimation
- **Size stories** using story points
- **Use planning poker** for team consensus
- **Consider complexity, effort, and risk**
- **Break down large items**

### 3. Prioritization
- **Reassess business value** and urgency
- **Consider dependencies** and constraints
- **Balance technical debt** with features
- **Align with business strategy**

### 4. Decomposition
- **Break epics** into features
- **Split features** into user stories
- **Identify tasks** within stories
- **Ensure stories are sprint-sized**

## Refinement Meeting Structure

### Frequency and Duration
- **Weekly refinement sessions**: 1-2 hours
- **Ongoing refinement**: As needed throughout the sprint
- **Just-in-time refinement**: Right before sprint planning

### Participants
- **Product Owner**: Provides requirements and priorities
- **Development Team**: Provides technical insights and estimates
- **Scrum Master**: Facilitates the process
- **Stakeholders**: As needed for specific items

### Agenda Template
```
1. Review newly added items (15 minutes)
   - Understand requirements
   - Ask clarifying questions
   - Identify dependencies

2. Estimate unestimated items (30 minutes)
   - Use planning poker
   - Discuss differences in estimates
   - Reach team consensus

3. Break down large items (30 minutes)
   - Identify epics that need splitting
   - Create smaller, manageable stories
   - Maintain business value focus

4. Reprioritize as needed (15 minutes)
   - Review current priorities
   - Adjust based on new information
   - Confirm top items are ready for sprint planning
```

## Definition of Ready (DoR)

A user story is "ready" for sprint planning when it meets these criteria:

### Story Level Criteria
- [ ] **Title** is clear and descriptive
- [ ] **User story format** is followed (As a, I want, So that)
- [ ] **Acceptance criteria** are defined and testable
- [ ] **Business value** is clearly articulated
- [ ] **Priority** is assigned
- [ ] **Dependencies** are identified

### Team Level Criteria
- [ ] **Story is estimated** by the team
- [ ] **Size is appropriate** for one sprint
- [ ] **Team understands** the requirements
- [ ] **Technical approach** is clear
- [ ] **Testing strategy** is understood

### Organizational Level Criteria
- [ ] **Stakeholder approval** if required
- [ ] **Compliance considerations** addressed
- [ ] **Budget approval** if needed
- [ ] **Resource availability** confirmed


## Definition of Done (DoD)

A user story is "done" when it meets all the criteria defined by the team for completed work. The Definition of Done ensures consistent quality and completeness across all deliverables.

### Story Level Criteria
- [ ] **All acceptance criteria** are met and verified
- [ ] **Code is complete** and implements all required functionality
- [ ] **Code review** completed by at least one other team member
- [ ] **Unit tests** written and passing (minimum 80% code coverage)
- [ ] **Integration tests** completed successfully
- [ ] **Documentation** updated (technical docs, user guides, API docs)
- [ ] **No critical or high-severity defects** remain unresolved

### Quality Assurance Criteria
- [ ] **Functional testing** completed and passed
- [ ] **User acceptance testing** completed by Product Owner
- [ ] **Performance testing** completed (if applicable)
- [ ] **Security testing** completed (if applicable)
- [ ] **Accessibility testing** completed (if applicable)
- [ ] **Cross-browser/device testing** completed (if applicable)
- [ ] **Regression testing** passed

### Technical Criteria
- [ ] **Code follows** team coding standards and conventions
- [ ] **Code is refactored** and technical debt addressed
- [ ] **Database changes** properly scripted and tested
- [ ] **Configuration changes** documented and applied
- [ ] **Dependencies** updated and documented
- [ ] **Error handling** implemented appropriately
- [ ] **Logging and monitoring** implemented where needed

### Deployment and Operations Criteria
- [ ] **Deployment scripts** tested and ready
- [ ] **Environment configuration** completed
- [ ] **Backup and rollback** procedures tested
- [ ] **Monitoring and alerting** configured
- [ ] **Production deployment** completed successfully
- [ ] **Post-deployment verification** completed
- [ ] **Stakeholder notification** sent (if required)

### Documentation and Communication Criteria
- [ ] **User documentation** updated
- [ ] **Technical documentation** updated
- [ ] **Release notes** written
- [ ] **Known issues** documented
- [ ] **Support team** notified of changes
- [ ] **Stakeholders** informed of completion

### BAU-Specific DoD Criteria

#### For Support Requests
- [ ] **Root cause** identified and documented
- [ ] **Resolution steps** documented in knowledge base
- [ ] **User notification** sent
- [ ] **Follow-up scheduled** if needed
- [ ] **Preventive measures** considered and implemented

#### For Bug Fixes
- [ ] **Root cause analysis** completed
- [ ] **Fix verified** in production-like environment
- [ ] **Regression testing** completed
- [ ] **Related areas** tested for side effects
- [ ] **Bug tracking system** updated with resolution details

#### For Maintenance Work
- [ ] **System health** verified post-maintenance
- [ ] **Performance impact** assessed
- [ ] **Backup verification** completed
- [ ] **Rollback plan** tested
- [ ] **Maintenance window** properly communicated

---

### Common DoD Pitfalls to Avoid

#### Pitfall 1: Too Rigid
- **Problem**: DoD becomes bureaucratic checklist
- **Solution**: Keep it practical and valuable

#### Pitfall 2: Too Loose
- **Problem**: Inconsistent quality across deliveries
- **Solution**: Be specific about quality expectations

#### Pitfall 3: Never Updated
- **Problem**: DoD becomes outdated and irrelevant
- **Solution**: Review and update DoD regularly

#### Pitfall 4: Not Team-Owned
- **Problem**: Team doesn't buy into or understand DoD
- **Solution**: Collaborate on creating and evolving DoD

### DoD Best Practices

#### Collaborative Creation
- **Involve entire team** in defining DoD
- **Include stakeholders** for business perspective
- **Consider organizational standards** and compliance
- **Start simple** and evolve over time

#### Regular Review and Updates
- **Monthly DoD review** in retrospectives
- **Update based on lessons learned**
- **Align with changing business needs**
- **Incorporate new tools and processes**

#### Automation Where Possible
- **Automated testing** in CI/CD pipeline
- **Automated code quality** checks
- **Automated deployment** verification
- **Automated documentation** generation

#### Clear Communication
- **Post DoD visibly** for team reference
- **Train new team members** on DoD
- **Communicate DoD** to stakeholders
- **Use DoD** in sprint reviews and retrospectives


## Estimation Techniques

### Story Points
Relative sizing using Fibonacci sequence (1, 2, 3, 5, 8, 13, 21)

#### What Story Points Represent
- **Complexity**: How difficult is the work?
- **Effort**: How much work is required?
- **Uncertainty**: How much risk or unknowns?

#### Story Point Guidelines
- **1 point**: Very simple, well-understood work
- **2 points**: Simple work with minor complexity
- **3 points**: Medium complexity, some unknowns
- **5 points**: Complex work, moderate unknowns
- **8 points**: Very complex, significant unknowns
- **13+ points**: Too large, needs to be broken down

### Planning Poker Process
1. **Present the story** to the team
2. **Discuss requirements** and ask questions
3. **Each team member** selects an estimate privately
4. **Reveal estimates** simultaneously
5. **Discuss differences** in estimates
6. **Re-estimate** if needed until consensus

### T-Shirt Sizing (Alternative)
For initial rough estimation:
- **XS**: 1-2 story points
- **S**: 3-5 story points
- **M**: 8 story points
- **L**: 13 story points
- **XL**: 20+ points (needs breaking down)

---

# Sprint Planning Guide

## Sprint Planning Overview

Sprint Planning is a time-boxed event where the Scrum Team collaborates to plan the work for the upcoming sprint. The team selects items from the Product Backlog and creates a plan for delivering them.

## Sprint Planning Objectives

### Primary Goals
- **Define sprint goal**: Clear objective for the sprint
- **Select backlog items**: Choose what to work on
- **Create sprint plan**: How the work will be accomplished
- **Commit to deliverables**: Team agreement on what will be done

## Sprint Planning Structure

### Two-Part Meeting

#### Part 1: What will we deliver? (First half)
- **Review sprint goal** options
- **Examine top backlog items**
- **Select items** for the sprint
- **Confirm team capacity**
- **Agree on sprint goal**

#### Part 2: How will we do the work? (Second half)
- **Break stories** into tasks
- **Estimate task hours**
- **Identify dependencies** and risks
- **Create detailed plan**
- **Confirm feasibility**

### Time-boxing
- **2-week sprint**: 4 hours maximum
- **1-week sprint**: 2 hours maximum
- **Adjust based** on team size and complexity

## Pre-Sprint Planning

### Product Owner Preparation
- [ ] **Backlog is refined** and prioritized
- [ ] **Top items have clear acceptance criteria**
- [ ] **Business priorities** are understood
- [ ] **Stakeholder input** is gathered
- [ ] **Dependencies** are identified

### Team Preparation
- [ ] **Previous sprint retrospective** completed
- [ ] **Team capacity** is known
- [ ] **Technical dependencies** are understood
- [ ] **Tools and environment** are ready

### Scrum Master Preparation
- [ ] **Meeting scheduled** with all participants
- [ ] **Sprint planning tools** are ready
- [ ] **Previous sprint metrics** are available
- [ ] **Impediments** from previous sprint addressed

## Sprint Goal Definition

### Characteristics of a Good Sprint Goal
- **Clear and concise**: Easy to understand
- **Achievable**: Realistic given team capacity
- **Valuable**: Delivers business value
- **Measurable**: Success can be determined
- **Focused**: Provides direction for decisions

### Sprint Goal Examples

#### Poor Sprint Goals
- "Complete assigned tasks"
- "Work on user stories"
- "Fix bugs and add features"

#### Good Sprint Goals
- "Enable users to securely access their account dashboard"
- "Improve application performance for better user experience"
- "Deliver reporting capabilities for the finance team"

## Capacity Planning

### Team Capacity Factors

#### Available Hours Calculation
```
Team Size: 5 people
Sprint Duration: 10 working days
Hours per person per day: 8 hours
Total possible hours: 5 × 10 × 8 = 400 hours

Subtract:
- Meetings (stand-ups, planning, review): 20 hours
- Admin tasks (email, training): 30 hours
- Leave/holidays: 16 hours
- Buffer for interruptions: 40 hours

Available capacity: 400 - 106 = 294 hours
```

#### Capacity Planning Template
```
Sprint: [Sprint Number]
Duration: [Number of days]
Team Members: [List with availability %]

[Name]: [Days available] × [Hours/day] = [Total hours]
[Name]: [Days available] × [Hours/day] = [Total hours]

Total Team Hours: [Sum]
Meeting Time (estimated): [Hours]
Admin Time (estimated): [Hours]
Buffer (20%): [Hours]

Net Available Hours: [Total - Meeting - Admin - Buffer]
```

### BAU Team Capacity Considerations

#### Planned vs. Unplanned Work Split
- **70% planned work**: Stories from backlog
- **20% reactive work**: Support requests, urgent fixes
- **10% overhead**: Meetings, admin, learning

#### Capacity Allocation Example
```
Total Sprint Capacity: 300 hours

Planned Stories: 210 hours (70%)
- Story A: 40 hours
- Story B: 60 hours  
- Story C: 50 hours
- Story D: 60 hours

Reactive Work Buffer: 60 hours (20%)
- Production support
- Urgent bug fixes
- Stakeholder requests

Overhead: 30 hours (10%)
- Sprint ceremonies
- Team meetings
- Administrative tasks
```

## Sprint Backlog Creation

### Sprint Backlog Components
- **Selected product backlog items**
- **Sprint goal**
- **Tasks for each story**
- **Task estimates**
- **Task assignments** (optional)

### Task Breakdown

#### Story Decomposition Process
1. **Review user story** and acceptance criteria
2. **Identify major components** of work
3. **Break into specific tasks**
4. **Estimate each task** in hours
5. **Identify task dependencies**

#### Task Types
- **Development tasks**: Coding, implementation
- **Testing tasks**: Unit tests, integration tests
- **Documentation tasks**: Technical docs, user guides
- **Review tasks**: Code review, design review
- **Deployment tasks**: Configuration, release

#### Task Estimation Guidelines
- **Tasks should be 4-16 hours** in size
- **Larger tasks** should be broken down further
- **Include all types** of work (dev, test, review)
- **Be realistic** about complexity and interruptions

## Sprint Planning Checklist

### Before Sprint Planning
- [ ] Product backlog is refined and prioritized
- [ ] Team capacity is calculated
- [ ] Previous sprint is completed
- [ ] Sprint planning meeting is scheduled
- [ ] Necessary stakeholders are available

### During Sprint Planning
- [ ] Sprint goal is defined and agreed upon
- [ ] Team reviews top backlog items
- [ ] Items are selected based on priority and capacity
- [ ] Stories are broken down into tasks
- [ ] Tasks are estimated in hours
- [ ] Dependencies and risks are identified
- [ ] Team commits to the sprint backlog

### After Sprint Planning
- [ ] Sprint backlog is documented in Azure DevOps
- [ ] Sprint goal is communicated to stakeholders
- [ ] Team members understand their commitments
- [ ] Daily stand-up schedule is confirmed
- [ ] Sprint board is set up and ready

---

# Azure DevOps Setup

## Project Configuration

### Project Setup Steps
1. **Create new project** or use existing
Name: BAU
Description: Demo project for Agile framework for BAU teams
Process: BAU-Scrum
2. **Configure project settings**
3. **Set up teams** and team settings
4. **Configure areas and iterations**
5. **Set up work item types**
6. **Configure board settings**

### Team Configuration
```
Team Name: [BAU Team Name]
Team Members: [List team members]
Default Area Path: [Project]\[Team Area]
Default Iteration: [Current Sprint]
Working Days: [Monday-Friday]
Working Hours: [9 AM - 5 PM]
Time Zone: [Team time zone]
```

## Iteration Setup

### Iteration Hierarchy
```
Project
├── Release 2025
│   ├── Q3 2025
│   │   ├── Sprint 1 (Sep 2-13)
│   │   ├── Sprint 2 (Sep 16-27)
│   │   └── Sprint 3 (Sep 30-Oct 11)
│   └── Q4 2025
│       ├── Sprint 4 (Oct 14-25)
│       └── Sprint 5 (Oct 28-Nov 8)
```

### Sprint Configuration
- **Sprint Duration**: 2 weeks
- **Start Date**: Monday
- **End Date**: Friday of second week
- **Sprint Planning**: Friday before start
- **Sprint Review**: Thursday of end week
- **Sprint Retrospective**: Friday of end week

## Work Item Types Configuration

### Custom Fields for BAU Teams
- **Business Priority**: Critical/High/Medium/Low
- **Request Type**: Feature/Bug/Support/Technical Debt
- **Stakeholder**: Requesting business area
- **Due Date**: If time-sensitive
- **Business Impact**: Description of impact

### Work Item States
```
User Story States:
New → Active → Resolved → Closed

Task States:
New → Active → Resolved → Closed

Bug States:
New → Active → Resolved → Closed

Support Request States:
New → Active → Waiting → Resolved → Closed
```

## Board Configuration

### Board Columns
- **New**: Newly created items
- **Ready**: Refined and ready for development
- **Active**: Currently being worked on
- **Testing**: Being tested
- **Done**: Completed and accepted

### Swim Lanes
- **Expedite**: Critical/urgent items
- **Planned**: Regular sprint backlog items
- **Waiting**: Blocked or waiting for dependencies

### Card Configuration
```
Card Fields to Display:
- Assigned To
- Story Points
- Priority
- Tags
- Remaining Work (for tasks)

Card Colors:
- Red: Bugs
- Blue: User Stories
- Green: Support Requests
- Yellow: Technical Debt
```

## Backlog Configuration

### Backlog Levels
```
Epic Backlog:
- Shows Epics and Features
- Used for long-term planning
- Business stakeholder view

Feature Backlog:
- Shows Features and User Stories
- Used for release planning
- Product Owner view

Sprint Backlog:
- Shows User Stories and Tasks
- Used for sprint execution
- Development team view
```

### Column Options
- **Title**: Story title
- **State**: Current state
- **Assigned To**: Team member
- **Story Points**: Estimate
- **Priority**: Business priority
- **Tags**: Categorization

## Reports and Dashboards

### Sprint Reports
- **Sprint Burndown**: Daily progress tracking
- **Sprint Capacity**: Team capacity utilization
- **Velocity Chart**: Historical team velocity
- **Cumulative Flow**: Work item flow analysis

### Team Dashboards
```
BAU Team Dashboard Widgets:
1. Sprint Burndown Chart
2. Team Velocity
3. Work Item Status (Pie Chart)
4. Recently Completed Work
5. Current Sprint Capacity
6. Bug Trends
7. Lead Time Trend
8. Cycle Time
```

### Stakeholder Reports
- **Sprint Summary**: High-level progress
- **Capacity Report**: Team utilization
- **Delivery Trend**: Completed work over time
- **Quality Metrics**: Bug and defect trends

## Automation and Integration

### Work Item Rules
```
Rule Examples:
1. When Story moves to Active → Set Started Date
2. When all Tasks are Done → Move Story to Resolved
3. When Bug Priority = Critical → Add Expedite tag
4. When Support Request is created → Notify team lead
```

### Integration with Microsoft Teams
- **Work item notifications** in team channels
- **Daily standup bot** integration
- **Sprint milestone notifications**
- **Build and deployment** status updates

---

# BAU-Specific Considerations

## Handling Reactive Work

### Types of Reactive Work
- **Production incidents**: System outages, critical bugs
- **Support requests**: User assistance, configuration changes
- **Urgent business needs**: Last-minute requirements
- **Maintenance tasks**: Routine system maintenance

### Reactive Work Management

#### Sprint Buffer Approach
Reserve 20-30% of sprint capacity for reactive work
```
Sprint Capacity: 200 hours
Planned Work: 140 hours (70%)
Reactive Buffer: 40 hours (20%)
Overhead: 20 hours (10%)
```

#### Swim Lane Strategy
Use board swim lanes to manage different work types:
- **Planned Lane**: Sprint backlog items
- **Reactive Lane**: Unplanned work
- **Expedite Lane**: Critical/urgent items

#### Work Item Classification
```
Classification Criteria:
- Planned: In sprint backlog before sprint start
- Reactive: Added during sprint
- Expedite: Critical business impact, immediate attention needed
```

## Mixed Work Types

### Balancing Different Work Types

#### Work Type Distribution (Recommended)
- **Features/Enhancements**: 40-50%
- **Bug Fixes**: 20-30%
- **Support Requests**: 15-25%
- **Technical Debt**: 10-15%
- **Maintenance**: 5-10%

#### Priority Framework for Mixed Work
```
Priority 1 (Critical): Production down, security issues
Priority 2 (High): Major business impact, committed deliverables
Priority 3 (Medium): Normal features, minor bugs
Priority 4 (Low): Nice-to-have features, technical improvements
```

## Stakeholder Communication

### Regular Communication Cadence
- **Daily**: Internal team updates
- **Weekly**: Stakeholder progress updates
- **Bi-weekly**: Sprint review and planning
- **Monthly**: Metrics and trend reporting

### Communication Templates

#### Weekly Status Update
```
Subject: [Team Name] Weekly Update - Week of [Date]

Sprint Progress:
- Sprint Goal: [Current sprint goal]
- Completed: [# of story points]
- In Progress: [# of story points]  
- Remaining: [# of story points]

Key Accomplishments:
- [Major completions]
- [Important milestones reached]

Upcoming This Week:
- [Planned deliverables]
- [Key milestones]

Issues/Risks:
- [Current blockers]
- [Risks to delivery]

Reactive Work This Week:
- [Support requests handled]
- [Urgent fixes completed]
```

### Expectation Management

#### Setting Realistic Expectations
- **Communicate capacity constraints** clearly
- **Explain impact** of reactive work on planned items
- **Provide regular updates** on progress
- **Be transparent** about challenges and delays

#### Managing Changing Priorities
- **Document priority changes** with rationale
- **Communicate impact** of changes to team and stakeholders
- **Use data** to support discussions about capacity
- **Maintain sprint goal** focus when possible

## Metrics for BAU Teams

### Key Performance Indicators

#### Delivery Metrics
- **Sprint Commitment Reliability**: % of committed points delivered
- **Cycle Time**: Average time from start to completion
- **Lead Time**: Average time from request to delivery
- **Throughput**: Stories/points completed per sprint

#### Quality Metrics
- **Defect Rate**: Bugs per story point
- **Escaped Defects**: Production issues post-deployment
- **Rework Rate**: % of work requiring rework
- **Customer Satisfaction**: Stakeholder feedback scores

#### Team Health Metrics
- **Team Velocity**: Story points per sprint
- **Velocity Stability**: Consistency of velocity over time
- **Capacity Utilization**: Actual vs. planned capacity usage
- **Team Satisfaction**: Team member satisfaction scores

### BAU-Specific Metrics

#### Reactive Work Metrics
- **Reactive Work %**: Percentage of capacity on unplanned work
- **Response Time**: Time to respond to support requests
- **Resolution Time**: Time to resolve issues
- **Escalation Rate**: % of issues escalated

#### Service Level Metrics
- **Availability**: System uptime percentage
- **Performance**: Response time metrics
- **Support Quality**: Customer satisfaction with support
- **Knowledge Base Usage**: Self-service adoption rate

---

# Templates and Checklists

## Sprint Planning Meeting Template

### Pre-Meeting Preparation (1 week before)
- [ ] Product Owner reviews and prioritizes backlog
- [ ] Team completes previous sprint retrospective
- [ ] Scrum Master calculates team capacity
- [ ] Meeting scheduled with all participants
- [ ] Azure DevOps sprint is created

### Sprint Planning Meeting Agenda

#### Opening (10 minutes)
- [ ] Review previous sprint results
- [ ] Confirm team capacity for upcoming sprint
- [ ] Review any impediments or dependencies
- [ ] Set meeting expectations and outcomes

#### Part 1: What will we deliver? (90 minutes)
- [ ] Product Owner presents sprint goal options
- [ ] Team reviews top priority backlog items
- [ ] Discuss and clarify requirements
- [ ] Select backlog items for sprint
- [ ] Confirm sprint goal

#### Part 2: How will we do the work? (90 minutes)
- [ ] Break selected stories into tasks
- [ ] Estimate task hours
- [ ] Identify task dependencies
- [ ] Assign initial task ownership (optional)
- [ ] Verify capacity and adjust if needed

#### Closing (10 minutes)
- [ ] Review and confirm sprint commitment
- [ ] Identify any risks or concerns
- [ ] Plan daily standup schedule
- [ ] Set sprint review date
- [ ] Document decisions and next steps

## Backlog Refinement Meeting Template

### Meeting Frequency: Weekly, 90 minutes

#### Preparation (Before Meeting)
- [ ] Product Owner adds new items to backlog
- [ ] Team members review items to be discussed
- [ ] Dependencies and clarifications identified
- [ ] Estimation poker cards/tools ready

#### Meeting Agenda

##### Review New Items (30 minutes)
- [ ] Present newly added backlog items
- [ ] Clarify requirements and expectations
- [ ] Identify questions and dependencies
- [ ] Determine if items need splitting

##### Estimation Session (45 minutes)
- [ ] Estimate unestimated items using planning poker
- [ ] Discuss estimation differences
- [ ] Re-estimate until consensus reached
- [ ] Document assumptions and clarifications

##### Prioritization Review (15 minutes)
- [ ] Review current priority order
- [ ] Discuss any priority changes needed
- [ ] Confirm top items are ready for sprint planning
- [ ] Identify items needing further work

### Post-Meeting Actions
- [ ] Update backlog items in Azure DevOps
- [ ] Communicate any priority changes
- [ ] Schedule follow-up discussions if needed
- [ ] Prepare items for next sprint planning

## Definition of Ready Checklist

### Story Level Criteria
- [ ] **Clear Title**: Descriptive and specific
- [ ] **User Story Format**: "As a... I want... So that..."
- [ ] **Acceptance Criteria**: Clear, testable conditions
- [ ] **Business Value**: Clearly articulated benefit
- [ ] **Priority Assigned**: Based on business value and urgency

### Technical Criteria
- [ ] **Estimated**: Team has provided story point estimate
- [ ] **Appropriately Sized**: Can be completed in one sprint
- [ ] **Dependencies Identified**: External dependencies documented
- [ ] **Technical Approach**: High-level approach understood
- [ ] **Testability Confirmed**: Can be tested effectively

### Business Criteria
- [ ] **Stakeholder Review**: Reviewed by relevant stakeholders
- [ ] **Compliance Check**: Regulatory/policy requirements considered
- [ ] **Resource Availability**: Required resources are available
- [ ] **Budget Approval**: Financial approval if required

## Sprint Review Checklist

### Pre-Review Preparation
- [ ] Demo environment prepared and tested
- [ ] Completed stories identified and ready to show
- [ ] Stakeholders invited and confirmed
- [ ] Meeting agenda shared
- [ ] Sprint metrics prepared

### During Sprint Review
- [ ] Review sprint goal and outcomes
- [ ] Demonstrate completed work
- [ ] Gather stakeholder feedback
- [ ] Discuss what didn't get completed
- [ ] Review key metrics and progress
- [ ] Discuss upcoming priorities

### Post-Review Actions
- [ ] Document feedback received
- [ ] Update backlog based on feedback
- [ ] Communicate review outcomes
- [ ] Plan follow-up actions
- [ ] Schedule next sprint review

## Capacity Planning Template

### Team Information
```
Team: [Team Name]
Sprint: [Sprint Number/Dates]
Sprint Duration: [X working days]
Team Size: [X people]
```

### Individual Capacity
```
Team Member: [Name]
Role: [Developer/Tester/etc.]
Standard Hours/Day: [X hours]
Days Available: [X days]
Vacation/Leave: [X days]
Training/Meetings: [X hours total]
Net Available: [X hours]

[Repeat for each team member]
```

### Team Capacity Summary
```
Total Possible Hours: [Sum of all team member hours]
Less: Meeting Time: [X hours]
Less: Admin Time: [X hours]
Less: Buffer (20%): [X hours]
Net Team Capacity: [X hours]
```

### Capacity Allocation
```
Planned Stories: [X hours] (70%)
Reactive Work: [X hours] (20%)
Overhead: [X hours] (10%)
Total Allocated: [X hours]
```

## Daily Standup Template

### Standard Questions
For each team member:
1. **What did I complete yesterday?**
   - Specific work items completed
   - Hours logged

2. **What will I work on today?**
   - Planned activities
   - Expected hours

3. **Are there any impediments?**
   - Blockers preventing progress
   - Help needed from team or stakeholders

### Enhanced BAU Format
1. **Progress Update**
   - Stories/tasks completed
   - Time tracking status
   - Quality of estimates

2. **Today's Plan**
   - Specific work planned
   - Expected outcomes
   - Resource needs

3. **Impediments and Risks**
   - Blockers requiring help
   - Risks to sprint goal
   - Escalation needs

4. **Reactive Work**
   - Support requests handled
   - Urgent issues addressed
   - Impact on planned work

### Standup Board Review
- [ ] Move completed items to "Done"
- [ ] Update work in progress
- [ ] Identify blocked items
- [ ] Review burndown progress
- [ ] Note any scope changes

This comprehensive guide provides the foundation for effective sprint planning and backlog management for BAU teams implementing Agile practices. Regular use and adaptation of these templates and processes will lead to improved planning accuracy, better stakeholder communication, and more predictable delivery outcomes.
