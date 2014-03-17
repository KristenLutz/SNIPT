#!/usr/bin/perl -w
use warnings;
use strict;

open my $in, "<", "/home/bif712_133a16/IGP/diffcheck/masterlist.csv" or die "CVS file could not be opened\n";

my @data = sort <$in>;

my $n = 0;
my @out;
my $lastline = '';
foreach my $currentline (@data) {
  next if $currentline eq $lastline;
  push @out, $currentline;
  $lastline = $currentline;
  $n++;
}

close $in;
open my $out, ">", "/home/bif712_133a16/IGP/diffcheck/masterlist.csv" or die "output file could not be opened\n";
print $out @out;
close $out;

