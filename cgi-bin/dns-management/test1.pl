#!/usr/bin/perl

use DBI;
use warnings ;

#get sql query passed to sub
my $sql = "select teampassword from TEAMS where team = 'security';" ;
#connect to db
my $dbh = DBI->connect('DBI:mysql:DNS;mysql_socket=/data/db/mysql/mysql.sock','root','117shinzu');
#prepare query
my $sth = $dbh->prepare($sql);
#run query
$sth->execute||die "bum sql";
#result in array @result
my @result = $sth->fetchrow_array;

my $sqlresult = $result[0];


print "SQL result is $sqlresult \n";

