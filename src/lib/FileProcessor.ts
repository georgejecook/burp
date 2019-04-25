import * as Debug from 'debug';

import { BurpConfig } from './BurpConfig';
import FileDescriptor from './FileDescriptor';
import { MacroValue } from './MacroValue';

const os = require('os');

const debug = Debug('FileProcessor');
const NO_FUNCTION = 'NoFunction';

export class FileProcessor {

  public get errors(): string[] {
    return this._errors;
  }

  public get warnings(): string[] {
    return this._warnings;
  }
  constructor(config: BurpConfig) {
    this.functionNameRegex = new RegExp('^\\s*(function|sub)\\s*([0-9a-z_]*)s*\\(', 'i');
    this.functionEndRegex = new RegExp('^\s*(end sub|end function)', 'i');
    this._config = config;
    this._warnings = [];
    this._errors = [];
    this._config.replacements.forEach( (replacement) => {
      replacement._regex = new RegExp(replacement.regex, 'i');
    });
  }
  public rootPath: string;

  private readonly _warnings: string[];
  private readonly _errors: string[];
  private readonly _config: BurpConfig;

  private functionEndRegex: RegExp;
  private functionNameRegex: RegExp;

  public processFile(fileDescriptor: FileDescriptor): boolean {
    let code = fileDescriptor ? fileDescriptor.fileContents : null;
    if (!code || !code.trim()) {
      debug(`no code for current descriptor`);
      this.errors.push('No code for file' + (fileDescriptor ? fileDescriptor.fullPath : `unknown file`));
      return false;
    }
    let name = fileDescriptor.normalizedFileName;
    let filename = fileDescriptor.normalizedFileName;
    let currentLocation = '';
    let lines = code.split(/\r?\n/);
    let filePath = fileDescriptor.fullPath;
    let packagePath = filePath = fileDescriptor.getPackagePath('', this.rootPath);
    let functionName: string = NO_FUNCTION;
    let isInFunction = false;
    let isDirty = false;

    for (let lineNumber = 1; lineNumber <= lines.length; lineNumber++) {
      currentLocation = filePath + ':' + lineNumber.toString();
      let line = lines[lineNumber - 1];
      if (isInFunction) {
        if (this.functionEndRegex.test(line)) {
          isInFunction = false;
          functionName = NO_FUNCTION;
        }
      } else {
        let functionNameMatch = this.getFunctionFromLine(line);
        if (functionNameMatch) {
          isInFunction = true;
          functionName = functionNameMatch;
        }
      }
      //run each of the user's regex's and replace with the replaced text
      this._config.replacements.forEach( (replacement) => {
        if (replacement.replacement === MacroValue.CommentLine) {
          if (line.match(replacement.regex)) {
            line = `'${line}`;
          }
          isDirty = true;
        } else if (line.match(replacement._regex)) {
          let replacementValue = replacement.replacement;
          replacementValue = replacementValue.replace(MacroValue.FileName, filename);
          replacementValue = replacementValue.replace(MacroValue.FullPath, `${packagePath}(${lineNumber.toString()})`);
          replacementValue = replacementValue.replace(MacroValue.FunctionName, functionName);
          replacementValue = replacementValue.replace(MacroValue.LineNumber, lineNumber.toString().trim());
          replacementValue = replacementValue.replace(MacroValue.FullLocation, `${packagePath}(${lineNumber.toString()}).${functionName}`);
          line = line.replace(replacement._regex, replacementValue);
          isDirty = true;
        }
        //DO the regex match here
      });
      lines[lineNumber - 1] = line;
    }
    if (isDirty) {
      fileDescriptor.setFileContents(lines.join(os.EOL));
      fileDescriptor.saveFileContents();
    }
    return true;
  }

  public getFunctionFromLine(line: string): any {
    let matches = line.match(this.functionNameRegex);
    return matches ? matches[2] : null;
  }

}
