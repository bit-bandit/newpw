#!/bin/sh

#match='a-zA-Z0-9`~!@#$%^&*()[]{}/|\?+=\-_;:<>'"'"'",.'
match='[:graph:]'
length=16
format='%s\n'
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
	-p, --printf STR (= $format)
	    Format string when printing. See printf(1).
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
			continue
			;;
		(-c | --length)
			length="$param"

			case "$length" in
				([:digit:]+)
					continue;
					;;
				(*)
					printf "$0: length must only contain 0-9\n" >&2;
					exit 1;
					;;
			esac
			;;
		(-p | --printf)
			format="$param"
			continue
			;;
		(-s | --source)
			src="$param"
			;;
		(*)
			;;
	esac

	arg="$param"
done

printf "$format" "$(cat "$src" | tr -cd "$match" | head -c "$length")"
