#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use utf8;
use DBI;

my $cgi = CGI->new;
print $cgi->header('text/xml;charset=UTF-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";


my $usuario = $cgi->param('usuario');

# Configuración de conexión
my $database = 'wikipweb1';
my $hostname = 'localhost';
my $port = 3306;
my $user = 'cgi_user';
my $password = '1234567890';

# DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conexión a la base de datos
my $dbh = DBI->connect(
    $dsn, 
    $user, 
    $password, 
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

if (defined $usuario) {
    # Consultar artículos según el propietario
    my $sql = "SELECT id, titulo FROM wiki WHERE owner = ?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($usuario);

    while (my ($id, $titulo) = $sth->fetchrow_array) {
        print <<XML;
    <article>
        <id>$id</id>
        <title>$titulo</title>
    </article>
XML
    }

    $sth->finish();
}

print "</articles>\n";

$dbh->disconnect();

