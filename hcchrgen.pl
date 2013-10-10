#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use Digest::MD5;

# name.........: hcchrgen.pl
# author.......: Rub3nCT
# description..: automates the process of creating hcchr charset files for hashcat with
#                different encodings for each language.
#
# requirements.:
#    - iconv GNU binary, needed to convert between different encodings.
#    - 'UTF8' folder must contain UTF-8 encoded files with the most common characters.
#    - 'UTF8/Special' folder can contain files that also include special characters.
#
# results......:
#    - 'Charsets/Standard' folder charset files will include the most common characters
#      (with the corresponding encodings to each language).
#    - 'Charsets/Special' folder charset files will include special characters (with the
#      corresponding encodings to each language).
#    - 'Charsets/Combined' folder will contain all the characters from all the encodings
#      of each language merged.
#    - Duplicated results are removed (different encodings wich produce the same output).

# Not for Windows!!! Probably won't have iconv...
if ($^O eq 'MSWin32') {
    die " Sorry, Windows systems are not supported\n";
}

my %languages = (
    Arabic     => [ 'ar',    [ 'cp1256', 'ISO-8859-6' ] ],
    Bulgarian  => [ 'bg',    [ 'cp1251', 'ISO-8859-5', 'KOI8-R' ] ],
    Castilian  => [ 'es-ES', [ 'cp1252', 'ISO-8859-1', 'ISO-8859-15' ] ],     # dudux & Rub3nCT
    Catalan    => [ 'ca',    [ 'cp1252', 'ISO-8859-1', 'ISO-8859-15' ] ],     # dudux & Rub3nCT
    English    => [ 'en',    [ 'cp1252', 'ISO-8859-1', 'ISO-8859-15' ] ],     # atom
    French     => [ 'fr',    [ 'cp1252', 'ISO-8859-1', 'ISO-8859-15', ] ],    # Rub3nCT
    German     => [ 'de',    [ 'cp1252', 'ISO-8859-1', 'ISO-8859-15' ] ],     # atom
    Greek      => [ 'el',    [ 'cp1253', 'ISO-8859-7' ] ],                    # m3g9tr0n
    Italian    => [ 'it',    [ 'cp1252', 'ISO-8859-1', 'ISO-8859-15' ] ],     # Rub3nCT
    Latvian    => [ 'lv',    [ 'cp1257', 'ISO-8859-4', 'ISO-8859-13' ] ],
    Lithuanian => [ 'lt',    [ 'cp1257', 'ISO-8859-4', 'ISO-8859-13' ] ],     # kt819gm
    Persian    => [ 'fa',    [ 'cp1256', 'ISO-8859-6' ] ],
    Portuguese => [ 'pt',    [ 'cp1252', 'ISO-8859-1', 'ISO-8859-15' ] ],     # Rub3nCT
    Romanian   => [ 'ro',    [ 'cp1250', 'ISO-8859-2', 'ISO-8859-16' ] ],
    Russian    => [ 'ru',    [ 'cp1251', 'ISO-8859-5', 'KOI8-R' ] ],          # Rolf
    Slovak     => [ 'sk',    [ 'cp1250', 'ISO-8859-2' ] ],                    # Kuci
    Spanish    => [ 'es',    [ 'cp1252', 'ISO-8859-1', 'ISO-8859-15' ] ],     # dudux & Rub3nCT
    Ukrainian  => [ 'uk',    [ 'cp1251', 'ISO-8859-5', 'KOI8-U' ] ],
);

foreach my $lang (sort keys %languages) {
    for ('standard', 'special', 'combined') {
        foreach my $encoding (@{ $languages{$lang}[1] }) {
            my $ISO639 = $languages{$lang}[0];
            my $sub    = \&{$_};
            $sub->($encoding, $ISO639, $lang);
        }
    }
}

if (!-d 'UTF8') {
    die " UTF8 directory not found!!!\n Please place UTF-8 language files there...\n";
}

# To store MD5 of generated files and remove duplicated results
my %charsets;
my %combined;

#
# Create Standard encoding files for each language (including the most common characters)
#
sub standard
{
    my ($encoding, $ISO639, $lang) = @_;

    # Only if UTF-8 file exists
    if (-e "UTF8/$lang.charset") {

        # Make language directory if not exists
        if (!-d "Charsets/Standard/$lang") {
            system "mkdir -p Charsets/Standard/$lang";
        }

        # Create corresponding encoding
        system "iconv UTF8/$lang.charset -c -f utf8 -t $encoding > Charsets/Standard/$lang/$ISO639"
          . "_$encoding.hcchr.tmp";

        # Sort and remove duplicated characters using HEX values
        my $tmp = "Charsets/Standard/$lang/$ISO639" . "_$encoding.hcchr.tmp";
        open my $TMP, '<', $tmp;
        my $chars = <$TMP>;    # Get first line of file (always contains only one line)
        close $TMP;
        unlink "$tmp";
        my @chars = split(//, $chars);
        my @sorted = HEX(@chars);

        # Print characters to file
        my $charset = "Charsets/Standard/$lang/$ISO639" . "_$encoding.hcchr";
        open my $FINAL, '>', $charset;
        foreach my $hextring (@sorted) {
            my $string = pack(qq{H*}, qq{$hextring});
            printf $FINAL $string;
        }
        close $FINAL;

        # Remove if file is duplicated (different encodings may produce the same output)
        my $file = "Charsets/Standard/$lang/$ISO639" . "_$encoding.hcchr";
        open my $FH, '<', $file;
        binmode($FH);
        my $MD5 = Digest::MD5->new->addfile($FH)->hexdigest;
        $charsets{$MD5}++;
        if ($charsets{$MD5} > 1) {
            unlink "$file";
        }
        else {
            print " [+] $ISO639"
              . "_$encoding.hcchr ("
              . scalar @sorted
              . " characters) generated!\n";
        }

        # Remove empty folders (rmdir doesn't remove non empty folders)
        system "rmdir Charsets/Standard/$lang 2>/dev/null";
    }
}

#
# Create Special encoding files for each language (including more special characters)
#
sub special
{
    my ($encoding, $ISO639, $lang) = @_;

    # Only if UTF-8 file exists
    if (-e "UTF8/Special/$lang.charset") {

        if (!-d "Charsets/Special/$lang") {
            system "mkdir -p Charsets/Special/$lang";
        }

        # Create corresponding encoding
        system
          "iconv UTF8/Special/$lang.charset -c -f utf8 -t $encoding > Charsets/Special/$lang/$ISO639"
          . "_$encoding-special.hcchr.tmp";

        # Sort and remove duplicated characters using HEX values
        my $tmp = "Charsets/Special/$lang/$ISO639" . "_$encoding-special.hcchr.tmp";
        open my $TMP, '<', $tmp;
        my $chars = <$TMP>;    # Get first line of file (will always contain only one line)
        close $TMP;
        unlink "$tmp";
        my @chars = split(//, $chars);
        my @sorted = HEX(@chars);

        # Print characters to file
        my $charset = "Charsets/Special/$lang/$ISO639" . "_$encoding-special.hcchr";
        open my $FINAL, '>', $charset;
        foreach my $hextring (@sorted) {
            my $string = pack(qq{H*}, qq{$hextring});
            printf $FINAL $string;
        }
        close $FINAL;

        # Remove if file is duplicated (different encodings may produce the same output)
        my $file = "Charsets/Special/$lang/$ISO639" . "_$encoding-special.hcchr";
        open my $FH, '<', $file;
        binmode($FH);
        my $MD5 = Digest::MD5->new->addfile($FH)->hexdigest;
        $charsets{$MD5}++;
        if ($charsets{$MD5} > 1) {
            unlink "$file";    # Delete file if is duplicated
        }
        else {
            print " [-] $ISO639"
              . "_$encoding-special.hcchr ("
              . scalar @sorted
              . " characters) generated!\n";
        }

        # Remove empty folders (rmdir doesn't remove non empty folders)
        system "rmdir Charsets/Special/$lang 2>/dev/null";
    }
}

#
# Combine all the generated encodings of each language and create a Combined charset
# (without duplicated characters)
#
sub combined
{
    my ($encoding, $ISO639, $lang) = @_;

    if (-d "Charsets/Standard/$lang") {

        # Make this only one time for each language
        $combined{$ISO639}++;
        if ($combined{$ISO639} == 1) {

            # Copy all the Standard and Special generated .hcchr
            if (!-d 'Charsets/Combined/Temp') {
                system 'mkdir -p Charsets/Combined/Temp';
            }
            system "cp Charsets/Standard/$lang/*.hcchr Charsets/Combined/Temp";
            if (-d "Charsets/Special/$lang") {
                system "cp Charsets/Special/$lang/*.hcchr Charsets/Combined/Temp";
            }
            system "cat Charsets/Combined/Temp/*.hcchr > Charsets/Combined/$lang.all";
            my $in  = "Charsets/Combined/$lang.all";
            my $out = "Charsets/Combined/$lang.hcchr";
            open my $IN,  '<', $in;
            open my $OUT, '>', $out;

            # Sort and remove duplicated characters using HEX values
            my $chars = <$IN>;    # Get first line of file (always contain only one line)
            close $IN;
            my @chars = split(//, $chars);
            my @sorted = HEX(@chars);

            # Print characters to file
            foreach my $hextring (@sorted) {
                my $string = pack(qq{H*}, qq{$hextring});
                printf $OUT $string;
            }
            close $OUT;

            # Remove if file is duplicated (different encodings may produce the same output)
            my $file = "Charsets/Combined/$lang.hcchr";
            open my $FH, '<', $file;
            binmode($FH);
            my $MD5 = Digest::MD5->new->addfile($FH)->hexdigest;
            $charsets{$MD5}++;
            if ($charsets{$MD5} > 1) {
                unlink "$file";
            }
            else {
                print " [*] $lang.hcchr with " . scalar @sorted . " uniq characters generated!\n\n";
            }

            # Delete temporal files
            system 'rm -rf Charsets/Combined/Temp 2>/dev/null';
            unlink "$in";
        }
    }
}

#
# Remove characters already included in hashcat default charset and duplicated characters
#
sub HEX
{
    my %hashcat;
    my @notincluded;
    my @included = (
        ' ', '!', '"', '#', '$', '%', '&',  '\'', '(', ')', '*', '+', ',', '-',
        '.', '/', '0', '1', '2', '3', '4',  '5',  '6', '7', '8', '9', ':', ';',
        '<', '=', '>', '?', '@', '[', '\\', ']',  '^', '_', '`', '{', '|', '}',
        '~', 'a', 'b', 'c', 'd', 'e', 'f',  'g',  'h', 'i', 'j', 'k', 'l', 'm',
        'n', 'o', 'p', 'q', 'r', 's', 't',  'u',  'v', 'w', 'x', 'y', 'z', 'A',
        'B', 'C', 'D', 'E', 'F', 'G', 'H',  'I',  'J', 'K', 'L', 'M', 'N', 'O',
        'P', 'Q', 'R', 'S', 'T', 'U', 'V',  'W',  'X', 'Y', 'Z'
    );

    # Remove characters already included in hashcat default charset
    @hashcat{@included} = ();
    foreach my $char (@_) {
        push(@notincluded, $char) if (!exists $hashcat{$char});
    }

    # Remove duplicated characters (based on their HEX values)
    my %seen;
    my @uniq;
    foreach my $string (@notincluded) {
        my $hextring = unpack(q{H*}, $string);
        $seen{$hextring}++;
        next if $seen{$hextring} > 1;
        push @uniq, $hextring;
    }

    # Sort characters
    my @sorted = sort { $a cmp $b } @uniq;
    return @sorted;
}
