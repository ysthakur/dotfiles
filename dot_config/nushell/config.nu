use std/config *

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = $env.ENV_CONVERSIONS | merge {
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
const NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    "~/.nix-profile/share/nu_scripts/"
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# Disable the welcome banner at startup
$env.config.show_banner = false

# $env.config.filesize.unit = "metric" # metric => KB, MB, GB (ISO standard), binary => KiB, MiB, GiB (Windows standard)
# $env.config.filesize.metric = true

# Use Helix for editing the buffer
$env.config.buffer_editor = "hx"

$env.config.history.file_format = "sqlite"
# Enable to share history between multiple sessions, else you have to close the session to write history to file
$env.config.history.sync_on_enter = true
# only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
$env.config.history.isolation = true

$env.config.table.show_empty = true # show 'empty list' and 'empty record' placeholders for command output
$env.config.table.header_on_separator = true

$env.config.completions.algorithm = "fuzzy"
$env.config.completions.external.enable = false # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up may be very slow

$env.config.cursor_shape = {
    emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line (line is the default)
    vi_insert: blink_block # block, underscore, line , blink_block, blink_underscore, blink_line (block is the default)
    vi_normal: underscore # block, underscore, line, blink_block, blink_underscore, blink_line (underscore is the default)
}

$env.config.color_config = if $env.LIGHT_THEME { (light-theme) } else { (dark_theme) }

# true or false to enable or disable right prompt to be rendered on last line of the prompt.
$env.config.render_right_prompt_on_last_line = false

# Enables highlighting of external commands in the repl resolved by which
$env.config.highlight_resolved_externals = true

$env.config.hooks.pre_prompt = [{
    if (which direnv | is-not-empty) {
        direnv export json | from json | default {} | load-env
    }
}]

source ($nu.cache-dir | path join zoxide.nu)
source ($nu.cache-dir | path join carapace.nu)
source ($nu.cache-dir | path join atuin.nu)
source ($nu.cache-dir | path join oh-my-posh.nu)
source ($nu.cache-dir | path join mise.nu)

use custom-completions/git/git-completions.nu *
use custom-completions/cargo/cargo-completions.nu *
use custom-completions/nix/nix-completions.nu *

