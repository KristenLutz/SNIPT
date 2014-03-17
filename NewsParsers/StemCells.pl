#!/usr/bin/perl -w
use strict;

# This program pulls the journal names, article titles, pubdate, doi and links from
# "Stem Cells'" newsfeeds and writes them to a file called 'masterlist.csv

use open ':std', ':encoding(UTF-8)';
use WWW::Mechanize;

my $mech = WWW::Mechanize->new();
my $url = "http://onlinelibrary.wiley.com/rss/journal/10.1002/(ISSN)1549-4918";
    
$mech ->get($url);
my $source_code = $mech->content;
# get the source code

my @journal_title = ();
my @ar_title = ();
my @ar_pubdate = ();
my @ar_doi = ();
my @ar_links = ();
my @ar_abstracts = ();

my @crawl_summary = ();
# set up the arrays to hold relevant information

while ($source_code =~ /<item(.+?)<title>(.+?)<\/title>(.+?)<link>(.+?)<\/link>(.+?)<dc:date(.+?)>(.+?)<\/dc:date>(.+?)<prism:doi(.+?)>(.+?)<\/prism:doi>(.+?)<description>(.+?)<\/description>/gis) {
    #   $2 -> ar title   $4 -> link       
    #   $7 -> date       $10 -> doi
    #   $12 -> abstract
    
    my $journal_title = 'Stem Cells';
    my $pubdate = substr $7,0,10;
    my $abstract = 'null';
    
    if ($12) {
        $abstract = $12;
        $abstract =~ s/^\s+//;
        $abstract =~ s/\s+$//;
    } 
    
    push @journal_title, $journal_title;
    push @ar_title, $2;
    push @ar_pubdate, $pubdate;
    push @ar_doi, $10;
    push @ar_links, $4;
    push @ar_abstracts, $abstract;
}

foreach (@ar_pubdate, @ar_abstracts) {
    $_ =~ s/,//g;
}
# get rid of commas that would otherwise mess up CSV file

for (my $i=0;$i<scalar @journal_title;$i++) {
    my @entry_array = (
        $journal_title[$i],
        $ar_pubdate[$i],
        $ar_title[$i],
        $ar_doi[$i],
        $ar_links[$i],
        $ar_abstracts[$i]
        );
    
    my $entry_string = join ",", @entry_array;
    unshift @crawl_summary, $entry_string;
}

open my $fh, ">>", "masterlist.csv" or die 'Error writing file list.csv';

foreach (@crawl_summary) {
    print $fh "$_\n";
}

close $fh;

#print "$ar_abstracts[1]\n";