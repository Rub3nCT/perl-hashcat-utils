#!/usr/bin/perl

use strict;
use warnings;
use open IO => q{:bytes};

# name........: cutb.pl
# author......: Rub3nCT
# based on....: cutb.c by atom
# description.: cut the specific prefix or suffix length off STDIN and pass it to STDOUT.
# added.......: only prints uniq words to STDOUT.

if (($#ARGV != 0) and ($#ARGV != 1)) {
    die "\n usage: $0 offset [length] < infile > outfile\n";
}

my $offset = $ARGV[0];
if ($offset !~ /^[-]?\d+$/) {
    die "\n Error: offset value must be an integer!!!\n";
}

my $length = 0;
if ($#ARGV == 1) {
    $length = $ARGV[1];
    if ($length !~ /^[-]?\d+$/) {
        die "\n Error: length value must be an integer!!!\n";
    }
}

my %uniq;

while (<STDIN>) {
    tr/\r\n//d;
    chomp;
    next if $_ eq q{};
    my $str = substr $_, $offset;
    $uniq{$str}++;
    next if $uniq{$str} > 1;
    if ($#ARGV == 1) {
        $str = substr $_, $offset, $length;
    }
    print "$str\n";
}
