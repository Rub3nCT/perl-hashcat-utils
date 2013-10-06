# perl-hashcat-utils
## Set of small utilities useful for advanced password cracking

I coded this utilities for my own use, but I think they can also be useful for someone else. That's why I'm releasing them!

Most of these tools are **based on [atom's hashcat-utils](http://hashcat.net/wiki/doku.php?id=hashcat_utils "atom's hashcat-utils homepage").**

They have the same functionality / behaviour, but I have included some extra changes / improvements.  

# Tools included:

## combinator

Each word from file2 is appended to each word from file1 and then printed to STDOUT.

        usage: ./combinator.pl file1 file2 [min-length] [max-length]

**Changes/improvements:**

* Only prints uniq words to STDOUT.
* Min-length, only prints words bigger than the specified length.
* Max-length, only prints words not bigger than the specified length.

## cutb

Cut the specific prefix or suffix length off from STDIN and pass it to STDOUT.

        usage: ./cutb.pl offset [length] < infile > outfile

**Changes/improvements:**

* Only prints uniq words to STDOUT.

## len

Each word into STDIN is passed to STDOUT if matches a specified word-length range.

        usage: ./len.pl min-length [max-length] < infile > outfile

**Changes/improvements:**

* Max-length is not mandatory.  

# License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
