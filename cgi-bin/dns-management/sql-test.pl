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


MAIN:
#start of body of program
{

my $row ;
my @row ;
my @fields;
my $hostname ;
my $domainsuffix ;
my @hostname ;
my @domainsuffix ;
my $hostcounter = 0 ;

#my ($fielda,$fieldb,$fieldc) = $sth->fetchrow_array();

my $dbh = DBI->connect('DBI:mysql:DNS;mysql_socket=/data/db/mysql/mysql.sock','www','www');


$sql = qq`SELECT hostname,domainsuffix FROM FORWARDZONE order by hostname`;
$sth = $dbh->prepare($sql) or die "Cannot prepare: " . $dbh->errstr();
$sth->execute() or die "Cannot execute: " . $sth->errstr();

while(@row = $sth->fetchrow_array()) {
	print "$row[0].$row[1]\n";

#  my @record = @row;
#  push(@fields, \@record);
}



# now process the fields

#if (@fields != 0) {
#  my $i=0;
#  foreach $line (@fields) {
#    print "@$line[0].@$line[1] \n";
#    $i++;
#  }
#}











$sth->finish();
$dbh->disconnect();


}
exit (0);

