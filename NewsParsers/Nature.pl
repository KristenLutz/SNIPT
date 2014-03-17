#!/usr/bin/perl -w
use strict;

# This program pulls the journal names, article titles, pubdate, doi and links from
# "Nature's" newsfeeds and writes them to a file called 'masterlist.csv'

use open ':std', ':encoding(UTF-8)';
use WWW::Mechanize;

my $mech = WWW::Mechanize->new();

my @nature_url_list = qw/
http:\/\/feeds.nature.com\/nature\/rss\/aop
http:\/\/feeds.nature.com\/nbt\/rss\/current
http:\/\/feeds.nature.com\/nbt\/rss\/aop
http:\/\/feeds.nature.com\/ncb\/rss\/current
http:\/\/feeds.nature.com\/ng\/rss\/current
http:\/\/feeds.nature.com\/ng\/rss\/aop
http:\/\/feeds.nature.com\/nm\/rss\/current
http:\/\/feeds.nature.com\/nm\/rss\/aop
http:\/\/feeds.nature.com\/nsmb\/rss\/current
http:\/\/feeds.nature.com\/nsmb\/rss\/aop
/;
# pull titles from all rel. journals under Nature incl biotech, genetics etc

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
    # essentially, this holds the preformated csv data
    
    while ($source_code=~/<item rdf:about="(.+?)<description>(.+?)<\/description>(.+?)<dc:title>(.+?)<\/dc:title>(.+?)<dc:source>(.+?)<\/dc:source>(.+?)<prism:publicationDate>(.+?)<\/prism:publicationDate>(.+?)<prism:doi>(.+?)<\/prism:doi>(.+?)<\/item>/gis) {
        # $2 - abstract
        # $4 - title
        # $6 - journal
        # $8 - date
        # $10 - doi
        
        push @ar_abstracts, $2;
        push @ar_title, $4;
        push @journal_title, $6;
        push @ar_pubdate, $8;
        push @ar_doi, $10;
        push @ar_links, my $ar = 'http://dx.doi.org/'.$10;
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