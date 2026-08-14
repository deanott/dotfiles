# Load dotfiles. Was `for file in ~/.{aliases}` -- bash does not expand a
# brace with a single element, so that looped once over the literal string
# "~/.{aliases}" and the -r guard silently swallowed it. Net effect: .bashrc
# has never actually sourced .aliases. One file, so no loop needed.
[ -r ~/.aliases ] && . ~/.aliases

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

. "$HOME/.cargo/env"


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
