function hostname_prompt_info
	set_color magenta
	# only write hostname in ssh session
	if test -n "$SSH_CLIENT" || test -n "$SSH_TTY"
		echo -s ""(id -nu)"@"(hostname)" "
	end

	# write container name if inside container
	if test -n "$CONTAINERNAME"
		echo -s "$CONTAINERNAME "
	else if test -e "/.dockerenv"
		echo -s "$HOSTNAME "
	end
	set_color normal
end

function git_prompt_info
	set -l branch (git rev-parse --abbrev-ref HEAD 2> /dev/null)
	if test $status -eq 0
		set -l color "green"
		set -l icon ""
		# try to get the status in under a second
		set -l git_status (timeout --foreground 1 git status -s)
		if test $status -ne 0
			set color "yellow"
			set icon "??"
		else
			set -l git_dirty (echo $git_status | wc -w)
			if test $git_dirty -ne 0
				set color "yellow"
				set icon "±"
			end
		end
		echo -n -s (set_color $color)"  $branch $icon"
		set_color normal
	end
end

function fish_prompt --description 'Write out the prompt'
	echo
	echo -n -s (hostname_prompt_info)
	echo -n -s (set_color --bold blue)(prompt_pwd)(set_color normal)
	echo -n -s (git_prompt_info)
	echo ''

	# show red gear if there are background jobs
	set -l num_jobs (jobs -l | wc -l)
	if test $num_jobs -gt 0
		echo -n -s (set_color red)'⚙ '
	end

	# color prompt start depending on last return value
	if test $status -eq 0
		set_color cyan
	else
		set_color red
	end

	echo -n '❯ '
	set_color normal
	echo ''
end

function venv_prompt_info
	if test -n "$VIRTUAL_ENV"
		# Strip out the path and just leave the env name
		set -l venv (echo $VIRTUAL_ENV | sed 's^.*/^^')
		echo (set_color 306998)" py:"(set_color ffd43b)"$venv "
		set_color normal
	end
end

function fish_right_prompt
	echo -n -s (venv_prompt_info)

	echo -n -s ' '
	set_color normal
end
