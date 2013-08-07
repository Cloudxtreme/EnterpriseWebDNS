#!/usr/bin/perl
#written Andrew Stringer 21/02/2007 to read zone file into database

use strict;
use warnings;

MAIN:
#start of body of program

my $zonefile = "rainsbrook-partial.txt";
my $record ;
my $i ; #Loop counter

my @ttltemp1 ;
my @soaline1 ;
my @soaline2 ;
my @soaline3 ;
my @soaline4 ;
my @soaline5 ;
my @soaline6 ;

my @nsline1 ;

my @aline1 ;
my $afields ;
my $aipaddress ;
my $ahost ;

open(ZONEFILE, $zonefile) || die "Error - couldn't open $zonefile!";
my @lines = <ZONEFILE>;         # Read it into an array
close(ZONEFILE);                # Close the file

my $length = @lines ;
print "Array is $length lines long.\n";

for ($i = 0; $i < $length; $i++) {

#ignore blank lines
if ($lines[$i] eq "\n") {next;}

#test for comment line
if ($lines[$i] =~/^;/)
{
        print "Comment - $lines[$i]" ;
        #if line is a comment, don't bother testing for anything else
        next ;
}

#start tests

#test for TTL
#FIXME Really should check for BIND 9.x, 8.x does not support $TTL
if ( $lines[$i] =~/\$TTL/ )
{
        print "Contains \$TTL \n" ;

        #this may get reset if a $ttl is encountered for specific records
        @ttltemp1 = split /\s+/, $lines[$i] ;

        print "\@ttl is $ttltemp1[0], $ttltemp1[1] \n";
        my $ttl = $ttltemp1[1] ;
        print "Zonefile \$ttl is $ttl \n\n";
}

#test for SOA,
#FIXME if SOA is written on one line or comment lines interspersed,this will fail.
#FIXME if this is Bind 8, last line is TTL, not expire.
if ($lines[$i] =~/SOA/)
{
        @soaline1 = split /\s+/, $lines[$i] ;
        @soaline2 = split /\s+/, $lines[$i+1] ;
        @soaline3 = split /\s+/, $lines[$i+2] ;
        @soaline4 = split /\s+/, $lines[$i+3] ;
        @soaline5 = split /\s+/, $lines[$i+4] ;
        @soaline6 = split /\s+/, $lines[$i+5] ;

        print "SOA domain is $soaline1[0] \n" ;
        print "SOA nameserver is $soaline1[3] \n" ;
        print "SOA contact is $soaline1[4] \n" ;

        print "SOA serial number is $soaline2[1] \n" ;
        print "SOA refresh is $soaline3[1] \n" ;
        print "SOA retry is $soaline4[1] \n" ;
        print "SOA expiry is $soaline5[1] \n" ;
        print "SOA neg cache is $soaline6[1] \n\n" ;

        #there can only be one SOA, so quit to next line
        next ;
}


#test for NS record
if ($lines[$i] =~/NS/)
{
        @nsline1 = split /\s+/, $lines[$i] ;
        print "NS domain is $nsline1[0] \n" ;
        print "Name server is $nsline1[3] \n\n" ;
}


#test for A record
if ($lines[$i] =~/ A /)
{
        @aline1 = split /\s+/, $lines[$i] ;
        $afields = @aline1 ;
        #check if host ends with a ".",  \. is needed to escape the ., $is end of line
        if ($aline1[0] =~/\.$/) {print "Host $aline1[0] is a fqdn.\n"; }
        #starting at last field for ipaddress
        $ahost = $aline1[0] ;
        $aipaddress = $aline1[($afields-1)] ;

        print "A record is $afields fields long:- $ahost, $aipaddress\n" ;
}

#print "$i, $lines[$i] \n";

#end for loop
}





