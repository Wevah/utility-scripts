#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;

my $stripblanks = 0;

GetOptions('stripblanks' => \$stripblanks);

my $file = $ARGV[0] or die("I need a file.\n");
my $macroname = $ARGV[1] or die("I need a macro name.\n");

open(my $fh, "<", $file) or die ("Couldn't read '$file'.\n");

print "#define $macroname ";

while (my $line = <$fh>) {
	next if $stripblanks && $line =~ m/^\s+$/;
	
	$line =~ s/(")/\\$1/g;
	$line =~ s/\n/\\n/g;
	print qq/@"$line" \\\n/;
}
