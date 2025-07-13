# Claude Code Workflow Guide

This guide explains how to use the feature-centric workflow system with Claude Code to manage your development tasks effectively.

## Table of Contents
- [Overview](#overview)
- [Getting Started](#getting-started)
- [Core Concepts](#core-concepts)
- [Common Workflows](#common-workflows)
- [Command Reference](#command-reference)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Overview

The feature-centric workflow organizes all work around features, PRDs (Product Requirement Documents), and bugs. Each piece of work gets its own folder containing all related files, ensuring better organization and continuity across Claude Code sessions.

### Why Use This Workflow?

1. **Session Continuity**: Easy to resume work after breaks or in new conversations
2. **Better Organization**: All related files stored together
3. **Clear Progress Tracking**: Always know what's done and what's next
4. **Team Collaboration**: Easy to hand off work with full context
5. **Decision History**: Important choices are documented and preserved

## Getting Started

### First-Time Setup

1. **Initialize the Workflow Structure**
   ```
   User: Run /setup-workflow
   ```
   This creates the necessary folder structure and templates in your project.

2. **Check Existing Work**
   ```
   User: Show me the /status
   ```
   This shows any active features, PRDs, or bugs already in progress.

3. **Start Your First Feature**
   ```
   User: /generate-feature "Add user profile page"
   ```

### Resuming Work

When starting a new Claude Code session:

```
User: /resume
```

Claude will find your most recent work and show you where you left off.

## Core Concepts

### 1. Feature-Centric Organization

Every piece of work lives in its own folder:

```
/docs/
├── features/
│   └── feature-0001-user-profile/
│       ├── feature-0001-user-profile.md    # Requirements & tasks
│       ├── session.md                      # Current progress
│       ├── decisions.md                    # Key decisions
│       ├── notes.md                        # Working notes
│       └── agents/                         # Multi-agent work
├── prd/
│   └── prd-0001-authentication/
│       └── [same structure]
└── bugs/
    └── bug-0001-login-error/
        └── [same structure]
```

### 2. Session Tracking

The `session.md` file tracks:
- Current status (Planning, In Progress, Blocked, Testing, Completed)
- What you're working on right now
- Completed and pending tasks
- Key decisions made
- Next steps

This file is automatically updated as you work.

### 3. Task Management

Tasks are tracked as checkboxes in the main document:
- `[ ]` - Not started
- `[x]` - Completed

Claude will update these as work progresses.

### 4. Decision Documentation

Important technical decisions are logged in `decisions.md` with:
- Context of why the decision was needed
- Options that were considered
- The chosen approach and rationale
- Impact on the implementation

## Common Workflows

### Starting a New Feature

**Scenario**: You need to add a new feature to your application.

```
User: I need to add a shopping cart feature

Claude: I'll help you add a shopping cart feature. This seems like a substantial feature. 
Would you like me to:
1. Create a PRD for planning (recommended for complex features)
2. Create a feature for immediate implementation

User: Let's create a feature

Claude: [Creates /docs/features/feature-0003-shopping-cart/]
```

### Fixing a Bug

**Scenario**: Users report a login issue.

```
User: Users can't login with email addresses containing '+'

Claude: I'll help you investigate and fix this login issue. Let me create a bug report.
[Creates /docs/bugs/bug-0015-email-plus-login/]
```

### Switching Between Tasks

**Scenario**: You need to pause one feature to work on an urgent bug.

```
User: /switch bug-0015

Claude: Switching to: Email Plus Login Bug (bug-0015)
Saving current feature progress...
Loading bug investigation status...
```

### Checking Overall Status

**Scenario**: Monday morning, checking what needs attention.

```
User: /status

Claude: 📊 Project Status Overview

Active Work:
- 2 Features (1 blocked)
- 1 PRD in planning
- 1 Bug under investigation

Needs Attention:
- Shopping Cart feature blocked for 3 days (waiting for payment API)
- User Profile feature not updated in 8 days
```

## Command Reference

### Starting Work

#### `/generate-feature "description"`
Creates a new feature with folder structure and starts planning.

**Example**:
```
User: /generate-feature "Add dark mode support"
```

**When to use**: For implementation-ready features (1-5 days of work)

---

#### `/generate-prd "description"`
Creates a Product Requirements Document for major features.

**Example**:
```
User: /generate-prd "Multi-tenant architecture"
```

**When to use**: For complex features requiring planning (5+ days)

---

#### `/report-bug "description"`
Creates a bug report and investigation workspace.

**Example**:
```
User: /report-bug "Users see 404 on profile page"
```

**When to use**: For any bugs or issues to investigate

### Continuing Work

#### `/resume`
Continues the most recent work or shows options if multiple active.

**Example**:
```
User: /resume

Claude: Found active session:
- Feature: Dark Mode (feature-0004)
- Status: In Progress (60% complete)
- Last task: Implementing theme persistence

Would you like to resume?
```

---

#### `/switch [name or id]`
Switches to a different active feature/PRD/bug.

**Example**:
```
User: /switch dark mode
User: /switch feature-0004
User: /switch 4
```

All three examples switch to the same feature.

---

#### `/status [filter]`
Shows overview of all work, optionally filtered.

**Options**:
- `/status` - All active work
- `/status features` - Only features
- `/status bugs` - Only bugs
- `/status blocked` - Only blocked items

### Workflow Management

#### `/setup-workflow`
Initializes the workflow structure in a project.

**When to use**: Once per project, at the beginning

## Best Practices

### 1. Start Sessions with Status Check

Always begin new Claude sessions by checking status:
```
User: /status
```

This helps you and Claude understand what's in progress.

### 2. Keep Sessions Focused

Work on one feature/bug at a time. If you need to switch:
```
User: /switch other-feature
```

### 3. Document Decisions

When making important technical choices:
```
User: We decided to use PostgreSQL instead of MongoDB because we need ACID compliance.

Claude: I'll document this decision in decisions.md with the context and rationale.
```

### 4. Update Progress Regularly

Claude automatically updates progress, but you can also request updates:
```
User: Mark the database schema task as complete

Claude: ✓ Updated task status in feature-0004-dark-mode.md
```

### 5. Complete the Cycle

When finishing work:
```
User: The dark mode feature is complete and tested

Claude: Great! I'll mark the feature as completed. Would you like me to:
1. Archive the feature folder
2. Keep it in active docs for reference
```

### 6. Use Notes for Temporary Information

The `notes.md` file is perfect for:
- Research links
- Code snippets to try
- Questions for team members
- Debugging observations

## Troubleshooting

### "No active sessions found"

This is normal for new projects or after archiving. Simply start new work:
```
User: /generate-feature "my new feature"
```

### "Branch doesn't match session"

This happens when git branch doesn't match the session's expected branch:
```
Claude: Warning: You're on 'main' but this feature expects 'feature/dark-mode'
Would you like me to switch branches?
```

### "Multiple matches found"

When switching features with ambiguous names:
```
User: /switch user

Claude: Found multiple matches:
1. User Profile (feature-0002)
2. User Settings (feature-0005)
3. User Search Bug (bug-0003)

Which one? (1-3)
```

### Session Seems Stale

If a session hasn't been updated in a while:
```
Claude: This session is 10 days old and may be stale.
Would you like to:
1. Resume anyway
2. Archive and start fresh
```

### Lost Work

All work is saved in the feature folders. Even if a session seems lost:
1. Check `/docs/features/`, `/docs/prd/`, or `/docs/bugs/`
2. Look for your feature by name
3. The `session.md` file contains the last state

## Advanced Usage

### Multi-Agent Workflows

When Claude spawns subagents for specialized tasks:
```
/docs/features/feature-0004-dark-mode/
└── agents/
    ├── search-patterns-01.md    # Agent searching for patterns
    └── test-runner-01.md        # Agent running tests
```

The main session.md tracks what each agent is doing.

### Custom Templates

You can modify templates in `/templates/` to match your team's needs:
- `session.md.template`
- `feature.md.template`
- `prd.md.template`
- `bug.md.template`

### Integration with Git

The workflow tracks git branches. Each feature typically has its own branch:
```
Feature: Dark Mode (feature-0004)
Branch: feature/dark-mode
```

When switching features, Claude will offer to switch git branches too.

## Quick Tips

1. **Use shortcuts**: `/switch 4` instead of `/switch feature-0004`
2. **Filter status**: `/status blocked` to see only blocked items
3. **Let Claude guide you**: It will ask clarifying questions
4. **Trust the process**: The structure seems complex but becomes natural quickly
5. **Archive completed work**: Keeps active work list clean

## Getting Help

If you're stuck:
1. Check `/status` to see current state
2. Look in the feature folder for all related files
3. Check `decisions.md` for past choices
4. Review `notes.md` for work-in-progress items

Remember: The workflow is designed to help you stay organized and maintain continuity. Use it as a tool, not a rigid process.