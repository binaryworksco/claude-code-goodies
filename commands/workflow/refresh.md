# Refresh Context

## Purpose
This command refreshes Claude Code's understanding of the project during long sessions or when context may have become stale. It re-reads core project files and provides a summary of any changes or important updates.

## Usage
```
/refresh
```

## Instructions

### 1. Check Context Freshness
Determine when the core files were last read:
- Note the current session duration
- Check if it's been more than 2 hours since initial context loading
- Look for indicators that context may be stale

### 2. Re-read Core Files
Systematically re-read the essential project files:
1. **PROJECT.md** - Check for updates to features, tech stack, or dependencies
2. **STANDARDS.md** - Verify any changes to coding standards or processes
3. **SESSION-NOTES.md** - Review recent entries to understand current work
4. **TASKS.md** - Scan for new [HIGH PRIORITY] items
5. **ISSUES.md** - Note any new critical issues

### 3. Identify Changes
Compare current file contents with your existing understanding:
- New features or PRDs added
- Updated dependencies or technical requirements
- Changed coding standards
- New high-priority tasks
- Recently discovered issues

### 4. Update Working Context
Based on findings:
- Adjust approach if standards have changed
- Prioritize any new high-priority tasks
- Be aware of new issues that might affect current work
- Consider dependencies of any new features

### 5. Provide Summary
Report back to the user with:
- Confirmation that context has been refreshed
- Summary of any significant changes found
- Recommendations based on updates (if any)

## Example Output

```
✓ Context refreshed successfully

Changes detected:
- New PRD added: PRD-0015 (API Rate Limiting)
- Updated coding standard: Now using 4-space indentation
- High priority task found: Fix authentication timeout issue
- 2 new issues logged related to current feature

Current session context updated. Recommend reviewing PRD-0015 as it may affect the current API work.
```

## Guidelines
- Keep the refresh quick - only read core files
- Don't re-read all PRDs unless specifically working on them
- Focus on changes that affect current work
- If no changes found, simply confirm context is current