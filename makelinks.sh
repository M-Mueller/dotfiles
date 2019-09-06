#!/bin/sh

DOTFILES=`pwd`

cd ~
ln -s $DOTFILES/.gitconfig
ln -s $DOTFILES/nvim .config
ln -s $DOTFILES/zsh .config
ln -s $DOTFILES/.zshrc
ln -s $DOTFILES/fish .config

cd $DOTFILES
