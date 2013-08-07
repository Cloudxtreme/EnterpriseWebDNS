#!/usr/bin/perl

#written by Andrew Stringer 10/03/2006 onwards
#test out sql access

use DBI;
use Data::Dumper;
use warnings;

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
<title>**Error detected**</title>
</head>
<body>

<table border="1">
<tr><td bgcolor="#eeeeee">$errorfield  .</td></tr>
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

my $team="network";

my $sqlquery = "select teampassword from TEAMS where team = '$team';";
my @sqlresult = DOSQL("$sqlquery");
my $sqlteampassword = $sqlresult[0];

print "SQL Query was \n $sqlquery \n ";
print "Team password is $sqlteampassword \n ";

#do lookup in database to check if ip address exists already
#$sqlquery = "select * from FORWARDZONE where (octet1='$octet1') AND (octet2='$octet2') AND 
#	(octet3='$octet3') AND (octet4='$octet4') ; " ;
#my @lookupresult = DOSQL("$sqlquery");

#	#no match so insert new value
#	$sqlquery = "insert into FORWARDZONE (octet1,octet2,octet3,octet4,
#	hostname,domainsuffix,macaddress,description,username,team)
#	values ('$octet1','$octet2','$octet3','$octet4',
#	'$host_name','$domainsuffix','$macaddress','$description','$username','$team');" ; 
#	
#	@lookupresult = DOSQL("$sqlquery");
#	}



#print header
#print "Content-type: text/html\n\n";
#print <<ENDOFTEXT1 ;

#<html>
#<head>
#<title>sql test</title>
#</head>
#<body>

#$sqlquery<br>

#</body>
#</html>
#ENDOFTEXT1


}
exit (0);

