#!/bin/bash
# approval-notification.sh - Sends notification only when Claude Code needs approval
# Place this in ~/.claude/hooks/approval-notification.sh

# Configuration
TELEGRAM_BOT_TOKEN="ENTER-TELEGRAM-BOT-ID-HERE"
TELEGRAM_CHAT_ID="ENTER-TELEGRAM-CHAT-ID-HERE"
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
    # Build notification message
    TELEGRAM_MESSAGE="⏳ *Claude Code Action Required*

*Message:* $MESSAGE

📍 Please return to Claude Code to review and respond."

    # Send the notification
    send_telegram "$TELEGRAM_MESSAGE"
    
    echo "[$(date)] Approval notification sent for: $MESSAGE" >> "$LOG_FILE"
else
    echo "[$(date)] No action required, skipping notification for: $MESSAGE" >> "$LOG_FILE"
fi

# Always exit successfully to not interfere with Claude Code
exit 0