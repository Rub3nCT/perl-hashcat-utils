#!/usr/bin/perl

use strict;
use warnings;
use open IO => q{:bytes};

# name........: combinator.pl
# author......: Rub3nCT
# based on....: combinator.c by atom
# description.: each word from file2 is appended to each word from file1 and then printed to STDOUT.
# added.......: only prints uniq words to STDOUT.
# ............: min-length, only prints words bigger than the specified length.
# ............: max-length, only prints words not bigger than the specified length.

if (($#ARGV < 1) or ($#ARGV > 3)) {
    die "\n usage: $0 file1 file2 [min-length] [max-length]\n";
}

my $file1 = $ARGV[0];
my $file2 = $ARGV[1];

my $min;
if ($#ARGV >= 2) {
    $min = $ARGV[2];
    if ($min !~ /^\d+$/) {
        die "\n Error: minimum length value must be a positive integer!!!\n";
    }
}

my $max;
if ($#ARGV == 3) {
    $max = $ARGV[3];
    if ($max !~ /^\d+$/) {
        die "\n Error: maximum length value must be a positive integer!!!\n";
    }
    if ($min > $max) {
        die "\n Error: maximum length value must be bigger than minimum length value!!!\n";
    }
}

open my $FH2, '<', $file2 or die "\n Error: Couldn't open $file2 for reading!!!\n";

my @file2;

while (<$FH2>) {
    tr/\r\n//d;
    chomp;
    next if $_ eq q{};
    push @file2, $_;
}
close $FH2 or warn " Warning: unable to close $FH2!!!";

open my $FH1, '<', $file1 or die "\n Error: Couldn't open $file1 for reading!!!\n";

my %uniq;

while (<$FH1>) {
    tr/\r\n//d;
    chomp;
    next if $_ eq q{};
    foreach my $append (@file2) {
        my $str = "$_$append";
        if ($#ARGV >= 2) {
            next if (length($str) < $min);
        }
        if ($#ARGV == 3) {
            next if (length($str) > $max);
        }
        $uniq{$str}++;
        next if $uniq{$str} > 1;
        print "$str\n";
    }
}
close $FH1 or warn " Warning: unable to close $FH1!!!";
