#!/usr/bin/perl -w
use strict;

# This program pulls the journal names, article titles, pubdate, doi and links from
# "Cell"'s newsfeeds and writes them to a file called 'masterlist.csv

use open ':std', ':encoding(UTF-8)';
use WWW::Mechanize;

require "../SubRoutines/date_converter.lib";
# does not follow a XXXX-XX-XX format, needs to be converted

my $mech = WWW::Mechanize->new();

my @nature_url_list = qw/
http:\/\/www.cell.com\/rssFeed\/cell-stem-cell\/rss.NewIssueAndArticles.xml 
http:\/\/www.cell.com\/rssFeed\/Cell\/rss.NewIssueAndArticles.xml 
/;
# pulling from Cell's main RSS as well as their stem cell specific feed

foreach (@nature_url_list) {
    
    my $url = "$_";
    
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
    
    
    while ($source_code =~ /<item>(.+?)<title>(.+?)<\/title>(.+?)<link>(.+?)<\/link>(.+?)<description>(.+?)<\/description>(.+?)<pubdate>(.+?)<\/pubdate>(.+?)<\/item>/gis) {
        #                           #1          $2          $3          $4           $5                 $6                  $7            $8              $8    
        #   $2 title
        #   $4 link
        #   $6 abstracts
        #   $8 pubdate
        
    
        push @journal_title, my $journal_title = 'CELL (STEM CELL)';    
        push @ar_title, $2;
        
        my $pubdate = YYYYMMDD($8);
        push @ar_pubdate, $pubdate;
        
        push @ar_links, $4;
        push @ar_doi, 'null';
        
        #my $mech_paper = WWW::Mechanize->new();
        #$mech_paper ->get($4);
        #my $source_code_paper = $mech_paper->content;
        
        push @ar_abstracts, $6;
    
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
}

__DATA__
cant grab full abstracts for all papers
working with first few sentences
will revise in future, to get full abstracts