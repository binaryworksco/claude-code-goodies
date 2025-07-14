# Setup workflow folder and files in a new project

## Purpose
This command sets up a structured workflow system to track project documentation, standards, learnings, and tasks. It helps maintain project clarity and development consistency throughout the codebase lifecycle.

## Steps

### 1. Pre-flight Checks
First, check if the `.working` folder already exists:
- If it exists, ask user whether to proceed with updating existing files or abort
- If it doesn't exist, proceed with creation

### 2. Create Workflow Structure
Create the `.working` folder in the project root, then create these documentation files:
- **PROJECT.md** - Core project info, tech stack, and high-level features list
- **STANDARDS.md** - Development rules, coding standards, and git discipline
- **LEARNINGS.md** - Technical insights, patterns discovered, and missteps to avoid
- **ISSUES.md** - Known bugs, regressions, and technical debt
- **TASKS.md** - Standalone tasks not tied to specific features/PRDs

### 3. Analyze Project Structure
Perform a systematic analysis of the codebase:
- **Tech Stack**: Identify languages, frameworks, and major dependencies from package files
- **Architecture**: Map the folder structure and identify architectural patterns
- **Documentation**: Locate and read existing README, docs, or wiki files
- **Testing**: Find test frameworks and commands (check package.json scripts, Makefile, etc.)
- **Code Style**: Identify linting configs, formatting rules, and naming conventions
- **Git Workflow**: Check branch naming patterns and commit message styles from git log

### 4. Fetch Template Files
Retrieve the template files from the remote repository:
- Navigate to https://github.com/mathewtaylor/claude-code-goodies/tree/main/templates
- Fetch these templates:
  - PROJECT.md.template
  - STANDARDS.md.template
  - LEARNINGS.md.template (for reference)
  - ISSUES.md.template (for reference)
  - TASKS.md.template (for reference)
- If unable to fetch, provide basic structure based on file purposes listed above

### 5. Populate Documentation Files
Using the templates as guides:
- **PROJECT.md**: Fill in project overview, tech stack details, special considerations, and PRD table structure
- **STANDARDS.md**: Customize based on detected code style, architecture patterns, and git practices
- **LEARNINGS.md**: Initialize with header structure from template
- **ISSUES.md**: Initialize with header structure from template
- **TASKS.md**: Initialize with header structure from template

### 6. Validation
Verify successful setup:
- Confirm all 5 files exist in `.working` folder
- Ensure PROJECT.md contains at least: overview, tech stack, and PRD section
- Ensure STANDARDS.md reflects actual project conventions found during analysis
- Check that no files are empty or contain only template placeholders

### 7. Final Summary
Report to user:
- List of created/updated files
- Key findings from project analysis
- Any assumptions made or areas needing user clarification
- Suggestions for maintaining these documents going forward
