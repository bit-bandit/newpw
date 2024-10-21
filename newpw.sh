#!/bin/sh

#match='a-zA-Z0-9`~!@#$%^&*()[]{}/|\?+=\-_;:<>'"'"'",.'
match='[:graph:]'
length=16
src='/dev/urandom'

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
	-s, --source FILE (= $src)
	    Source file for random bytes. See cat(1).
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
		(-s | --source)
			src="$param"

			if ! [ -r "$param" ]; then
				printf "%s\n" "$0: source file \`$param' is unreadable"
				exit 1
			fi
			;;
		(*)
			;;
	esac

	arg="$param"
done

tr -cd "$match" < "$src" | head -c "$length"
printf "\n"
