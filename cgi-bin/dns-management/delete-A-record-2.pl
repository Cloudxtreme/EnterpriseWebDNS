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


MAIN:
#start of body of program
{

#use cgi-lib to get password
require "cgi-lib.pl" ;

my $domainsuffixquery ;
my $hostnamequery ;

#read in the values passed
&ReadParse ;

our %in ;
$hostnamequery = $in{'host_name'} ;
$domainsuffixquery = $in{'domainsuffix'} ;

my $username = $in{'username'} ;
my $userpassword = $in{'userpassword'} ;

#Start sanity checking

#check host name, this should always pass as the
#hostname was passed from a previous script,
#but remember data:tamper for firefox...
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


#Added 17/03/2014 AJS to allow hostname search form to submit query to this program
if ($domainsuffixquery eq '') {
#        print "1st option \n";
        ($hostnamequery, $domainsuffixquery) = split(/\./, $hostnamequery, 2);
    }

#do lookup in database to check if host_name exists.
my $sqlquery = "select recorddata,recordclass,recordtype,hostname,domainsuffix,description,username,team,modified,id from FORWARDZONE 
where (hostname='$hostnamequery') AND (domainsuffix='$domainsuffixquery'); " ;
my @lookupresult = GETSQL("$sqlquery");

my $recorddata=$lookupresult[0]; 
my $recordclass=$lookupresult[1]; 
my $recordtype=$lookupresult[2]; 
my $hostname=$lookupresult[3]; 
my $domainsuffix=$lookupresult[4]; 
my $description=$lookupresult[5]; 
my $dbusername=$lookupresult[6]; 
my $team=$lookupresult[7]; 
my $modified=$lookupresult[8]; 
my $id=$lookupresult[9];

$sqlquery = "select (fullname) from USERS where (username='$dbusername'); " ;
my @fullname = GETSQL("$sqlquery");
$sqlquery = "select (password) from USERS where (username='$dbusername'); " ;
my @password = GETSQL("$sqlquery");


$sqlquery = "select (displayname) from TEAMS where (team='$team'); " ;
my @displayname = GETSQL("$sqlquery");




#Start of web page
#print http header
print "Content-type: text/html\n\n";

print <<ENDOFTEXT2 ;
<b>Passed from previous page</b>
<br>
$hostnamequery.$domainsuffixquery
<br>
$username & $userpassword
<br>

<b>Looked up from database</b>
<br>
record id $id <br>
record data  $recorddata <br>
record class $recordclass <br>
record type $recordtype <br>
hostname $hostname <br>
domain suffix $domainsuffix <br>
description $description <br>
username $dbusername <br>
team $team <br>
<br>
modified $modified <br>
<br>
Fullname @fullname <br>
Password @password <br>
TeamDisplayName @displayname <br>

ENDOFTEXT2


#Insert values into deleted info table for archive, then delete from FORWARDZONE

$sqlquery = "insert into DELETEDFORWARDZONE
        (recorddata,recordclass,recordtype,hostname,domainsuffix,description,username,team)
 values ('$recorddata','$recordclass','$recordtype','$hostname','$domainsuffix','$description','$username','$team');" ;

@lookupresult = GETSQL("$sqlquery");
#Assume that this has worked, test needed for certainty.


#Delete request from FORWARDZONE 

$sqlquery = "delete from FORWARDZONE where id = $id ;" ;
@lookupresult = GETSQL("$sqlquery");


}
exit 0

