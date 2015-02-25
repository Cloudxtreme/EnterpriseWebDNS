#!/usr/bin/perl


#cgi stuff
$| = 1;
print "Content-type: application/rtf\n\n";
#print "Content-type: text/html\n\n";

$cmd = '/usr/bin/mysqldump -udbuser -pdbpass -hdbhost dbname >temp.txt';


system($cmd);

open FILE,"temp.txt";

print <FILE>;

