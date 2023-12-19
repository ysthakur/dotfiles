export-env {
  $env.RTX_SHELL = "nu"
  
  $env.config = ($env.config | upsert hooks {
      pre_prompt: ($env.config.hooks.pre_prompt ++
      [{
      condition: {|| "RTX_SHELL" in $env }
      code: {|| rtx_hook }
      }])
      env_change: {
          PWD: ($env.config.hooks.env_change.PWD ++
          [{
          condition: {|| "RTX_SHELL" in $env }
          code: {|| rtx_hook }
          }])
      }
  })
}
  
def "parse vars" [] {
  $in | lines | parse "{op},{name},{value}"
}
  
def-env rtx [command?: string, --help, ...rest: string] {
  let commands = ["shell", "deactivate"]
  
  if ($command == null) {
    ^"/nix/store/cnca6q1yf852b8l8gq26dvxdki8xsi9w-rtx-2023.10.1/bin/rtx"
  } else if ($command == "activate") {
    let-env RTX_SHELL = "nu"
  } else if ($command in $commands) {
    ^"/nix/store/cnca6q1yf852b8l8gq26dvxdki8xsi9w-rtx-2023.10.1/bin/rtx" $command $rest
    | parse vars
    | update-env
  } else {
    ^"/nix/store/cnca6q1yf852b8l8gq26dvxdki8xsi9w-rtx-2023.10.1/bin/rtx" $command $rest
  }
}
  
def-env "update-env" [] {
  for $var in $in {
    if $var.op == "set" {
      load-env {($var.name): $var.value}
    } else if $var.op == "hide" {
      hide-env $var.name
    }
  }
}
  
def-env rtx_hook [] {
  ^"/nix/store/cnca6q1yf852b8l8gq26dvxdki8xsi9w-rtx-2023.10.1/bin/rtx" hook-env -s nu
    | parse vars
    | update-env
}

