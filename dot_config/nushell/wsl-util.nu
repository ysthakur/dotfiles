const windowsUsername = "yasht"

# Check if we're in WSL
export def is-wsl [] {
  "/mnt/wsl" | path exists
}

export def is-light-theme [] {
  (powershell.exe $"C:/Users/($windowsUsername)/bin/GetTheme.ps1") == 1
}

