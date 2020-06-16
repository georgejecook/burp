export interface BurpReplacement {
  regex: string;
  _regex?: RegExp;
  replacement: string;
}

export interface BurpConfig {
  sourcePath?: string;
  filePattern?: string[];
  replacements?: BurpReplacement[];
}
