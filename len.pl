#!/usr/bin/perl

use strict;
use warnings;
use open IO => q{:bytes};

# name........: len.pl
# author......: Rub3nCT
# based on....: len.c by atom
# description.: each word into STDIN is passed to STDOUT if matches a specified word-length range.
# modified....: max-length is not mandatory.

sub usage
{
    print "\n usage: $0 min-length [max-length] < infile > outfile\n";
}

if (($#ARGV != 0) and ($#ARGV != 1)) {
    usage ();
    exit 1;
}

my ($min, $max) = @ARGV;

if ($min !~ /^\d+$/) {
    usage ();
    die "\n Error: minimum length value must be a positive integer!!!\n";
}

if ($#ARGV == 1) {
    if ($max !~ /^\d+$/) {
        usage ();
        die "\n Error: maximum length value must be a positive integer!!!\n";
    }
    if ($min > $max) {
        usage ();
        die
            "\n Error: maximum length value must be bigger than minimum length value!!!\n";
    }
}

while (<STDIN>) {
    tr/\r\n$/\n/d;
    chomp;
    next if $_ eq q{};
    next if (length ($_) < $min);
    if ($#ARGV == 1) {
        next if (length ($_) > $max);
    }
    print "$_\n";
}
