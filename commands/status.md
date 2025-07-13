# /status - Show Overview of All Active Work

<command_overview>
This command provides a comprehensive overview of all active features, PRDs, and bugs. It helps you understand what's in progress, what's blocked, and what needs attention across the entire project.
</command_overview>

<usage>
/status [filter]

Options:
- /status          - Show all active work
- /status features - Show only active features  
- /status prd      - Show only active PRDs
- /status bugs     - Show only active bugs
- /status blocked  - Show only blocked items
- /status stale    - Show items not updated in 7+ days
</usage>

<arguments>$ARGUMENTS</arguments>

<process>

## Step 1: Scan All Session Files
Search for session.md files in:
- `/docs/features/*/session.md`
- `/docs/prd/*/session.md`
- `/docs/bugs/*/session.md`

## Step 2: Parse Session Information
For each session.md found, extract:
- Type (Feature/PRD/Bug)
- ID and Name
- Status
- Branch
- Last Updated timestamp
- Current Focus (first line)
- Completion percentage (based on task checkboxes)

## Step 3: Check Git Branch Status
Compare each session's branch with existing git branches:
- ✓ Branch exists and is up to date
- ⚠️ Branch exists but is behind main
- ❌ Branch not found
- 🔀 Has uncommitted changes

## Step 4: Calculate Metrics
- Total active items
- Items by status (Planning, In Progress, Blocked, Testing)
- Stale items (not updated in 7+ days)
- Completion rates

## Step 5: Format and Display Results

### Default View (All Active Work)
```
📊 Project Status Overview
Generated: 2024-01-15 10:30 AM

Summary:
- 3 Features (1 blocked)
- 2 PRDs (1 in planning)  
- 1 Bug (investigating)
- 2 items need attention (stale)

## 🚀 Features (3)

### ✅ Authentication (feature-0005) - 75% complete
   Branch: feature/authentication ✓
   Status: In Progress
   Updated: 2 hours ago
   Focus: Implementing refresh token endpoint

### ⚠️ User Search (feature-0009) - 40% complete
   Branch: feature/user-search ⚠️ (3 commits behind main)
   Status: In Progress
   Updated: 8 days ago ⚠️ STALE
   Focus: Adding search filters

### 🚫 Dark Mode (feature-0007) - 60% complete
   Branch: feature/dark-mode ✓
   Status: BLOCKED
   Updated: 3 days ago
   Focus: Waiting for design system updates
   Blocker: Need final color palette from design team

## 📋 PRDs (2)

### 📝 Reporting System (prd-0003)
   Branch: main
   Status: Planning
   Updated: 1 day ago
   Focus: Gathering requirements

### ✅ Analytics Dashboard (prd-0008)
   Branch: feature/analytics ❌ (branch not found)
   Status: In Progress  
   Updated: 4 hours ago
   Focus: Implementing data models

## 🐛 Bugs (1)

### 🔍 Random Logouts (bug-0015)
   Branch: bugfix/random-logouts ✓
   Status: Investigating
   Updated: 12 hours ago
   Focus: Analyzing session timeout logs

## ⚡ Quick Actions
1. Resume most recent: Authentication (feature-0005) - use /resume
2. Address stale items: User Search (8 days old)
3. Check blocked items: Dark Mode (blocked 3 days)
4. Create missing branch: Analytics Dashboard (prd-0008)
```

### Filtered Views

#### Features Only (/status features)
```
## 🚀 Active Features (3)

✅ Authentication (75%) - In Progress - 2 hours ago
⚠️ User Search (40%) - In Progress - 8 days ago [STALE]
🚫 Dark Mode (60%) - BLOCKED - 3 days ago

Quick Stats:
- 1 blocked feature needs attention
- 1 stale feature (not updated in 7+ days)
- Average completion: 58%
```

#### Blocked Items (/status blocked)
```
## 🚫 Blocked Items (1)

### Dark Mode (feature-0007)
   Status: BLOCKED for 3 days
   Blocker: Need final color palette from design team
   Last Progress: Implemented theme context provider
   Next Step: Apply color tokens once received
   
Action Required: Follow up with design team
```

#### Stale Items (/status stale)
```
## ⚠️ Stale Items (1)

### User Search (feature-0009)
   Last Updated: 8 days ago
   Status: In Progress (40% complete)
   Branch: feature/user-search
   
   Possible Actions:
   1. Resume work - use: /switch user-search
   2. Mark as blocked if waiting on something
   3. Archive if no longer needed
```

</process>

<status_indicators>

## Status Icons
- ✅ Active and healthy
- ⚠️ Needs attention (stale or behind main)
- 🚫 Blocked
- 📝 Planning phase
- 🔍 Investigation phase
- ✓ Branch up to date
- ❌ Branch missing or error
- 🔀 Uncommitted changes

## Health Indicators
- **Healthy**: Updated within 3 days, branch exists
- **Attention**: Updated 4-7 days ago OR branch behind main
- **Stale**: Not updated in 7+ days
- **Critical**: Blocked for 3+ days OR branch missing

</status_indicators>

<implementation_notes>

## Implementation Notes for Claude

1. Parse all session.md files in parallel for performance
2. Cache git branch status to avoid repeated calls
3. Calculate completion percentage from task checkboxes:
   - Count `[x]` vs `[ ]` in task lists
   - Ignore nested tasks for simplicity
4. Sort items by last updated (most recent first) within each category
5. Use relative time for "Last Updated" (e.g., "2 hours ago", "yesterday")
6. Highlight critical issues:
   - Blocked items over 3 days
   - Stale items over 7 days
   - Missing branches
7. For filtered views, only show relevant sections
8. Include actionable next steps in the summary
9. If no active work found, suggest creating new work:
   ```
   No active work found. Ready to start something new?
   - Create a feature: /generate-feature
   - Create a PRD: /generate-prd
   - Report a bug: /report-bug
   ```

## Performance Considerations
- Don't parse file contents beyond what's needed
- Skip archived folders
- Limit git operations to avoid slowdowns

</implementation_notes>

<formatting_rules>

## Display Rules

1. **Grouping**: Always group by type (Features, PRDs, Bugs)
2. **Sorting**: Within groups, sort by status priority:
   - BLOCKED items first
   - In Progress items
   - Planning/Investigation items
   - Then by last updated (recent first)
3. **Truncation**: 
   - Show only first line of "Current Focus"
   - Limit blockers to 100 characters
4. **Colors/Emphasis** (in markdown):
   - Use emoji for visual scanning
   - Bold for important numbers
   - CAPS for critical states (BLOCKED, STALE)

</formatting_rules>

<examples>

## Example 1: Healthy Project
```
User: /status

Claude: 📊 Project Status Overview
Generated: 2024-01-15 2:30 PM

Summary:
- 2 Features (all healthy)
- 1 PRD (in progress)
- 0 Bugs
- All items updated recently ✅

## 🚀 Features (2)

### ✅ Payment Integration (feature-0011) - 90% complete
   Branch: feature/payments ✓
   Status: In Progress
   Updated: 1 hour ago
   Focus: Final testing with Stripe

### ✅ Email Templates (feature-0012) - 65% complete
   Branch: feature/email-templates ✓
   Status: In Progress
   Updated: 3 hours ago
   Focus: Creating welcome email template

## 📋 PRDs (1)

### ✅ Mobile App (prd-0009)
   Branch: main
   Status: In Progress
   Updated: yesterday
   Focus: Defining API requirements

Great job! All work is progressing well with no blockers.
```

## Example 2: Project Needing Attention
```
User: /status blocked

Claude: ## 🚫 Blocked Items (2)

### API Rate Limiting (feature-0015)
   Status: BLOCKED for 5 days ⚠️
   Blocker: Waiting for infrastructure team to provision Redis cluster
   Last Progress: Implemented rate limit logic
   Branch: feature/rate-limiting ✓
   
### Login Bug (bug-0018)  
   Status: BLOCKED for 1 day
   Blocker: Cannot reproduce issue, waiting for user logs
   Last Progress: Reviewed authentication flow
   Branch: bugfix/login-issue ✓

Action Items:
1. Escalate Redis cluster request (blocked 5 days)
2. Follow up with user for login logs
```

</examples>