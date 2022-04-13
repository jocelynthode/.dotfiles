set -x EDITOR nvim
set -g fish_greeting
if status is-interactive
    # Commands to run in interactive sessions can go here
  starship init fish | source
  kubectl completion fish | source

  alias k='kubectl'
  alias cat='bat'
  alias find='fd'
end

