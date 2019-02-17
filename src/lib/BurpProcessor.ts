import * as Debug from 'debug';

import * as fs from 'fs-extra';
import * as path from 'path';

import { BurpConfig } from './BurpConfig';
import FileDescriptor from './FileDescriptor';
import { FileProcessor } from './FileProcessor';

const debug = Debug('Burp');
const glob = require('glob-fs')({ gitignore: true });

export default class BurpProcessor {
  constructor(config: BurpConfig) {
    if (!config) {
      throw new Error('config is empty');
    }

    if (!config.sourcePath) {
      throw new Error('sourcePath is empty');
    }
    this._config = config;
    console.log('Starting directory: ' + process.cwd());
    try {
      process.chdir(this._config.sourcePath);
    } catch (err) {
      console.log('Could not change directory to source path: ' + err);
    }
    this._warnings = [];
    this._errors = [];
    this._config.globPattern = this._config.globPattern || '**/*.brs';
    this.processFiles();
  }

  private readonly _config: BurpConfig;
  private readonly _warnings: string[];
  private readonly _errors: string[];

  get errors(): string[] {
    return this._errors;
  }

  get warnings(): string[] {
    return this._warnings;
  }

  public processFiles() {
    debug(`Running burp at path ${this._config.sourcePath} `);
    debug(`processing files at path ${process.cwd()} `);
    let fileProcessor = new FileProcessor(this._config);
    glob.readdirStream(this._config.globPattern)
      .on('data', (file) => {
        const fileDescriptor = new FileDescriptor(file.dirname, file.basename, file.extname.toLowerCase());
        fileProcessor.processFile(fileDescriptor);
      });

    this.errors.concat(this.errors);
    this.warnings.concat(this.warnings);
    this.reportErrors();
    this.reportWarnings();
  }

  public reportErrors() {
    if (this.errors.length > 0) {

      console.log(`
    The following errors occurred during processing:

    ======
    `);
      this.errors.forEach( (errorText) => console.log(`[ERROR] ${errorText}`));
      console.log(`
    ======
    `);
    }
  }

  public reportWarnings() {
    if (this.warnings.length > 0) {

      console.log(`
    The following warnings occurred during processing:

    ======
    `);
      this.warnings.forEach( (errorText) => console.log(`[WARN] ${errorText}`));
      console.log(`
    ======
    `);
    }
  }
}
