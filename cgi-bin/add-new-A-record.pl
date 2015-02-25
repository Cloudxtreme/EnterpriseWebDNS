#!/usr/bin/perl

#written by Andrew Stringer 09/08/2005 onwards
#input form processor for dns A record entry

use DBI;
use Data::Dumper;

use warnings;
use strict;

#get config values for connection to DB.
require "globalconfig.pl";
our ($mysqluser, $mysqlpw);


sub DOSQL
{
#get sql query passed to sub
my $sql = shift ;
#connect to db
my $dbh = DBI->connect('DBI:mysql:DNS;mysql_socket=/data/db/mysql/mysql.sock',$mysqluser,$mysqlpw);
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
<title>Add A record **Error detected**</title>
</head>
<body>

<table id="table">
<tr><td bgcolor="#eeeeee">$errorfield <br>
Please use the back button in your browser and correct the error.</td></tr>
</table>

</body>
</html>
ENDOFTEXTs1

exit (1) ;
}

sub EXISTS
#this prints out a page when the ipaddress is already in the database
{

my $recorddata = shift ;
my $hostname = shift ;
my $domainsuffix = shift ;

#print http header
print "Content-type: text/html\n\n";
print <<ENDOFTEXTs2 ;

<html>
<head>
<title>Add A record **ipaddress exists**</title>
</head>
<body>

<table id="table">
<tr>
<td bgcolor="#eeeeee">The ipaddress you have entered is already in the database, Consider adding a CNAME record.</td>
</tr>
<tr>
<td>$recorddata, $hostname.$domainsuffix.</td>
<tr>

</table>

</body>
</html>
ENDOFTEXTs2

exit (1) ;
}


#
MAIN:
#start of body of program
{


my $ipaddress ;
my $ipvalid ;
my $macvalid;
our %in ;

my @lookupresult ;
my $lookupresult ;


#use cgi-lib to get password
require "cgi-lib.pl" ;

#read in the values passed
&ReadParse ;

my $octet1 = $in{'octet1'} ;
my $octet2 = $in{'octet2'} ;
my $octet3 = $in{'octet3'} ;
my $octet4 = $in{'octet4'} ;


my $macaddress = $in{'macaddress'} ;
my $hostname = $in{'hostname'} ;
my $domainsuffix = $in{'domainsuffix'} ;
my $description = $in{'description'} ;
my $username = $in{'username'} ;
my $userpassword = $in{'userpassword'} ;
my $team = $in{'team'} ;


#Start sanity checking
#ipaddress first, only allow 10, 172 and 192 range addresses, allow 0 and 255
#as these are legal addresses for /23 and shorter subnet masks.
if (($octet1=="10" || $octet1=="172" || $octet1=="192") &&
    ($octet2>=0 && $octet2<=255) &&
    ($octet3>=0 && $octet3<=255) &&
    ($octet4>=0 && $octet4<=255))
	{
	$ipvalid="1" ;
	$ipaddress = join ".", $octet1, $octet2, $octet3, $octet4 ;
	}
else
	{
	$ipvalid="0" ;
	ERROR("There is a problem with the ipaddress ($octet1.$octet2.$octet3.$octet4).");	
	}

#check mac address
#remove colons to make testing length easier later
$macaddress=~s/:// ;
#convert all to lower case
$macaddress=~tr/A-Z/a-z/ ;
#check for allowed hex numbers  -FIXME hex letters not allowed

if ($macaddress=~m/[^0-9][^a-f]/)
	{
	$macvalid="1";
	ERROR("Your MAC address $macaddress contains illegal characters, format required is 001A92074B27.");
	}
else
	{
	$macvalid="0";
	}

if (length $macaddress<12)
	{
	$macvalid="0";
	ERROR("Your MAC address is the wrong length.");
	}
else
	{
	$macvalid="1";
	#If it's valid, put delimiters back
        my $macoctet1= substr($macaddress, 0, 2);
        my $macoctet2= substr($macaddress, 2, 2);
        my $macoctet3= substr($macaddress, 4, 2);
        my $macoctet4= substr($macaddress, 6, 2);
        my $macoctet5= substr($macaddress, 8, 2);
        my $macoctet6= substr($macaddress, 10, 2);
	$macaddress = "$macoctet1\-$macoctet2\-$macoctet3\-$macoctet4\-$macoctet5\-$macoctet6";
	}

#check host name
$hostname=~tr/A-Z/a-z/ ;

my $hostvalid ;

if ($hostname=~m/[^a-z][^0-9]_/)
	{
	$hostvalid="0";
	ERROR("Your hostname, $hostname, contains illegal characters");
	}
elsif (length "$hostname" == 0)
	{
	$hostvalid="0";
	ERROR("Your hostname appears to be blank. You really need a hostname for an A record :-}");
	}
else
	{
	$hostvalid="1";
	}

#check if username is acceptable
if (length "$username" == 0)
	{
	ERROR("Your username is blank.")
	}

#check if password is correct
if (length "$userpassword" == 0)
	{
	ERROR("Your password is null.")
	}

my $sqlquery = "select password from USERS where username = '$username';";
my @sqlresult = DOSQL("$sqlquery");
my $sqluserpassword = $sqlresult[0];

if ($sqluserpassword ne $userpassword)
	{
	ERROR("Your password is incorrect - Password is $sqluserpassword , sqlpw is $sqluserpassword. FIXME for production!!");
	}
#password is correct if this is reached.

####
#FIXME need to add code to check if user is member of the team they claim they are.
####

#do lookup in database to check if ip address exists already
$sqlquery = "select recorddata,hostname,domainsuffix from FORWARDZONE where (recorddata='$ipaddress') ;" ;

@lookupresult = DOSQL("$sqlquery");

my $lookuprecorddata = $lookupresult[0] ;
my $lookuphostname = $lookupresult[1] ;
my $lookupdomainsuffix = $lookupresult[2] ;

if ($lookuprecorddata ne "")
	{
	EXISTS($lookuprecorddata,$lookuphostname,$lookupdomainsuffix);
	}
else
	{
	#no match so insert new value
	$sqlquery = "insert into FORWARDZONE 
	(recorddata,recordclass,recordtype,hostname,domainsuffix,description,username,team)
	values ('$ipaddress','IN','A','$hostname','$domainsuffix','$description','$username','$team');" ; 
	
	@lookupresult = DOSQL("$sqlquery");
	}



#print header
#print "Content-type: text/html\n\n";
print <<ENDOFTEXT1 ;

<table id="table">
<tr><td bgcolor="#eeeeee">ip is $octet1.$octet2.$octet3.$octet4 &nbsp;, MAC is $macaddress</td></tr>
<tr><td bgcolor="#eeeeee">$hostname.$domainsuffix</td></tr>
<tr><td bgcolor="#eeeeee">$description</td></tr>
<tr><td bgcolor="#eeeeee">$username is part of $team team. </td></tr>
</table>

ENDOFTEXT1

}
exit (0);

