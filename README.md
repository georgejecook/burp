<h3 align="center">
Burp - Lightweight script processing for Roku brightscript projects
</h3>
<p align="center">
  Version 0.1.0
</p>

## Links
 - **[Documentation](documentation)**
 - **[Release notes / History / Changes](CHANGELOG.md)**
 - [Roku developer slack group](https://join.slack.com/t/rokudevelopers/shared_invite/enQtMzgyODg0ODY0NDM5LTc2ZDdhZWI2MDBmYjcwYTk5MmE1MTYwMTA2NGVjZmJiNWM4ZWY2MjY1MDY0MmViNmQ1ZWRmMWUzYTVhNzJiY2M)
 - [Issue tracker](https://github.com/georgejecook/burp/issues)
 - [Roadmap](ROADMAP.md)

## Development

Burp is an independent open-source project, maintained exclusively by volunteers.

You might want to help! Get in touch via the slack group, or raise issues.

## What is Burp?

It's a simple tool for executing regex replacements on source code files, a bit like _awk_. The killer feature is that it understands brightscript syntax, so it knows what line and function it's in. It can be used from command line, or from a js environment (such as when using  gulp for building)

## Usage

### From command line

 - Install burp globally with `npm install -g burp-brightscript`
 - Create a config file for your source, such as `burpConfig.json` containing:

```
{
  sourcePath: "relative/or/absolute/path/of/your/source",
  globPattern: "**/*.brs",
  replacements: [
    {
      regex: "(^.*\?\s*\")",
      replacement: '$1#FileName#.#FunctionName#(#LineNumber#) '
      }
  ]
      
}
```
 - Execute Burp `burp burpConfig.json`

### From a node enviroment

 - Create a `BurpProcessor` with the required json config
 - call `processor.processFiles()`, which returns true if no errors were encountered. `processor.warnings`, and `processor.errors` contain any processing errors and warnings.
 -  Example:

```
	import BurpProcessor from 'burp-brightscript';
	
    config = {
      sourcePath: targetPath,
      globPattern: '**/*.brs',
      replacements: [{
        regex: '(^.*\\?\\s*\\")',
        replacement: '$1#FileName#.#FunctionName#(#LineNumber#) '
      }];
      let result = processor.processFiles();
```

### Replacement values
You can use the following constants in your regex replacements:

 - `#FullPath#` - full path of file
 - `#LineNumber#` - line number of replacement
 - `#FileName#` - filename of replacement
 - `#FunctionName#` - function name of replacement
 - `#CommentLine#` - will result in the line being commented out
 
## Why call it Burp?
I like the name. It doesn't mean anything.


## Why did you make this?

I also made [rLog](https://github.com/georgejecook/rLog) and needed a tool that could process source files to insert the line number and function name. I figured this is a more generally useful way of doing it, which other's might leverage in their own tool-chains and build processes.
