# newpw.sh

A POSIX shell script that generates passwords. Here's the help text:

```
./newpw.sh [OPTS..]
Generates a random password.

Options:
	-c, --length NUM (= 16)
	    Length of output password. Must be positive, and include only digits. See head(1).
	-f, --format STR (= [:graph:])
	    Character class of allowed characters in the password. See tr(1).
    	-h, --help
	    Output this help message.
```

----
The license is 0BSD. Check [LICENSE](/LICENSE) for more information.
