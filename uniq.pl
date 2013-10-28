#!/usr/bin/perl

use strict;
use warnings;
use open IO => q{:bytes};

# name........: uniq.pl
# author......: Rub3nCT
# description.: parses STDIN input and only print non duplicated strings to STDOUT.
# 				input data doesn't need to be sorted.

if ($#ARGV != -1) {
    die "\n usage: $0 < infile > outfile\n";
}

my %uniq;

while (<STDIN>) {
    tr/\r\n$/\n/d;
    chomp;
    $uniq{$_}++;
    next if $uniq{$_} > 1;
    print "$_\n";
}
