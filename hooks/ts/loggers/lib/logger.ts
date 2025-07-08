// Logger utility for Claude Code hooks
import * as fs from 'fs';
import * as path from 'path';

export class HookLogger {
  private logDir: string;
  private hookType: string;

  constructor(hookType: string) {
    this.hookType = hookType;
    // Use .claude directory in current working directory
    this.logDir = path.join(process.cwd(), '.claude', 'logs', 'hooks');
    this.ensureLogDirectory();
  }

  private ensureLogDirectory(): void {
    try {
      fs.mkdirSync(this.logDir, { recursive: true });
    } catch (error) {
      // Directory might already exist, that's fine
    }
  }

  private getLogFilePath(): string {
    return path.join(this.logDir, `${this.hookType}.json`);
  }

  private readExistingLogs(): any[] {
    const logPath = this.getLogFilePath();
    try {
      if (fs.existsSync(logPath)) {
        const content = fs.readFileSync(logPath, 'utf-8');
        return JSON.parse(content);
      }
    } catch (error) {
      // If file is corrupted or empty, start fresh
      console.error(`Error reading existing logs: ${error}`);
    }
    return [];
  }

  public log(input: any): void {
    try {
      const existingLogs = this.readExistingLogs();
      existingLogs.push(input);
      
      // Write as pretty-printed JSON for readability
      fs.writeFileSync(
        this.getLogFilePath(),
        JSON.stringify(existingLogs, null, 2),
        'utf-8'
      );
    } catch (error) {
      console.error(`Failed to write log: ${error}`);
    }
  }

  public static async readStdin(): Promise<any> {
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

  public static writeResponse(response: any): void {
    process.stdout.write(JSON.stringify(response));
  }
}