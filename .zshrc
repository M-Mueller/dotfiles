# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _match _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' match-original both
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' menu select=1
zstyle ':completion:*' prompt 'Correction:'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/markus/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt autocd nomatch
unsetopt appendhistory beep extendedglob
# End of lines configured by zsh-newuser-install

#-----------------------------
# Plugins
#-----------------------------
source ~/.config/zsh/zsh-history-substring-search.zsh
source ~/.config/zsh/expand-multiple-dots.zsh

#-----------------------------
# Aliases
#-----------------------------
alias v="nvim"
alias vim="nvim"
alias open="xdg-open"
alias kdiff="kdiff3-qt"
alias ipy="ipython3"

#-----------------------------
# Environment variables
#-----------------------------
export BROWSER="firefox"
export EDITOR="nvim"

#-----------------------------
# Keybindings
#-----------------------------
bindkey -e
bindkey '^?' backward-delete-char
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' history-substring-search-up
bindkey '^[[D' backward-char
bindkey '^[[B' history-substring-search-down
bindkey '^[[C' forward-char 
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

#-----------------------------
# Prompt
#-----------------------------
function git_prompt_info {
	local branch
	branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
	if [[ $? -eq 0 ]]; then
		local color="green"
		local icon=""
		local git_status
		# try to get the status in under a second
		git_status=$(timeout 1 git status -s)
		if [[ $? -ne 0 ]]; then
			icon="??"
		elif [[ $(echo $git_status | wc -w) -ne 0 ]]; then
			color="yellow"
			icon="±"
		fi
		echo  %F{$color}  ${branch} ${icon}%f
	fi
}
function prompt {
	echo
	echo %B%F{blue}%~%f%b$(git_prompt_info)
	# color prompt start depending on last return value
	echo '%(?.%F{cyan}.%F{red})❯ %f'
}
function rprompt {
	# show icon if there are background jobs
	echo '%F{red}%(1j.⚙.)%f'
}

setopt prompt_subst
PROMPT='$(prompt)'
RPROMPT='$(rprompt)'
