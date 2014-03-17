#!/usr/bin/perl -w
use strict;

# THIS IS AN EXAMPLE OF AN INFINITE CRAWL-BOT

use open ':std', ':encoding(UTF-8)';
use WWW::Mechanize;
use Array::Utils qw(:all);

my @timestamp = timestamp();

my $csvfilename = 'crawl.csv';
my $mech = WWW::Mechanize->new();
my $url = "http://www.engadget.com/rss.xml";

my $time = localtime;
$| = 1;
# timestamp + counter

print <<infoheader;
            _       _   
  ___ _ __ (_)_ __ | |_ 
 \/ __| '_ \\| | '_ \\| __|
 \\__ \\ | | | | |_\) | |_ 
 |___/_| |_|_| .__\/'\\__|
             |_|
             
The script is now running.
It will check for new titles every five minutes.

Start time: $time
infoheader

open my $fh, ">", "$csvfilename";
close $fh;
# create a blank csv file

for (my $j=1; $j>0; $j++) {
# run this shit forever

    my @article_title = ();
    my @article_link = ();
    my @article_pubdate = ();
    my @rss_crawl_summary =();
    # define arrays for each piece of info

    $mech ->get($url);
    my $source_code = $mech->content;
    # connect to the Engadget RSS XML
    
    while ($source_code =~ /<title><\!\[CDATA\[(.+?)\]\]><\/title>(.+?)<pubDate>(.+?)<\/pubdate>(.+?)<guid isPermaLink="false">(.+?)<\/guid>/gis) {
        my $title = $1;
        push @article_title, $title;
    
        my $pubdate = $3;
        push @article_pubdate, $pubdate;
    
        my $link = $5;
        push @article_link, $link;
    }
    # fetches article title, pubdates, links --> arrays
    
    foreach (@article_title, @article_pubdate) {
        $_ =~ s/,//g;
    }
    # remove commas from timestamp and article titles - for proper csv output
    
    for (my $i=0; $i<scalar @article_title; $i++) {
        my $entry_string = join(',',$timestamp[2],$article_pubdate[$i],$article_title[$i],$article_link[$i]);
        unshift @rss_crawl_summary, $entry_string;
        }
    # take a pc of ea array, plop into another array, join into string with comma 
    # rss_crawl_summary is an array with each item: <date>,<title>,<link>
    # mimics @filecontents=<$fh>
    
    open $fh, "<", "$csvfilename";
    my @filecontents = <$fh>;
    chomp @filecontents;
    close $fh;
    
    my @unique_entries = unique(@filecontents,@rss_crawl_summary);
    # compare what we had in the file, to what we just found
    # get all the unique entries, and put em into @unique_entries
    
    @unique_entries = sort(@unique_entries);
    # unique subroutine does not order the items;
    
    open $fh, ">", "$csvfilename";
    foreach (@unique_entries) {
        print $fh "$_\n";
    }
    # prints unique array into file
    
    my $cycles = $j-1;
    print "Check cycles: $j\r";
    
    close $fh;
    sleep (300);
    #wait 5 minutes before repeating
}

print "for some strange reason, Im done.\n";
<STDIN>;

#SUBROUTINES
sub timestamp {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    
    #TIME
    if ($mon < 10) {$mon = "0$mon";}
    if ($hour < 10) {$hour = "0$hour";}
    if ($min < 10)  {$min = "0$min";}
    if ($sec < 10)  {$sec = "0$sec";}
    my $time_r = join(':',$hour,$min,$sec);
    
    #DATE
    my $year_r = eval "$year+1900\n";
    if ($mday < 10)  {$mday = "0$mday";}
    my $month_r = eval "$mon+1";
    if ($month_r < 10)  {$month_r = "0$month_r";}
    my $date = join('/',$year_r,$month_r,$mday);
    
    my $timestamp = "$year_r$month_r$mday$hour$min$sec";
    
    my @time_array = ($time_r, $date, $timestamp);
    return @time_array;
}

__END__
a few issues/notes with this method

-[bug - fixed] after multiple iterations, list items are out of order, with random blank lines in between
-[bug - fixed] prints doubles of each title

-[concern] if the script/system crashes, we have to restart
    -not sure how that will impact the csv file
    -the filehandle is closed after every loop, so it should be ok

-[concern] the @unique_entries array will keep getting bigger
    -roughly 1KB for five entries
    -assume 4GB free ram --> 20971520 rss objects
    -NEED TO FIGURE OUT A WAY TO FLUSH DATA
    -open only the last 100 lines? should work
    
    -note: 12MB of ram used after running for 8h

-implement a way to email nightly reports?

