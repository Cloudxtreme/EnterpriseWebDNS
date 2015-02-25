#!/usr/bin/perl

#written by Andrew Stringer 16/03/2014 onwards
#delete-A-record-1.pl, displays found A records

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

my $hostname;

#Start sanity checking

#check host name
my $hostvalid;
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

#Connect
my $dbh = DBI->connect('DBI:mysql:DNS;mysql_socket=/data/db/mysql/mysql.sock',"$mysqluser","$mysqlpw");

#declare domainsuffix
my $domainsuffix ;

#Find records matching what we want to delete.
my $sqlquery = "select hostname, domainsuffix from FORWARDZONE where (hostname like \"%$hostnamequery%\" OR description like \"%$hostnamequery%\") AND (recordtype='A');" ;

#Set statement handle
my $sth = $dbh->prepare($sqlquery);

#run query
$sth->execute||die "bum sql";

$sth->bind_columns(undef,\$hostname, \$domainsuffix);







#Start of web page
#print header
print "Content-type: text/html\n\n";
print <<ENDOFTEXT1 ;

<html>
<head>
<title>Delete A record</title>
</head>
<body>

<form name=\"deleteArecord\" action=\"/cgi-bin/dns-management/delete-A-record-2.pl\" method=\"post\">
<table id=\"table\">
<th colspan="2">These A records match $hostnamequery:-</th>
ENDOFTEXT1

if($sth->rows) {

	while ($sth->fetch()) {
	print "<tr><td><input type=\"radio\" name=\"host_name\" value=\"$hostname.$domainsuffix\">$hostname.$domainsuffix</td></tr>";
	}
	print <<ENDOFTEXT4 ;

	<tr>
	<td>Your username:- <input type="text" name="username" size="10" maxlength="10"></td>
	<td>Your password:- <input type="password" name="userpassword" size="20" maxlength="20"></td>
	</tr>

ENDOFTEXT4

	print <<ENDOFTEXT5 ;
	<tr>
	<td colspan="2"><input type=\"submit\" value=\"Select A record to delete\"></td>
	</tr>
ENDOFTEXT5
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


print <<ENDOFTEXT6 ;

</table>

</body>
</html>
ENDOFTEXT6

$sth->finish();
$dbh->disconnect();


}
exit (0);
