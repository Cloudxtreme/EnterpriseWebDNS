#!/usr/bin/perl

#written by Andrew Stringer 09/08/2005 onwards
#input form processor for dns CNAME record entry

use DBI;
use Data::Dumper;



sub DOSQL
{
#get sql query passed to sub
my $sql = shift ;
#connect to db
my $dbh = DBI->connect('DBI:mysql:DNS','www','www');
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
<title>Add CNAME record **Error detected**</title>
</head>
<body>

<table border="1">
<tr><td bgcolor="#eeeeee">$errorfield Please use the back button 
in your browser and correct the error.</td></tr>
</table>

</body>
</html>
ENDOFTEXTs1

exit (1) ;
}

sub EXISTS
#this prints out a page when the CNAME is already in the database

{
my $host_name = shift ;
my $domainsuffix = shift ;
my $lookeduphostname = shift ;
my $lookedupdomainname = shift ;

#print http header
print "Content-type: text/html\n\n";
print <<ENDOFTEXTs2 ;

<html>
<head>
<title>Add CNAME record **CNAME exists**</title>
</head>
<body>

<table id="table">
<tr><th>The CNAME you have entered is already in the database:-</th></tr>
<tr><td>You requested $host_name.$domainsuffix</td></tr>
<tr><td>the database returns $lookeduphostname and $lookedupdomainname</td></tr>
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

#use cgi-lib
require "cgi-lib.pl" ;

#read in the values passed
&ReadParse ;

my $cname = $in{'cname'} ;


my $host_name = $in{'host_name'} ;
my $domainsuffix = $in{'domainsuffix'} ;
my $description = $in{'description'} ;
my $username = $in{'username'} ;
my $team = $in{'team'} ;
my $teampasswd = $in{'teampasswd'} ;


#Start sanity checking
#check CNAME

$cname=~tr/A-Z/a-z/ ;
if ($cname=~m/[^a-z][^0-9]_/)
	{
	$cnamevalid="0";
	ERROR("Your CNAME contains illegal characters");
	}
else
	{
	$cnamevalid="1";
	}

#check if team password is correct
if (length "$teampasswd" == 0)
	{
	ERROR("Your team password is null.")
	}

my $sqlquery = "select teampassword from TEAMS where team = '$team';";
my @sqlresult = DOSQL("$sqlquery");
my $sqlteampassword = $sqlresult[0];

if ($sqlteampassword ne $teampasswd)
	{
	ERROR("Your team password is incorrect - Team is $team , sqlpw is $sqlteampassword.");
	}
#password is correct if this is reached.



#do lookup in database to check if cname address exists already
$sqlquery = "select hostname,domainsuffix from FORWARDZONE where (hostname='$host_name') AND (domainsuffix='$domainsuffix'); " ;
my @lookupresult = DOSQL("$sqlquery");

my $lookeduphostname = $lookupresult[0];
my $lookedupdomainname = $lookupresult[1];

if ("$lookeduphostname.$lookedupdomainname" eq "$host_name.$domainsuffix ")
	{
	EXISTS($host_name,$domainsuffix,$lookeduphostname,$lookedupdomainname);
	}
else
	{
	#no match so insert new value
	$sqlquery = "insert into FORWARDZONE (recorddata,recordtype,recordclass,domainsuffix,description,username,team)
	values ('$host_name','CNAME','IN','$domainsuffix','$description','$username','$team');" ; 
	
	@lookupresult = DOSQL("$sqlquery");
	}



#print header
print "Content-type: text/html\n\n";
print <<ENDOFTEXT1 ;

<html>
<head>
<title>Add CNAME record</title> FIXME
</head>
<body>

<!--$sqlquery<br>-->
<table id="table">
<tr><td bgcolor="#eeeeee">$lookeduphostname.$lookedupdomainname</td></tr>
<tr><td bgcolor="#eeeeee">$host_name.$domainsuffix</td></tr>
<tr><td bgcolor="#eeeeee">$description</td></tr>
<tr><td bgcolor="#eeeeee">$username, $team, $teampasswd. </td></tr>
<tr><td>SQL password result is $sqlteampassword</td></tr>

</table>

</body>
</html>
ENDOFTEXT1

#print "$octet1.$octet2.$octet3.$octet4 \n";
#print "$hostname.$domainsuffix \n";
#print "$description \n";
#print "$username, $team, $teampassword \n";

}
exit (0);

