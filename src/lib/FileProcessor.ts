import * as Debug from 'debug';
import * as path from 'path';

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
  }
  public rootPath: string;

  private readonly _warnings: string[];
  private readonly _errors: string[];
  private readonly _config: BurpConfig;

  private functionEndRegex: RegExp;
  private functionNameRegex: RegExp;

  public processFileWithPath(absolutePath: string, isUsingGlobalReplace = false): string | undefined {
    try {
      let fd = new FileDescriptor(path.dirname(path.resolve(absolutePath)), path.basename(absolutePath), path.extname
        (absolutePath).toLowerCase());
      let success = this.processFile(fd, isUsingGlobalReplace, false);
      return success ? fd.fileContents : undefined;
    } catch (e) {
      console.error(e);
    }

    return undefined;
  }

  public processFile(fileDescriptor: FileDescriptor, isUsingGlobalReplace = false, isSaving = true): boolean {
    let code = fileDescriptor ? fileDescriptor.fileContents : null;
    if (!code || !code.trim()) {
      debug(`no code for current descriptor`);
      this.errors.push('No code for file' + (fileDescriptor ? fileDescriptor.fullPath : `unknown file`));
      return false;
    }

    if (isUsingGlobalReplace) {

      let filename = fileDescriptor.normalizedFileName;
      let currentLocation = '';
      let filePath = fileDescriptor.fullPath;
      let packagePath = filePath = fileDescriptor.getPackagePath('', this.rootPath);
      let functionName: string = NO_FUNCTION;
      let isInFunction = false;
      let isDirty = false;
      let isBrs = fileDescriptor.extension.toLowerCase() === '.brs';
      let lines = code.split(/\r?\n/);
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
        for (let replacement of this._config.replacements) {
          if (replacement.replacement === MacroValue.CommentLine) {
            if (line.match(replacement.regex)) {
              line = `'${line}`;
            }
            isDirty = true;
          } else if (line.match(new RegExp(replacement.regex, 'ig'))) {
            let replacementValue = replacement.replacement;
            replacementValue = replacementValue.replace(MacroValue.FileName, filename);
            replacementValue = replacementValue.replace(MacroValue.FullPath, `${packagePath}(${lineNumber.toString()})`);
            replacementValue = replacementValue.replace(MacroValue.FunctionName, functionName);
            replacementValue = replacementValue.replace(MacroValue.LineNumber, lineNumber.toString().trim());
            if (isBrs) {
              replacementValue = replacementValue.replace(MacroValue.SourceLocation, `"${packagePath}(${lineNumber.toString()})"`);
            }

            line = line.replace(new RegExp(replacement.regex, 'ig'), replacementValue);
            console.log(line);
            isDirty = true;
          }
        }
        lines[lineNumber - 1] = line;

        if (isDirty) {
          fileDescriptor.setFileContents(lines.join(os.EOL));
          if (isSaving) {
            fileDescriptor.saveFileContents();
          }
        }
      }
    } else {
      let oldCode = code;
      for (let replacement of this._config.replacements) {
        code = code.replace(new RegExp(replacement.regex, 'gim'), replacement.replacement);
      }
      if (oldCode.length !== code.length) { //crude; but efficient for our purposes
        fileDescriptor.setFileContents(code);
        if (isSaving) {
          fileDescriptor.saveFileContents();
        }
      }

    }
    return true;
  }

  public getFunctionFromLine(line: string): any {
    let matches = line.match(this.functionNameRegex);
    return matches ? matches[2] : null;
  }

}
