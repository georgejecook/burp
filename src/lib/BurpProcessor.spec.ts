import * as chai from 'chai';
import * as fs from 'fs-extra';

import { expect } from 'chai';

import { BurpConfig } from './BurpConfig';
import BurpProcessor from './BurpProcessor';

const chaiSubset = require('chai-subset');
let dircompare = require('dir-compare');

chai.use(chaiSubset);
let processor: BurpProcessor;
let sourcePath = 'src/test/stubProject';
let testsPath = 'build/source/tests';
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
      sourcePath: sourcePath,
      globPattern: '**/*.brs',
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
      processor.processFiles();
    });
  });
});
