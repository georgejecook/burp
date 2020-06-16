<h3 align="center">
Burp - Lightweight script processing for Roku brightscript projects
</h3>


[![codecov](https://codecov.io/gh/georgejecook/burp/branch/master/graph/badge.svg)](https://codecov.io/gh/georgejecook/burp) [![Build Status](https://travis-ci.org/georgejecook/burp.svg?branch=master)](https://travis-ci.org/georgejecook/burp)
[![GitHub](https://img.shields.io/github/release/georgejecook/burp.svg?style=flat-square)](https://github.com/georgejecook/burp/releases) 
[![NPM](https://nodei.co/npm/burp-brightscript.png)](https://npmjs.org/package/burp-brightscrip)

## Links
 - [Roku developer slack group](https://join.slack.com/t/rokudevelopers/shared_invite/enQtMzgyODg0ODY0NDM5LTc2ZDdhZWI2MDBmYjcwYTk5MmE1MTYwMTA2NGVjZmJiNWM4ZWY2MjY1MDY0MmViNmQ1ZWRmMWUzYTVhNzJiY2M)
 - [Issue tracker](https://github.com/georgejecook/burp/issues)
 - [CHANGELOG](CHANGELOG.md)

## Development

Burp is an independent open-source project, maintained exclusively by volunteers.

You might want to help! Get in touch via the slack group, or raise issues.

## What is Burp?

It's a simple tool for executing regex replacements on source code files, a bit like _awk_. The killer feature is that it understands brightscript syntax, so it knows what line and function it's in. It can be used from command line, or from a js environment (such as when using  gulp for building)

## What kinds of things can you do with it?

 - Add line numbers to log calls in your files, or disable logs
 - Prevent further asserts executing in unit tests, if a test has failed
 - Replace tokens in your files
 - and more
 
## Usage

### From javascript/typescript/node

#### Gulp typescript example

The following working gulpfile can be found in my [roku MVVM spike](https://github.com/georgejecook/rokuNavSpike/tree/feature/viewModels); but the process is as follows.

 - `npm install burp-brightscript --save-dev`
 - Add the following to the top of gulpfile.ts `import { BurpConfig, BurpProcessor } from "burp-brightscript";
 - Create a task to process your files, with the desired regex replacements, such as:

 ```
 export function addDevLogs(cb) {
  let config: BurpConfig = {
    "sourcePath": "build/.roku-deploy-staging",
    "globPattern": ["**/*.brs","**/*.bs"],
    "replacements": [
      {
        "regex": "(^.*(logInfo|logError|logVerbose|logDebug)\\((\\s*\"))",
        "replacement": "$1#FullPath# "
      },
      {
        "regex": "(^.*(logMethod)\\((\\s*\"))",
        "replacement": "$1#FullPath# "
      }
    ]
  }
  const processor = new BurpProcessor(config);
  processor.processFiles();
  cb();
}
```


### From command line

 - Install burp globally with `npm install -g burp-brightscript`
 - Create a config file for your source, such as `burpConfig.json` containing:

```
{
    "sourcePath": "build/.roku-deploy-staging",
    "globPattern": ["**/*.brs"],
    "replacements": [
      {
        "regex": "(^.*(logInfo|logError|logVerbose|logDebug)\\((\\s*\"))",
        "replacement": "$1#FullPath# "
      },
      {
        "regex": "(^.*(logMethod)\\((\\s*\"))",
        "replacement": "$1#FullPath# "
      }
    ]
  }

```
 - Execute Burp `burp burpConfig.json`

### Replacement values

You can use the following constants in your regex replacements:

 - `#FullPath#` - full path of file
 - `#LineNumber#` - line number of replacement
 - `#FileName#` - filename of replacement
 - `#FunctionName#` - function name of replacement
 - `#CommentLine#` - will result in the line being commented out
 
## Why call it Burp?

I like the name. It doesn't mean anything.

## Using with .bs files

Note, you should invoke burp BEFORE you transpile, until further notice - this is because the line numbers will be completely wrong in your transpiled code.
Burp will rename all file paths in the output from .bs to .brs
Here's a gulp example of how you can achieve this (please feel free to put up a pr with docs improvements, for a better suggestion) - the following is for mac/linux:

```
export async function compile(cb) {
  // copy all sources to tmp folder
  // so we can add the line numbers to them prior to transpiling
  await copyFiles();
  await sleep(100);
  await applyBurpPreprocessing();
  let builder = new ProgramBuilder();
  await builder.run({
    stagingFolderPath: outDir,
    createPackage: false,
    "rootDir": tmpBuildDir,
    "autoImportComponentScript": true,
  });
}

  public async copyFiles() {
    let oldPath = path.resolve(process.cwd());
    try {
      let outPath = path.resolve(this.config.outputPath);
      fs.mkdirSync(this.config.outputPath);

      let sourcePaths = this.config.sourcePaths.map((p) => {
        p = path.resolve(p);
        p = p.endsWith('/') ? p : p + '/';
        if (!fs.existsSync(p)) {
          feedbackError(new File(p, '', '', ''), `cannot find source path  ${p}`, true);
        }
        return p;
      }).join(' ');

      await exec(`rsync -az ${sourcePaths} ${outPath}`);
      console.log(`files copied to ${outPath} dir is now ${process.cwd()}`);
    } catch (err) {
      console.error(err);
    }
    process.chdir(oldPath);
  }

```

## Why did you make this?

I also made [rLog](https://github.com/georgejecook/rLog) and needed a tool that could process source files to insert the line number and function name. I figured this is a more generally useful way of doing it, which other's might leverage in their own tool-chains and build processes.
