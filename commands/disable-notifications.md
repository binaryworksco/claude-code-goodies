# /disable-notifications - Disable Telegram Notifications

<command_overview>
Quickly disable Telegram notifications by setting TELEGRAM_NOTIFICATIONS_ENABLED="false" in your ~/.claude/.env file.
</command_overview>

!grep -q "TELEGRAM_NOTIFICATIONS_ENABLED" ~/.claude/.env 2>/dev/null && echo "TELEGRAM_NOTIFICATIONS_ENABLED setting found in .env" || echo "TELEGRAM_NOTIFICATIONS_ENABLED not found in .env"

Please disable Telegram notifications by:

1. If TELEGRAM_NOTIFICATIONS_ENABLED exists in the .env file, update it to "false"
2. If it doesn't exist, append it to the .env file
3. Confirm the change was made successfully

Use sed to update if it exists, or echo to append if it doesn't.

$ARGUMENTS