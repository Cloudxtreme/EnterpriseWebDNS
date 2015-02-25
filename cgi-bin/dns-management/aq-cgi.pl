#!/usr/bin/perl

eval <<'end_of_it';

#tell perl, "don't buffer output"

$| = 1;

#print the http header

print "Content-type: text/html\n\n";

use DBI;
use CGI;


#parse incoming form info.
$web = new CGI;

print qq!<HTML><BODY BGCOLOR="330011" TEXT="3399ff">!;

if ($web->param('todo') eq "help"){
	
	print qq!<H3>Instructions for using this query tool</H3>
			This tool gives you an easy way to execute SQL statements against a database.<BR>
			Before it can be used for the first time it must be set up to use your database (around line 73 of the script).<BR><BR>
			
			Execute single SQL statements by typing them into the form windows and pressing the "do it" button closest to that window.<BR>
			To edit the query or do another one, use your back button.  Occaisionally your browser will be set to forget the contents of form blanks.  This setting makes using this script much less convenient.<BR><BR>
			
			To execute more than one SQl statement, seperate the statements with "\g".  On the first line of a form blank, put a ";" then paste or type in one or more SQL statements on the second and following lines.<BR><BR>
			
			To run all the statements in a file, use the file upload button at the bottom of the form.  Make sure the statements are seperated with a "\g".  The file upload will not work with some web server configurations.  If you'd like help troubleshooting this and have some control over your server, drop me an email at <A HREF="mailto:nathan\@ncyoung.com">nathan\@ncyoung.com</A><BR><BR>
			
			If you use this script and like it, please let me know.  If you re-distribute this script, please include the following credits:<BR>
			Copywrite 2000 to Nathan Young <A HREF="mailto:nathan\@ncyoung.com">nathan\@ncyoung.com</A><BR>!;
			
			exit;

}

$url = $web->url;

$web->param(-name => 'query', -value =>$sql);
unless ($web->param('query')){

	print qq!<A HREF="$url?todo=help"><FONT SIZE="-1" COLOR="red">Help</A>!;

		print "<CENTER>";
		for $i (1..4){
			print qq!
					<FORM ACTION="$url" METHOD="POST">
					<INPUT TYPE="text" SIZE="80" NAME="query"><INPUT TYPE="submit" NAME="toss" VALUE="do it"></FORM>
			!;
		}

		for $i (1..4){
			print qq!<FORM ACTION="$url" METHOD="POST">!;
			print "<H3>";
			print qq!<INPUT TYPE="submit" NAME="toss" VALUE="do it"><BR>!;
			print qq!<TEXTAREA COLS="70" ROWS="4" NAME="query" WRAP="virtual"></TEXTAREA></FORM>!;
		}
		
		print qq!<BR><BR><BR><BR><FORM ACTION="$url" METHOD="POST" ENCTYPE="multipart/form-data">
			<CENTER><BR><H3>
			<INPUT TYPE="file" NAME="file_name"><INPUT TYPE="hidden" NAME="query" VALUE="file"><INPUT TYPE="submit" NAME="toss" VALUE="upload"></FORM><BR>!;

		
		exit;
}	#end unless


#connect to the DB
$database_name = "DNS";
$user = "root";
$pass = "117shinzu";
$database_host = "127.0.0.1";
	
#connect to db
$db_init_string = qq!dbi:mysql:$database_name:$database_host!;
$dbh = DBI->connect("$db_init_string;mysql_socket=/data/db/mysql/mysql.sock", $user, $pass)
	    || die "Can't connect to $database_name: $DBI::errstr";



$web_query = $web->param("query");

#$web_query =~ s/&#39;/\'/gs;

if ($file_name = $web->param('file_name')){
	$web_query = "";
	while ($bytesread=read($file_name,$buffer,1024)) {
		$web_query .= $buffer;
			
	}
	$web_query = ";\n".$web_query;
	
}	# end if file name

if ($web_query =~ m/^;/){
	
	$web_query =~ s/^;//;
	@queries = split /\\g/,$web_query;
	
}
else {
	
	push @queries,$web_query;
}

foreach $query (@queries){
	
	$done = "";
	
	print "<BR><B>$query </B><BR>";
	
	if ($query =~ /^select/i){

		$sth = $dbh->prepare($query);

		$sth->execute||print "error: $DBI::errstr";


		#for each row do what's in the while statement.
		while(%row = %{$sth->fetchrow_hashref}) {

			$done++;



			foreach $field (keys %row){

				if ($row{$field}){

					print "Field is $field, data is $row{$field} <BR>\n";

				}	#end if the field has a value

			}	#end for each field in the row

			print "<BR><BR>Next Row:<BR><BR>";
		}	#end while rows exist

		if ($done){
			print "<BR><BR>$done rows<BR><BR>";
		}	#end if the row counter has a value
		$sth->finish;
	}	#end if it's a select statement

	else {
	
		#postgres function creation statements are not
		#forgiving of whitespace in this context.
		if ($query =~ m/^\s*create function/i){
			
			$temp1 = chr(13);
			$temp2 = chr(10);
			$query =~ s/$temp1|$temp2/ /gis;
			
			#print $query;
		}

		$dbh->do($query);
		if ($dbh->errstr){print $dbh->errstr}

	}

}	#end foreach


#clean up and disconnect


$dbh->disconnect ;


if ($err){

	print "Problem:  ".$err;

	exit;

}


print "<BR><BR><BR>Done";

end_of_it

print $@;


