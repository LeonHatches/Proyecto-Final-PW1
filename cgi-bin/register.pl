#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header('application/xml; charset=utf-8');

my $userName  = $cgi->param('userName');
my $password  = $cgi->param('password');
my $firstName = $cgi->param('firstName');
my $lastName  = $cgi->param('lastName');

if ($userName && $password && $firstName && $lastName) {
    my $dsn = "DBI:mysql:database=wikipweb1;host=localhost;port=3306";
    my $dbh = DBI->connect($dsn, 'cgi_user', '1234567890', { RaiseError => 1, mysql_enable_utf8 => 1 });

    my $sth = $dbh->prepare("INSERT INTO Users (userName, password, firstName, lastName) VALUES (?, ?, ?, ?)");
    if ($sth->execute($userName, $password, $firstName, $lastName)) {
        print <<"XML";
<?xml version='1.0' encoding='utf-8'?>
<user>
  <owner>$userName</owner>
  <firstName>$firstName</firstName>
  <lastName>$lastName</lastName>
</user>
XML
    } else {
        print "<?xml version='1.0' encoding='utf-8'?>\n<user></user>";
    }
    $dbh->disconnect();
} else {
    print "<?xml version='1.0' encoding='utf-8'?>\n<user></user>";
}
