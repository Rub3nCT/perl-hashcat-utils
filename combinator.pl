#!/usr/bin/perl

use strict;
use warnings;
use open IO => q{:bytes};

# name........: combinator.pl
# author......: Rub3nCT
# based on....: combinator.c by atom
# description.: each word from file2 is appended to each word from file1 and then printed to STDOUT.
# added.......: only prints uniq words to STDOUT (-u / --uniq).
# ............: min-length, only prints words bigger than the specified length.
# ............: max-length, only prints words not bigger than the specified length.

sub usage
{
    print "\n usage: $0 [-u] file1 file2 [min-length] [max-length]\n";
}

my ($uniq, $file1, $file2, $min, $max) = (0, q{}, q{}, 0, 0);

if (($#ARGV < 1) || ($#ARGV > 4)) {
    usage ();
    exit 1;
}

if ($#ARGV == 1) {
    if (($ARGV[0] eq '-u') || ($ARGV[0] eq '--uniq')) {
        usage ();
        die "\n Error: invalid arguments specified!!!\n";
    }
    else {
        $file1 = $ARGV[0];
        $file2 = $ARGV[1];
    }
}

if ($#ARGV == 2) {
    if (($ARGV[0] eq '-u') || ($ARGV[0] eq '--uniq')) {
        $uniq  = 1;
        $file1 = $ARGV[1];
        $file2 = $ARGV[2];
    }
    else {
        $file1 = $ARGV[0];
        $file2 = $ARGV[1];
        $min   = $ARGV[2];
    }
}

if ($#ARGV == 3) {
    if (($ARGV[0] eq '-u') || ($ARGV[0] eq '--uniq')) {
        $uniq  = 1;
        $file1 = $ARGV[1];
        $file2 = $ARGV[2];
        $min   = $ARGV[3];
    }
    else {
        $file1 = $ARGV[0];
        $file2 = $ARGV[1];
        $min   = $ARGV[2];
        $max   = $ARGV[3];
    }
}

if ($#ARGV == 4) {
    if (($ARGV[0] eq '-u') || ($ARGV[0] eq '--uniq')) {
        $uniq  = 1;
        $file1 = $ARGV[1];
        $file2 = $ARGV[2];
        $min   = $ARGV[3];
        $max   = $ARGV[4];
    }
    else {
        usage ();
        die "\n Error: invalid arguments specified!!!\n";
    }
}

if ($min != 0) {
    if ($min !~ /^\d+$/) {
        usage ();
        die "\n Error: minimum length value must be a positive integer!!!\n";
    }
}

if ($max != 0) {
    if ($max !~ /^\d+$/) {
        usage ();
        die "\n Error: maximum length value must be a positive integer!!!\n";
    }
}

if (($min != 0) and ($max != 0)) {
    if ($min > $max) {
        usage ();
        die
            "\n Error: maximum length value must be bigger than minimum length value!!!\n";
    }
}

open my $FH1, '<', $file1
    or die "\n Error: couldn't open $file1 for reading!!!\n";
open my $FH2, '<', $file2
    or die "\n Error: couldn't open $file2 for reading!!!\n";

if ($uniq == 1) {

    my %uniq;

    while (my $str1 = <$FH1>) {
        seek $FH2, 0, 0;
        $str1 =~ tr/\r\n$/\n/d;
        chomp $str1;
        next if $str1 eq q{};

        while (my $str2 = <$FH2>) {
            $str2 =~ tr/\r\n$/\n/d;
            chomp $str2;
            next if $str2 eq q{};
            my $str = $str1 . $str2;
            if ($min != 0) {
                next if (length ($str) < $min);
            }
            if ($max != 0) {
                next if (length ($str) > $max);
            }
            $uniq{$str}++;
            next if $uniq{$str} > 1;
            print "$str\n";
        }
    }
}

else {
    while (my $str1 = <$FH1>) {
        seek $FH2, 0, 0;
        $str1 =~ tr/\r\n$/\n/d;
        chomp $str1;
        next if $str1 eq q{};

        while (my $str2 = <$FH2>) {
            $str2 =~ tr/\r\n$/\n/d;
            chomp $str2;
            next if $str2 eq q{};
            my $str = $str1 . $str2;
            if ($min != 0) {
                next if (length ($str) < $min);
            }
            if ($max != 0) {
                next if (length ($str) > $max);
            }
            print "$str\n";
        }
    }
}
close $FH1 or warn " Warning: unable to close $FH1!!!";
close $FH2 or warn " Warning: unable to close $FH2!!!";
