# AI Coding Agent Context Documentation Task

**Role:** You are a senior software engineer with extensive experience in software architecture, technical documentation, and optimizing AI coding agent workflows. You understand the importance of efficient context management for AI systems.

**Objective:** Review the entire application codebase, including all documentation (.md files), and create a comprehensive set of context documentation files that will serve as primers for AI coding agents working on this project.

## Requirements

### 1. File Organization
- Create focused context files in `@docs/agent-context/`
- Each file should address a single domain or responsibility
- Target length: 500-1500 tokens per file (to optimize context window usage)
- Use clear, descriptive filenames (e.g., `database-architecture.md`, `frontend-vue-app.md`)

### 2. Suggested Context Files
Adapt based on your codebase analysis:
- `infrastructure.md` - Database schemas, Redis configuration, message bus setup
- `module-architecture.md` - Module structure, communication patterns, dependencies
- `backend-api.md` - API endpoints, authentication, business logic
- `frontend-application.md` - UI framework, component structure, state management
- `deployment-config.md` - Build processes, CI/CD, environment configurations
- `testing-strategy.md` - Test frameworks, coverage requirements, testing patterns
- `security-practices.md` - Authentication, authorization, security considerations

### 3. Content Guidelines for Each File
- **Purpose statement** - When should an agent read this file?
- **Key concepts** - Essential terminology and patterns used
- **Architecture overview** - How this component fits into the system
- **Implementation details** - Critical technical decisions and constraints
- **Common tasks** - Frequent modifications or operations in this area
- **Dependencies** - Related files or systems that interact with this component
- **Gotchas** - Non-obvious behaviors or important warnings

### 4. Create an Index File (`index.md`)
```markdown
# Context Documentation Index

Select the relevant files based on your task:

- `module-architecture.md` - Read when creating new modules or modifying module structure
- `database-architecture.md` - Read when working with database queries, indexes, or schema changes
- `frontend-application.md` - Read when modifying UI components or user interactions
[Continue for all files...]
```

### 5. Create Project Overview (`about.md`)
- Project purpose and business context
- High-level architecture diagram (in ASCII or markdown)
- Technology stack summary
- Key design decisions and trade-offs
- Development workflow and conventions
- Links to external documentation or resources

## Success Criteria

- **Completeness**: All major system components are documented
- **Clarity**: Another developer could understand the system from these files alone
- **Efficiency**: Total context across all files should be under 10,000 tokens
- **Modularity**: An agent can read only relevant files without missing critical cross-cutting concerns
- **Actionability**: Each file provides enough detail for an agent to make informed implementation decisions

## Process

1. First, analyze the codebase structure and create a list of proposed context files
2. Draft the `about.md` overview file
3. Create individual context files, ensuring no unnecessary duplication
4. Write the `index.md` with clear guidance on when to use each file
5. Review all files for completeness and optimize for token efficiency

**Remember:** Ultrathink about this task, these documents are specifically for AI agents, not human developers. Focus on structured, factual information that enables accurate code generation and modification. Avoid lengthy explanations that a human might appreciate but an AI doesn't need.