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
HIST_INGORE_ALL_DUPS=1
HIST_FIND_NO_DUPS=1
SAVEHIST=10000
setopt autocd nomatch appendhistory incappendhistory 
unsetopt beep extendedglob
# End of lines configured by zsh-newuser-install

#-----------------------------
# Plugins
#-----------------------------
source ~/.config/zsh/zsh-history-substring-search.zsh
source ~/.config/zsh/expand-multiple-dots.zsh
if [ -f ~/.config/zsh/generate-password.zsh ]; then
	source ~/.config/zsh/generate-password.zsh
fi

#-----------------------------
# Aliases
#-----------------------------
alias ls="ls --color=auto"
alias lsl="ls -l"
alias grep="grep --color=auto"
alias v="nvim"
alias vim="nvim"
alias open="xdg-open"
alias kdiff="kdiff3-qt"
alias ipy="ipython3"
if [ -x "$(command -v gio)" ]; then
	alias trash="gio trash"
elif [ -x "$(command -v gvfs-trash)" ]; then
	alias trash="gvfs-trash"
fi
alias pyclean="find . -type d -name '__pycache__' -exec rm -r {} +"

#-----------------------------
# Environment variables
#-----------------------------
export BROWSER="firefox"
export EDITOR="nvim"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PATH=$PATH:~/.local/bin

if [ -x "$(command -v fd)" ]; then
	# Use fd for fzf if available
	export FZF_DEFAULT_COMMAND='fd --type file'
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

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
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

#-----------------------------
# Prompt
#-----------------------------
function hostname_prompt_info {
	# only write hostname in ssh session
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		echo %F{magenta}%n@%m %f
	fi

	# write container name if inside container
	if [ -n "$CONTAINERNAME" ]; then
		echo %F{magenta}$CONTAINERNAME %f
	elif [ -e "/.dockerenv" ]; then
		echo %F{magenta}$HOSTNAME %f
	fi
}
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
function venv_prompt_info {
	if [[ -n "$VIRTUAL_ENV" ]]; then
		# Strip out the path and just leave the env name
		venv="${VIRTUAL_ENV##*/}"
		echo %F{027} py:%f%F{221}$venv %f
	fi

}
function prompt {
	echo
	echo $(hostname_prompt_info)%B%F{blue}%~%f%b$(git_prompt_info)
	# color prompt start depending on last return value
	echo '%(?.%F{cyan}.%F{red})❯ %f'
}
function rprompt {
	# show icon if there are background jobs
	echo $(venv_prompt_info)'%F{red}%(1j.⚙.)%f'
}

setopt prompt_subst
PROMPT='$(prompt)'
RPROMPT='$(rprompt)'
