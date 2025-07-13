# /switch-feature <name> - Switch Between Active Features

<command_overview>
This command allows you to switch context between different active features, PRDs, or bugs. It saves the current session state and loads the target session, handling git branch switches as needed.
</command_overview>

<usage>
/switch-feature <partial-name-or-id>

Examples:
- /switch-feature auth
- /switch-feature feature-0005
- /switch-feature reporting
- /switch-feature bug-15
</usage>

<arguments>$ARGUMENTS</arguments>

<process>

## Step 1: Save Current Session State
Before switching, check if there's an active session:
1. Look for the most recently updated session.md file
2. If found and modified since last save:
   - Update the "Last Updated" timestamp
   - Add current focus/status
   - Note any uncommitted changes

## Step 2: Search for Target Session
Search for matches in session names/IDs:
1. Check `/docs/features/*/session.md` for feature matches
2. Check `/docs/prd/*/session.md` for PRD matches  
3. Check `/docs/bugs/*/session.md` for bug matches

Match against:
- Feature/PRD/Bug ID (e.g., "feature-0005", "prd-0003", "bug-0015")
- Feature/PRD/Bug name (partial match acceptable)

## Step 3: Handle Multiple Matches
If no matches found:
```
No active sessions found matching "<search-term>".

Active sessions:
1. Feature: Authentication (feature-0005)
2. PRD: Reporting (prd-0003)
3. Bug: Random Logouts (bug-0015)

Please specify which session to switch to.
```

If multiple matches found:
```
Found multiple matches for "<search-term>":

1. Feature: User Authentication (feature-0005)
   - Branch: feature/authentication
   - Status: In Progress

2. Feature: OAuth Integration (feature-0008)
   - Branch: feature/oauth-auth
   - Status: Planning

Which would you like to switch to? (1-2)
```

## Step 4: Check Git Status
Before switching branches:
1. Run `git status` to check for uncommitted changes
2. Check if target branch exists
3. Check if current branch matches target branch

## Step 5: Handle Branch Switch
If branches differ and there are uncommitted changes:
```
Current branch: feature/current-work
Target branch: feature/authentication
You have uncommitted changes in 3 files.

Options:
1. Stash changes and switch
2. Commit changes with message: "WIP: [description]"
3. Discard changes and switch
4. Cancel switch

What would you like to do? (1-4)
```

If branches differ but working directory is clean:
```
Switching from branch 'feature/current-work' to 'feature/authentication'...
[Execute: git checkout feature/authentication]
✓ Successfully switched to feature/authentication
```

## Step 6: Load Target Session
1. Read the target session.md file
2. Display session summary:
   ```
   Switched to: Authentication Feature (feature-0005)
   Branch: feature/authentication ✓
   Status: In Progress
   Last Updated: 3 hours ago
   
   ## Current Focus
   Implementing JWT refresh tokens
   
   ## Recent Progress
   - Completed login endpoint
   - Added access token generation
   
   ## Next Tasks
   - [ ] Implement refresh token endpoint
   - [ ] Add token revocation
   - [ ] Update API documentation
   
   ## Active Decisions
   - Using 15-minute access tokens
   - Refresh tokens in httpOnly cookies
   ```

3. Load any specific context mentioned in the session

## Step 7: Update Session Timestamp
Update the "Last Updated" field in the newly loaded session.md to reflect the switch.

</process>

<branch_handling>

## Branch Creation
If the target session specifies a branch that doesn't exist locally:
```
The branch 'feature/authentication' doesn't exist locally.
Would you like to:
1. Create and checkout the branch
2. Fetch from remote (if it exists remotely)
3. Continue on current branch
```

## Stash Management
When stashing changes:
```bash
# Create descriptive stash
git stash push -m "WIP: Switching from feature-X to feature-Y"

# After switch, remind user:
"Note: You have stashed changes from the previous feature. 
Use 'git stash list' to see stashes and 'git stash pop' to restore when you switch back."
```

</branch_handling>

<quick_switch>

## Quick Switch Syntax
Support abbreviated commands for common switches:

- `/switch auth` → Finds any session with "auth" in the name
- `/switch 5` → Switches to feature-0005 if it exists
- `/switch .` → Shows all active sessions (same as no argument)

## Recent Sessions
Track recently accessed sessions for quick switching:
```
No exact match found for "rep". Did you mean:
1. Reporting Feature (feature-0012) - accessed 1 hour ago
2. Report Generation Bug (bug-0034) - accessed yesterday
3. Repository Setup (feature-0003) - accessed 3 days ago
```

</quick_switch>

<implementation_notes>

## Implementation Notes for Claude

1. Always save current state before switching (if there's an active session)
2. Use fuzzy matching for search terms:
   - "auth" matches "authentication", "authorization", "oauth"
   - "5" matches "feature-0005", "prd-0005", "bug-0005"
3. Case-insensitive search
4. Prioritize exact ID matches over name matches
5. Always confirm before discarding changes
6. Update both old and new session.md files with switch timestamp
7. If switching fails, restore to previous state
8. Remember the stash name if changes are stashed
9. Check remote branches if local branch doesn't exist
10. Quick switch with just ID number: `/switch 5` → feature-0005

## Error Recovery
- If branch switch fails, stay on current branch
- If session.md is corrupted, offer to recreate from template
- Keep track of last successful state for rollback

</implementation_notes>

<examples>

## Example 1: Clean Switch
```
User: /switch reporting

Claude: Found: Reporting Feature (feature-0012)

Saving current session state...
✓ Current session saved

Switching to: Reporting Feature
Current branch: main
Target branch: feature/reporting

Switching branches...
✓ Successfully switched to feature/reporting

Loaded: Reporting Feature (feature-0012)
Status: In Progress
Current Focus: Implementing PDF export

Next task: Complete PDF template for usage reports
```

## Example 2: Switch with Uncommitted Changes
```
User: /switch auth

Claude: Found: Authentication Feature (feature-0005)

Current branch: feature/reporting
Target branch: feature/authentication
Warning: You have uncommitted changes in 2 files:
- src/reports/pdf-export.ts
- tests/pdf-export.test.ts

Options:
1. Stash changes and switch
2. Commit changes with message: "WIP: PDF export progress"
3. Discard changes and switch
4. Cancel switch

What would you like to do?

User: 1

Claude: Creating stash: "WIP: Switching from reporting to authentication"
✓ Changes stashed successfully

Switching to feature/authentication...
✓ Branch switched

Loaded: Authentication Feature (feature-0005)
Status: In Progress

Note: Your changes are stashed. Use 'git stash pop' when you return to the reporting feature.
```

## Example 3: Ambiguous Search
```
User: /switch user

Claude: Found multiple matches for "user":

1. Feature: User Profile (feature-0008)
   - Branch: feature/user-profile
   - Status: In Progress
   - Last Updated: 2 hours ago

2. Feature: User Search (feature-0010)
   - Branch: feature/user-search  
   - Status: Planning
   - Last Updated: yesterday

3. Bug: User Login Timeout (bug-0022)
   - Branch: bugfix/login-timeout
   - Status: Investigating
   - Last Updated: 3 days ago

Which would you like to switch to? (1-3)

User: 1

Claude: Switching to User Profile feature...
[continues with normal switch process]
```

</examples>