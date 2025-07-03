#!/bin/bash
# auto-approve.sh - Auto-approves certain Claude Code requests
# Place this in ~/.claude/hooks/auto-approve.sh

# Configuration
ALLOWED_LIST_FILE="$HOME/.claude/hooks/allowed-tasks.txt"
DANGEROUS_LIST_FILE="$HOME/.claude/hooks/dangerous-tasks.txt"
TELEGRAM_BOT_TOKEN="ENTER-TELEGRAM-BOT-ID-HERE"
TELEGRAM_CHAT_ID="ENTER-TELEGRAM-CHAT-ID-HERE"
APPROVE_LOG_FILE="$HOME/.claude/logs/auto-approve.log"
BLOCKED_LOG_FILE="$HOME/.claude/logs/auto-blocked.log"
DANGEROUS_LOG_FILE="$HOME/.claude/logs/dangerous-commands.log"

# Logging configuration
VERBOSE_LOGGING=false  # Set to true for detailed debugging logs

# Create directories if they don't exist
mkdir -p "$HOME/.claude/hooks" "$HOME/.claude/logs"

# Initialize log buffer
LOG_BUFFER=""

# Variable to store the matched pattern for approval
MATCHED_PATTERN=""

# Function to add to log buffer (original function for compatibility)
log_buffer() {
    LOG_BUFFER="${LOG_BUFFER}[$(date)] $1\n"
}

# Function for verbose logging (only logs when VERBOSE_LOGGING=true)
log_verbose() {
    if [[ "$VERBOSE_LOGGING" == "true" ]]; then
        log_buffer "$1"
    fi
}

# Function for always logging (logs regardless of verbosity setting)
log_always() {
    log_buffer "$1"
}

# Start logging
log_verbose "========================================"
log_verbose "===== NEW HOOK EXECUTION STARTED ====="
log_verbose "========================================"

# Read input JSON
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input')

# Function to get brief description of the operation
get_operation_brief() {
    local tool="$1"
    local input="$2"
    
    case "$tool" in
        "Task")
            echo "$tool: $(echo "$input" | jq -r '.title // "Unknown"')"
            ;;
        "Bash")
            echo "$tool: $(echo "$input" | jq -r '.command // "Unknown"' | head -c 100)"
            ;;
        "Glob")
            echo "$tool: $(echo "$input" | jq -r '.pattern // "Unknown"')"
            ;;
        "Grep")
            echo "$tool: $(echo "$input" | jq -r '.pattern // .search // "Unknown"')"
            ;;
        "Read"|"Write"|"Edit"|"MultiEdit"|"Update")
            echo "$tool: $(echo "$input" | jq -r '.path // .file_path // "Unknown"')"
            ;;
        "WebFetch")
            echo "$tool: $(echo "$input" | jq -r '.url // "Unknown"')"
            ;;
        "WebSearch")
            echo "$tool: $(echo "$input" | jq -r '.query // "Unknown"')"
            ;;
        *)
            echo "$tool operation"
            ;;
    esac
}

# Get operation brief for logging
OPERATION_BRIEF=$(get_operation_brief "$TOOL_NAME" "$TOOL_INPUT")

# Non-verbose logging for incoming request
if [[ "$VERBOSE_LOGGING" != "true" ]]; then
    log_always "$OPERATION_BRIEF"
fi

# Log the incoming request
log_verbose "===== INCOMING REQUEST ====="
log_verbose "Tool: $TOOL_NAME"
log_verbose "Full Input: $INPUT"
log_verbose "Tool Input: $TOOL_INPUT"

# Function to send Telegram notification with proper formatting
send_telegram() {
    local message="$1"
    
    log_verbose "Sending Telegram notification..."
    
    if curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=$message" \
        -d "parse_mode=Markdown" > /dev/null 2>&1; then
        log_verbose "Telegram notification sent successfully"
    else
        log_verbose "Failed to send Telegram notification"
    fi
}

# Function to check if command is dangerous
is_dangerous_command() {
    local tool="$1"
    local input="$2"
    
    log_verbose "Checking for dangerous patterns for tool: $tool"
    
    # Check if dangerous list file exists
    if [[ ! -f "$DANGEROUS_LIST_FILE" ]]; then
        log_verbose "Dangerous list file not found: $DANGEROUS_LIST_FILE"
        return 1
    fi
    
    # Extract relevant information based on tool type
    local check_value=""
    case "$tool" in
        "Bash")
            check_value=$(echo "$input" | jq -r '.command // empty')
            log_verbose "Checking Bash command for dangerous patterns: $check_value"
            ;;
        "Write"|"Edit"|"MultiEdit"|"Update")
            # Check file paths for dangerous overwrites
            check_value=$(echo "$input" | jq -r '.path // .file_path // empty')
            log_verbose "Checking file path for dangerous patterns: $check_value"
            ;;
        *)
            # For other tools, generally not dangerous
            return 1
            ;;
    esac
    
    # Check against dangerous patterns
    if [[ -n "$check_value" ]]; then
        while IFS= read -r pattern; do
            [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
            if [[ "$check_value" =~ $pattern ]]; then
                log_always "⚠️ DANGEROUS PATTERN DETECTED: $check_value (matched: $pattern)"
                return 0
            fi
        done < "$DANGEROUS_LIST_FILE"
    fi
    
    return 1
}

# Function to check if task should be auto-approved
should_auto_approve() {
    local tool="$1"
    local input="$2"
    
    log_verbose "Checking auto-approval for tool: $tool"
    
    # Check if allowed list file exists
    if [[ ! -f "$ALLOWED_LIST_FILE" ]]; then
        log_verbose "Allowed list file not found: $ALLOWED_LIST_FILE"
        return 1
    fi
    
    # Extract relevant information based on tool type
    case "$tool" in
        "Task")
            TASK_TITLE=$(echo "$input" | jq -r '.title // empty')
            log_verbose "Checking Task: $TASK_TITLE"
            # Check if task title matches any pattern in allowed list
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                if [[ "$TASK_TITLE" =~ $pattern ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved Task: $TASK_TITLE (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            ;;
        "Bash")
            COMMAND=$(echo "$input" | jq -r '.command // empty')
            log_verbose "Checking Bash command: $COMMAND"
            # Check for safe commands
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                log_verbose "Testing pattern: $pattern"
                if [[ "$COMMAND" =~ $pattern ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved Bash: $COMMAND (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            log_verbose "No matching pattern found for: $COMMAND"
            ;;
        "Glob")
            PATTERN=$(echo "$input" | jq -r '.pattern // empty')
            log_verbose "Checking Glob pattern: $PATTERN"
            # Check for allowed glob patterns
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                # Allow all Glob operations if pattern is ^Glob$
                if [[ "$pattern" == "^Glob$" ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved Glob: all patterns allowed"
                    return 0
                fi
                if [[ "$PATTERN" =~ $pattern ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved Glob: $PATTERN (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            ;;
        "Grep")
            SEARCH=$(echo "$input" | jq -r '.pattern // .search // empty')
            log_verbose "Checking Grep search: $SEARCH"
            # Check for allowed grep operations
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                # Allow all Grep operations if pattern is ^Grep$
                if [[ "$pattern" == "^Grep$" ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved Grep: all searches allowed"
                    return 0
                fi
                if [[ "$SEARCH" =~ $pattern ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved Grep: $SEARCH (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            ;;
        "Read")
            FILE_PATH=$(echo "$input" | jq -r '.path // .file_path // empty')
            log_verbose "Checking Read file: $FILE_PATH"
            # Check if file path is in allowed directories for reading
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                # Skip exclusion patterns
                [[ "$pattern" =~ ^! ]] && continue
                # Allow all Read operations if pattern is ^Read$
                if [[ "$pattern" == "^Read$" ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved Read: all files allowed"
                    return 0
                fi
                if [[ "$FILE_PATH" =~ $pattern ]]; then
                    # Check exclusions
                    while IFS= read -r exclude; do
                        [[ "$exclude" =~ ^! ]] || continue
                        exclude_pattern="${exclude#!}"
                        if [[ "$FILE_PATH" =~ $exclude_pattern ]]; then
                            log_always "Blocked by exclusion: $FILE_PATH (matched: $exclude)"
                            return 1
                        fi
                    done < "$ALLOWED_LIST_FILE"
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved Read: $FILE_PATH (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            ;;
        "Write"|"Edit"|"MultiEdit"|"Update")
            FILE_PATH=$(echo "$input" | jq -r '.path // .file_path // empty')
            log_verbose "Checking file path: $FILE_PATH"
            # Check if file path is in allowed directories
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                # Skip exclusion patterns
                [[ "$pattern" =~ ^! ]] && continue
                # Check if pattern matches the tool name exactly (e.g., ^Write$, ^Edit$)
                if [[ "$pattern" == "^Write$" ]] && [[ "$tool" == "Write" ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved Write: all files allowed"
                    return 0
                fi
                if [[ "$pattern" == "^Edit$" ]] && [[ "$tool" == "Edit" ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved Edit: all files allowed"
                    return 0
                fi
                if [[ "$pattern" == "^MultiEdit$" ]] && [[ "$tool" == "MultiEdit" ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved MultiEdit: all files allowed"
                    return 0
                fi
                if [[ "$pattern" == "^Update$" ]] && [[ "$tool" == "Update" ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved Update: all files allowed"
                    return 0
                fi
                if [[ "$FILE_PATH" =~ $pattern ]]; then
                    # Check exclusions
                    while IFS= read -r exclude; do
                        [[ "$exclude" =~ ^! ]] || continue
                        exclude_pattern="${exclude#!}"
                        if [[ "$FILE_PATH" =~ $exclude_pattern ]]; then
                            log_always "Blocked by exclusion: $FILE_PATH (matched: $exclude)"
                            return 1
                        fi
                    done < "$ALLOWED_LIST_FILE"
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved File: $FILE_PATH (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            ;;
        "WebFetch"|"WebSearch")
            URL=$(echo "$input" | jq -r '.url // .query // empty')
            log_verbose "Checking Web operation: $URL"
            # Check for allowed web operations
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                # Special handling for web tools - if pattern is just the tool name, allow all
                if [[ "$pattern" == "^WebFetch$" ]] && [[ "$tool" == "WebFetch" ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved WebFetch: all URLs allowed"
                    return 0
                fi
                if [[ "$pattern" == "^WebSearch$" ]] && [[ "$tool" == "WebSearch" ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved WebSearch: all queries allowed"
                    return 0
                fi
                # Otherwise check URL/query patterns
                if [[ "$URL" =~ $pattern ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved $tool: $URL (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            ;;
        *)
            # For any other tool type, check if the tool name itself is allowed
            log_verbose "Checking unknown tool type: $tool"
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                if [[ "$tool" =~ $pattern ]]; then
                    MATCHED_PATTERN="$pattern"
                    log_always "Auto-approved $tool: tool name matched pattern $pattern"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            ;;
    esac
    
    return 1
}

# First check if this is a dangerous command
if is_dangerous_command "$TOOL_NAME" "$TOOL_INPUT"; then
    # Dangerous command detected - bypass auto-approval and notify
    MESSAGE="🚨 *DANGEROUS COMMAND DETECTED*

*Tool:* \`$TOOL_NAME\`"
    
    case "$TOOL_NAME" in
        "Bash")
            COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // "Unknown"' | head -c 200)
            MESSAGE="$MESSAGE
*Command:* \`$COMMAND\`"
            ;;
        "Write"|"Edit"|"MultiEdit"|"Update")
            FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.path // .file_path // "Unknown"')
            MESSAGE="$MESSAGE
*File:* \`$FILE_PATH\`"
            ;;
    esac
    
    MESSAGE="$MESSAGE

⚠️ *Status:* This command matches a dangerous pattern and requires manual approval."
    
    send_telegram "$MESSAGE"
    
    # Log the dangerous command
    if [[ "$VERBOSE_LOGGING" != "true" ]]; then
        log_always "🚨 DANGEROUS: $OPERATION_BRIEF"
    else
        log_always "🚨 DANGEROUS COMMAND DETECTED: $TOOL_NAME"
    fi
    
    # Return undefined decision - let Claude Code's existing permission flow handle it
    RESPONSE="{\"info\": \"Dangerous command pattern detected\"}"
    echo "$RESPONSE"
    log_verbose "Response to Claude: $RESPONSE"
    log_verbose "===== END REQUEST ====="
    
    # Write to dangerous commands log
    echo -e "$LOG_BUFFER" >> "$DANGEROUS_LOG_FILE"
    exit 0
fi

# Check if the request should be auto-approved
if should_auto_approve "$TOOL_NAME" "$TOOL_INPUT"; then
    # Auto-approve the request - bypass permission system
    RESPONSE="{\"decision\": \"approve\", \"reason\": \"Auto-approved by hook (matched: $MATCHED_PATTERN)\"}"
    echo "$RESPONSE"
    if [[ "$VERBOSE_LOGGING" != "true" ]]; then
        log_always "✅ AUTO-APPROVED (matched: $MATCHED_PATTERN)"
    else
        log_always "✅ AUTO-APPROVED: $TOOL_NAME"
    fi
    log_verbose "Response to Claude: $RESPONSE"
    log_verbose "===== END REQUEST ====="
    
    # Write to approved log
    echo -e "$LOG_BUFFER" >> "$APPROVE_LOG_FILE"
    exit 0
else
    # Not auto-approved - send notification and let Claude Code decide
    # Build message with actual newlines
    MESSAGE="📋 *Claude Code Activity*

*Tool:* \`$TOOL_NAME\`"
    
    case "$TOOL_NAME" in
        "Task")
            TASK_TITLE=$(echo "$TOOL_INPUT" | jq -r '.title // "Unknown"')
            MESSAGE="$MESSAGE
*Task:* $TASK_TITLE"
            ;;
        "Bash")
            COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // "Unknown"' | head -c 100)
            MESSAGE="$MESSAGE
*Command:* \`$COMMAND\`..."
            ;;
        "Glob")
            PATTERN=$(echo "$TOOL_INPUT" | jq -r '.pattern // "Unknown"')
            MESSAGE="$MESSAGE
*Pattern:* \`$PATTERN\`"
            ;;
        "Grep")
            SEARCH=$(echo "$TOOL_INPUT" | jq -r '.pattern // .search // "Unknown"')
            MESSAGE="$MESSAGE
*Search:* \`$SEARCH\`"
            ;;
        "Read")
            FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.path // .file_path // "Unknown"')
            MESSAGE="$MESSAGE
*File:* \`$FILE_PATH\`"
            ;;
        "Write"|"Edit"|"MultiEdit"|"Update")
            FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.path // .file_path // "Unknown"')
            MESSAGE="$MESSAGE
*File:* \`$FILE_PATH\`"
            ;;
        "WebFetch")
            URL=$(echo "$TOOL_INPUT" | jq -r '.url // "Unknown"')
            MESSAGE="$MESSAGE
*URL:* \`$URL\`"
            ;;
        "WebSearch")
            QUERY=$(echo "$TOOL_INPUT" | jq -r '.query // "Unknown"')
            MESSAGE="$MESSAGE
*Search:* \`$QUERY\`"
            ;;
        *)
            MESSAGE="$MESSAGE
*Details:* $TOOL_NAME operation"
            # Try to extract some info from tool input
            DETAIL=$(echo "$TOOL_INPUT" | jq -r 'to_entries | map("\(.key): \(.value)") | join(", ")' 2>/dev/null | head -c 100)
            if [[ -n "$DETAIL" ]]; then
                MESSAGE="$MESSAGE
*Input:* \`$DETAIL\`..."
            fi
            ;;
    esac
    
    MESSAGE="$MESSAGE

ℹ️ *Status:* Not in auto-approval list. Claude Code will handle this request."
    
    send_telegram "$MESSAGE"
    
    # Log the request
    if [[ "$VERBOSE_LOGGING" != "true" ]]; then
        log_always "❌ BLOCKED: $OPERATION_BRIEF"
    else
        log_always "❌ BLOCKED (sent to Claude Code): $TOOL_NAME"
    fi
    
    # Return undefined decision - let Claude Code's existing permission flow handle it
    # According to docs: "undefined leads to the existing permission flow"
    # We output a JSON object with no "decision" field
    RESPONSE="{\"info\": \"Not in auto-approval list\"}"
    echo "$RESPONSE"
    log_verbose "Response to Claude: $RESPONSE"
    log_verbose "===== END REQUEST ====="
    
    # Write to blocked log
    echo -e "$LOG_BUFFER" >> "$BLOCKED_LOG_FILE"
    exit 0
fi