#!/usr/bin/perl -w

use DBI;
use Data::Dumper;

$dbh = DBI->connect('DBI:mysql:DNS','root','117shinzu');

$sql = qq-select * from PTR order by host -;

$sth = $dbh->prepare($sql);

$sth->execute||die "bum sql";

while (@row=$sth->fetchrow_array)
	{
#	print "@row\n";
	$ipaddress = $row[0] ;
	$host = $row[1] ;
	$descr = $row[2] ;
	$group = $row[3] ;
	$modifier = $row[4] ;
	$date = $row[5] ;
	print "$ipaddress\tIN\tA\t$host\n";
	}

#my (@result) = $sth->fetchrow_array;
#print "
#ipaddress is $result[0] 
#host is $result[1]
#Descr is $result[2] 
#Group is $result[3]
#Mod is $result[4]
#Date is $result[5]\n";

print "\n";
print Dumper(@row);

