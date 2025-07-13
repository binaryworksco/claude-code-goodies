# /resume - Continue Working on Active Sessions

<command_overview>
This command helps you resume work on active features, PRDs, or bugs by loading the appropriate session context. It scans for active session.md files and provides a summary of work in progress.
</command_overview>

<usage>
/resume

The command will:
1. Scan for active sessions in /docs/features/, /docs/prd/, and /docs/bugs/
2. Show a list of active work with status
3. Load the most recent session or ask which to resume
</usage>

<process>

## Step 1: Scan for Active Sessions
Look for session.md files in:
- `/docs/features/*/session.md`
- `/docs/prd/*/session.md`
- `/docs/bugs/*/session.md`

Check the Status field in each session.md - only consider sessions that are NOT marked as "Completed" or "Archived".

## Step 2: Analyze Session Recency
For each active session found:
1. Check the "Last Updated" timestamp
2. Check the current git branch against the session's branch
3. Note any sessions marked as "Blocked"

## Step 3: Present Options
If no active sessions found:
```
No active sessions found. Would you like to:
1. Start a new feature (/generate-feature)
2. Create a new PRD (/generate-prd)
3. Report a bug (/report-bug)
```

If one active session found:
```
Found active session:
- Feature: Authentication (feature-0005)
- Branch: feature/authentication
- Status: In Progress
- Last Updated: 2 hours ago
- Current Focus: Implementing JWT refresh tokens

Would you like to resume this work? (Yes/No)
```

If multiple active sessions found:
```
Found 3 active sessions:

1. Feature: Authentication (feature-0005)
   - Status: In Progress
   - Last Updated: 2 hours ago
   - Branch: feature/authentication

2. PRD: Reporting System (prd-0003)
   - Status: Planning
   - Last Updated: 1 day ago
   - Branch: main

3. Bug: Random Logouts (bug-0015)
   - Status: Blocked (waiting for logs)
   - Last Updated: 3 days ago
   - Branch: bugfix/random-logouts

Which would you like to resume? (1-3)
```

## Step 4: Load Session Context
Once a session is selected:
1. Read the session.md file
2. Check if we're on the correct git branch
3. If not, offer to switch: `git checkout [branch-name]`
4. Load any relevant documentation mentioned in the session
5. Show current status and next steps

## Step 5: Provide Status Summary
```
Resuming: Authentication Feature (feature-0005)
Branch: feature/authentication ✓
Last Updated: 2 hours ago

## Current Status
You were implementing JWT refresh tokens. The access token endpoint is complete.

## Completed Tasks
- [x] Create auth module structure
- [x] Implement login endpoint
- [x] Add JWT access token generation
- [ ] Add refresh token endpoint (IN PROGRESS)
- [ ] Add token revocation

## Next Steps
1. Complete the refresh token endpoint in /src/auth/refresh-token.ts
2. Add tests for token refresh
3. Update API documentation

## Recent Decisions
- Using 15-minute access token expiry
- Refresh tokens stored in httpOnly cookies
- One refresh token per device

Ready to continue? The next task is implementing the refresh token endpoint.
```

</process>

<error_handling>

## Common Issues

### Branch Mismatch
If the current git branch doesn't match the session branch:
```
Warning: You're on branch 'main' but this session is for branch 'feature/authentication'
Would you like to switch branches? (git checkout feature/authentication)
```

### Uncommitted Changes
If there are uncommitted changes when trying to switch branches:
```
Warning: You have uncommitted changes. Would you like to:
1. Stash changes and switch branch
2. Commit changes first
3. Stay on current branch
```

### Stale Sessions
If a session hasn't been updated in over 7 days:
```
Note: This session hasn't been updated in 10 days. It may be stale.
Would you like to:
1. Resume anyway
2. Archive this session
3. View other active sessions
```

### Missing Session Files
If session.md exists but other expected files are missing:
```
Warning: Some session files appear to be missing:
- decisions.md not found
- notes.md not found

Continue anyway? (Yes/No)
```

</error_handling>

<implementation_notes>

## Implementation Notes for Claude

1. Start by scanning all three directories for session.md files
2. Parse each session.md to extract:
   - Feature/PRD/Bug name and ID
   - Branch name
   - Status
   - Last Updated timestamp
   - Current Focus section
3. Sort sessions by last updated (most recent first)
4. If on wrong branch, always ask before switching
5. Never auto-switch branches without user confirmation
6. After loading a session, update its "Last Updated" timestamp
7. If resuming after branch switch, check for any new commits
8. Provide a clear, actionable summary of next steps
9. If session is marked "Blocked", highlight the blockers prominently

## Quick Resume Logic
- If user runs `/resume` again within same conversation, just show quick status
- Don't reload everything, just confirm still working on same session

</implementation_notes>

<examples>

## Example 1: Single Active Session
```
User: /resume

Claude: Found active session:
- Feature: Dark Mode Toggle (feature-0007)
- Branch: feature/dark-mode
- Status: In Progress  
- Last Updated: 3 hours ago
- Current Focus: Adding theme persistence

Would you like to resume this work?

User: Yes

Claude: Resuming Dark Mode Toggle feature. You're currently on the correct branch.

Last task completed: Created theme context provider
Next task: Implement localStorage persistence for theme preference

The component structure is in place. Ready to add the persistence layer?
```

## Example 2: Multiple Sessions with Branch Switch
```
User: /resume

Claude: Found 2 active sessions:

1. PRD: Analytics Dashboard (prd-0008)
   - Status: Planning
   - Last Updated: 1 hour ago
   - Branch: main

2. Feature: User Search (feature-0009)
   - Status: In Progress
   - Last Updated: yesterday
   - Branch: feature/user-search

Which would you like to resume?

User: 2

Claude: You're currently on branch 'main' but the User Search feature is on branch 'feature/user-search'.
Would you like to switch branches?

User: Yes

Claude: [Switches to feature/user-search branch]

Resuming User Search feature. 

You were implementing the search filters. The basic search is working, and you were adding filter options for role and status.

Next steps:
1. Complete the filter UI components
2. Add filter logic to search query
3. Test with various filter combinations
```

</examples>