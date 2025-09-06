# Developer Velocity Planning Workshop
## Agile Framework for BAU Teams

---

# Workshop Agenda

1. **Agile Fundamentals** (1 hour)
2. **User Story Creation and Management** (1.5 hours)
3. **Sprint Planning and Backlog Management** (1 hour)
4. **Metrics and Reporting** (1 hour)
5. **Daily Accountability and Time Tracking** (30 minutes)
6. **Change Management and Adoption Strategy** (30 minutes)
7. **Action Planning and Next Steps** (30 minutes)

---

# Section 1: Agile Fundamentals (1 hour)

## What is Agile?

### Core Values
- **Individuals and interactions** over processes and tools
- **Working software** over comprehensive documentation
- **Customer collaboration** over contract negotiation
- **Responding to change** over following a plan

### Core Principles
- Customer satisfaction through early and continuous delivery
- Welcome changing requirements
- Deliver working software frequently
- Business people and developers work together daily
- Motivated individuals with support and trust
- Face-to-face conversation
- Working software as primary measure of progress
- Sustainable development
- Technical excellence and good design
- Simplicity - maximizing work not done
- Self-organizing teams
- Regular reflection and adaptation

## Agile Frameworks

### Scrum
- **Roles**: Product Owner, Scrum Master, Development Team
- **Events**: Sprint, Sprint Planning, Daily Scrum, Sprint Review, Sprint Retrospective
- **Artifacts**: Product Backlog, Sprint Backlog, Increment

### Kanban
- **Principles**: Visualize work, limit WIP, manage flow, continuous improvement
- **Practices**: Visual board, WIP limits, lead time measurement

### Hybrid Model for BAU Teams
- **Combine Scrum structure with Kanban flexibility**
- **2-week sprints with continuous flow for urgent items**
- **Planned work in sprint backlog + swim lane for reactive work**

## Why Agile for BAU Teams?

### Benefits
- **Predictable delivery** through consistent sprint cadence
- **Better visibility** into work progress and capacity
- **Improved quality** through clear acceptance criteria
- **Enhanced team collaboration** through daily stand-ups
- **Continuous improvement** through retrospectives

### BAU-Specific Considerations
- **Mix of planned and reactive work**
- **Varying task sizes and urgency levels**
- **Need for quick response to production issues**
- **Stakeholder communication and expectation management**

## Exercise: Agile Mindset Assessment
**Time: 15 minutes**

Rate your team's current maturity (1-5 scale):
- [ ] We have clear work visibility
- [ ] We deliver value consistently
- [ ] We respond well to change
- [ ] We collaborate effectively
- [ ] We continuously improve

**Discussion: What are your biggest challenges?**

---

# Section 2: User Story Creation and Management (1.5 hours)

## What is a User Story?

### Definition
A user story is a short, simple description of a feature told from the perspective of the person who desires the new capability.

### Format
**As a** [type of user], **I want** [some goal] **so that** [some reason/benefit].

## INVEST Principle

- **I**ndependent - Can be developed independently
- **N**egotiable - Details can be discussed
- **V**aluable - Provides value to the user
- **E**stimable - Can be sized/estimated
- **S**mall - Can be completed in one sprint
- **T**estable - Has clear acceptance criteria

## User Story Components

### 1. Title
- **Clear and concise**
- **Describes the capability**
- **Example**: "User can reset password via email"

### 2. Description
- **User story format (As a, I want, So that)**
- **Context and background**
- **Business value explanation**

### 3. Acceptance Criteria
- **Clear conditions for completion**
- **Given/When/Then format**
- **Testable and specific**

### 4. Priority
- **Must Have** (Critical)
- **Should Have** (Important)
- **Could Have** (Nice to have)
- **Won't Have** (This time)

## BAU-Specific Story Types

### Epic
Large body of work that spans multiple sprints
**Example**: "Implement new security compliance framework"

### Feature
Functionality that provides value
**Example**: "User authentication system"

### User Story
Specific capability from user perspective
**Example**: "As a user, I want to log in with my email"

### Task
Technical work or subtask
**Example**: "Configure Azure AD integration"

### Bug
Defect or issue to be resolved
**Example**: "Login page crashes on mobile browsers"

### Support Request
BAU operational work
**Example**: "Investigate slow database queries"

## Writing Effective Acceptance Criteria

### Good Example
```
Given I am on the login page
When I enter valid credentials
Then I should be redirected to the dashboard
And I should see my user profile in the header

Given I enter invalid credentials
When I click the login button
Then I should see an error message
And I should remain on the login page
```

### Poor Example
```
- User can login
- Login works correctly
- Error handling implemented
```

## Exercise 1: Writing User Stories
**Time: 30 minutes**

### Scenario
Your team needs to implement a new report generation feature for the finance team.

### Instructions
1. Form groups of 3-4 people
2. Write 2-3 user stories following INVEST principles
3. Include title, description, and acceptance criteria
4. Assign priorities

### Template
```
**Title**: [Story Title]

**Description**: 
As a [user type]
I want [goal]
So that [benefit]

**Acceptance Criteria**:
- Given [context]
  When [action]
  Then [outcome]

**Priority**: [Must/Should/Could/Won't]
```

## Exercise 2: Story Review and Refinement
**Time: 20 minutes**

1. Groups present their stories
2. Team provides feedback using INVEST criteria
3. Refine stories based on feedback

## Story Sizing and Estimation

### Story Points
- **Relative sizing** (Fibonacci: 1, 2, 3, 5, 8, 13)
- **Complexity, effort, and uncertainty**
- **Team-specific and consistent**

### T-Shirt Sizing
- **XS, S, M, L, XL**
- **Good for initial estimation**
- **Convert to story points later**

### Planning Poker
- **Team consensus approach**
- **Reveals different perspectives**
- **Promotes discussion**

## Exercise 3: Story Estimation
**Time: 15 minutes**

1. Use your written stories
2. Estimate using story points (1, 2, 3, 5, 8)
3. Discuss any large differences
4. Reach consensus

---

# Section 3: Sprint Planning and Backlog Management (1 hour)

## Product Backlog

### Characteristics
- **Single source of truth** for all work
- **Prioritized list** of features, bugs, tasks
- **Living document** that evolves
- **Owned by Product Owner**

### Backlog Items Include
- **User stories**
- **Bugs and defects**
- **Technical debt**
- **Research spikes**
- **Support requests**

## Backlog Refinement (Grooming)

### Purpose
- **Clarify requirements**
- **Estimate effort**
- **Break down large items**
- **Ensure readiness for sprint**

### Activities
- **Review acceptance criteria**
- **Add details and context**
- **Size/estimate stories**
- **Identify dependencies**

### When and How Often
- **Ongoing activity** (not just in meetings)
- **10% of team capacity**
- **Regular refinement sessions**

## Sprint Planning

### Sprint Goal
- **Clear objective** for the sprint
- **Provides focus** and direction
- **Measurable outcome**

### Sprint Planning Meeting
- **Part 1**: What will we deliver?
  - Review backlog items
  - Select stories for sprint
  - Confirm sprint goal

- **Part 2**: How will we do the work?
  - Break stories into tasks
  - Estimate task hours
  - Identify dependencies

### Capacity Planning
- **Team availability** (holidays, training, meetings)
- **Historical velocity**
- **Planned vs. unplanned work ratio**
- **Buffer for BAU reactive work**

## Sprint Backlog

### Components
- **Selected product backlog items**
- **Sprint goal**
- **Task breakdown**
- **Estimated hours**

### Characteristics
- **Owned by development team**
- **Updated daily**
- **Visible to all stakeholders**

## BAU Sprint Planning Considerations

### Planned vs. Reactive Work
- **Reserve 20-30% capacity** for reactive work
- **Use swim lanes** in sprint board
- **Emergency process** for critical issues

### Sprint Structure
```
Sprint Capacity: 100 hours
- Planned Stories: 70 hours (70%)
- Reactive Work Buffer: 20 hours (20%)
- Meetings/Admin: 10 hours (10%)
```

## Azure DevOps for Sprint Management

### Sprint Setup
1. **Create iteration path**
2. **Set sprint dates**
3. **Configure team settings**
4. **Set up sprint board**

### Sprint Board Configuration
- **Columns**: To Do, In Progress, Code Review, Testing, Done
- **Swim lanes**: Planned Work, Reactive Work, Blocked
- **Card fields**: Assigned To, Effort, Priority

### Sprint Metrics
- **Burndown chart**
- **Velocity chart**
- **Cumulative flow diagram**
- **Sprint capacity**

## Exercise: Sprint Planning Simulation
**Time: 30 minutes**

### Scenario
Plan a 2-week sprint for a BAU team with 4 developers (80 hours total capacity)

### Backlog Items (Story Points)
1. User authentication enhancement (8)
2. Database performance optimization (5)
3. Security audit findings (3)
4. UI bug fixes (3)
5. API documentation update (2)
6. Mobile app crash fix (3)
7. New reporting feature (13)

### Instructions
1. Select stories for the sprint
2. Consider 70% planned, 20% reactive, 10% overhead
3. Justify your selections
4. Define sprint goal

---

# Section 4: Metrics and Reporting (1 hour)

## Key Agile Metrics

### Velocity
- **Story points completed** per sprint
- **Measure of team capacity**
- **Use for future planning**
- **Track trend over time**

### Burndown Chart
- **Work remaining** over time
- **Shows sprint progress**
- **Identifies potential issues**
- **Daily tracking tool**

### Burnup Chart
- **Work completed** over time
- **Shows scope changes**
- **Tracks progress toward goal**
- **Useful for releases**

### Cumulative Flow Diagram
- **Work in each state** over time
- **Identifies bottlenecks**
- **Shows work patterns**
- **Cycle time analysis**

### Lead Time
- **Time from request to delivery**
- **Customer perspective**
- **Includes wait time**
- **Service level measurement**

### Cycle Time
- **Time from start to completion**
- **Development perspective**
- **Active work time only**
- **Process efficiency measure**

## Team Performance Metrics

### Capacity Utilization
- **Planned vs. actual capacity**
- **Availability tracking**
- **Efficiency measurement**

### Quality Metrics
- **Defect rate**
- **Escaped defects**
- **Rework percentage**
- **Test coverage**

### Predictability Metrics
- **Sprint commitment vs. delivery**
- **Estimation accuracy**
- **Scope change frequency**

## Azure DevOps Reporting

### Built-in Reports
- **Velocity chart**
- **Burndown chart**
- **Sprint capacity**
- **Team velocity**
- **Cumulative flow**

### Custom Queries
- **Work item queries**
- **Filter by iteration, area, state**
- **Export to Excel**
- **Share with stakeholders**

### Analytics Views
- **Power BI integration**
- **Custom dashboards**
- **Historical trending**
- **Cross-team reporting**

## Power BI Dashboard Setup

### Key Dashboard Components
1. **Team Velocity Trend**
2. **Sprint Burndown**
3. **Work Item Status**
4. **Capacity Utilization**
5. **Quality Metrics**
6. **Cycle Time Analysis**

### Dashboard Design Principles
- **Clear and simple visualizations**
- **Relevant to audience**
- **Actionable insights**
- **Regular updates**

## Interpreting Metrics for Decision Making

### Velocity Analysis
```
Sprint 1: 25 points
Sprint 2: 30 points
Sprint 3: 28 points
Sprint 4: 15 points (holiday period)
Sprint 5: 32 points

Average Velocity: 26 points
Planning Velocity: 26-28 points
```

### Burndown Analysis
- **Ideal line vs. actual**
- **Early completion**: Underestimation or scope reduction
- **Late completion**: Overestimation or obstacles
- **Flat line**: No progress or blocked work

### Red Flags
- **Declining velocity**
- **Frequent scope changes**
- **High defect rates**
- **Poor estimation accuracy**
- **Consistently missing commitments**

## Exercise: Metrics Interpretation
**Time: 20 minutes**

### Given Data
```
Team Alpha - Last 6 Sprints
Sprint 1: Planned 30, Completed 25
Sprint 2: Planned 28, Completed 32
Sprint 3: Planned 30, Completed 18
Sprint 4: Planned 25, Completed 27
Sprint 5: Planned 30, Completed 31
Sprint 6: Planned 28, Completed 22
```

### Questions
1. What is the average velocity?
2. What should be planned for Sprint 7?
3. What concerns do you see?
4. What investigations would you recommend?

---

# Section 5: Daily Accountability and Time Tracking (30 minutes)

## Daily Stand-up (Daily Scrum)

### Purpose
- **Synchronize team activities**
- **Identify impediments**
- **Plan the day's work**
- **Maintain sprint focus**

### Format
Each team member answers:
1. **What did I complete yesterday?**
2. **What will I work on today?**
3. **Are there any impediments?**

### Best Practices
- **Keep it time-boxed** (15 minutes)
- **Focus on the work**, not the people
- **Identify impediments**, don't solve them
- **Use sprint board** as visual aid
- **Stand up** (or equivalent for remote)

## Time Tracking Importance

### Why Track Time?
- **Accurate capacity planning**
- **Better estimation**
- **Project costing**
- **Performance insights**
- **Billing and compliance**

### What to Track
- **Story/task hours**
- **Bug fixing time**
- **Meeting time**
- **Administrative tasks**
- **Learning/training**

## Time Tracking Best Practices

### Daily Updates
- **Log hours at least daily**
- **Update remaining work**
- **Use consistent categories**
- **Include brief notes**

### Categories for BAU Teams
- **Development Work**
- **Bug Fixes**
- **Support Requests**
- **Code Reviews**
- **Testing**
- **Documentation**
- **Meetings**
- **Administrative**

### Azure DevOps Time Tracking
- **Original Estimate**: Initial task estimate
- **Completed Work**: Hours logged
- **Remaining Work**: Hours left to complete

## Integration with Daily Stand-ups

### Enhanced Stand-up Format
1. **What did I complete yesterday?** (with hours)
2. **What will I work on today?** (with planned hours)
3. **Are there any impediments?**
4. **How are my estimates tracking?**

### Stand-up Board Updates
- **Move work items** to appropriate columns
- **Update remaining hours** on tasks
- **Add impediment markers**
- **Note blocked items**

## Tools and Automation

### Microsoft Teams Integration
- **Daily stand-up bot**
- **Automated reminders**
- **Time tracking prompts**
- **Status updates**

### Browser Extensions
- **Azure DevOps time tracking**
- **Automatic time capture**
- **One-click logging**

### Mobile Apps
- **Time tracking on-the-go**
- **Quick status updates**
- **Offline capability**

## Building the Habit

### Start Small
- **Begin with daily updates only**
- **Add detail gradually**
- **Focus on consistency**
- **Celebrate compliance**

### Team Accountability
- **Peer reminders**
- **Team metrics**
- **Regular check-ins**
- **Shared responsibility**

### Management Support
- **Lead by example**
- **Provide tools and training**
- **Recognize good practices**
- **Remove obstacles**

---

# Section 6: Change Management and Adoption Strategy (30 minutes)

## Change Management Principles

### Kotter's 8-Step Process
1. **Create urgency**
2. **Form a guiding coalition**
3. **Develop a vision and strategy**
4. **Communicate the vision**
5. **Empower broad-based action**
6. **Generate short-term wins**
7. **Sustain acceleration**
8. **Institute change**

### People Side of Change
- **Individual transition process**
- **Resistance is natural**
- **Communication is key**
- **Support is essential**

## Common Resistance Points

### Individual Level
- **Fear of change**
- **Comfort with current state**
- **Lack of skills/confidence**
- **Past negative experiences**

### Team Level
- **Existing processes**
- **Team dynamics**
- **Workload concerns**
- **Tool familiarity**

### Organizational Level
- **Cultural misalignment**
- **Resource constraints**
- **Leadership support**
- **Competing priorities**

## Adoption Strategy

### Phase 1: Foundation (Months 1-2)
- **Leadership alignment**
- **Pilot team selection**
- **Initial training**
- **Tool setup**

### Phase 2: Pilot (Months 3-4)
- **Run pilot sprints**
- **Gather feedback**
- **Refine processes**
- **Document lessons learned**

### Phase 3: Expansion (Months 5-8)
- **Roll out to additional teams**
- **Provide ongoing coaching**
- **Share success stories**
- **Address challenges**

### Phase 4: Maturation (Months 9-12)
- **Full adoption**
- **Continuous improvement**
- **Advanced practices**
- **Cultural embedding**

## Success Factors

### Leadership Support
- **Visible commitment**
- **Resource allocation**
- **Remove obstacles**
- **Champion the change**

### Communication Plan
- **Clear messaging**
- **Regular updates**
- **Multiple channels**
- **Two-way dialogue**

### Training and Support
- **Role-based training**
- **Hands-on practice**
- **Ongoing coaching**
- **Peer support networks**

### Quick Wins
- **Early successes**
- **Visible improvements**
- **Celebrate achievements**
- **Build momentum**

## Pilot Team Approach

### Selection Criteria
- **Motivated team members**
- **Manageable scope**
- **Supportive stakeholders**
- **Representative work types**

### Pilot Success Metrics
- **Sprint completion rate**
- **Story estimation accuracy**
- **Team satisfaction**
- **Stakeholder feedback**

### Scaling Strategy
- **Document best practices**
- **Train additional coaches**
- **Adapt to team contexts**
- **Maintain momentum**

---

# Section 7: Action Planning and Next Steps (30 minutes)

## Implementation Roadmap

### Immediate Actions (Next 2 Weeks)
- [ ] Form Agile Champion team
- [ ] Select pilot team
- [ ] Set up Azure DevOps workspace
- [ ] Schedule initial training sessions

### Short-term Goals (Next 2 Months)
- [ ] Complete team training
- [ ] Run first 2-week sprint
- [ ] Establish metrics baseline
- [ ] Refine processes based on feedback

### Medium-term Objectives (Next 6 Months)
- [ ] Roll out to all BAU teams
- [ ] Implement advanced reporting
- [ ] Establish communities of practice
- [ ] Measure success metrics

### Long-term Vision (Next 12 Months)
- [ ] Fully mature Agile practices
- [ ] Continuous improvement culture
- [ ] Cross-team collaboration
- [ ] Organizational agility

## Success Criteria

### Team Level
- **Consistent sprint completion** (80%+ commitment delivery)
- **Improved estimation accuracy** (±20% variance)
- **Daily time tracking compliance** (90%+ team members)
- **High team satisfaction** (4+ out of 5 rating)

### Organizational Level
- **Increased delivery predictability**
- **Better stakeholder satisfaction**
- **Reduced rework and defects**
- **Enhanced team productivity**

## Roles and Responsibilities

### Agile Champion
- **Drive adoption strategy**
- **Provide coaching and support**
- **Remove organizational obstacles**
- **Report progress to leadership**

### Team Leads
- **Facilitate team adoption**
- **Ensure consistent practices**
- **Support team members**
- **Provide feedback to champions**

### Team Members
- **Actively participate in ceremonies**
- **Follow agreed processes**
- **Update work items daily**
- **Provide honest feedback**

### Leadership
- **Provide resources and support**
- **Remove organizational barriers**
- **Champion the change**
- **Celebrate successes**

## Support Structure

### Agile Coaching
- **Weekly team check-ins**
- **Monthly maturity assessments**
- **Quarterly strategy reviews**
- **Ongoing skill development**

### Training Program
- **Initial workshop (completed today)**
- **Role-specific training**
- **Tool training sessions**
- **Advanced topics workshops**

### Community of Practice
- **Monthly sharing sessions**
- **Best practice documentation**
- **Peer support network**
- **Continuous learning culture**

## Risk Mitigation

### Common Risks
- **Low adoption rate**
- **Tool complexity**
- **Resource constraints**
- **Competing priorities**

### Mitigation Strategies
- **Strong change management**
- **Comprehensive training**
- **Executive support**
- **Gradual implementation**

## Measuring Success

### Leading Indicators
- **Training completion rates**
- **Tool usage metrics**
- **Process compliance**
- **Team engagement scores**

### Lagging Indicators
- **Delivery predictability**
- **Stakeholder satisfaction**
- **Team productivity**
- **Quality metrics**

## Next Steps

### Today
- [ ] Complete action planning exercise
- [ ] Identify pilot team
- [ ] Schedule follow-up meetings
- [ ] Distribute workshop materials

### This Week
- [ ] Set up Azure DevOps
- [ ] Schedule team training
- [ ] Create communication plan
- [ ] Begin change management activities

### Next Two Weeks
- [ ] Conduct pilot team training
- [ ] Start first sprint
- [ ] Establish metrics collection
- [ ] Begin regular check-ins

---

# Workshop Wrap-up

## Key Takeaways
1. **Agile principles** apply to BAU teams with adaptations
2. **User stories** provide clarity and focus
3. **Consistent processes** improve predictability
4. **Metrics** enable data-driven decisions
5. **Change management** is critical for success

## Feedback and Evaluation
- **Workshop effectiveness**
- **Content relevance**
- **Delivery quality**
- **Actionability of outcomes**

## Continued Support
- **Follow-up coaching sessions**
- **Regular check-ins**
- **Resource availability**
- **Community building**

Thank you for participating in the Developer Velocity Planning Workshop!

---

# Appendix: Additional Resources

## Recommended Reading
- "Scrum: The Art of Doing Twice the Work in Half the Time" by Jeff Sutherland
- "User Stories Applied" by Mike Cohn
- "Agile Estimating and Planning" by Mike Cohn
- "The Lean Startup" by Eric Ries

## Online Resources
- Scrum.org
- Agile Alliance
- Azure DevOps Documentation
- Power BI Learning Resources

## Training Opportunities
- Certified ScrumMaster (CSM)
- Professional Scrum Master (PSM)
- Azure DevOps Certification
- Agile Coach Certification
