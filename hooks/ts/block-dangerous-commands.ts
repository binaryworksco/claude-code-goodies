#!/usr/bin/env npx tsx
// Block dangerous commands based on configurable rules

import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';
import { PreToolUseInput, PreToolUseDecision } from './loggers/lib/types';

// Types for our configuration
interface CommandRule {
  pattern: string;
  action: 'deny' | 'prompt';
  reason: string;
}

interface FileRule {
  pattern: string;
  action: 'deny' | 'prompt';
  reason: string;
}

interface DangerousCommandsConfig {
  commands: CommandRule[];
  files: {
    read: FileRule[];
    write: FileRule[];
  };
}

// Helper to read JSON from stdin
async function readStdin(): Promise<any> {
  return new Promise((resolve, reject) => {
    let data = '';
    
    process.stdin.setEncoding('utf8');
    
    process.stdin.on('data', (chunk) => {
      data += chunk;
    });
    
    process.stdin.on('end', () => {
      try {
        const parsed = JSON.parse(data);
        resolve(parsed);
      } catch (error) {
        reject(new Error(`Failed to parse JSON input: ${error}`));
      }
    });
    
    process.stdin.on('error', reject);
  });
}

// Helper to load the dangerous commands configuration
function loadDangerousCommands(): DangerousCommandsConfig | null {
  const configPath = path.join(os.homedir(), '.claude', 'hooks', 'ts', 'config', 'dangerous-commands.json');
  
  try {
    if (fs.existsSync(configPath)) {
      const content = fs.readFileSync(configPath, 'utf-8');
      return JSON.parse(content);
    }
  } catch (error) {
    console.error(`[DangerousCommands] Error loading config: ${error}`);
  }
  
  return null;
}

// Helper to check if a string matches a glob pattern
function matchesGlob(str: string, pattern: string): boolean {
  // Convert glob to regex
  let regex = pattern
    .replace(/\./g, '\\.')
    .replace(/\*\*/g, '___DOUBLE_STAR___')
    .replace(/\*/g, '[^/]*')
    .replace(/___DOUBLE_STAR___/g, '.*')
    .replace(/\?/g, '.');
  
  // Add anchors if not present
  if (!regex.startsWith('^')) regex = '^' + regex;
  if (!regex.endsWith('$')) regex = regex + '$';
  
  try {
    return new RegExp(regex).test(str);
  } catch {
    return false;
  }
}

// Enhanced logging system
interface LogEntry {
  timestamp: string;
  event: string;
  tool?: string;
  input?: any;
  configLoaded?: boolean;
  checks?: Array<{
    pattern: string;
    matched: boolean;
    action?: string;
    reason?: string;
  }>;
  decision?: string;
  response?: string;
  error?: string;
}

class Logger {
  private logDir: string;
  private logFile: string;
  private checks: LogEntry['checks'] = [];
  
  constructor() {
    // Use project-local directory
    this.logDir = path.join(process.cwd(), '.claude', 'logs', 'hooks');
    this.logFile = path.join(this.logDir, 'block-dangerous-commands.log');
    this.ensureLogDirectory();
  }
  
  private ensureLogDirectory(): void {
    try {
      fs.mkdirSync(this.logDir, { recursive: true });
    } catch (error) {
      console.error(`[DangerousCommands] Failed to create log directory: ${error}`);
    }
  }
  
  private writeLog(entry: LogEntry): void {
    try {
      fs.appendFileSync(this.logFile, JSON.stringify(entry) + '\n', 'utf-8');
    } catch (error) {
      console.error(`[DangerousCommands] Failed to write log: ${error}`);
    }
  }
  
  logRequest(tool: string, input: any): void {
    this.writeLog({
      timestamp: new Date().toISOString(),
      event: 'request_received',
      tool,
      input
    });
  }
  
  logConfigStatus(loaded: boolean, error?: string): void {
    this.writeLog({
      timestamp: new Date().toISOString(),
      event: 'config_load',
      configLoaded: loaded,
      error
    });
  }
  
  addCheck(pattern: string, matched: boolean, action?: string, reason?: string): void {
    this.checks.push({ pattern, matched, action, reason });
  }
  
  logDecision(tool: string, input: any, decision: string, response: string): void {
    this.writeLog({
      timestamp: new Date().toISOString(),
      event: 'decision_made',
      tool,
      input,
      checks: this.checks,
      decision,
      response
    });
  }
  
  logError(error: string): void {
    this.writeLog({
      timestamp: new Date().toISOString(),
      event: 'error',
      error
    });
  }
}

async function main() {
  const logger = new Logger();
  
  try {
    // Read input from stdin
    const input = await readStdin() as PreToolUseInput;
    
    const toolName = input.tool_name;
    const toolInput = input.tool_input;
    
    // Log incoming request
    logger.logRequest(toolName, toolInput);
    
    // Load dangerous commands configuration
    const config = loadDangerousCommands();
    if (!config) {
      // No config, allow all
      logger.logConfigStatus(false, 'Configuration file not found');
      logger.logDecision(toolName, toolInput, 'allow', '{}');
      process.stdout.write('{}');
      return;
    }
    
    logger.logConfigStatus(true);
    
    // Check Bash commands
    if (toolName === 'Bash' && toolInput.command) {
      const command = toolInput.command.trim();
      
      for (const rule of config.commands) {
        try {
          const regex = new RegExp(rule.pattern);
          const matched = regex.test(command);
          
          logger.addCheck(rule.pattern, matched, matched ? rule.action : undefined, matched ? rule.reason : undefined);
          
          if (matched) {
            if (rule.action === 'deny') {
              const response: PreToolUseDecision = {
                decision: 'deny',
                reason: rule.reason
              };
              const responseStr = JSON.stringify(response);
              logger.logDecision(toolName, toolInput, 'deny', responseStr);
              process.stdout.write(responseStr);
              return;
            } else if (rule.action === 'prompt') {
              // Return empty to trigger Claude's prompt
              console.error(`[DangerousCommands] Prompting for: ${command} (${rule.reason})`);
              logger.logDecision(toolName, toolInput, 'prompt', '{}');
              process.stdout.write('{}');
              return;
            }
          }
        } catch (error) {
          console.error(`[DangerousCommands] Invalid regex pattern: ${rule.pattern}`);
          logger.addCheck(rule.pattern, false, undefined, `Invalid regex: ${error}`);
        }
      }
    }
    
    // Check file operations
    if ((toolName === 'Read' || toolName === 'Write' || toolName === 'Edit' || toolName === 'MultiEdit') && 
        (toolInput.file_path || toolInput.path)) {
      const filePath = toolInput.file_path || toolInput.path;
      const rules = toolName === 'Read' ? config.files.read : config.files.write;
      
      for (const rule of rules) {
        const matched = matchesGlob(filePath, rule.pattern);
        
        logger.addCheck(rule.pattern, matched, matched ? rule.action : undefined, matched ? rule.reason : undefined);
        
        if (matched) {
          if (rule.action === 'deny') {
            const response: PreToolUseDecision = {
              decision: 'deny',
              reason: rule.reason
            };
            const responseStr = JSON.stringify(response);
            logger.logDecision(toolName, toolInput, 'deny', responseStr);
            process.stdout.write(responseStr);
            return;
          } else if (rule.action === 'prompt') {
            // Return empty to trigger Claude's prompt
            console.error(`[DangerousCommands] Prompting for file: ${filePath} (${rule.reason})`);
            logger.logDecision(toolName, toolInput, 'prompt', '{}');
            process.stdout.write('{}');
            return;
          }
        }
      }
    }
    
    // No dangerous patterns matched, allow
    logger.logDecision(toolName, toolInput, 'allow', '{}');
    process.stdout.write('{}');
    
  } catch (error) {
    // On error, allow to not break Claude Code
    const errorMsg = `Hook error: ${error}`;
    console.error(`[DangerousCommands] ${errorMsg}`);
    logger.logError(errorMsg);
    process.stdout.write('{}');
  }
}

// Run the hook
main().catch((error) => {
  console.error('[DangerousCommands] Unexpected error:', error);
  // Try to log the error if possible
  try {
    const logger = new Logger();
    logger.logError(`Unexpected error: ${error}`);
  } catch {
    // Ignore logging errors
  }
  process.stdout.write('{}');
  process.exit(0);
});