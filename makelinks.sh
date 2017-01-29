#!/bin/sh

DOTFILES=`pwd`

cd ~
ln -s $DOTFILES/.gitconfig
ln -s $DOTFILES/nvim .config

cd $DOTFILES
