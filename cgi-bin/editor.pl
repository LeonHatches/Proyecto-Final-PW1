#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use utf8;
use DBI;

my $cgi = CGI->new;
print $cgi->header('application/xml');
      $cgi->charset('UTF-8');
      
print "<?xml version='1.0' encoding='utf-8'?>\n";

# Obtener los parámetros
my $title = $cgi->param('title');
my $owner = $cgi->param('owner');
my $text = $cgi->param('text');

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

#------------ -----------------------------------------------------

# Verificar que se recibieron los datos necesarios
if (defined $owner and defined $title and defined $text) {

    # Comprobar si ya existe un artículo con el mismo título y propietario
    my $check_sql = "UPDATE Articles SET text = ? WHERE title = ? AND owner = ?";
    my $check_sth = $dbh->prepare($check_sql);
    $check_sth->execute($text, $title, $owner);

	editar($title, $text);
    $check_sth->finish;

} else {
     XMLvacio();
}

$dbh->disconnect;

# Subrutina para imprimir el XML de éxito
sub editar {
    my ($title, $text) = @_;
    print<<XML;
<article>
    <title>$title</title>
    <text>$text</text>
</article>
XML
}

# Subrutina para imprimir el XML vacio
sub XMLvacio {
    print<<XML;
<article>
    <title></title>
    <text></text>
</article>
XML
}
