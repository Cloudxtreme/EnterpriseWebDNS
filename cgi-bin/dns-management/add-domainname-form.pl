#!/usr/bin/perl

#written by Andrew Stringer 26/03/2006 onwards
#this proints out the form for adding a new domainname (suffix) 
#it is to be run as an ssi
#

use strict;
use warnings;

#get config values for connection to DB.
require "globalconfig.pl";
our ($mysqluser, $mysqlpw);


#print http header
print "Content-type: text/html\n\n";

print <<ENDOFTEXT1 ;
<form name="adddomainname" action="/cgi-bin/dns-management/add-domainname.pl" method="post">
<table id="table">
<th>Add a new domainname.</th>
<tr>
<td>
Domainname:
<input type="text" name="domainname" size="20" maxlength="20">
<br>
Username:
<input type="text" name="user" size="10" maxlength="10">
Password:-
<input type="password" name="passwd" size="10" maxlength="20">
&nbsp;

<input type="Submit" value="Add new domainname">
</td>
</tr>
</table>
</form>

ENDOFTEXT1


exit (0);

