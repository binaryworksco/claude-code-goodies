# Study the codebase and generate a summary

!find . -type f -name "package.json" -o -name "requirements.txt" -o -name "Gemfile" -o -name "Cargo.toml" -o -name "go.mod" -o -name "pom.xml" -o -name "build.gradle" | head -10
!find . -type f -name "README*" -o -name "readme*" | head -5
!find . -type f -name "CLAUDE.md" | head -5
!ls -la
!git status 2>/dev/null || echo "Not a git repository"
!git remote -v 2>/dev/null || echo "No git remotes"
!find . -type d -name "src" -o -name "lib" -o -name "app" -o -name "components" -o -name "pages" -o -name "api" | grep -v node_modules | head -20
!find . -type f \( -name "*.config.js" -o -name "*.config.ts" -o -name ".env.example" -o -name "docker-compose.yml" \) | head -10
!cat package.json 2>/dev/null | head -50 || echo "No package.json found"
!cat README.md 2>/dev/null | head -100 || cat readme.md 2>/dev/null | head -100 || echo "No README found"
!cat CLAUDE.md 2>/dev/null | head -200 || echo "No CLAUDE.md found"
!tree -L 3 -I 'node_modules|.git|dist|build|coverage|.next|target|vendor' 2>/dev/null | head -100 || find . -type d -not -path '*/\.*' -not -path '*/node_modules/*' -not -path '*/dist/*' -not -path '*/build/*' | sort | head -50

Create a comprehensive project summary that includes the following and remember this as context going forward as we code.

## 📋 Project Overview
- **Project Name & Purpose**: What is this project and what problem does it solve?
- **Technology Stack**: Primary languages, frameworks, and tools used
- **Project Type**: (e.g., web application, CLI tool, library, API service, mobile app)
- **Current Status**: Development stage, version, or release status if apparent

## 🏗️ Architecture & Structure
- **Directory Organization**: How is the codebase structured?
- **Key Components**: Main modules, services, or features
- **Entry Points**: Main files or scripts to run the project
- **Configuration**: Important configuration files and their purposes

## 🔧 Development Setup
- **Dependencies**: Package managers and key dependencies
- **Build Process**: How to build/compile the project
- **Testing**: Test framework and how to run tests
- **Development Server**: How to run locally

## 🌟 Key Features
- List the main features or capabilities based on the codebase
- Note any unique or notable implementations

## 📚 Documentation
- What documentation exists (README, CLAUDE.md, docs folder)?
- Are there any gaps in documentation that should be addressed?

## 🚀 Getting Started
- Quick steps for a new developer to get up and running
- Any prerequisites or system requirements

## 🤔 Observations & Recommendations
- Code quality observations
- Potential improvements or refactoring opportunities
- Missing configurations or setup steps

