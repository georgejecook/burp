#!/usr/bin/env node
import BurpProcessor from './lib/BurpProcessor';
import { BurpConfig } from './lib/BurpConfig';
const program = require('commander');
const fs = require('fs');
const pkg = require('../package.json');
program
  .version(pkg.version)
  .description('Brightscript Burp Preprocessor');

program
  .command('process <sourcePath> <globPattern>')
  .alias('p')
  .description(`
  processes a brightscript SceneGraph project and apply regex replacements
  as per the passed in config
  `)
  .action((configPath) => {
    console.log(`Processing....`);
    console.log(`   config path ${configPath}`);
    let config: BurpConfig = {};
    let configText: string = fs.readFileSync(configPath);
    try {
      config = JSON.parse(configText);
    } catch (e) {
      throw new Error('error loading config');
    }
    console.time('Finished in:');
    let processor = new BurpProcessor(config);
    processor.processFiles();
    console.timeEnd('Finished in:');
  });

program.parse(process.argv);
