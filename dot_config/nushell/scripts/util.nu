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

