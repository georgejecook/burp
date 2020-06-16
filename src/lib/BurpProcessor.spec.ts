import * as chai from 'chai';
import * as fs from 'fs-extra';
import * as path from 'path';

import { expect } from 'chai';

import { BurpConfig } from './BurpConfig';
import { BurpProcessor } from './BurpProcessor';

const chaiSubset = require('chai-subset');

chai.use(chaiSubset);
let processor: BurpProcessor;
let sourcePath = path.resolve(__dirname, '../test/stubProject');
let targetPath = 'build';

function clearFiles() {
  fs.removeSync(targetPath);
}

function copyFiles() {
  try {
    fs.copySync(sourcePath, targetPath);
  } catch (err) {
    console.error(err);
  }
}

let config: BurpConfig;

describe('BurpProcessor tests', function() {
  beforeEach(() => {
    clearFiles();
    copyFiles();
    config = {
      sourcePath: targetPath,
      filePattern: ['**/*.brs'],
      replacements: []
    };
    processor = new BurpProcessor(config);
  });

  describe('Initialization', function() {
    it('correctly sets source paths and config', function() {
      expect(processor).to.not.be.null;
    });
  });

  describe('Process files valid test', function() {
    it('tests file creation', () => {
      config.replacements = [{
        regex: '(^.*\\?\\s*\\")',
        replacement: '$1#FileName#.#FunctionName#(#LineNumber#) '
      }];
      let result = processor.processFiles();
      expect(result).to.be.true;
    });
  });
});
