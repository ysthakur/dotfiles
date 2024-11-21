# Update a file if it hasn't been updated in a while
# Returns whether or not the file was updated
export def update-cached [
    path: string, # The file to update
    duration: duration, # How often to update it
    generate: closure, # Generate text to update file
  ]: nothing -> bool {
  if not ($path | path exists) or (date now) - (ls $path).0.modified > $duration {
    do $generate | save -f $path
    true
  } else {
    false
  }
}

