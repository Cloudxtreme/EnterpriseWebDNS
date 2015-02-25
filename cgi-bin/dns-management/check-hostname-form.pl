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

print <<ENDOFTEXT2 ;
<table id="table">


<table id="table">
<th>Check ip address</th>
<tr>
<td>
<form name="checkipaddress" action="/cgi-bin/dns-management/checkipaddress.pl" method="post" onsubmit="validate();">
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




<th>Check hostname</th>
<tr>
<td>
<form name="searchhostname" action="/cgi-bin/dns-management/checkhostname.pl" method="post" onsubmit="validate();">
Hostname:
<input type="text" name="host_name" size="20" maxlength="20">.
<select name="domainsuffix" size="1">
ENDOFTEXT2
$printcount = 0 ;
foreach (@domainname)
        {
        print "<option>$domainname[$printcount]</option> \n";
        $printcount ++ 
        }
print <<ENDOFTEXT3 ;
</select>
<br>
<input type="Submit" value="Check Hostname">
</form>
</td>
</tr>




<th>Search hostname</th>
<tr>
<td>
<form name="checkhostname" action="/cgi-bin/dns-management/searchhostname.pl" method="post" onsubmit="validate();">
Hostname:
<input type="text" name="host_name" size="20" maxlength="20">

<!-- As we seaarch across all hostnames, no need to give a domain to seaarch. Code left in for future use.
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
<input type="Submit" value="Search Hostname">
</form>
</td>
</tr>
</table>

ENDOFTEXT4

exit (0);
