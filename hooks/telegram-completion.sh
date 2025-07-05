#!/bin/bash
# telegram-completion.sh - Sends notification when Claude Code completes
# Place this in ~/.claude/hooks/telegram-completion.sh

# Load configuration from .env file
ENV_FILE="$HOME/.claude/.env"
if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
else
    # Fallback to empty values if .env doesn't exist
    TELEGRAM_BOT_TOKEN=""
    TELEGRAM_CHAT_ID=""
fi

LOG_FILE="$HOME/.claude/logs/completion.log"

# Create log directory if it doesn't exist
mkdir -p "$HOME/.claude/logs"

# Read input JSON
INPUT=$(cat)
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active')

# Don't run if already in a stop hook loop
if [[ "$STOP_HOOK_ACTIVE" == "true" ]]; then
    exit 0
fi

# Function to send Telegram notification with proper formatting
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
    
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=$message" \
        -d "parse_mode=Markdown" > /dev/null 2>&1
}

# Try to get the transcript file path
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')
USER_COMMAND=""

# If we have a transcript file, read it directly
if [[ -n "$TRANSCRIPT_PATH" && -f "$TRANSCRIPT_PATH" ]]; then
    # Read JSONL file and find first user message
    # Each line in JSONL is a separate JSON object
    while IFS= read -r line; do
        ROLE=$(echo "$line" | jq -r '.role // empty' 2>/dev/null)
        if [[ "$ROLE" == "user" ]]; then
            USER_COMMAND=$(echo "$line" | jq -r '.content // empty' 2>/dev/null | head -c 150)
            break
        fi
    done < "$TRANSCRIPT_PATH"
fi

# If no command found, try parsing the transcript field
if [[ -z "$USER_COMMAND" ]]; then
    TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript // empty')
    if [[ -n "$TRANSCRIPT" ]]; then
        USER_COMMAND=$(echo "$TRANSCRIPT" | jq -r '.messages[]? | select(.role == "user") | .content' 2>/dev/null | head -1 | head -c 150)
    fi
fi

# If still nothing, use a more descriptive default
if [[ -z "$USER_COMMAND" ]]; then
    USER_COMMAND="Claude Code session"
fi

# Get project directory
PROJECT_DIR=$(pwd)
PROJECT_NAME=$(basename "$PROJECT_DIR")

# Build notification message with the command
MESSAGE="🚀 *Claude Code session complete* for project: \`$PROJECT_NAME\`"

# Add ellipsis if command was truncated
if [[ ${#USER_COMMAND} -eq 150 ]]; then
    MESSAGE="$MESSAGE..."
fi

# Send the notification
if send_telegram "$MESSAGE"; then
    echo "[$(date)] Sent completion notification for $PROJECT_DIR" >> "$LOG_FILE"
    echo "[$(date)] Command shown: $USER_COMMAND" >> "$LOG_FILE"
else
    echo "[$(date)] Failed to send completion notification for $PROJECT_DIR" >> "$LOG_FILE"
fi

# Allow Claude to stop normally
exit 0