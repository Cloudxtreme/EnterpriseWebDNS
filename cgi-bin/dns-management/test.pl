#!/usr/bin/perl

use strict;
use warnings;

my $octet1='192' ;
my $octet2='168' ;
my $octet3='1' ;
my $octet4='42' ;

#my $string = join "", $this, $that, $the, $other;

my $ipaddress = join ".", $octet1, $octet2, $octet3, $octet4 ;

print "$ipaddress \n";

