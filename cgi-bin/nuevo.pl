
#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header('application/xml');
print "<?xml version='1.0' encoding='utf-8'?>\n";

my $titulo = $cgi->param('titulo');
my $texto = $cgi->param('text_intro');
my $user = $cgi->param('owner');

if (defined $titulo and defined $texto and defined $user) {
    my $dsn = "DBI:mysql:database=wikipweb1;host=localhost;port=3306";
    my $dbh = DBI->connect($dsn, 'root', '1234567890', {
        RaiseError => 1,
        PrintError => 0,
    });

    my $check_sql = "SELECT * FROM Articles WHERE title = ? AND owner = ?";
    my $check_sth = $dbh->prepare($check_sql);
    $check_sth->execute($titulo, $user);

    if ($check_sth->fetchrow_array) {
        print "<error>El artículo ya existe</error>\n";
    } else {
        print "<message>Artículo no encontrado</message>\n";
    }

    $dbh->disconnect;
} else {
    print "<error>Faltan parámetros</error>\n";
}
