#!/usr/bin/perl

#written by Andrew Stringer 10/10/2012 onwards
#This prints out the left hand side navigator for the main web page.
#All links will open in an iframe. 
#

use strict;
use warnings;

#print http header
print "Content-type: text/html\n\n";

print <<ENDOFTEXT1 ;
<ul>
<li><a href="loremipsum.html" target="contentifrm">Home</a></li>
<li><a href="/cgi-bin/dns-management/add-new-A-record-form.pl" target="contentifrm">Add new A record</a></li>
<li><a href="/cgi-bin/dns-management/check-ip-form.pl" target="contentifrm">Check A record</a></li>
<li><a href="/cgi-bin/dns-management/check-hostname-form.pl" target="contentifrm">Check hostname</a></li>
<li><a href="/cgi-bin/dns-management/add-new-CNAME-form.pl" target="contentifrm">Add new CNAME record</a></li>
<li>Delete A record</li>
<li>Delete CNAME record</li>
<li><a href="dns-adddomainname-form.shtml" target="contentifrm">Add domain name</a></li>
<li>Add new user</li>
<li>Delete existing user</li>
</ul>

ENDOFTEXT1
