#!/usr/bin/perl

#written by Andrew Stringer 23/03/2006 onwards
#read out domain names

use DBI;
use Data::Dumper;

MAIN:
{

#get config values for connection to DB.
require "globalconfig.pl";
our ($mysqluser, $mysqlpw);

my $dbh = DBI->connect('DBI:mysql:DNS',"$mysqluser","$mysqlpw") or die $DBI::errstr ;


#Get valid domain names
my $sql = "select domainsuffix from DOMAINNAME order by domainsuffix;" ;

my $sth = $dbh->prepare($sql);
$sth->execute||die $DBI::errstr;

my @domainrow ;
my @domainname ;
my $domainname ;

my $domaincounter = 0 ;
while (@domainrow = $sth->fetchrow_array)
        {
        $domainname[$domaincounter] = $domainrow[0];
        $domaincounter ++
        }

my $printcount = 0 ;
foreach (@domainname)
        {
        print "$domainname[$printcount]\n";
        $printcount ++
        }



}
exit (0);

