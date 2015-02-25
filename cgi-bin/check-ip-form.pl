#!/usr/bin/perl

#written by Andrew Stringer 10/03/2006 onwards
#this proints out the form for checking ipaddress, A or CNAME records.
#it is to be run as an ssi
#

use strict;
use warnings;

use DBI;
use Data::Dumper;

#get config values for connection to DB.
require "globalconfig.pl";
our ($mysqluser, $mysqlpw);

my $dbh = DBI->connect('DBI:mysql:DNS;mysql_socket=/data/db/mysql/mysql.sock',"$mysqluser","$mysqlpw") or die $DBI::errstr ;

my $sql ;
my $sth ;

my $printcount ;

#Get valid domain names
$sql = "select domainsuffix from DOMAINNAME order by domainsuffix;" ;

$sth = $dbh->prepare($sql);
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

$sth->finish();
$dbh->disconnect();

#print http header
print "Content-type: text/html\n\n";

print <<ENDOFTEXT1 ;

<form name="checkipaddress" action="/cgi-bin/dns-management/checkipaddress.pl" method="post" onsubmit="validate();">
<table id="table">
<th>Check ip address</th>
<tr>
<td>
IP address:
<input type="text" name="octet1" size="3" maxlength="3"><b>.</b>
<input type="text" name="octet2" size="3" maxlength="3"><b>.</b>
<input type="text" name="octet3" size="3" maxlength="3"><b>.</b>
<input type="text" name="octet4" size="3" maxlength="3">
</td>
</tr>

<tr>
<td>
<input type="Submit" value="Check Ip Address">
</form>
</td>
</tr>

<tr><td>&nbsp;</td></tr>

ENDOFTEXT1

print "\n";


exit (0);
