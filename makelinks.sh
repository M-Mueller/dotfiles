#!/bin/sh

DOTFILES=`pwd`
echo $DOTFILES

cd ~
ln -s $DOTFILES/.gitconfig
ln -s $DOTFILES/nvim .config

cd $DOTFILES
