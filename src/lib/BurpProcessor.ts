import * as Debug from 'debug';

import * as fs from 'fs-extra';
import * as path from 'path';

import { BurpConfig } from './BurpConfig';
import FileDescriptor from './FileDescriptor';
import { FileProcessor } from './FileProcessor';

const debug = Debug('Burp');
const glob = require('glob-all');

export class BurpProcessor {
  constructor(config: BurpConfig) {
    if (!config) {
      throw new Error('config is empty');
    }

    if (!config.sourcePath) {
      throw new Error('sourcePath is empty');
    }
    this._config = config;
    console.log(`Starting directory: ${process.cwd()} sourcePath ${this._config.sourcePath}`);
    try {
      process.chdir(this._config.sourcePath);
    } catch (err) {
      console.log('Could not change directory to source path: ' + err);
      throw new Error('Aborting');
    }
    this._rootPath = process.cwd();
    console.log('Set working directory to : ' + process.cwd());
    this._warnings = [];
    this._errors = [];
    this._config.globPattern = this._config.globPattern || '**/*.brs';
  }

  private readonly _config: BurpConfig;
  private readonly _warnings: string[];
  private readonly _errors: string[];
  private readonly _rootPath: string;

  get errors(): string[] {
    return this._errors;
  }

  get warnings(): string[] {
    return this._warnings;
  }

  public processFiles(): boolean {
    debug(`Running Config is ${this._config} `);
    debug( `path ${this._config.sourcePath} `);
    debug(`rootpath ${this._rootPath} `);

    let fileProcessor = new FileProcessor(this._config);
    fileProcessor.rootPath = process.cwd();
    let files = glob.sync(this._config.globPattern);
    files.forEach( (file) => {
      debug(`file ${file}, ${path.resolve(file)}`);
      const fileDescriptor = new FileDescriptor(path.dirname(path.resolve(file)), path.basename(file), path.extname(file).toLowerCase());
      let result = fileProcessor.processFile(fileDescriptor);
      debug(` processed file ${fileDescriptor.fullPath} result: ${result}`);
      this.errors.concat(fileProcessor.errors);
      this.warnings.concat(fileProcessor.warnings);
    });

    this.errors.concat(this.errors);
    this.warnings.concat(this.warnings);
    this.reportErrors();
    this.reportWarnings();
    return this.reportErrors.length === 0;
  }

  public reportErrors() {
    if (this.errors.length > 0) {

      debug(`
    The following errors occurred during processing:

    ======
    `);
      this.errors.forEach( (errorText) => debug(`[ERROR] ${errorText}`));
      debug(`
    ======
    `);
    }
  }

  public reportWarnings() {
    if (this.warnings.length > 0) {

      debug(`
    The following warnings occurred during processing:

    ======
    `);
      this.warnings.forEach( (errorText) => debug(`[WARN] ${errorText}`));
      debug(`
    ======
    `);
    }
  }
}
