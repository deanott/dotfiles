#!/usr/bin/env bash

CMD="$1"
# Get current dir (so run this script from anywhere)

DOTFILES_DIR=$(pwd)
BACKUP_DIR=~/.dotfiles.orig

# NOTE: .ssh is deliberately NOT here. This repo is public, so ssh config must
# never live in it -- and because install() does `rm -rf ~/<entry>` before
# symlinking, listing something absent from the repo would destroy ~/.ssh.
dotfiles=(.zshrc .aliases .bashrc .vimrc .Xresources .Xmodmap .dircolors .git-templates)
dotfiles_config=(kitty git i3 i3status fish dunst redshift neofetch sakura)

# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Update dotfiles itself first

#if is-executable git -a -d "$DOTFILES_DIR/.git"; then git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master; fi

# Bunch of symlinks

# Package managers & packagesvg

install() {
    # Backup config.
    if ! [ -f $BACKUP_DIR/check-backup.txt ]; then
        mkdir -p $BACKUP_DIR/.config
        cd $BACKUP_DIR
        touch check-backup.txt

        # Backup to ~/.dotfiles.orig
        for dots in "${dotfiles[@]}"
        do
            /bin/cp -rf ~/${dots} $BACKUP_DIR &> /dev/null
        done

        #Backup some folder in ~/.config to ~/.dotfiles.orig/.config
        for dots_conf in "${dotfiles_config[@]//./}"
        do
            /bin/cp -rf ~/.config/${dots_conf} $BACKUP_DIR/.config &> /dev/null
        done

        # Backup again with Git.
        git init &> /dev/null
        git add -u &> /dev/null
        git add . &> /dev/null
        git commit -m "Backup original config on `date '+%Y-%m-%d %H:%M'`" &> /dev/null

        # Output.
        echo -e $blue"Your config is backed up in "$BACKUP_DIR"\n" >&2
        echo -e $red"Please do not delete check-backup.txt in .dotfiles.orig folder."$white >&2
        echo -e "It's used to backup and restore your old config.\n" >&2
    fi

    # Install config.
    # Guard: never rm -rf a target whose source is missing from the repo,
    # otherwise a stale array entry silently deletes real data in $HOME.
    for dots in "${dotfiles[@]}"
    do
        if ! [ -e "$DOTFILES_DIR/${dots}" ]; then
            echo -e $red"skip ${dots}: not in repo"$white >&2
            continue
        fi
        /bin/rm -rf ~/${dots}
        /bin/ln -fs "$DOTFILES_DIR/${dots}" ~/
    done

    #Install config to ~/.config.
    mkdir -p ~/.config
    for dots_conf in "${dotfiles_config[@]}"
    do
        if ! [ -e "$DOTFILES_DIR/.config/${dots_conf}" ]; then
            echo -e $red"skip .config/${dots_conf}: not in repo"$white >&2
            continue
        fi
        /bin/rm -rf ~/.config/${dots_conf[@]//./}
        /bin/ln -fs "$DOTFILES_DIR/.config/${dots_conf}" ~/.config/${dots_conf[@]//./}
    done

    echo -e $blue"New dotfiles is installed!\n"$white >&2
    echo "There may be some errors when Terminal is restarted." >&2
}

packages() {
    # Curated list only -- what these dotfiles actually need.
    # native.txt / aur.txt are full dumps of the old machine; cherry-pick from
    # them by hand rather than installing 272 packages onto a fresh box.
    # pacman reads one target per line from stdin and does NOT understand
    # comments -- feeding it the file raw makes it look for a package called
    # "# Packages these dotfiles actually depend on." Strip comments/blanks.
    grep -vE '^[[:space:]]*(#|$)' "$DOTFILES_DIR/packages/essential.txt" \
        | sudo pacman -S --needed -
    echo -e $blue"Not covered by pacman: fzf (git install into ~/.fzf)"$white >&2
}

case "$CMD" in
    -i)
        install
        ;;
    -r)
        uninstall
        ;;
    -p)
        packages
        ;;
    *)
        echo "Command not found. Commands -i install, -r uninstall, -p packages" >&2
        exit 1
esac