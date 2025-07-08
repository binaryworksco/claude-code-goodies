#!/usr/bin/env npx tsx
// Notification hook - Logs all notifications from Claude Code

import { HookLogger } from './lib/logger';
import { NotificationInput } from './lib/types';

async function main() {
  const logger = new HookLogger('notification');
  
  try {
    // Read input from stdin
    const input = await HookLogger.readStdin() as NotificationInput;
    
    // Log the input
    logger.log(input);
    
    // Notification hooks don't need to return anything
    // Exit cleanly to continue normal flow
    process.exit(0);
  } catch (error) {
    // Log error but don't interrupt Claude Code
    console.error('Notification hook error:', error);
    process.exit(0);
  }
}

// Run the hook
main().catch((error) => {
  console.error('Unexpected error:', error);
  process.exit(0); // Always exit cleanly
});