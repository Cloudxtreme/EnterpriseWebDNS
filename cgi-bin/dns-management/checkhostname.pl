#!/usr/bin/perl

#written by Andrew Stringer 09/08/2005 onwards
#added strict and warnings 31/09/2012
#Check for existence of hostname in database

use strict;
use warnings;

use DBI;
use Data::Dumper;

#get config values for connection to DB.
require "globalconfig.pl";
our ($mysqluser, $mysqlpw);



sub GETSQL
{
#get sql query passed to sub
my $sql = shift ;
#connect to db
my $dbh = DBI->connect('DBI:mysql:DNS;mysql_socket=/data/db/mysql/mysql.sock',"$mysqluser","$mysqlpw");
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

#Start sanity checking

#check host name
my $hostvalid;
my $hostnamequerylength = length $hostnamequery;

if ($hostnamequerylength le 1)
        {
        $hostvalid="0";
        ERROR("Did you select a hostname to query?");
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


#Added 17/03/2014 AJS to allow hostname search form to submit query to this program
if ($domainsuffixquery eq '') {
#        print "1st option \n";
        ($hostnamequery, $domainsuffixquery) = split(/\./, $hostnamequery, 2);
    }

#do lookup in database to check if host_name exists.
my $sqlquery = "select recorddata,recordclass,recordtype,hostname,domainsuffix,description,username,team,modified from FORWARDZONE 
where (hostname='$hostnamequery') AND (domainsuffix='$domainsuffixquery'); " ;
my @lookupresult = GETSQL("$sqlquery");

my $recorddata=$lookupresult[0]; 
my $recordclass=$lookupresult[1]; 
my $recordtype=$lookupresult[2]; 
my $hostname=$lookupresult[3]; 
my $domainsuffix=$lookupresult[4]; 
my $description=$lookupresult[5]; 
my $username=$lookupresult[6]; 
my $team=$lookupresult[7]; 
my $modified=$lookupresult[8]; 

$sqlquery = "select (fullname) from USERS where (username='$username'); " ;
my @fullname = GETSQL("$sqlquery");
$sqlquery = "select (displayname) from TEAMS where (team='$team'); " ;
my @displayname = GETSQL("$sqlquery");


#print header
print "Content-type: text/html\n\n";
print <<ENDOFTEXT1 ;

<html>
<head>
<title>Check hostname</title>
</head>
<body>


ENDOFTEXT1
if ($hostname && $domainsuffix ne "")
	{
	#do some stuff to get macaddress, desc etc for ipaddress
	print <<ENDOFTEXT2 ;

<table id="table">
<th colspan="2">Hostname exists in the database</th>
<tr><td>Record from database</td><td bgcolor="#eeeeee">$recorddata</td></tr>
<tr><td>Record type</td><td bgcolor="#eeeeee">$recordtype</td></tr>
<tr><td>FQDN</td><td bgcolor="#eeeeee">$hostname.$domainsuffix</td></tr>
<tr><td>Description</td><td bgcolor="#eeeeee">$description</td></tr>
<tr><td>Created by</td><td bgcolor="#eeeeee">$fullname[0] in $displayname[0] team. </td></tr>
<tr><td>Created date</td><td bgcolor="#eeeeee">$modified </td></tr>
</table>

ENDOFTEXT2
	}
else	
	{
print <<ENDOFTEXT3 ;
<table id="table">
<th colspan="2">$hostnamequery.$domainsuffixquery</th>
<tr><td>You looked up:-</td><td bgcolor="#eeeeee">$hostnamequery.$domainsuffixquery which does not exist in the database.</td></tr>
<tr><td bgcolor="#eeeeee" colspan="2">Have you tried looking up $hostnamequery with a different domainname?</td></tr>
</table>
ENDOFTEXT3
	}

print <<ENDOFTEXT4 ;
</body>
</html>
ENDOFTEXT4


}
exit (0);

