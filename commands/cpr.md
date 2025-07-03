# Commit, push and PR the latest changes

!git status --porcelain
!git branch --show-current
!git log origin/$(git rev-parse --abbrev-ref HEAD)..HEAD --oneline 2>/dev/null | wc -l

Based on the git status above, please help me ship these changes:

- If there are uncommitted changes: stage, commit with appropriate message
- If there are unpushed commits: push them
- If we're not on main/master: create a PR
- If the branch doesn't exist on remote yet: push with --set-upstream

Make smart decisions about:
- Whether to add all files or be selective
- Commit message based on the changes
- PR title and description based on the branch name and commits

Guidelines for commit messages:
- feat: new features
- fix: bug fixes  
- docs: documentation changes
- style: formatting, missing semicolons, etc.
- refactor: code restructuring without functionality changes
- test: adding or updating tests
- chore: maintenance tasks, dependency updates

Examples:
- "feat: add user authentication with JWT tokens"
- "fix: resolve memory leak in data processing loop"
- "docs: update API documentation for new endpoints"
- "refactor: extract utility functions to separate module"

$ARGUMENTS