#!/usr/bin/perl

use strict;
use warnings;
use open IO => q{:bytes};

# name........: uniq.pl
# author......: Rub3nCT
# description.: parses STDIN input and only print non duplicated strings to STDOUT.
# 				input doesn't need to be sorted.

if ($#ARGV != 0) {
    die "\n usage: $0 < infile > outfile\n";
}

my %uniq;

while (<>) {
	tr/\r\n//d;
	chomp;
	$uniq{$_}++;
	next if $uniq{$_} > 1;
	print "$_\n";
}
