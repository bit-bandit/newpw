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

set --

# todo: check for EOF in fd 0 and account for it by using /dev/urandom
# likely abusing `0<filename command [args]`
if [ -t 0 ]; then
	set -- "$defsrc"
fi

cat "$@" | tr -cd "$match" | head -c "$length"
printf "\n"
