#!/usr/bin/perl

#written by Andrew Stringer 13/10/2005 onwards
#input form processor for delete hostname record entry

use DBI;
use Data::Dumper;

sub RANDOM
{
my $upper = shift;
my $lower = shift;
my $random = int(rand( $upper-$lower+1 ) ) + $lower;
return $random;
}

sub DOSQL
{
#get sql query passed to sub
my $sql = shift ;
#connect to db
my $dbh = DBI->connect('DBI:mysql:DNS','root','117shinzu');
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
<title>Delete record **Error detected**</title>
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

sub NOTEXIST
#this prints out a page when the hostname does not exist in the database
{
my $lookupresult0 = shift ;
my $lookupresult1 = shift ;

#print http header
print "Content-type: text/html\n\n";
print <<ENDOFTEXTs2 ;

<html>
<head>
<title>Delete A record **ipaddress does NOT exist**</title>
</head>
<body>

<table border="1">
<tr><td bgcolor="#eeeeee">
The hostname you have entered does not exist in the database.
</td></tr>
<tr><td>
Cannot delete <b>$lookupresult0.$lookupresult1</b> because it does not exist!
</td><tr>

</table>

</body>
</html>
ENDOFTEXTs2

exit (1) ;
}


MAIN:
#start of body of program
{

#use cgi-lib to get password
require "cgi-lib.pl" ;

#read in the values passed
&ReadParse ;


my $host_name = $in{'host_name'},$in{'value'} ;
my $domainsuffix = $in{'domainsuffix'},$in{'value'} ;
my $username = $in{'username'},$in{'value'} ;
my $team = $in{'team'},$in{'value'} ;
my $teampasswd = $in{'teampasswd'},$in{'value'} ;


#check host name
$host_name=~tr/A-Z/a-z/ ;
if ($host_name=~m/[^a-z][^0-9]_/)
        {
        $hostvalid="0";
        ERROR("Your hostname contains illegal characters");
        }
else
        {
        $hostvalid="1";
        }

#check if team password is null
if (length "$teampasswd" == 0)
        {
        ERROR("Your team password is null.")
        }

#check if team is correct
my $sqlquery = "select team from FORWARDZONE where (hostname='$host_name') AND (domainsuffix='$domainsuffix') ; ";
my @sqlresult = DOSQL("$sqlquery");
my $sqlteam = $sqlresult[0];

if ($sqlteam ne $team)
        {
        ERROR("Your team is incorrect.")
        }

#check if team password is correct
my $sqlquery = "select teampassword from TEAMS where team = '$team';";
my @sqlresult = DOSQL("$sqlquery");
my $sqlteampassword = $sqlresult[0];

if ($sqlteampassword ne $teampasswd)
        {
        ERROR("Your team password is incorrect.");
        }
#password is correct if this is reached.


#do lookup in database to check if ip address exists already
$sqlquery = "select * from FORWARDZONE where (hostname='$host_name') AND (domainsuffix='$domainsuffix') ; " ;
my @lookupresult = DOSQL("$sqlquery");

if ($lookupresult[0] && $lookupresult[1] ne "")
        {
	#address exists, so we can delete the line
	$sqlquery = "delete from FORWARDZONE where (hostname='$host_name') AND (domainsuffix='$domainsuffix') ; " ;
	my @lookupresult = DOSQL("$sqlquery");



	#start by printing html header etc.

print "Content-type: text/html\n\n";
print <<ENDOFTEXT4 ;

<html>
<head>
<title>Delete A record </title>
</head>
<body>

<table border="1">
<tr><td bgcolor="#eeeeee">
Deleted!
</td></tr>
<tr><td>
<b>$host_name.$domainsuffix</b>.
</td><tr>

</table>

</body>
</html>
ENDOFTEXT4

        }
else
        {
        #no match so cannot delete
        NOTEXIST($host_name,$domainsuffix);
        }


}
exit (0);

