#!/bin/bash
# approval-notification.sh - Sends notification only when Claude Code needs approval
# Place this in ~/.claude/hooks/approval-notification.sh

# Load configuration from .env file
ENV_FILE="$HOME/.claude/.env"
if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
else
    # Fallback to empty values if .env doesn't exist
    TELEGRAM_BOT_TOKEN=""
    TELEGRAM_CHAT_ID=""
fi

LOG_FILE="$HOME/.claude/logs/approval-notifications.log"

# Create log directory if it doesn't exist
mkdir -p "$HOME/.claude/logs"

# Read input JSON
INPUT=$(cat)

# Extract notification details
MESSAGE=$(echo "$INPUT" | jq -r '.message // empty')
TITLE=$(echo "$INPUT" | jq -r '.title // empty')

# Log the incoming notification
echo "[$(date)] Notification received: Title='$TITLE', Message='$MESSAGE'" >> "$LOG_FILE"

# Check if this is an approval-needed notification
# Look for patterns that indicate Claude is waiting for user action
NEEDS_APPROVAL=false

# Skip the generic "waiting for input" message that appears after task completion
if [[ "$MESSAGE" == "Claude is waiting for your input" ]]; then
    NEEDS_APPROVAL=false
    echo "[$(date)] Skipping generic 'waiting for input' message (post-completion)" >> "$LOG_FILE"
else
    # Common patterns that indicate approval is needed
    if [[ "$MESSAGE" =~ "waiting for" ]] || \
       [[ "$MESSAGE" =~ "needs your" ]] || \
       [[ "$MESSAGE" =~ "requires approval" ]] || \
       [[ "$MESSAGE" =~ "permission" ]] || \
       [[ "$MESSAGE" =~ "confirm" ]] || \
       [[ "$MESSAGE" =~ "approve" ]] || \
       [[ "$MESSAGE" =~ "deny" ]] || \
       [[ "$MESSAGE" =~ "review" ]] || \
       [[ "$MESSAGE" =~ "action required" ]]; then
        NEEDS_APPROVAL=true
    fi
fi

# Skip completion notifications
if [[ "$MESSAGE" =~ "complete" ]] || \
   [[ "$MESSAGE" =~ "finished" ]] || \
   [[ "$MESSAGE" =~ "done" ]] || \
   [[ "$MESSAGE" =~ "success" ]]; then
    NEEDS_APPROVAL=false
    echo "[$(date)] Skipping completion notification" >> "$LOG_FILE"
fi

# Function to send Telegram notification
send_telegram() {
    local message="$1"
    
    # Check if notifications are disabled
    if [[ "${TELEGRAM_NOTIFICATIONS_ENABLED:-true}" == "false" ]]; then
        echo "[$(date)] Telegram notifications disabled by configuration" >> "$LOG_FILE"
        return 1
    fi
    
    # Check if Telegram is configured
    if [[ -z "$TELEGRAM_BOT_TOKEN" ]] || [[ -z "$TELEGRAM_CHAT_ID" ]]; then
        echo "[$(date)] Telegram not configured (missing bot token or chat ID)" >> "$LOG_FILE"
        return 1
    fi
    
    if curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=$message" \
        -d "parse_mode=Markdown" > /dev/null 2>&1; then
        echo "[$(date)] Telegram notification sent successfully" >> "$LOG_FILE"
        return 0
    else
        echo "[$(date)] Failed to send Telegram notification" >> "$LOG_FILE"
        return 1
    fi
}

# Only send notification if approval is needed
if [[ "$NEEDS_APPROVAL" == "true" ]]; then
    # Extract tool name from message if possible
    TOOL_NAME=""
    echo "[$(date)] Extracting tool name from: '$MESSAGE'" >> "$LOG_FILE"
    
    if [[ "$MESSAGE" =~ permission\ to\ use\ ([A-Za-z]+) ]]; then
        TOOL_NAME="${BASH_REMATCH[1]}"
        echo "[$(date)] Tool name extracted: '$TOOL_NAME'" >> "$LOG_FILE"
    elif [[ "$MESSAGE" =~ approve\ ([A-Za-z]+) ]]; then
        TOOL_NAME="${BASH_REMATCH[1]}"
        echo "[$(date)] Tool name extracted: '$TOOL_NAME'" >> "$LOG_FILE"
    elif [[ "$MESSAGE" =~ Tool:\ ([A-Za-z]+) ]]; then
        TOOL_NAME="${BASH_REMATCH[1]}"
        echo "[$(date)] Tool name extracted: '$TOOL_NAME'" >> "$LOG_FILE"
    else
        echo "[$(date)] Could not extract tool name from message" >> "$LOG_FILE"
    fi
    
    # Build notification message
    if [[ -n "$TOOL_NAME" ]]; then
        # Create tool-specific message
        TOOL_DESC=""
        case "$TOOL_NAME" in
            "Write")
                TOOL_DESC="create or overwrite files"
                ;;
            "Edit"|"MultiEdit")
                TOOL_DESC="modify existing files"
                ;;
            "Update")
                TOOL_DESC="update files"
                ;;
            "Bash")
                TOOL_DESC="execute shell commands"
                ;;
            "Read")
                TOOL_DESC="read file contents"
                ;;
            "TodoWrite")
                TOOL_DESC="manage task lists"
                ;;
            "WebFetch")
                TOOL_DESC="fetch web content"
                ;;
            "WebSearch")
                TOOL_DESC="search the web"
                ;;
            *)
                TOOL_DESC="perform an operation"
                ;;
        esac
        
        # Get project directory and name
        PROJECT_DIR=$(pwd)
        PROJECT_NAME=$(basename "$PROJECT_DIR")
        
        TELEGRAM_MESSAGE="⏳ *Claude Code Action Required*
📂 Project: \`$PROJECT_NAME\`

Claude needs approval to use the *${TOOL_NAME}* tool to ${TOOL_DESC}

📍 Please return to Claude Code to review and respond."
    else
        # Fallback to original message if tool name can't be extracted
        # Get project directory and name
        PROJECT_DIR=$(pwd)
        PROJECT_NAME=$(basename "$PROJECT_DIR")
        
        TELEGRAM_MESSAGE="⏳ *Claude Code Action Required*
📂 Project: \`$PROJECT_NAME\`

*Message:* $MESSAGE

📍 Please return to Claude Code to review and respond."
    fi

    # Send the notification
    send_telegram "$TELEGRAM_MESSAGE"
    
    echo "[$(date)] Approval notification sent for: $MESSAGE" >> "$LOG_FILE"
else
    echo "[$(date)] No action required, skipping notification for: $MESSAGE" >> "$LOG_FILE"
fi

# Always exit successfully to not interfere with Claude Code
exit 0