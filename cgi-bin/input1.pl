#!/usr/bin/perl

#written by Andrew Stringer 07/07/2005 onwards
#accepts input for a computer booking system


sub RANDOM
{
my $upper = shift;
my $lower = shift;
my $random = int(rand( $upper-$lower+1 ) ) + $lower;
return $random;
}

sub VALIDATEUSER
{
my $username = shift;
my $password = shift;

my $validate="no";

if (
$username == "1234" && $password == "123"
||
$username == "anonymous" && $password == "999"
)
{$validate = "1";}
else
{$validate = "0";}

return $validate;
}


sub CREATELOGIN
{
my $loginname = shift;
my $password = shift ;
my $logintime = shift;
my $warntime = shift ;
my $logouttime = shift;
my $remotehost = shift;

#temp - need crypt routine
my $crypt = $password;

#create new file with commands for remote user generation
print "Create File $loginname, $password \n";
open USER, ">/tmp/$loginname.sh";
print USER "#!/bin/bash \n";
print USER "#script for at command for user $loginname. \n\n";
print USER "/usr/sbin/useradd -d /home/$loginname -g users -m -p $crypt 
-s
/bin/bash $loginname";
close USER;
`/usr/bin/chmod u+x /tmp/$loginname.sh `;

#copy file to remotehost - scp -i file [[user@]host1:]file1 [...] 
[[user@]host2:]file2
print "copy to remote host $remotehost . \n";
print "/usr/bin/scp -i /home/www/.ssh/id_rsa /tmp/$loginname.sh
root\@$remotehost:/root/$loginname.sh 2>&1 \n";

`/usr/bin/scp -i /home/www/.ssh/id_rsa /tmp/$loginname.sh
root\@$remotehost:/root/$loginname.sh 2>&1`


}


#
MAIN:
#start of body of program
{

#use cgi-lib to get password
require "cgi-lib.pl" ;

#read in the values passed
&ReadParse ;

my $librarynumber = $in{'librarynumber'},$in{'value'} ;
my $pin = $in{'pin'},$in{'value'} ;
my $location = $in{'location'},$in{'value'} ;

#test!!
#my $librarynumber = "1234";
#my $pin = "123";

if (&VALIDATEUSER($librarynumber, $pin))
{

open WORDLIST, "<wordlist.txt" or die "Cannot open file wordlist.txt 
for
input." ;

#read in all of wordlist.txt in to array "@wordlist"
@wordlist = <WORDLIST> ;
#close wordlist.txt
close WORDLIST ;
my $size=$#wordlist;

#generate random number for username
my $upper1=$size;
my $upper1a=999;
my $random1 = &RANDOM($upper1, 1);
my $random1a = &RANDOM($upper1a, 1);
$tmp = $wordlist[$random1] ;
$tmp =~ s/\r\n//;
my $username = $tmp.$random1a ;
#print "Username is $username \n";


#generate random number for password
my $upper2=$size;
my $upper2a=999;
my $random2 = &RANDOM($upper2, 1);
my $random2a = &RANDOM($upper2a, 1);
$tmp = $wordlist[$random2] ;
$tmp =~ s/\r\n//;
my $passwd= $tmp.$random2a ;
#print "Password is $passwd \n";


#print header
print "Content-type: text/html\n\n";
print <<ENDOFTEXT1 ;

<html>
<head>
<title>Login details</title>
</head>
<body>
<b>Login details</b>
<br><br>
<table border="1">
<tr><td bgcolor="#eeeeee">Username</td><td>$username</td></tr>
<tr><td bgcolor="#eeeeee">Password</td><td>$passwd</td></tr>
</table>

</body>
</html>
ENDOFTEXT1


my $logintime  = "17:30"   ;
my $warntime   = "17:35"   ;
my $logouttime = "17:40"   ;
my $remotehost = "10.110.129.190";


&CREATELOGIN($username, $passwd, $logintime, $warntime, $logouttime,
$remotehost);

#generate remote user
#`/usr/bin/ssh -i /home/www/.ssh/id_rsa root@10.110.129.190 \
#"/usr/sbin/useradd -d /home/$username -g users \
#-m -p $passwd -s /bin/bash $username " `


}
else
#password invalid, print error
{
#print header
print "Content-type: text/html\n\n";
print <<ENDOFTEXT2 ;

<html>
<head>
<title>Invalid library card or PIN.</title>
</head>
<body>
Sorry your username/pin is invalid, <a 
href="/library/page2.html">please
try again</a>.
<br>
</body>
</html>
ENDOFTEXT2

#end of else
}

}
exit (0);


