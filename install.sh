#!/usr/bin/env bash

CMD="$1"
# Get current dir (so run this script from anywhere)

DOTFILES_DIR=$(pwd)
BACKUP_DIR=~/.dotfiles.orig

dotfiles=(.zshrc .ssh .aliases .bashrc .vimrc .Xresources .dircolors )
dotfiles_config=(kitty git i3 i3status fish )

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
    for dots in "${dotfiles[@]}"
    do
        /bin/rm -rf ~/${dots}
        /bin/ln -fs "$DOTFILES_DIR/${dots}" ~/
    done

    #Install config to ~/.config.
    mkdir -p ~/.config
    for dots_conf in "${dotfiles_config[@]}"
    do
        /bin/rm -rf ~/.config/${dots_conf[@]//./}
        /bin/ln -fs "$DOTFILES_DIR/.config/${dots_conf}" ~/.config/${dots_conf[@]//./}
    done

    echo -e $blue"New dotfiles is installed!\n"$white >&2
    echo "There may be some errors when Terminal is restarted." >&2
}

case "$CMD" in
    -i)
        install
        ;;
    -r)
        uninstall
        ;;
    *)
        echo "Command not found. Commands -i install and -r unistall" >&2
        exit 1
esac