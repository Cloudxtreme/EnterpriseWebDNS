#!/usr/bin/perl

#written by Andrew Stringer 09/08/2005 onwards
#added strict and warnings 31/09/2012
#Check for existence of ipaddress

use DBI;
use Data::Dumper;

#use strict;
use warnings;

sub GETSQL
{
#get sql query passed to sub
my $sql = shift ;
#connect to db
my $dbh = DBI->connect('DBI:mysql:DNS;mysql_socket=/data/db/mysql/mysql.sock','www','www');
#prepare query
my $sth = $dbh->prepare($sql);
#run query
$sth->execute||die "bum sql";
#result in array @result
my @result = $sth->fetchrow_array;
#return array 
return @result
}

sub ERROR
{
my $errorfield = shift ;
#print http header
print "Content-type: text/html\n\n";
print <<ENDOFTEXTs1 ;

<html>
<head>
<title>Check Ip address **Error detected**</title>
</head>
<body>

<table id="table">
<tr><td bgcolor="#eeeeee">$errorfield Please use the back button 
in your browser and correct the error.</td></tr>
</table>

</body>
</html>
ENDOFTEXTs1

exit (1) ;
}


#
MAIN:
#start of body of program
{

#use cgi-lib to get password
require "cgi-lib.pl" ;

my $ipaddress ;

#read in the values passed
&ReadParse ;

our %in ;
my $octet1 = $in{'octet1'} ;
my $octet2 = $in{'octet2'} ;
my $octet3 = $in{'octet3'} ;
my $octet4 = $in{'octet4'} ;



#Start sanity checking
#ipaddress first, only allow 10, 172 and 192 range addresses
if (($octet1=="10" || $octet1=="172" || $octet1=="192") &&
    ($octet2>=0 && $octet2<=255) &&
    ($octet3>=0 && $octet3<=255) &&
    ($octet4>=0 && $octet4<=255))
	{
	my $ipvalid="1" ;
	$ipaddress = join ".", $octet1, $octet2, $octet3, $octet4 ;
	}
else
	{
	my $ipvalid="0" ;
	ERROR("There is a problem with the ipaddress, >$octet1.$octet2.$octet3.$octet4<.");	
	}

#mysql> select recorddata,recordclass,recordtype,domainsuffix,description,username,team,modified from FORWARDZONE ;
#| 192.168.1.1  | IN          | A          | rainsbrook.pri   | Optiplex in rack          | Andrew   | network  | 2012-09-25 11:21:14 |
#| 192.168.5.21 | IN          | A          | rainsbrook.co.uk | Quince in virtual server  | Andrew   | server   | 2012-09-25 11:21:28 |
#| 192.168.5.12 | IN          | A          | rainsbrook.co.uk | Spruce webserver in attic | Andrew   | server   | 2012-09-25 11:21:24 |
#| 192.168.1.10 | IN          | A          | rainsbrook.co.uk | Firewall                  | Andrew   | security | 2012-09-25 11:21:33 |
#| 192168142    | IP          | A          | rainsbrook.pri   | filer in rack             | andrew   | server   | 2012-09-27 12:21:15 |
#| 192.168.1.41 | IP          | A          | rainsbrook.pri   | oak not in rack           | andrew   | server   | 2012-09-27 12:50:09 |
#+--------------+-------------+------------+------------------+---------------------------+----------+----------+---------------------+
#6 rows in set (0.00 sec)



#do lookup in database to check if ip address exists already
#my $sqlquery = "select * from FORWARDZONE where (recorddata='$ipaddress'); " ;
my $sqlquery = "select recorddata,recordclass,recordtype,hostname,domainsuffix,description,username,team,modified from FORWARDZONE where (recorddata='$ipaddress'); " ;
my @lookupresult = GETSQL("$sqlquery");

my $recorddata = $lookupresult[0] ;
my $recordclass = $lookupresult[1] ;
my $recordtype = $lookupresult[2] ;
my $hostname = $lookupresult[3] ;
my $domainsuffix = $lookupresult[4] ;
my $description = $lookupresult[5] ;
my $username = $lookupresult[6] ;
my $team = $lookupresult[7] ;
my $modified = $lookupresult[8] ;


$sqlquery = "select (fullname) from USERS where (username='$username'); " ;
my @fullname = GETSQL("$sqlquery");
$sqlquery = "select (displayname) from TEAMS where (team='$team'); " ;
my @displayname = GETSQL("$sqlquery");


#print header
print "Content-type: text/html\n\n";
print <<ENDOFTEXT1 ;

<html>
<head>
<title>Check IP Address</title>
</head>
<body>
<!--Start loop through @lookupresult <br> -->
ENDOFTEXT1
#print "\$recorddata is $recorddata <br>\n" ;

#foreach (@lookupresult) {
#print ">$_< <br>\n" ;
#}


if ($recorddata ne "")
	{
	print <<ENDOFTEXT2 ;

	<table id="table">
	<th colspan="2">IP address exists in the database</th>
	<tr>
	<td>Ipaddress from database</td><td bgcolor="#eeeeee">$recorddata </td>
	</tr>
	<tr>
	<td>FQDN</td><td bgcolor="#eeeeee">$hostname.$domainsuffix</td>
	</tr>
	<tr>
	<td>Description</td><td bgcolor="#eeeeee">$description</td>
	</tr>
	<tr>
	<td>Created by</td><td bgcolor="#eeeeee">$fullname[0] in the $displayname[0] team. </td>
	</tr>
	<tr>
	<td>Created date</td><td bgcolor="#eeeeee">$modified</td>
	</tr>
	</table>
<br><br>
ENDOFTEXT2

print "<pre>$recorddata   $recordclass   $recordtype  $hostname.$domainsuffix.</pre> \n";


	}
else	
	{
	print <<ENDOFTEXT3 ;

	<table id="table">
	<th colspan="2">IP address >$ipaddress< does not exist in the database.</th>
	</table>

ENDOFTEXT3
	}

print <<ENDOFTEXT4 ;
</body>
</html>
ENDOFTEXT4


}
exit (0);

