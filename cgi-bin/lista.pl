#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use utf8;
use DBI;

# CGI
my $cgi = CGI->new;
print $cgi->header('application/xml');
      $cgi->charset('UTF-8');
      
print "<?xml version='1.0' encoding='utf-8'?>\n";

# Verificar su procedencia
my $direccion = $cgi->param('direccion');

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

# Generar respuesta XML
print "<articles>\n";

if (defined $direccion && $direccion eq "login") {

    my $userName = $cgi->param('owner');

    # Consultar artículos según el propietario
    my $sql = "SELECT owner, title FROM Articles WHERE owner = ?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($userName);

    mostrar($sth);
    $sth->finish();

} else {

     # Consultar todos los artículos
    my $sql = "SELECT owner, title FROM Articles";
    my $sth = $dbh->prepare($sql);
    $sth->execute();

    mostrar($sth);
    $sth->finish();
}

print "</articles>";

$dbh->disconnect();


sub mostrar {
    my ($sth) = @_;

    while (my ($owner, $title) = $sth->fetchrow_array) {
        print<<XML;
    <article>
        <owner>$owner</owner>
        <title>$title</title>
    </article>
XML
    }
}
