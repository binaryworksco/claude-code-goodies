# Setup standard workflow for the project

<command_overview>
This document sets up a feature-centric workflow that should be followed by coding agents. It creates a structured approach where all related artifacts for a feature, PRD, or bug are stored together. You are to understand the instructions set out in the document and update the project CLAUDE.md file so these instructions are loaded into context every session.
</command_overview>

<documents>
Documents are created in markdown format and organized in a feature-centric structure. Each feature, PRD, or bug gets its own folder containing all related artifacts including session state, decisions, and notes.
</documents>

<structure>
/docs/                                  # Root folder where all documents are to be stored.
├── README.md                           # High-level overview of the project: what it does, who it's for, etc.
├── QUICKSTART.md                       # Essential project info for quick context loading (< 500 lines)
├── LESSONS.md                          # Accumulated learnings and patterns that work well
├── features/                           # Feature-specific folders with all related artifacts
│   └── feature-XXXX-[name]/            # Each feature gets its own folder
│       ├── feature-XXXX-[name].md      # Feature document
│       ├── session.md                  # Current session state and progress
│       ├── decisions.md                # Key decisions made during development
│       ├── notes.md                    # Working notes and scratchpad
│       └── agents/                     # Multi-agent session files
├── prd/                                # Product Requirement Documents
│   └── prd-XXXX-[name]/                # Each PRD gets its own folder
│       ├── prd-XXXX-[name].md          # PRD document
│       ├── session.md                  # Session state for this PRD
│       └── ...                         # Other related artifacts
├── bugs/                               # Bug tracking and fixes
│   └── bug-XXXX-[description]/         # Each bug gets its own folder
│       ├── bug-XXXX-[description].md   # Bug report
│       ├── session.md                  # Investigation/fix progress
│       └── investigation.md            # Detailed investigation notes
├── style/                              # Contains design and user experience guides
│   ├── ux-guide.md                     # Guide on managing the user experience
│   └── ui-guide.md                     # Guide on designing the user interface
├── tech/                               # Technical documentation and architecture details
│   ├── architecture.md                 # Project architecture, frameworks, patterns
│   └── coding-standards.md             # Coding standards and best practices
├── templates/                          # Reusable templates for consistency
│   ├── session.md.template             # Template for session files
│   ├── decisions.md.template           # Template for decision logs
│   └── feature.md.template             # Template for feature documents
└── archive/                            # Completed features/PRDs/bugs
    └── YYYY-QX/                        # Organized by year and quarter
</structure>

<workflow>
When you are given a task, always do the following:

1. **Check for Active Sessions**: Look for active session.md files in /docs/features/, /docs/prd/, and /docs/bugs/ folders to see if there's ongoing work.

2. **Load Essential Context**: 
   - Read /docs/QUICKSTART.md for essential project information
   - Check /docs/LESSONS.md for project-specific patterns and gotchas
   - If resuming work, load the relevant session.md file

3. **Identify Task Type**:
   - bug-fix: Quick fixes, use /docs/bugs/ structure
   - feature: Implementation work, use /docs/features/ structure  
   - prd: Major features needing planning, use /docs/prd/ structure
   - research: Information gathering, may not need session tracking

4. **Create or Update Session**:
   - For new work: Create appropriate folder structure with session.md
   - For existing work: Update session.md with current progress
   - Track decisions in decisions.md as you make them

5. **Load Relevant Documentation**:
   - Based on task type, read specific docs from /docs/tech/, /docs/style/, etc.
   - Only load what's needed to avoid token overload

6. **Clarify and Align**:
   - Ask clarifying questions based on gaps in understanding
   - Summarize your understanding before starting implementation
   - Update session.md with the agreed approach

7. **Multi-Agent Coordination** (if spawning agents):
   - Create agent session files in the feature's agents/ subdirectory
   - Update main session.md with agent activities
   - Coordinate through the parent session file
</workflow>

<response_style>
- Be professional and technically accurate
- Use clear, concise language
- Provide justifications for technology/technical design consideraction choices
- Be realistic about timelines and complexity
- Focus on actionable outcomes
- Ensure consistency across all documentation files
- Create logical connections between implementation, structure, and design
</response_style>

<session_management>
## Session File Structure

Each session.md file should contain:

```markdown
## Feature/PRD/Bug: [Name] ([ID])
- Branch: [branch-name]
- Created: [timestamp]
- Last Updated: [timestamp]
- Status: [Planning|In Progress|Blocked|Testing|Completed]

## Current Focus
[What you're currently working on]

## Completed Tasks
- [x] Task 1
- [x] Task 2
- [ ] Task 3 (in progress)

## Key Decisions
- Decision 1: [What was decided and why]
- Decision 2: [What was decided and why]

## Blockers/Questions
- [Any blockers or pending questions]

## Next Steps
- [What needs to be done next]
```

## Session Lifecycle

1. **Creation**: When starting new work, create folder and initialize session.md
2. **Updates**: After each significant step, update session.md
3. **Completion**: Mark status as "Completed" when done
4. **Archive**: Move entire folder to /docs/archive/YYYY-QX/ after merge
</session_management>

<actions>
1. Create the /docs folder structure as set out in <structure> section
2. Create template files in /docs/templates/ for consistency
3. Create initial QUICKSTART.md and LESSONS.md files
4. Update the project CLAUDE.md to include:
   - The feature-centric workflow instructions
   - Session management guidelines
   - Quick reference for checking active sessions
5. Do not change the structure, workflow, or response_style instructions when updating CLAUDE.md
</actions>