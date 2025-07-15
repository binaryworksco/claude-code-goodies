# Optimize CLAUDE.md

## Purpose
This command creates an optimized CLAUDE.md file that works efficiently with the workflow system. It reduces token usage by 80-90% while maintaining essential functionality.

## What it does
- Creates an optimized CLAUDE.md that redirects to the workflow system
- Backs up existing CLAUDE.md if present
- Preserves only critical security rules and restrictions
- Dramatically reduces automatic context loading

## Process

### 1. Check for Existing CLAUDE.md
First, check if CLAUDE.md exists in the project root:
- If it exists, read it to identify critical rules to preserve
- Look for security restrictions, dangerous operations, or custom constraints
- Create a backup as `CLAUDE.md.backup` with timestamp

### 2. Identify Critical Rules
Scan the existing CLAUDE.md for patterns indicating critical rules:
- Security constraints (e.g., "NEVER", "MUST NOT", "FORBIDDEN")
- Defensive security rules
- Project-specific dangerous operations
- Custom tool restrictions
- Compliance requirements

Extract only these critical rules, ignoring:
- Project descriptions (covered by PROJECT.md)
- Architecture details (covered by CODEBASE.md)
- Coding standards (covered by STANDARDS.md)
- Feature lists (covered by PROJECT.md)

### 3. Generate Optimized CLAUDE.md
Create a new CLAUDE.md with this structure:

```markdown
# CLAUDE.md

This project uses a structured workflow system for context management.

## Required: Start Every Session
```
/prime
```

This command loads project context, standards, and recent work from the .working directory.

## Available Commands
- `/workflow-help` - View all workflow commands
- `/context <term>` - Search project information
- `/refresh` - Update context during long sessions

## Project Documentation
All project-specific information is maintained in:
- `.working/PROJECT.md` - Project overview and features
- `.working/STANDARDS.md` - Coding standards
- `.working/CODEBASE.md` - Key implementation locations

[INSERT CRITICAL RULES HERE IF ANY]

---
Note: This file is intentionally minimal. Use the workflow system for detailed project information.
```

### 4. Add Critical Rules Section
If critical rules were found, add them under a "## Critical Rules" section:
- Keep only truly critical constraints
- Maintain original wording for clarity
- Group similar rules together

### 5. Report Results
Provide feedback to the user:
- Confirmation of streamlined file creation
- Location of backup (if created)
- Estimated token savings
- Any critical rules that were preserved

## Example Output

```
✓ Optimized CLAUDE.md created successfully

Actions taken:
- Backed up existing file to: CLAUDE.md.backup-2024-01-15-14:30
- Preserved 2 critical security rules
- Reduced file size from 450 lines to 25 lines
- Estimated token savings: ~85% per session

Critical rules preserved:
- Authentication security constraints
- Database access restrictions

The workflow system will now handle all project-specific context loading.
```

## Guidelines
- Always create a backup before modifying CLAUDE.md
- Err on the side of preserving rules if uncertain
- Keep the optimized version under 30 lines
- Ensure `/prime` command is prominently featured
- Test that the optimized version doesn't break existing workflows