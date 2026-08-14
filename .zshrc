# Themes.
ZSH_THEME="steeef"

# Case-sensitive completion.
CASE_SENSITIVE="true"

# Disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Disable marking untracked files under VCS as dirty.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# History.
HIST_STAMPS="yyyy-mm-dd"

# Plugins.
plugins=(
    zsh-autosuggestions
    extract
    git
    ubuntu
	zsh-syntax-highlighting
	zsh-nvm
	kubectl
)

#Environment exports
export ZSH="$HOME/.oh-my-zsh"

export PATH="$PATH:$HOME/bin/:/usr/bin"


# Oh My Zsh time! Guarded: omz is a git install, not a package, so on a fresh
# box this file gets sourced before it exists -- unguarded that's a hard error
# on every shell start.
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH"/oh-my-zsh.sh

# Aliases.
source ~/.aliases

# Base16 Shell.
[ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ] && eval "$("$BASE16_SHELL/profile_helper.sh")"

# Start tmux.
if [[ -x "$(command -v tmux)" && "$(ps -o 'cmd=' -p $(ps -o 'ppid=' -p $$))" = "alacritty" ]]; then
    [ -z "$TMUX" ] && { tmux attach-session || exec tmux && exit; }
fi

zsh_stats(){
  fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n20
}

#Pretty print some json
pj() {
    python3 -m json.tool
}

jsonless() {
  if [ -t 0 ]; then
    # If input is from terminal, use file argument
    jq . "$1" | less -R
  else
    # If input is piped
    jq . | less -R
  fi
}


id_active_window() {
    xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}'
}

preexec () {
    # Note the date when the command started, in unix time.
    CMD_START_DATE=$(date +%s)
    # Store the command that we're running.
    CMD_NAME=$1
    CMD_WINDOW_ID=$(id_active_window)
}

precmd () {
    # Proceed only if we've ran a command in the current shell.
    if ! [[ -z $CMD_START_DATE ]]; then
        # Note current date in unix time
        CMD_END_DATE=$(date +%s)
        # Store the difference between the last command start date vs. current date.
        CMD_ELAPSED_TIME=$(($CMD_END_DATE - $CMD_START_DATE))
        # Store an arbitrary threshold, in seconds.
        CMD_NOTIFY_THRESHOLD=35

        if [[ $CMD_ELAPSED_TIME -gt $CMD_NOTIFY_THRESHOLD ]]; then
            if [[ "$CMD_WINDOW_ID" != "$(id_active_window)" ]]; then
                # Beep or visual bell if the elapsed time (in seconds) is greater than threshold
                print -n '\a'
                # Send a notification
                notify-send 'The cat brings gift' "\"$CMD_NAME\" finished."
            fi
        fi
    fi
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# `[[ /usr/bin/kubectl ]]` was a non-empty-string test -- true unconditionally,
# whether or not kubectl is installed. Test for the command itself, matching
# the `command -v tmux` idiom above.
command -v kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)

# Guarded like omz and fzf: pyenv is not in essential.txt, so on a fresh box
# this hard-errors on every shell start.
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

export PATH=$PATH:${GOPATH:-$HOME/go}/bin

export CLIPMENU_LAUNCHER="rofi -dmenu -theme clipmenu-center"
export CM_LAUNCHER=rofi

export PATH="$HOME/.nvm/versions/node/v22.11.0/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
# Double-quoted, not single as gcloud writes it -- $HOME does not expand in ''.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi
export PATH="$HOME/.local/bin:$PATH"

# Host-specific ssh aliases live in ~/.zshrc.local (untracked) -- this repo
# is public and has no business naming my boxes.
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
