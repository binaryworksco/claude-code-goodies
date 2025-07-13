# Claude Code Workflow Quick Reference

## 🚀 Quick Start
```
1. /status                    # Check what's active
2. /resume                    # Continue recent work
3. /generate-feature "..."    # Start new feature
```

## 📁 Folder Structure
```
/docs/
├── features/feature-XXXX-name/
│   ├── feature-XXXX-name.md    # Requirements & tasks
│   ├── session.md              # Progress tracking
│   ├── decisions.md            # Key decisions
│   └── notes.md                # Temp notes
├── prd/prd-XXXX-name/          # Major features
└── bugs/bug-XXXX-name/         # Bug fixes
```

## 🔧 Essential Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/setup-workflow` | Initialize workflow (once per project) | `/setup-workflow` |
| `/status` | Show all active work | `/status` |
| `/status blocked` | Show only blocked items | `/status blocked` |
| `/resume` | Continue most recent work | `/resume` |
| `/switch [name]` | Switch to different work | `/switch auth` or `/switch 5` |
| `/generate-feature` | Start new feature (1-5 days) | `/generate-feature "Add dark mode"` |
| `/generate-prd` | Start major feature (5+ days) | `/generate-prd "Payment system"` |
| `/report-bug` | Create bug report | `/report-bug "Login fails"` |

## 🔄 Common Workflows

### Starting Fresh
```
User: /status                     # Check existing work
User: /generate-feature "..."     # Start new feature
```

### Resuming Work
```
User: /resume                     # Continue where you left off
```

### Switching Tasks
```
User: /switch feature-0005        # Full ID
User: /switch auth                # Partial name
User: /switch 5                   # Just number
```

### Quick Status Check
```
User: /status                     # Everything
User: /status features            # Just features
User: /status blocked             # Blocked items
```

## 📊 Status Indicators

| Icon | Meaning |
|------|---------|
| ✅ | Active, healthy |
| ⚠️ | Needs attention (stale) |
| 🚫 | Blocked |
| 📝 | Planning phase |
| 🔍 | Investigating |

## 🎯 Task States

- `[ ]` Not started
- `[x]` Completed
- Status: Planning → In Progress → Testing → Completed

## 💡 Pro Tips

1. **Always start with**: `/status` or `/resume`
2. **Keep organized**: One feature per folder
3. **Switch cleanly**: Use `/switch` to change context
4. **Document decisions**: They go in `decisions.md`
5. **Use shortcuts**: `/switch 5` = `/switch feature-0005`

## 🚨 Quick Fixes

**Can't find work?**
```
/status
```

**Wrong branch?**
```
Claude will detect and offer to switch
```

**Work seems old?**
```
Check /status - items > 7 days are marked stale
```

**Need to pause?**
```
Just stop - session.md saves your state
```

## 📝 File Purposes

| File | Purpose | When Updated |
|------|---------|--------------|
| `feature-XXXX.md` | Requirements & tasks | During planning |
| `session.md` | Current progress | Continuously |
| `decisions.md` | Important choices | When decisions made |
| `notes.md` | Temporary scratch | As needed |

## 🎬 Session Lifecycle

1. **Create**: `/generate-feature` → Creates folder
2. **Work**: Updates session.md automatically
3. **Switch**: `/switch` → Saves state
4. **Complete**: Mark as "Completed" in session.md
5. **Archive**: Move to `/docs/archive/YYYY-QX/`

## 🔑 Key Concepts

- **Feature-centric**: Everything for a feature in one folder
- **Session continuity**: Easy to resume across conversations
- **Auto-tracking**: Claude updates progress automatically
- **Decision history**: Important choices are preserved

---

**Full guide**: See `/docs/WORKFLOW-GUIDE.md` for detailed instructions