#!/bin/sh

DOTFILES=`pwd`

cd ~
ln -s $DOTFILES/.gitconfig
ln -s $DOTFILES/.ctags
ln -s $DOTFILES/.tmux.conf
ln -s $DOTFILES/nvim .config
ln -s $DOTFILES/fish .config

echo 'install rg, jq, fd'

cd $DOTFILES
