# Nushell Config File
#
# version = 0.83.1

# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes
use std/config *

# Disable the welcome banner at startup
$env.config.show_banner = false

$env.config.filesize.metric = true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)

# Use Helix for editing the buffer
$env.config.buffer_editor = "hx"

$env.config.history.file_format = "sqlite"
# Enable to share history between multiple sessions, else you have to close the session to write history to file
$env.config.history.sync_on_enter = true
# only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
$env.config.history.isolation = true

$env.config.table.show_empty = true # show 'empty list' and 'empty record' placeholders for command output
$env.config.table.header_on_separator = true

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
        let direnv = (direnv export json | from json)
        let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
        $direnv | load-env
    }
}]

source ($nu.cache-dir | path join zoxide.nu)
source ($nu.cache-dir | path join carapace.nu)
source ($nu.cache-dir | path join atuin.nu)
source ($nu.cache-dir | path join oh-my-posh.nu)
use ($nu.cache-dir | path join mise.nu)

use custom-completions/git/git-completions.nu *
use custom-completions/cargo/cargo-completions.nu *
use custom-completions/nix/nix-completions.nu *

