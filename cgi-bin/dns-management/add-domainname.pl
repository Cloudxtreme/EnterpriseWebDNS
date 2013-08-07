#!/usr/bin/perl

#written by Andrew Stringer 09/08/2005 onwards
#input form processor for dns A record entry

use DBI;
use Data::Dumper;

use strict;
use warnings;

#get config values for connection to DB.
require "globalconfig.pl";
our ($superuser, $superuserpw, $mysqluser, $mysqlpw);


sub DOSQL
{
#get sql query passed to sub
my $sql = shift ;
#connect to db
my $dbh = DBI->connect('DBI:mysql:DNS',"$mysqluser","$mysqlpw");
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
<title>Add new domain name  **Error detected**</title>
</head>
<body>

<table id="table">
<tr><td bgcolor="#eeeeee">
$errorfield Please use the back button in your browser and correct the error.
</td></tr>
</table>

</body>
</html>
ENDOFTEXTs1

exit (1) ;
}

sub EXISTS
#this prints out a page when the domain name already exists in the database
{
my $domainname = shift ;
my $domainsuffix = shift ;

#print http header
print "Content-type: text/html\n\n";
print <<ENDOFTEXTs2 ;

<html>
<head>
<title>Add new domain **domain $domainname exists**</title>
</head>
<body>
<table id="table">
<tr colspan="2"><td bgcolor="#eeeeee">The domain you have entered is already in the database:-</td></tr>
<tr><td>Requested domain</td><td>$domainname</td><tr>
<tr><td>db lookup domain</td><td>$domainsuffix</td><tr>

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

#define username & password - now included in global config file
#my $superuser = "root";
#my $superuserpw = "letmein";

my $username = $superuser ;

#read in the values passed
&ReadParse ;

#values are domainname, user and passwd 

our %in ;
my $domainname = $in{'domainname'} ;
my $user = $in{'user'} ;
my $passwd = $in{'passwd'} ;

#check if username is correct
if (length "$user" == 0)
        {
        ERROR("Your user name is null.") ;
        }
if ($user ne $superuser)
        {
        ERROR("Your username is incorrect.");
        }

#check if password is correct
if (length "$passwd" == 0)
        {
        ERROR("Your password is null.") ;
        }

if ($passwd ne $superuserpw)
        {
        ERROR("Your password is incorrect.");
        }
#username and password are correct if this is reached.



#check domain name,
#force to lowercase
my $domainvalid;
$domainname=~tr/A-Z/a-z/ ;
if ($domainname=~m/[^a-z][^0-9]_/)
        {
        $domainvalid="0";
        ERROR("Your domain name contains illegal characters (Only letters, numerals and underscore)");
        }
else
        {
        $domainvalid="1";
        }

#do lookup in database to check if domain exists already
my $sqlquery = "select domainsuffix from DOMAINNAME where (domainsuffix='$domainname') ; " ;
my @lookupresult = DOSQL("$sqlquery");
my $domainsuffix = $lookupresult[0] ;

if ($domainsuffix eq $domainname)
        {
	EXISTS($domainname, $domainsuffix);
        }
else
        {
        #no match so insert new value
        $sqlquery = "insert into DOMAINNAME (domainsuffix) values ('$domainname');" ;
        DOSQL("$sqlquery");
        }

#read out from database to check
$sqlquery = "select domainsuffix  from DOMAINNAME where (domainsuffix='$domainname') ; " ;
@lookupresult = DOSQL("$sqlquery");

my $domainsuffixlookup = $lookupresult[0];


#print header
print "Content-type: text/html\n\n";
print <<ENDOFTEXT1 ;

<html>
<head>
<title>Add New Domain name</title>
</head>
<body>

<table id="table>
<tr><th>Requested domain name:- $domainname</th></tr>
<tr><td>Domainname looked up from db:- $domainsuffixlookup </td></tr>
</table>

</body>
</html>
ENDOFTEXT1

}
exit (0);

