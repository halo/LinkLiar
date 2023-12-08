schema_version = 1

project {
  license        = "MIT"
  copyright_year = 2012
  copyright_holder = "halo https://github.com/halo/LinkLiar"

  # (OPTIONAL) A list of globs that should not have copyright/license headers.
  # Supports doublestar glob patterns for more flexibility in defining which
  # files or folders should be ignored
  header_ignore = [
    "LinkLiarHelp/**",
    "docs/**",
    "**/*.yml",
  ]
}
