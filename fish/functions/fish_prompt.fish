function fish_prompt
	set_color -b blue
	set_color black
	set -l CWD (string replace $HOME \~ (pwd))
	if test (string length "$CWD") -gt 30
		# only shorten prompt if its too long
		set CWD (prompt_pwd)
	end
	echo -n " "$CWD" "

	set_color normal
	set_color blue

	set -l branch (git rev-parse --abbrev-ref HEAD ^/dev/null)
	if test $status -eq 0
		set -l color "green"
		set -l icon ""
		if test (count (git status -s)) -ne 0
			set color "yellow"
			set icon "±"
		end

		set_color -b $color
		echo -n ""

		set_color black
		echo -n "  "$branch" $icon"

		set_color normal
		set_color $color
		echo -n ""
	else
		echo -n ""
	end

	set_color normal
	echo " "
end
