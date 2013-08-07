#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use Data::Dumper;


my $dbh = DBI->connect('DBI:mysql:DNS','www','www') or die $DBI::errstr ;

my $sql = "select team, displayname from TEAMS order by team;" ;

my $sth = $dbh->prepare($sql);
$sth->execute||die $DBI::errstr;


my @teamrow ;
my $teamname ;
my $displayname ;
my @teamname ;
my @displayname ;

my $teamcounter = 0 ;
while (@teamrow = $sth->fetchrow_array) 
	{
	$teamname[$teamcounter] = $teamrow[0];
	$displayname[$teamcounter] = $teamrow[1];
	$teamcounter ++
	}

$sth->finish();
$dbh->disconnect();


my $printcount = 0 ;
foreach (@teamname) 
	{
	print "Teamname is $teamname[$printcount], Displayname is $displayname[$printcount] \n";
	$printcount ++
	}



exit (0);


#print Dumper(@sqlresult);

