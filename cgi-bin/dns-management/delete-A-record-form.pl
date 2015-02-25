#!/usr/bin/perl

#written by Andrew Stringer 10/03/2014 onwards
#this prints out the form for deleting an A record.

#
MAIN:
#start of body of program
{

use strict;
use warnings;

use DBI;
use Data::Dumper;


#This section is only required for searching by a domain name which is commented out.
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


#Start of Web page
#=================
print "Content-type: text/html\n\n";

print <<ENDOFTEXT4 ;
<table id="table">

<th>Search for A record to delete.</th>
<tr>
<td>
<form name="checkhostname" action="/cgi-bin/dns-management/delete-A-record-1.pl" method="post" onsubmit="validate();">
Hostname:
<input type="text" name="host_name" size="20" maxlength="20">



<!-- As we search across all hostnames, no need to give a domain to search. Code left in for future use.
<b>.</b>
<select name="domainsuffix" size="1">
ENDOFTEXT3
$printcount = 0 ;

foreach (@domainname)
        {
        print "<option>$domainname[$printcount]</option> \n";
        $printcount ++ 
        }
print <<ENDOFTEXT4 ;
</select>
-->




<br>
<input type="Submit" value="Search for A record to delete">
</form>
</td>
</tr>
</table>

ENDOFTEXT4

exit (0);
}
