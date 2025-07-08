#!/usr/bin/env npx tsx
// Post-tool-use hook - Logs tool execution results

import { HookLogger } from './lib/logger';
import { PostToolUseInput } from './lib/types';

async function main() {
  const logger = new HookLogger('post-tool-use');
  
  try {
    // Read input from stdin
    const input = await HookLogger.readStdin() as PostToolUseInput;
    
    // Log the input
    logger.log(input);
    
    // Post-tool-use hooks don't need to return anything specific
    // Exit cleanly to continue normal flow
    process.exit(0);
  } catch (error) {
    // Log error but don't interrupt Claude Code
    console.error('Post-tool-use hook error:', error);
    process.exit(0);
  }
}

// Run the hook
main().catch((error) => {
  console.error('Unexpected error:', error);
  process.exit(0); // Always exit cleanly
});