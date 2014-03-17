#!/usr/bin/perl -w
use strict;

# This program pulls the journal names, article titles, pubdate, doi and links from
# "Stem Cells and Development"'s newsfeeds and writes them to a file called 'masterlist.csv

use open ':std', ':encoding(UTF-8)';
use WWW::Mechanize;

require "date_converter.lib";
# does not follow a XXXX-XX-XX format, needs to be converted

my $mech = WWW::Mechanize->new();
my $url = "http://online.liebertpub.com/action/showFeed?mi=cjwv&ai=su&jc=SCD&type=etoc&feed=rss";

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

while ($source_code =~ /<item>(.+?)<title>(.+?)<\/title>(.+?)<link>(.+?)\?ai(.+?)<\/link>(.+?)<description>(.+?)<\/description>(.+?)<pubDate>(.+?)<\/pubDate>(.+?)<\/item>/gis) {
#   $2 title
#   $4 link
#   $6 journal title
#   $8 pubdate

    my $journal_title = 'Stem Cells and Development';
     my $article_doi = substr $4, 37, 21;
    
    push @journal_title, $journal_title;
    push @ar_title, $2;
    push @ar_pubdate, YYYYMMDD($9);
    push @ar_links, $4;
    push @ar_doi, $article_doi;
    
    my $mech_abs = WWW::Mechanize->new();
    $mech_abs ->get($4);
    my $source_code_abs = $mech_abs->content;
    
    my $abstract = 'null';
    if ($source_code_abs =~/<div class="abstractSection"> *<p class=(.+?)>(.+?)<\/p>/gis) {
        $abstract = $2;
    }
    push @ar_abstracts, $abstract;
}

foreach (@ar_title, @journal_title, @ar_pubdate, @ar_abstracts) {
    $_ =~ s/,//g;
}

for (my $i=0;$i<scalar @journal_title;$i++) {
    my @entry_array = (
        $journal_title[$i],
        $ar_pubdate[$i],
        $ar_title[$i],
        $ar_doi[$i],
        $ar_links[$i],
        $ar_abstracts[$i]);
    my $entry_string = join ",", @entry_array;
    unshift @crawl_summary, $entry_string;
}

open my $fh, ">>", "masterlist.csv" or die 'Error writing file list.csv';
foreach (@crawl_summary) {
    print $fh "$_\n";
}

close $fh;

__DATA__
<div class="abstractSection"> <p class=(.+?)>(.+?)<\/p>