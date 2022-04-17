set -Ux EDITOR nvim
set -U fish_greeting
set -gx fish_key_bindings fish_user_key_bindings


if test -z (pgrep ssh-agent | string collect)
  eval (ssh-agent -c)
  set -Ux SSH_ASKPASS "/usr/bin/ksshaskpass"
end

if status is-interactive
  # Commands to run in interactive sessions can go here
  kubectl completion fish | source

  alias k='kubectl'
  alias keti='kubectl exec -ti'
  alias cat='bat'
  alias find='fd'
  alias vi="nvim"
  alias vim="nvim"
end

