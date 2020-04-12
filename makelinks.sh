#!/bin/sh

DOTFILES=`pwd`

cd ~
ln -s $DOTFILES/.gitconfig
ln -s $DOTFILES/.ctags
ln -s $DOTFILES/nvim .config
ln -s $DOTFILES/fish .config

cd $DOTFILES
