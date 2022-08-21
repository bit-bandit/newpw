# newpw.sh

A POSIX shell script that generates passwords. Here's the help text:

```
./newpw.sh [OPTS..]
Generates a random password.

Options:
	-c, --length NUM (= 16)
	    Length of output password. Must be positive. See head(1).
	-f, --format STR (= [:graph:])
	    Allowed characters. See tr(1).
    	-h, --help
	    Output this help message.
	-p, --printf STR (= %s\n)
	    Format string when printing. See printf(1).
        -s, --source FILE (= /dev/urandom)
	    Source file for random bytes. See cat(1).
```

----
The license is 0BSD. Check [LICENSE](/LICENSE) for more information.
