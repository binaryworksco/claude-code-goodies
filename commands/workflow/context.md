# Context Search

## Purpose
This command searches across all files in the .working directory to find relevant context for a specific topic or keyword. It helps you quickly locate information without loading entire files, supporting the "just enough context" principle.

## Usage
To use this command, provide the topic or keyword you want to search for:
```
/context <topic>
```

## Instructions

### 1. Parse Search Query
Extract the search topic from the user's input. If no topic is provided, ask the user what they want to search for.

### 2. Search Strategy
Perform a comprehensive search across the .working directory:
- Search in all markdown files (.md)
- Look for the topic in file contents, not just filenames
- Use case-insensitive matching
- Include partial matches

### 3. Present Results
Display search results in a structured format:
- Group results by file
- Show relevant snippets (2-3 lines of context around matches)
- Include line numbers for easy reference
- Limit to top 10 most relevant results

### 4. Smart Suggestions
Based on the search results:
- Suggest which specific files to read for more detail
- Identify if the topic relates to a specific PRD, issue, or task
- Recommend related searches if the initial search yields few results

## Example Output

```
Searching for: "authentication"

Found 4 matches:

📄 PROJECT.md (line 45-47)
   ...The system uses JWT-based authentication with refresh tokens...
   ...Authentication is handled by the auth service...

📄 features/user-auth/PRD-001.md (line 12-14)
   ...Implement OAuth2 authentication flow...
   ...Support social authentication providers...

📄 ISSUES.md (line 23-25)
   ...Bug: Authentication tokens not refreshing properly...
   ...Impact: Users getting logged out unexpectedly...

📄 SESSION-NOTES.md (line 89-90)
   ...Fixed authentication middleware to properly validate tokens...

Suggestions:
- For implementation details, read: features/user-auth/PRD-001.md
- For known issues, check: ISSUES.md (1 authentication-related issue)
- Related searches: "jwt", "oauth", "login"
```

## Guidelines
- Keep search fast by using efficient grep patterns
- Don't load entire file contents into memory
- Provide actionable next steps based on results
- If no results found, suggest alternative search terms