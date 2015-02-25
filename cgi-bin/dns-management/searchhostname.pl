#!/usr/bin/perl

#written by Andrew Stringer 16/03/2014 onwards
#Searches for hostnames in database

use strict;
use warnings;

use DBI;
use Data::Dumper;

#get config values for connection to DB.
require "globalconfig.pl";
our ($mysqluser, $mysqlpw);



sub ERROR
{
my $errorfield = shift ;
#print http header
print "Content-type: text/html\n\n";
print <<ENDOFTEXTs1 ;

<html>
<head>
<title>Check Hostname **Error detected**</title>
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

#read in the values passed
&ReadParse ;

our %in ;
my $hostnamequery = $in{'host_name'} ;
my $domainsuffixquery = $in{'domainsuffix'};

my $hostname;
my $domainsuffix;

#Start sanity checking

#check host name
my $hostvalid;
my $hostnamequerylength = length $hostnamequery;

if ($hostnamequerylength le 1)
	{
	$hostvalid="0";
	ERROR("Your hostname search is too short. Please be more specific.");
	}

$hostnamequery=~tr/A-Z/a-z/ ;
if ($hostnamequery=~m/[^a-z][^0-9]_/)
        {
        $hostvalid="0";
        ERROR("Your hostname contains illegal characters");
        }
else
        {
        $hostvalid="1";
        }



#print header
print "Content-type: text/html\n\n";
print <<ENDOFTEXT1 ;

<html>
<head>
<title>Search hostname</title>
</head>
<body>
ENDOFTEXT1



my $dbh = DBI->connect('DBI:mysql:DNS;mysql_socket=/data/db/mysql/mysql.sock',"$mysqluser","$mysqlpw");
my $sqlquery = "select hostname, domainsuffix from FORWARDZONE where (hostname like '%$hostnamequery%') OR (description like '%$hostnamequery%');" ;

#Set statement handle
my $sth = $dbh->prepare($sqlquery);

#run query
$sth->execute||die "bum sql";

$sth->bind_columns(undef,\$hostname, \$domainsuffix);

print "<form name=\"checkhostname\" action=\"/cgi-bin/dns-management/checkhostname.pl\" method=\"post\">";
print "<table id=\"table\">";
print "<th>These match $hostnamequery:-</th>";


if($sth->rows) {
	while ($sth->fetch()) {
	print "<tr><td><input type=\"radio\" name=\"host_name\" value=\"$hostname.$domainsuffix\">$hostname.$domainsuffix</td></tr>";
	}
	print "</table>";
	print "<input type=\"submit\" value=\"Find Details\">";

	}
else
	{
print <<ENDOFTEXT4a ;
        <tr>
        <td>No results found</td>
        <td>.</td>
        </tr>
ENDOFTEXT4a
	}


print <<ENDOFTEXT4 ;
</body>
</html>
ENDOFTEXT4


}
exit (0);


