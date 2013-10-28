#!/usr/bin/perl

use strict;
use warnings;
use open IO => q{:bytes};

# name........: cutb.pl
# author......: Rub3nCT
# based on....: cutb.c by atom
# description.: cut the specific prefix or suffix length off STDIN and pass it to STDOUT.
# added.......: only prints uniq words to STDOUT (-u / --uniq).

sub usage
{
    print "\n usage: $0 [-u] offset [length] < infile > outfile\n";
}

if (($#ARGV < 0) or ($#ARGV > 2)) {
    usage ();
    exit 1;
}

my ($uniq, $offset, $length) = (0, 0, 0);

if ($#ARGV == 0) {
    if (($ARGV[0] eq '-u') or ($ARGV[0] eq '--uniq')) {
        usage ();
        die "\n Error: an offset value must be specified!!!\n";
    }
    else {
        $offset = $ARGV[0];
    }
}

if ($#ARGV == 1) {
    if (($ARGV[0] eq '-u') or ($ARGV[0] eq '--uniq')) {
        $uniq   = 1;
        $offset = $ARGV[1];
    }
    else {
        $offset = $ARGV[0];
        $length = $ARGV[1];
    }
}

if ($#ARGV == 2) {
    if (($ARGV[0] eq '-u') or ($ARGV[0] eq '--uniq')) {
        $uniq   = 1;
        $offset = $ARGV[1];
        $length = $ARGV[2];
    }
    else {
        usage ();
        die "\n Error: invalid arguments specified!!!\n";
    }
}

if ($offset !~ /^[-]?\d+$/) {
    usage ();
    die "\n Error: offset value must be an integer!!!\n";
}

if ($length !~ /^[-]?\d+$/) {
    usage ();
    die "\n Error: length value must be an integer!!!\n";
}

if ($uniq == 1) {

    my %uniq;

    while (<STDIN>) {
        tr/\r\n$/\n/d;
        chomp;
        next if $_ eq q{};
        my $str = $_;
        if ($length != 0) {
            $str = substr $_, $offset, $length;
        }
        else {
            $str = substr $_, $offset;
        }
        next if $str eq q{};
        $uniq{$str}++;
        next if $uniq{$str} > 1;
        print "$str\n";
    }
}

else {
    while (<STDIN>) {
        tr/\r\n$/\n/d;
        chomp;
        next if $_ eq q{};
        my $str = $_;
        if ($length != 0) {
            $str = substr $_, $offset, $length;
        }
        else {
            $str = substr $_, $offset;
        }
        next if $str eq q{};
        print "$str\n";
    }
}
