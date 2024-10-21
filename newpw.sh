#!/bin/sh

#match='a-zA-Z0-9`~!@#$%^&*()[]{}/|\?+=\-_;:<>'"'"'",.'
match='[:graph:]'
length=16
defsrc='/dev/urandom'

help() {
    cat <<EOF
$0 [OPTS..]
Generates a random password.

Options:
	-c, --length NUM (= $length)
	    Length of output password. Must be positive. See head(1).
	-f, --format STR (= $match)
	    Allowed characters. See tr(1).
    	-h, --help
	    Output this help message.
EOF
}

arg=''

for param in "$@"; do
	if [ "$param" = '-h' ] || [ "$param" = '--help' ]; then
		help
		exit
	fi

	case "$arg" in
		(-f | --format)
			match="$param"
			;;
		(-c | --length)
			length="$param"
			tmp="$(echo "$param" | tr -cd '[:digit:]')"

			if [ "$length" != "$tmp" ]; then
				printf "%s\n" "$0: length must only contain digits" >&2;
				exit 1
			fi
			;;
		(*)
			;;
	esac

	arg="$param"
done



# big hack so shell scripting can achieve what was previously considered impossible
# no additional shell or os capabilities required! no third file descriptor!
# no fifo or temporary files! fully posix! kill me!

# tries to read stdin.
# if its a terminal, an empty file, or a closed fd,
# then use the first argument as a path to a file to read instead
stdin_or_file() {
	# dont ask the terminal for data
	if [ -t 0 ]; then
		cat "$1"
		exit
	fi

	# read and consume a character as octal
	# no going back

	# when a nul byte is read from fd 0, xargs complains about it..
	# .. and then printf complains about invalid syntax..
	# .. but it writes "000" anyway, so in the end it works out.
	# if no bytes at all are sent, char becomes an empty string
	char="$(dd bs=1 count=1 2>/dev/null | xargs -I {} printf "%03o" "'{}" 2>/dev/null)"
	# if xargs -0 were in posix i could avoid one warning, oh well

	# check for actual lack of data, not a nul byte!
	if [ -z "$char" ]; then
		cat "$1"
	else # oops we got data
		# its like it was never gone
		printf "%s" "$(eval 'printf "'\\"$char"'"')"

		# catch closed fd 0 incase some smart-alec ran us with <&-
		cat 2>/dev/null || cat "$1"
	fi
}

stdin_or_file "$defsrc" | tr -cd "$match" | head -c "$length"
printf "\n"
