set fish_greeting ""

set --export PATH $PATH ~/.local/bin ~/.dotnet/tools
set --export BROWSER "firefox"
set --export EDITOR "vim"
set --export VISUAL "vim"
set --export PAGER "less"

set --export VIRTUAL_ENV_DISABLE_PROMPT 1

alias ls="ls --color=auto"
alias lsl="ls -l"
alias grep="grep --color=auto"
alias vim="nvim"
alias v="nvim"
alias ipy="ipython3"

if type -q gio
	alias trash="gio trash"
else if type -q gvfs-trash
	alias trash="gvfs-trash"
end

if type -q nodejs-yarn
	alias yarn "nodejs-yarn"
else if type -q yarnpkg
	alias yarn "yarnpkg"
end

if type -q fdfind
    alias fd "fdfind"
end

if test -e ~/.fzf
    set PATH $PATH ~/.fzf/bin
end

if type -q fd
	# Use fd for fzf if available
	set --export FZF_DEFAULT_COMMAND 'fd --type file --follow'
	set --export FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
end


set fish_prompt_pwd_dir_length 0
