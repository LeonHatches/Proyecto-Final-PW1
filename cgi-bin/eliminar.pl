#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use DBI;
use utf8;

my $cgi = CGI->new;
print $cgi->header('application/xml');
      $cgi->charset('UTF-8');
      
print "<?xml version='1.0' encoding='utf-8'?>\n";

# Parámetros CGI
my $owner = $cgi->param('owner');
my $title = $cgi->param('title');

#-----------------------------------------------------------------

# Configuración de conexión
my $db = 'wikipweb1';
my $db_host = 'localhost';
my $db_port = 3306;
my $db_user = 'cgi_user';
my $db_password = '1234567890';

# DSN de conexión
my $dsn = "DBI:mysql:database=$db;host=$db_host;port=$db_port";

# Conexión a la base de datos
my $dbh = DBI->connect(
    $dsn, 
    $db_user, 
    $db_password, 
    {
        RaiseError => 1,
        PrintError => 0,
        AutoCommit => 1,
        mysql_enable_utf8mb4 => 1
    }
) or die "Error al conectar a la base de datos MariaDB: $DBI::errstr\n";

$dbh->do("SET NAMES utf8mb4");

#----------------------------------------------------------------

if (defined $owner && defined $title) {

    # Comprobar si ya existe un artículo con el mismo título y propietario
    my $check_sql = "SELECT * FROM Articles WHERE title = ? AND owner = ?";
    my $check_sth = $dbh->prepare($check_sql);
    $check_sth->execute($title, $owner);

    if ($check_sth->fetchrow_array) {
        
        #  eliminar el artículo
        my $sql = "DELETE FROM Articles WHERE owner = ? AND title = ?";
        my $sth = $dbh->prepare($sql);
        $sth->execute($owner, $title);
        
        mostrarEliminar($owner, $title);

        $sth->finish;

    } else {
        XMLvacio();
    }
} else {
     XMLvacio();
}

$dbh->disconnect;

sub XMLvacio {
    print<<XML;
<article>
    <owner></owner>
    <title></title>
</article>
XML
}

sub mostrarEliminar {
    my ($owner, $title) = @_;
    print<<XML;
<article>
    <owner>$owner</owner>
    <title>$title</title>
</article>
XML
}