#!/usr/bin/perl

#written by Andrew Stringer 10/03/2006 onwards
#this proints out the form for adding a new CNAME record,
#modified 28/11/2012, uses username and passwords etc rather then teampassword.
#changed mysql login to include code from common password file

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


#Get Team info
$sql = "select team, displayname from TEAMS order by team;" ;

$sth = $dbh->prepare($sql);
$sth->execute||die $DBI::errstr;


my @teamrow ;
my $teamname ;
my $displayname ;
my @teamname ;
my @displayname ;

my $printcount ;

my $teamcounter = 0 ;
while (@teamrow = $sth->fetchrow_array)
        {
        $teamname[$teamcounter] = $teamrow[0];
        $displayname[$teamcounter] = $teamrow[1];
        $teamcounter ++
        }

#Get valid hostnames to add cname to

$sql = "select hostname,domainsuffix from FORWARDZONE order by hostname;" ;
$sth = $dbh->prepare($sql);
$sth->execute||die $DBI::errstr;

my $hostname ;
my $domainsuffix ;
my @hostname ;
my @domainsuffix ;
my $hostrow ;
my @hostrow ;
my $hostcounter = 0 ;

while (@hostrow = $sth->fetchrow_array)
	{
	$hostname[$hostcounter] = "$hostrow[0].$hostrow[1]";
	$hostcounter ++
	}

#Done with db queries, so close connection.
$sth->finish();
$dbh->disconnect();


#Start to print web page out.
print "Content-type: text/html\n\n";

print <<ENDOFTEXT1 ;
<form name="addcname" action="/cgi-bin/dns-management/add-new-CNAME-record.pl" method="post">
<table id="table">
<th>Add a new CNAME record.</th>
<tr>
<td>
CNAME:
<input type="text" name="cname" size="20" maxlength="20">
<b>.</b>
<select name="domainsuffix" size="1">
ENDOFTEXT1
$printcount = 0 ;
foreach (@domainname)
        {
        print "<option>$domainname[$printcount]</option> \n";
        $printcount ++
        }
print <<ENDOFTEXT1a ;
</select>




<br>
Target host name:
<select name="targetfqdn">
ENDOFTEXT1a
#select hosts here
$printcount = 0 ;
foreach (@hostname)
        {
        print "<option>$hostname[$printcount]</option> \n";
        $printcount ++
        }
print <<ENDOFTEXT2 ;
</select>
ENDOFTEXT2




print <<ENDOFTEXT3 ;
<br>

Description of CNAME:-
<br>
<textarea name="description" rows="4" cols="60">
</textarea>
<br>


Your username:-
<input type="text" name="username" size="10" maxlength="10">
<br>
Your password:-
<input type="password" name="userpassword" size="20" maxlength="20">

<select name="team" size="1">
ENDOFTEXT3

$printcount = 0 ;
foreach (@teamname)
        {
        print "<option>$teamname[$printcount]</option> \n";
        $printcount ++
        }
print <<ENDOFTEXT4 ;
</select>

<input type="Submit" value="Add new CNAME record">
</td>
</tr>
</table>
</form>
ENDOFTEXT4

exit (0);

