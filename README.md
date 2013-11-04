# Perl-hashcat-utils
## Small set of utilities useful for advanced password cracking

I coded this utilities for my own use, but I think they can also be useful for someone else. That's why I'm releasing them!

Most of these tools are **based on [atom's hashcat-utils](http://hashcat.net/wiki/doku.php?id=hashcat_utils "atom's hashcat-utils homepage").**

They have the same functionality / behaviour, but I have included some extra changes / improvements. Official hashcat-utils and GNU utilities are faster as Perl is an interpreted language, so use them unless you really need these improvements.

# Tools included:

## combinator

Each word from file2 is appended to each word from file1 and then printed to STDOUT.

        usage: ./combinator.pl [-u] file1 file2 [min-length] [max-length]

**Changes / improvements:**

* Only prints uniq words to STDOUT (-u / --uniq).
* Min-length, only prints words bigger than the specified length.
* Max-length, only prints words not bigger than the specified length.

## cutb

Cut the specific prefix or suffix length off from STDIN and pass it to STDOUT.

        usage: ./cutb.pl [-u] offset [length] < infile > outfile

**Changes / improvements:**

* Only prints uniq words to STDOUT (-u / --uniq).

## hcchrgen

Automates the process of creating hcchr charset files for hashcat with different encodings for each language.

        usage: ./hcchrgen.pl

You can find more info on [this hashcat's forum thread](http://hashcat.net/forum/thread-2046.html) and [this hashcat's trac ticket](https://hashcat.net/trac/ticket/55).

**Thanks to:** atom, dudux, HASH-IT, Immy, K4r0lSz, kt819gm, Kuci, m3g9tr0n and Rolf.

*Everyone who wants to collaborate with more charsets is welcome!!!!!*

**Requirements:**

* iconv GNU binary, needed to convert between different encodings.
* 'UTF8' folder must contain UTF-8 encoded files with the most common characters.
* 'UTF8/Special' folder can contain files that also include special characters.

**Results:**

* 'Charsets/Standard' folder charset files will include the most common characters (with the corresponding encodings to each language).
* 'Charsets/Special' folder charset files will include special characters (with the corresponding encodings to each language).
* 'Charsets/Combined' folder will contain all the characters from all the encodings of each language merged.
* Duplicated results are removed (different encodings which produce the same output).

## len

Each word into STDIN is passed to STDOUT if matches a specified word-length range.

        usage: ./len.pl min-length [max-length] < infile > outfile

**Changes / improvements:**

* Max-length is not mandatory.

## req

Each word going into STDIN is passed to STDOUT if matches an specified password group criteria.

        usage: ./req.pl req_mask < infile > outfile

**Changes / improvements:**

* Uses multiple letters instead of integers (ludsLUDS) [lower, upper, digit, special].
* Lowercase characters _require_, uppercase characters _exclude_.

## splitlen

Split STDIN into specific files based on string lengths.

        usage: ./splitlen.pl outdir < infile

**Changes / improvements:**

* If the destination directory doesn't exist, then it's created.
* If a file corresponding to some length is empty, then it's deleted.

## uniq

Parses STDIN input and only print non duplicated strings to STDOUT.

        usage: ./uniq.pl < infile > outfile

**Changes / improvements:**

* Input data doesn't need to be sorted.

# License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
