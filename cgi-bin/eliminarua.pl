#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;

# Establecer la conexión con la base de datos
my $dbh = DBI->connect("DBI:mysql:database=wikipweb1;host=localhost", "cgi_user", "1234567890", {'RaiseError' => 1});

# Crear un objeto CGI
my $q = CGI->new;

# Obtener el parámetro del nombre de usuario
my $usuario = $q->param('usuario');

# Verificar si falta el nombre de usuario
if (!$usuario) {
    print $q->header('text/xml');
    print "<?xml version='1.0' encoding='utf-8'?>\n";
    print "<response>\n";
    print "<status>error</status>\n";
    print "<message>Falta el nombre de usuario.</message>\n";
    print "</response>\n";
    exit;
}

# Eliminar el usuario de la base de datos
my $sth = $dbh->prepare("DELETE FROM Users WHERE userName = ?");
$sth->execute($usuario);

# Verificar si se eliminó algún usuario
if ($sth->rows == 0) {
    print $q->header('text/xml');
    print "<?xml version='1.0' encoding='utf-8'?>\n";
    print "<response>\n";
    print "<status>error</status>\n";
    print "<message>Usuario no encontrado.</message>\n";
    print "</response>\n";
} else {
    print $q->header('text/xml');
    print "<?xml version='1.0' encoding='utf-8'?>\n";
    print "<response>\n";
    print "<status>success</status>\n";
    print "<message>Usuario eliminado exitosamente.</message>\n";
    print "</response>\n";
}

# Cerrar la conexión
$dbh->disconnect;
