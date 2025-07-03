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

# Create directories if they don't exist
mkdir -p "$HOME/.claude/hooks" "$HOME/.claude/logs"

# Initialize log buffer
LOG_BUFFER=""

# Function to add to log buffer
log_buffer() {
    LOG_BUFFER="${LOG_BUFFER}[$(date)] $1\n"
}

# Start logging
log_buffer "========================================"
log_buffer "===== NEW HOOK EXECUTION STARTED ====="
log_buffer "========================================"

# Read input JSON
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input')

# Log the incoming request
log_buffer "===== INCOMING REQUEST ====="
log_buffer "Tool: $TOOL_NAME"
log_buffer "Full Input: $INPUT"
log_buffer "Tool Input: $TOOL_INPUT"

# Function to send Telegram notification with proper formatting
send_telegram() {
    local message="$1"
    
    log_buffer "Sending Telegram notification..."
    
    if curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=$message" \
        -d "parse_mode=Markdown" > /dev/null 2>&1; then
        log_buffer "Telegram notification sent successfully"
    else
        log_buffer "Failed to send Telegram notification"
    fi
}

# Function to check if command is dangerous
is_dangerous_command() {
    local tool="$1"
    local input="$2"
    
    log_buffer "Checking for dangerous patterns for tool: $tool"
    
    # Check if dangerous list file exists
    if [[ ! -f "$DANGEROUS_LIST_FILE" ]]; then
        log_buffer "Dangerous list file not found: $DANGEROUS_LIST_FILE"
        return 1
    fi
    
    # Extract relevant information based on tool type
    local check_value=""
    case "$tool" in
        "Bash")
            check_value=$(echo "$input" | jq -r '.command // empty')
            log_buffer "Checking Bash command for dangerous patterns: $check_value"
            ;;
        "Write"|"Edit"|"MultiEdit")
            # Check file paths for dangerous overwrites
            check_value=$(echo "$input" | jq -r '.path // .file_path // empty')
            log_buffer "Checking file path for dangerous patterns: $check_value"
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
                log_buffer "⚠️ DANGEROUS PATTERN DETECTED: $check_value (matched: $pattern)"
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
    
    log_buffer "Checking auto-approval for tool: $tool"
    
    # Check if allowed list file exists
    if [[ ! -f "$ALLOWED_LIST_FILE" ]]; then
        log_buffer "Allowed list file not found: $ALLOWED_LIST_FILE"
        return 1
    fi
    
    # Extract relevant information based on tool type
    case "$tool" in
        "Task")
            TASK_TITLE=$(echo "$input" | jq -r '.title // empty')
            log_buffer "Checking Task: $TASK_TITLE"
            # Check if task title matches any pattern in allowed list
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                if [[ "$TASK_TITLE" =~ $pattern ]]; then
                    log_buffer "Auto-approved Task: $TASK_TITLE (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            ;;
        "Bash")
            COMMAND=$(echo "$input" | jq -r '.command // empty')
            log_buffer "Checking Bash command: $COMMAND"
            # Check for safe commands
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                log_buffer "Testing pattern: $pattern"
                if [[ "$COMMAND" =~ $pattern ]]; then
                    log_buffer "Auto-approved Bash: $COMMAND (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            log_buffer "No matching pattern found for: $COMMAND"
            ;;
        "Glob")
            PATTERN=$(echo "$input" | jq -r '.pattern // empty')
            log_buffer "Checking Glob pattern: $PATTERN"
            # Check for allowed glob patterns
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                # Allow all Glob operations if pattern is ^Glob$
                if [[ "$pattern" == "^Glob$" ]]; then
                    log_buffer "Auto-approved Glob: all patterns allowed"
                    return 0
                fi
                if [[ "$PATTERN" =~ $pattern ]]; then
                    log_buffer "Auto-approved Glob: $PATTERN (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            ;;
        "Grep")
            SEARCH=$(echo "$input" | jq -r '.pattern // .search // empty')
            log_buffer "Checking Grep search: $SEARCH"
            # Check for allowed grep operations
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                # Allow all Grep operations if pattern is ^Grep$
                if [[ "$pattern" == "^Grep$" ]]; then
                    log_buffer "Auto-approved Grep: all searches allowed"
                    return 0
                fi
                if [[ "$SEARCH" =~ $pattern ]]; then
                    log_buffer "Auto-approved Grep: $SEARCH (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            ;;
        "Read")
            FILE_PATH=$(echo "$input" | jq -r '.path // .file_path // empty')
            log_buffer "Checking Read file: $FILE_PATH"
            # Check if file path is in allowed directories for reading
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                # Skip exclusion patterns
                [[ "$pattern" =~ ^! ]] && continue
                # Allow all Read operations if pattern is ^Read$
                if [[ "$pattern" == "^Read$" ]]; then
                    log_buffer "Auto-approved Read: all files allowed"
                    return 0
                fi
                if [[ "$FILE_PATH" =~ $pattern ]]; then
                    # Check exclusions
                    while IFS= read -r exclude; do
                        [[ "$exclude" =~ ^! ]] || continue
                        exclude_pattern="${exclude#!}"
                        if [[ "$FILE_PATH" =~ $exclude_pattern ]]; then
                            log_buffer "Blocked by exclusion: $FILE_PATH (matched: $exclude)"
                            return 1
                        fi
                    done < "$ALLOWED_LIST_FILE"
                    log_buffer "Auto-approved Read: $FILE_PATH (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            ;;
        "Write"|"Edit"|"MultiEdit")
            FILE_PATH=$(echo "$input" | jq -r '.path // .file_path // empty')
            log_buffer "Checking file path: $FILE_PATH"
            # Check if file path is in allowed directories
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                # Skip exclusion patterns
                [[ "$pattern" =~ ^! ]] && continue
                if [[ "$FILE_PATH" =~ $pattern ]]; then
                    # Check exclusions
                    while IFS= read -r exclude; do
                        [[ "$exclude" =~ ^! ]] || continue
                        exclude_pattern="${exclude#!}"
                        if [[ "$FILE_PATH" =~ $exclude_pattern ]]; then
                            log_buffer "Blocked by exclusion: $FILE_PATH (matched: $exclude)"
                            return 1
                        fi
                    done < "$ALLOWED_LIST_FILE"
                    log_buffer "Auto-approved File: $FILE_PATH (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            ;;
        "WebFetch"|"WebSearch")
            URL=$(echo "$input" | jq -r '.url // .query // empty')
            log_buffer "Checking Web operation: $URL"
            # Check for allowed web operations
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                # Special handling for web tools - if pattern is just the tool name, allow all
                if [[ "$pattern" == "^WebFetch$" ]] && [[ "$tool" == "WebFetch" ]]; then
                    log_buffer "Auto-approved WebFetch: all URLs allowed"
                    return 0
                fi
                if [[ "$pattern" == "^WebSearch$" ]] && [[ "$tool" == "WebSearch" ]]; then
                    log_buffer "Auto-approved WebSearch: all queries allowed"
                    return 0
                fi
                # Otherwise check URL/query patterns
                if [[ "$URL" =~ $pattern ]]; then
                    log_buffer "Auto-approved $tool: $URL (matched: $pattern)"
                    return 0
                fi
            done < "$ALLOWED_LIST_FILE"
            ;;
        *)
            # For any other tool type, check if the tool name itself is allowed
            log_buffer "Checking unknown tool type: $tool"
            while IFS= read -r pattern; do
                [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
                if [[ "$tool" =~ $pattern ]]; then
                    log_buffer "Auto-approved $tool: tool name matched pattern $pattern"
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
        "Write"|"Edit"|"MultiEdit")
            FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.path // .file_path // "Unknown"')
            MESSAGE="$MESSAGE
*File:* \`$FILE_PATH\`"
            ;;
    esac
    
    MESSAGE="$MESSAGE

⚠️ *Status:* This command matches a dangerous pattern and requires manual approval."
    
    send_telegram "$MESSAGE"
    
    # Log the dangerous command
    log_buffer "🚨 DANGEROUS COMMAND DETECTED: $TOOL_NAME"
    
    # Return undefined decision - let Claude Code's existing permission flow handle it
    RESPONSE="{\"info\": \"Dangerous command pattern detected\"}"
    echo "$RESPONSE"
    log_buffer "Response to Claude: $RESPONSE"
    log_buffer "===== END REQUEST ====="
    
    # Write to dangerous commands log
    echo -e "$LOG_BUFFER" >> "$DANGEROUS_LOG_FILE"
    exit 0
fi

# Check if the request should be auto-approved
if should_auto_approve "$TOOL_NAME" "$TOOL_INPUT"; then
    # Auto-approve the request - bypass permission system
    RESPONSE="{\"decision\": \"approve\", \"reason\": \"Auto-approved by hook\"}"
    echo "$RESPONSE"
    log_buffer "✅ AUTO-APPROVED: $TOOL_NAME"
    log_buffer "Response to Claude: $RESPONSE"
    log_buffer "===== END REQUEST ====="
    
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
        "Write"|"Edit"|"MultiEdit")
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
    log_buffer "❌ BLOCKED (sent to Claude Code): $TOOL_NAME"
    
    # Return undefined decision - let Claude Code's existing permission flow handle it
    # According to docs: "undefined leads to the existing permission flow"
    # We output a JSON object with no "decision" field
    RESPONSE="{\"info\": \"Not in auto-approval list\"}"
    echo "$RESPONSE"
    log_buffer "Response to Claude: $RESPONSE"
    log_buffer "===== END REQUEST ====="
    
    # Write to blocked log
    echo -e "$LOG_BUFFER" >> "$BLOCKED_LOG_FILE"
    exit 0
fi