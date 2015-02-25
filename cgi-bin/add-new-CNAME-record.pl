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
my $domainsuffix = $in{'domainsuffix'} ;
my $targetfqdn = $in{'targetfqdn'} ;

my $description = $in{'description'} ;
my $username = $in{'username'} ;
my $team = $in{'team'} ;
my $userpassword = $in{'userpassword'} ;


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




my $sqlquery = "select password from USERS where username = '$username';";
my @sqlresult = DOSQL("$sqlquery");
my $sqluserpassword = $sqlresult[0];

if ($sqluserpassword ne $userpassword)
        {
        ERROR("Your password is incorrect.");
        }
#password is correct if this is reached.



#do lookup in database to check if cname address exists already
$sqlquery = "select hostname,domainsuffix from FORWARDZONE where (hostname='$cname') AND (domainsuffix='$domainsuffix'); " ;
my @lookupresult = DOSQL("$sqlquery");

my $lookeduphostname = $lookupresult[0];
my $lookedupdomainname = $lookupresult[1];

if ("$lookeduphostname.$lookedupdomainname" eq "$host_name.$domainsuffix")
	{
	EXISTS($cname,$domainsuffix,$lookeduphostname,$lookedupdomainname);
	}
else
	{
	#no match so insert new value
	$sqlquery = "insert into FORWARDZONE 
		(hostname,recorddata,recordtype,recordclass,domainsuffix,description,username,team)
	values  ('$cname','$targetfqdn','CNAME','IN','$domainsuffix','$description','$username','$team');" ; 
	
	@lookupresult = DOSQL("$sqlquery");
	}

#| id | hostname    | domainsuffix            | description          | username | team     | modified            | recorddata               | recordclass | recordtype |
#+----+-------------+-------------------------+----------------------+----------+----------+---------------------+--------------------------+-------------+------------+
#| 0  |optiplex     | rainsbrook.pri          | Optiplex in rack     | Andrew   | network  | 2012-09-25 11:21:14 | 192.168.1.1              | IN          | A          |
#| 1  |www          | andrewstringer.co.uk    | website              | andrew   | server   | 2012-10-16 09:34:57 | quince.rainsbrook.co.uk. | IN          | CNAME      |



#print header
print "Content-type: text/html\n\n";
print <<ENDOFTEXT1 ;

<html>
<head>
<title>Add CNAME record</title>
</head>
<body>

targetfqdn from form is >$targetfqdn< <br>
domain suffix from form is >$domainsuffix< <br>


<!--$sqlquery<br>-->
<table id="table">
<tr><td>CNAME  Domain</td><td bgcolor="#eeeeee">$cname.$domainsuffix</td></tr>
<tr><td>Target FQDN</td>  <td bgcolor="#eeeeee">$targetfqdn</td></tr>
<tr><td>Description></td> <td bgcolor="#eeeeee">$description</td></tr>
<tr><td>Created by</td>   <td bgcolor="#eeeeee">$username, $team. </td></tr>

</table>

</body>
</html>
ENDOFTEXT1

}
exit (0);

