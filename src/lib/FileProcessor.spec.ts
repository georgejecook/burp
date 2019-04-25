import * as chai from 'chai';
import * as fs from 'fs-extra';

import { expect } from 'chai';

import * as path from 'path';

import FileDescriptor from './FileDescriptor';
import { FileProcessor } from './FileProcessor';

const chaiSubset = require('chai-subset');

chai.use(chaiSubset);
let processor: FileProcessor;
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
let config;

describe('FileProcessor tests', function() {
  beforeEach(() => {
    clearFiles();
    copyFiles();
    config = {
      sourcePath: targetPath,
      globPattern: '**/*.brs',
      replacements: []
    };
  });

  describe('Initialization', function() {
    it('correctly sets source paths and config', function() {
      processor = new FileProcessor(config);
      expect(processor).to.not.be.null;
    });
  });

  describe('getFunctionFromLine', function() {
    it('checks non function lines', () => {
      processor = new FileProcessor(config);
      expect(processor.getFunctionFromLine('')).to.be.null;
      expect(processor.getFunctionFromLine('    ')).to.be.null;
      expect(processor.getFunctionFromLine(' m.this  = "someValue')).to.be.null;
      expect(processor.getFunctionFromLine(`'   function long_word_Different1(with Args) as void`)).to.be.null;
      expect(processor.getFunctionFromLine(`'function foo() as void`)).to.be.null;
    });

    it('checks function lines', () => {
      processor = new FileProcessor(config);
      expect(processor.getFunctionFromLine('function foo() as void')).to.equal('foo');
      expect(processor.getFunctionFromLine('sub foo() as void')).to.equal('foo');
      expect(processor.getFunctionFromLine('   sub foo() as void')).to.equal('foo');
      expect(processor.getFunctionFromLine('   function foo() as void')).to.equal('foo');
      expect(processor.getFunctionFromLine('   function long_word_Different1() as void')).to.equal('long_word_Different1');
      expect(processor.getFunctionFromLine('   function long_word_Different1(with Args) as void')).to.equal('long_word_Different1');
    });
  });

  describe('processFile', function() {
    beforeEach(() => {
      clearFiles();
      copyFiles();
      config = {
        sourcePath: targetPath,
        globPattern: '**/*.brs',
        replacements: []
      };
    });

    it('ignores null file descriptor', () => {
      config.replacements = [{
        regex: '.*',
        replacement: '#CommentLine#'
      }];
      processor = new FileProcessor(config);
      let result = processor.processFile(null);
      expect(result).to.be.false;
    });

    it('comments out all lines', () => {
      config.replacements = [{
        regex: '.*',
        replacement: '#CommentLine#'
      }];
      processor = new FileProcessor(config);
      let fileDescriptor = new FileDescriptor(`build/source/tests`, `VideoModuleTests.brs`, `.brs`);
      let result = processor.processFile(fileDescriptor);
      expect(result).to.be.true;
    });

    it('comments out all lines with print statements', () => {
      config.replacements = [{
        regex: '^.*\\?',
        replacement: '#CommentLine#'
      }];
      processor = new FileProcessor(config);
      let fileDescriptor = new FileDescriptor(`build/source/tests`, `VideoModuleTests.brs`, `.brs`);
      let result = processor.processFile(fileDescriptor);
      expect(result).to.be.true;
    });

    it('replaces print contents with line number', () => {
      config.replacements = [{
        regex: '(^.*\\?\\s*\\")',
        replacement: '$1#LineNumber#'
      }];
      processor = new FileProcessor(config);
      let fileDescriptor = new FileDescriptor(`build/source/tests`, `VideoModuleTests.brs`, `.brs`);
      let result = processor.processFile(fileDescriptor);
      expect(result).to.be.true;
    });

    it('replaces print contents with full file path', () => {
      config.replacements = [{
        regex: '(^.*\\?\\s*\\")',
        replacement: '$1#FullPath#'
      }];
      processor = new FileProcessor(config);
      let fileDescriptor = new FileDescriptor(`build/source/tests`, `VideoModuleTests.brs`, `.brs`);
      let result = processor.processFile(fileDescriptor);
      expect(result).to.be.true;
    });

    it('replaces print contents with full file path and method', () => {
      config.replacements = [{
        regex: '(^.*\\?\\s*\\")',
        replacement: '$1#FullPath#.#FunctionName#'
      }];
      processor = new FileProcessor(config);
      let fileDescriptor = new FileDescriptor(`build/source/tests`, `VideoModuleTests.brs`, `.brs`);
      let result = processor.processFile(fileDescriptor);
      expect(result).to.be.true;
    });

    it('replaces print contents with file name and method', () => {
      config.replacements = [{
        regex: '(^.*\\?\\s*\\")',
        replacement: '$1#FileName#.#FunctionName#'
      }];
      processor = new FileProcessor(config);
      let fileDescriptor = new FileDescriptor(`build/source/tests`, `VideoModuleTests.brs`, `.brs`);
      let result = processor.processFile(fileDescriptor);
      expect(result).to.be.true;
    });

    it('replaces print contents with file name, method and line number', () => {
      config.replacements = [{
        regex: '(^.*\\?\\s*\\")',
        replacement: '$1#FileName#.#FunctionName#(#LineNumber#) '
      }];
      processor = new FileProcessor(config);
      let fileDescriptor = new FileDescriptor(`build/source/tests`, `VideoModuleTests.brs`, `.brs`);
      let result = processor.processFile(fileDescriptor);
      expect(result).to.be.true;
    });

    it('replaces print contents with full location', () => {
      config.replacements = [{
        regex: '(^.*\\?\\s*\\")',
        replacement: '$1#Location#'
      }];
      processor = new FileProcessor(config);
      let fileDescriptor = new FileDescriptor(`build/source/tests`, `VideoModuleTests.brs`, `.brs`);
      let result = processor.processFile(fileDescriptor);
      expect(result).to.be.true;
    });
  });
});
