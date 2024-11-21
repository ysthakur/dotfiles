# Nushell Environment Config File
#
# version = 0.83.1

use scripts/util.nu update-cached
use scripts/wsl-util.nu

# Windows uses USERPROFILE instead of HOME
$env.HOME = $env.HOME? | default $env.USERPROFILE?

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
  "LIGHT_THEME": {
    from_string: { |s| $s | into bool }
    to_string: { |b| $b | into string }
  }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    $"($env.HOME)/.nix-profile/share/nu_scripts/"
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# The Oh My Posh config chooses a palette based on the LIGHT_THEME env var
# $env.LIGHT_THEME = (wsl-util is-wsl) and (wsl-util is-light-theme)
$env.LIGHT_THEME = ($env.LIGHT_THEME? | default true | into bool)

def create-in-cache-dir [ path: string, dur: duration, gen: closure ] {
  let full = $nu.cache-dir | path join $path
  if (update-cached $full $dur $gen) {
    print $"Updated ($full)"
  }
}

mkdir $nu.cache-dir
create-in-cache-dir oh-my-posh.nu 1wk {
  oh-my-posh init nu --print --config $"($env.HOME)/ysthakur_prompt_theme.omp.json"
}

create-in-cache-dir zoxide.nu 6wk { zoxide init nushell }
create-in-cache-dir carapace.nu 4wk { carapace _carapace nushell }
create-in-cache-dir mise.nu 4wk { ^mise activate nu }
create-in-cache-dir atuin.nu 4wk { atuin init nu --disable-up-arrow }

