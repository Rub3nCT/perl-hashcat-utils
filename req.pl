#!/usr/bin/perl

use strict;
use warnings;
use open IO => q{:bytes};

# name........: req.pl
# author......: Rub3nCT
# based on....: req.c by atom
# description.: each word going into STDIN is passed to STDOUT if matches an specified password group criteria.
# modified....: uses multiple letters instead of integers (ludsLUDS) [lower, upper, digit, special].
# ............: lowercase characters require, uppercase characters exclude.

if ($#ARGV != 0) {
    die "\n usage: $0 req_mask < infile > outfile\n";
}

my $req_mask = $ARGV[0];
if ($req_mask !~ /^(?:[l|u|d|s]){0,4}$/i) {
    die ' Error: especified req_mask is not a valid mask criteria!!!';
}
if (   ($req_mask =~ /l/) && ($req_mask =~ /L/)
    || ($req_mask =~ /u/) && ($req_mask =~ /U/)
    || ($req_mask =~ /d/) && ($req_mask =~ /D/)
    || ($req_mask =~ /s/) && ($req_mask =~ /S/))
{
    die ' Error: especified req_mask is not a valid mask criteria!!!';
}

my ($lower, $LOWER, $upper, $UPPER, $digit, $DIGIT, $special, $SPECIAL) = (0, 0, 0, 0, 0, 0, 0, 0);

if ($req_mask =~ /l/) { $lower   = 1 }
if ($req_mask =~ /L/) { $LOWER   = 1 }
if ($req_mask =~ /u/) { $upper   = 1 }
if ($req_mask =~ /U/) { $UPPER   = 1 }
if ($req_mask =~ /d/) { $digit   = 1 }
if ($req_mask =~ /D/) { $DIGIT   = 1 }
if ($req_mask =~ /s/) { $special = 1 }
if ($req_mask =~ /S/) { $SPECIAL = 1 }

while (<STDIN>) {
    tr/\r\n//d;
    chomp;
    next if $_ eq q{};
    if ($lower == 1)   { next if ($_ !~ /[[:lower:]]/) }
    if ($LOWER == 1)   { next if ($_ =~ /[[:lower:]]/) }
    if ($upper == 1)   { next if ($_ !~ /[[:upper:]]/) }
    if ($UPPER == 1)   { next if ($_ =~ /[[:upper:]]/) }
    if ($digit == 1)   { next if ($_ !~ /[[:digit:]]/) }
    if ($DIGIT == 1)   { next if ($_ =~ /[[:digit:]]/) }
    if ($special == 1) { next if ($_ !~ /[[:punct:]\s]/) }
    if ($SPECIAL == 1) { next if ($_ =~ /[[:punct:]\s]/) }
    print "$_\n";
}
