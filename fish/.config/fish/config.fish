set -Ux EDITOR nvim
set -g fish_greeting

if test -z (pgrep ssh-agent | string collect)
  eval (ssh-agent -c)
  set -Ux SSH_ASKPASS "/usr/bin/ksshaskpass"
end

if status is-interactive
    # Commands to run in interactive sessions can go here
  starship init fish | source
  kubectl completion fish | source
  fish_vi_key_bindings

  alias k='kubectl'
  alias keti='kubectl exec -ti'
  alias cat='bat'
  alias find='fd'
  alias vi="nvim"
  alias vim="nvim"
end

