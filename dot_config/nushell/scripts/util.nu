# Does the given executable exist?
export def exists-exe [exe_name: string]: nothing -> bool {
  which $exe_name | is-not-empty
}

# Helper commands for WSL stuff
export module wsl {
  const windowsUsername = "yasht"

  # Check if we're in WSL
  export def is-wsl [] {
    "/mnt/wsl" | path exists
  }

  export def is-light-theme [] {
    (powershell.exe $"C:/Users/($windowsUsername)/bin/GetTheme.ps1") == "1"
  }
}

# Given a POSIX shell script containing aliases, translate those aliases to Nushell
#
# Preserves comments and blank lines
export def gen-aliases [ alias_file: path ] : nothing -> string {
  open --raw $alias_file | lines | each { |line|
    # todo the body may contain escaped quotes or whatever, need to unescape that
    let parsed = $line | parse 'alias {name}="{body}"'
    if ($parsed | is-not-empty) {
      $"alias ($parsed.0.name) = ($parsed.0.body)\n"
    } else if ($line | str starts-with "#") {
      $"($line)\n"
    } else if $line == "" {
      "\n"
    } else {
      # If the line isn't an alias, comment, or blank, ignore it
      ""
    }
  } | str join ""
}

