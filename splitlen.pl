#!/usr/bin/perl

use strict;
use warnings;
use open IO => q{:bytes};

# name........: splitlen.pl
# author......: Rub3nCT
# based on....: splitlen.c by atom
# description.: split STDIN into specific files based on string lengths.
# added.......: if the destination directory doesn't exist, then it's created.
# ............: if a file corresponding to some length is empty, then it's deleted.

if ($#ARGV != 0) {
    die "\n usage: $0 outdir < infile\n";
}

my $out = $ARGV[0];
if (!-d $out) {
    print " Directory $out not found...\n";
    mkdir $out
        or die " Error: unable to create $out directory for writing!!!";
    print " Directory $out created!!!\n\n";
}

my @files = qw(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15);
my @fh;
foreach my $file (0 .. $#files) {
    open $fh[$file], '>', "$out/$files[$file]"
        or die "\n Error: Couldn't open $out/$files[$file] for writing!!!\n";
}

while (<STDIN>) {
    tr/\r\n$/\n/d;
    chomp;
    next if $_ eq q{};
    my $length = length $_;
    if ($length <= 15) {
        print {$fh[ $length - 1 ]} "$_\n";
    }
}

foreach my $file (0 .. $#files) {
    close $fh[$file]
        or warn "\n Warning: unable to close $out/$files[$file]!!!\n";
    if (-z "$out/$files[$file]") {
        unlink "$out/$files[$file]"
            or warn
            "\n Warning: unable to remove blank file $out/$files[$file]!!!\n";
    }
}
