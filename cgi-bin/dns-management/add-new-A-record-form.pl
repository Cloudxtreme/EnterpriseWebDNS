#!/usr/bin/perl

#written by Andrew Stringer 10/03/2006 onwards
#this proints out the form for adding a new A record, 
#it is to be run as an ssi
#

use strict;
use warnings;

use DBI;
use Data::Dumper;

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


#Get Team info
$sql = "select team, displayname from TEAMS order by team;" ;

$sth = $dbh->prepare($sql);
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






#print http header
print "Content-type: text/html\n\n";

print <<ENDOFTEXT1 ;
<form name="addArecord" action="/cgi-bin/dns-management/add-new-A-record.pl" method="post">
<table id="table">
<th>Add a new A record.</th>
<tr>
<td>
Ip address:
<input type="text" name="octet1" size="3" maxlength="3"><b>.</b>
<input type="text" name="octet2" size="3" maxlength="3"><b>.</b>
<input type="text" name="octet3" size="3" maxlength="3"><b>.</b>
<input type="text" name="octet4" size="3" maxlength="3">
&nbsp;
Mac Address:<input type="text" name="macaddress" size="18" maxlength="18">
<br>
Host name:
<input type="text" name="hostname" size="20" maxlength="20">
<b>.</b>
<select name="domainsuffix" size="1">
ENDOFTEXT1
my $printcount = 0 ;
foreach (@domainname)
        { 
        #print "Teamname is $teamname[$printcount], Displayname is $displayname[$printcount] \n";
        print "<option>$domainname[$printcount]</option> \n";
        $printcount ++
        }

print <<ENDOFTEXT2 ;
</select>
<br>
Description & location of Host:-
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
ENDOFTEXT2

$printcount = 0 ;
foreach (@teamname) 
        {
        print "<option>$teamname[$printcount]</option> \n";
        $printcount ++
        }
print <<ENDOFTEXT3 ;
</select>
&nbsp;

<input type="Submit" value="Add new A record">
</td>
</tr>
</table>
</form>

ENDOFTEXT3


exit (0);

