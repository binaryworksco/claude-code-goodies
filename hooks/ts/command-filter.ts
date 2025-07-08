#!/usr/bin/env bun
// Command filter: blocks dangerous commands, approves safe ones, falls back to Claude for others

import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';
import { PreToolUseInput, PreToolUseDecision } from './loggers/lib/types';

// Types for our configuration
interface Rule {
  pattern: string;
  reason: string;
}

interface CommandsConfig {
  commands: Rule[];
  files: {
    read: Rule[];
    write: Rule[];
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

// Helper to load blocked commands configuration
function loadBlockedCommands(): CommandsConfig | null {
  const configPath = path.join(os.homedir(), '.claude', 'hooks', 'ts', 'config', 'blocked-commands.json');
  
  try {
    if (fs.existsSync(configPath)) {
      const content = fs.readFileSync(configPath, 'utf-8');
      return JSON.parse(content);
    }
  } catch (error) {
    console.error(`[CommandFilter] Error loading blocked commands: ${error}`);
    // Log config errors
    try {
      const logger = new Logger();
      logger.logConfigError(`Error loading blocked commands: ${error}`);
    } catch {
      // Ignore logging errors
    }
  }
  
  return null;
}

// Helper to load allowed commands configuration
function loadAllowedCommands(): CommandsConfig | null {
  const configPath = path.join(os.homedir(), '.claude', 'hooks', 'ts', 'config', 'allowed-commands.json');
  
  try {
    if (fs.existsSync(configPath)) {
      const content = fs.readFileSync(configPath, 'utf-8');
      return JSON.parse(content);
    }
  } catch (error) {
    console.error(`[CommandFilter] Error loading allowed commands: ${error}`);
    // Log config errors
    try {
      const logger = new Logger();
      logger.logConfigError(`Error loading allowed commands: ${error}`);
    } catch {
      // Ignore logging errors
    }
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

// Environment configuration interface
interface EnvConfig {
  COMMAND_FILTER_LOG_ENABLED?: string;
  [key: string]: string | undefined;
}

// Load environment configuration
function loadEnvConfig(): EnvConfig {
  const envPath = path.join(os.homedir(), '.claude', '.env');
  const config: EnvConfig = {};
  
  try {
    if (fs.existsSync(envPath)) {
      const content = fs.readFileSync(envPath, 'utf-8');
      content.split('\n').forEach(line => {
        const trimmed = line.trim();
        if (trimmed && !trimmed.startsWith('#')) {
          const equalIndex = trimmed.indexOf('=');
          if (equalIndex > 0) {
            const key = trimmed.substring(0, equalIndex).trim();
            let value = trimmed.substring(equalIndex + 1).trim();
            
            // Remove quotes from value if present
            value = value.replace(/^["']|["']$/g, '');
            
            // Remove inline comments
            const commentIndex = value.indexOf('#');
            if (commentIndex > 0) {
              value = value.substring(0, commentIndex).trim();
            }
            
            config[key] = value;
          }
        }
      });
    }
  } catch (error) {
    // Silently ignore env loading errors
  }
  
  return config;
}

// Enhanced logging system
interface LogEntry {
  timestamp: string;
  event: string;
  tool?: string;
  input?: any;
  configLoaded?: boolean;
  matchedPattern?: {
    pattern: string;
    list: 'blocked' | 'allowed';
    reason: string;
  };
  noMatch?: boolean;
  decision?: string;
  response?: string;
  error?: string;
}

class Logger {
  private logDir: string;
  private logFile: string;
  private matchedPattern: LogEntry['matchedPattern'] | null = null;
  private loggingEnabled: boolean;
  
  constructor() {
    // Load env config to check if logging is enabled
    const envConfig = loadEnvConfig();
    this.loggingEnabled = envConfig.COMMAND_FILTER_LOG_ENABLED !== 'false';
    
    // Use user directory for persistent logs
    this.logDir = path.join(os.homedir(), '.claude', 'logs', 'hooks');
    this.logFile = path.join(this.logDir, 'command-filter.log');
    
    if (this.loggingEnabled) {
      this.ensureLogDirectory();
    }
  }
  
  private ensureLogDirectory(): void {
    try {
      fs.mkdirSync(this.logDir, { recursive: true });
    } catch (error) {
      console.error(`[CommandFilter] Failed to create log directory: ${error}`);
    }
  }
  
  private writeLog(entry: LogEntry): void {
    if (!this.loggingEnabled) return;
    
    try {
      fs.appendFileSync(this.logFile, JSON.stringify(entry) + '\n', 'utf-8');
    } catch (error) {
      console.error(`[CommandFilter] Failed to write log: ${error}`);
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
  
  logConfigError(error: string): void {
    this.writeLog({
      timestamp: new Date().toISOString(),
      event: 'config_error',
      error
    });
  }
  
  setMatchedPattern(pattern: string, list: 'blocked' | 'allowed', reason: string): void {
    this.matchedPattern = { pattern, list, reason };
  }
  
  logDecision(tool: string, input: any, decision: string, response: string): void {
    const entry: LogEntry = {
      timestamp: new Date().toISOString(),
      event: 'decision_made',
      tool,
      input,
      decision,
      response
    };
    
    if (this.matchedPattern) {
      entry.matchedPattern = this.matchedPattern;
    } else {
      entry.noMatch = true;
    }
    
    this.writeLog(entry);
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
    
    // Load configurations
    const blockedConfig = loadBlockedCommands();
    const allowedConfig = loadAllowedCommands();
    
    // Helper function to check command patterns
    function checkCommandPatterns(command: string, rules: Rule[], phase: 'blocked' | 'allowed'): Rule | null {
      for (const rule of rules) {
        try {
          const regex = new RegExp(rule.pattern);
          const matched = regex.test(command);
          
          if (matched) {
            logger.setMatchedPattern(rule.pattern, phase, rule.reason);
            return rule;
          }
        } catch (error) {
          console.error(`[CommandFilter] Invalid regex pattern: ${rule.pattern}`);
        }
      }
      return null;
    }
    
    // Helper function to check file patterns
    function checkFilePatterns(filePath: string, rules: Rule[], phase: 'blocked' | 'allowed'): Rule | null {
      for (const rule of rules) {
        const matched = matchesGlob(filePath, rule.pattern);
        
        if (matched) {
          logger.setMatchedPattern(rule.pattern, phase, rule.reason);
          return rule;
        }
      }
      return null;
    }
    
    // Check Bash commands
    if (toolName === 'Bash' && toolInput.command) {
      const command = toolInput.command.trim();
      
      // Phase 1: Check blocked commands
      if (blockedConfig) {
        const blockedRule = checkCommandPatterns(command, blockedConfig.commands, 'blocked');
        if (blockedRule) {
          const response: PreToolUseDecision = {
            decision: 'block',
            reason: blockedRule.reason
          };
          const responseStr = JSON.stringify(response);
          logger.logDecision(toolName, toolInput, 'block', responseStr);
          process.stdout.write(responseStr);
          return;
        }
      }
      
      // Phase 2: Check allowed commands
      if (allowedConfig) {
        const allowedRule = checkCommandPatterns(command, allowedConfig.commands, 'allowed');
        if (allowedRule) {
          const response: PreToolUseDecision = {
            decision: 'approve',
            reason: allowedRule.reason
          };
          const responseStr = JSON.stringify(response);
          logger.logDecision(toolName, toolInput, 'approve', responseStr);
          process.stdout.write(responseStr);
          return;
        }
      }
    }
    
    // Check file operations
    if ((toolName === 'Read' || toolName === 'Write' || toolName === 'Edit' || toolName === 'MultiEdit') && 
        (toolInput.file_path || toolInput.path)) {
      const filePath = toolInput.file_path || toolInput.path;
      const isReadOperation = toolName === 'Read';
      
      // Only check blocked files - if not blocked, it's allowed by default
      if (blockedConfig) {
        const blockedRules = isReadOperation ? blockedConfig.files.read : blockedConfig.files.write;
        const blockedRule = checkFilePatterns(filePath, blockedRules, 'blocked');
        if (blockedRule) {
          const response: PreToolUseDecision = {
            decision: 'block',
            reason: blockedRule.reason
          };
          const responseStr = JSON.stringify(response);
          logger.logDecision(toolName, toolInput, 'block', responseStr);
          process.stdout.write(responseStr);
          return;
        }
      }
      
      // File operations not in blocked list are automatically approved
      const response: PreToolUseDecision = {
        decision: 'approve',
        reason: 'File operation is not blocked'
      };
      const responseStr = JSON.stringify(response);
      logger.logDecision(toolName, toolInput, 'approve', responseStr);
      process.stdout.write(responseStr);
      return;
    }
    
    // Phase 3: Default - fall back to Claude's standard process
    logger.logDecision(toolName, toolInput, 'default', '{}');
    process.stdout.write('{}');
    
  } catch (error) {
    // On error, fall back to default to not break Claude Code
    const errorMsg = `Hook error: ${error}`;
    console.error(`[CommandFilter] ${errorMsg}`);
    logger.logError(errorMsg);
    process.stdout.write('{}');
  }
}

// Run the hook
main().catch((error) => {
  console.error('[CommandFilter] Unexpected error:', error);
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