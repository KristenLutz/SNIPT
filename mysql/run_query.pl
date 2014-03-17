#!/usr/bin/perl
use warnings;
use strict;
use DBI;

#Declare database information
my $host = "DBI:mysql:host=209.208.110.182;database=SNIPT";
my $account = "mxie";
my $password = "log1n";


# Open the database 
my $dbh =DBI->connect($host, $account,$password)
or die("Problem connecting: ", DBI->errstr);

print $dbh;
run_query("select * from ppi");

sub run_query{
    #(dbhandle, str:query, ar_ref:values, int: choice) -> (sth, int:run)
    #Return sth, statement handle and run result, if choice is 1 when accessing
    #database using db_handle, query and query values, otherwise return nothing
    
    #Initialize variables
    my $dbhandle = $_[0];
    my $query = $_[1];
    my $run = "";
    my $return_opt = $_[3];
    
    #Prepare statement handle from database handle
    my $sth = $dbhandle->prepare($query) or die ("Problem with prepare: ", DBI->errstr);
    #Execute statement handle depending whether external values for query are needed
    if ((scalar @_) > 2) {
        my @values = @$_[2];    
        $run = $sth->execute(@values) or die("Problem with execute: ", DBI->errstr);
    }else{
        $run = $sth->execute() or die("Problem with execute: ", DBI->errstr);
    }
    
    #Determine whether to return statement handle and run or return nothing
    if ($return_opt == 1 && $run!=0) {
        return ($sth, $run);
    }
}