#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;

my $stripblanks = 0;
my $style = "objc";

GetOptions('stripblanks' => \$stripblanks, 'style=s' => \$style);

my ($file, $macroname) = @ARGV or die <<'USAGE';
Usage: text2macro.pl [--style=<style>] [--stripblanks] <file> <macro name>
USAGE

open(my $fh, "<", $file) or die ("Couldn't read '$file'.\n");

print "#define $macroname ";

my ($start, $end);

if ($style eq "objc") { $start = '@"'; $end = '"' }
elsif ($style eq "c") { $start = '"'; $end = '"' }
else { die "Unknown style value.\n" }

while (my $line = <$fh>) {
	next if $stripblanks && $line =~ m/^\s+$/;
	
	$line =~ s/(")/\\$1/g;
	$line =~ s/\n/\\n/g;
	
	print qq/$start$line$end\\\n/;
}
