#!/usr/bin/perl
# Cambiado el nombre del archivo a delete.pl
use strict;
use warnings;
use CGI;
use DBI;
use utf8;

my $cgi = CGI->new;
print $cgi->header('application/xml');
$cgi->charset('UTF-8');

my $owner = $cgi->param('owner');
my $title = $cgi->param('title');

print "<?xml version='1.0' encoding='utf-8'?>\n";

if ($owner && $title) {
    # Configuración de conexión
    my $database = 'wikipweb1';
    my $hostname = 'localhost';
    my $port     = 3306;
    my $user     = 'cgi_user';
    my $password = '1234567890';
    my $dsn      = "DBI:mysql:database=$database;host=$hostname;port=$port";
    
    my $dbh = DBI->connect($dsn, $user, $password, { RaiseError => 1, PrintError => 0, mysql_enable_utf8 => 1 });
    
    if ($dbh) {
        my $query = "DELETE FROM Articles WHERE owner = ? AND title = ?";
        my $sth   = $dbh->prepare($query);
        my $rows  = $sth->execute($owner, $title);
        
        if ($rows > 0) {
            print "<article>\n";
            print "  <owner>$owner</owner>\n";
            print "  <title>$title</title>\n";
            print "</article>\n";
        } else {
            print "<article>\n</article>\n"; # XML vacío si no se elimina
        }
        $dbh->disconnect();
    } else {
        print "<article>\n</article>\n"; # XML vacío si falla la conexión
    }
} else {
    print "<article>\n</article>\n"; # XML vacío si faltan parámetros
}