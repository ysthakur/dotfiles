# Nushell Environment Config File
#
# version = 0.83.1

use scripts/util.nu *

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
}

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# Update a file if it hasn't been updated in a while.
# If the tool isn't installed, create an empty file so that there won't be
# problems when sourcing it.
def update-cached [tool: string, dur: duration, gen: closure] {
  let path = $nu.cache-dir | path join $"($tool).nu"
  if (exists-exe $tool) {
    if not ($path | path exists) or (date now) - (ls $path).0.modified > $dur {
      do $gen | save -f $path
      print $"Updated ($tool).nu"
    }
  } else {
    "" | save -f $path
  }
}

mkdir $nu.cache-dir
update-cached oh-my-posh 1wk {
  oh-my-posh init nu --print --config "~/ysthakur_prompt_theme.omp.json"
}
update-cached zoxide 6wk { zoxide init nushell }
update-cached carapace 4wk { carapace _carapace nushell }
update-cached mise 4wk { ^mise activate nu }
update-cached atuin 4wk { atuin init nu --disable-up-arrow }
update-cached stickyvar 4wk { stickyvar init nu }

