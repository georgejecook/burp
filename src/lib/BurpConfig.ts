export interface BurpReplacement {
  regex: string;
  _regex?: RegExp;
  replacement: string;
}

export interface BurpConfig {
  sourcePath?: string;
  globPattern?: string;
  replacements?: BurpReplacement[];
}
