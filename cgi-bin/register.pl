#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;

# Establecer la conexión con la base de datos
my $dbh = DBI->connect("DBI:mysql:database=wikipweb1;host=localhost", "cgi_user", "1234567890", {'RaiseError' => 1});

# Crear un objeto CGI
my $q = CGI->new;

# Obtener los parámetros de entrada
my $user = $q->param('userName');
my $password = $q->param('password');
my $lastName = $q->param('lastName');
my $firstName = $q->param('firstName');

# Verificar si faltan parámetros
if (!$user || !$password || !$lastName || !$firstName) {
    print $q->header('text/xml');
    print "<?xml version='1.0' encoding='utf-8'?>\n";
    print "<response>\n";
    print "<status>error</status>\n";
    print "<message>Faltan parámetros.</message>\n";
    print "</response>\n";
    exit;
}

# Comprobar si el usuario ya existe
my $sth = $dbh->prepare("SELECT * FROM Users WHERE userName = ?");
$sth->execute($user);
my $existing_user = $sth->fetchrow_arrayref;

if ($existing_user) {
    print $q->header('text/xml');
    print "<?xml version='1.0' encoding='utf-8'?>\n";
    print "<response>\n";
    print "<status>error</status>\n";
    print "<message>El usuario ya existe.</message>\n";
    print "</response>\n";
    exit;
}

# Insertar el nuevo usuario en la base de datos
my $insert_sth = $dbh->prepare("INSERT INTO Users (userName, password, lastName, firstName) VALUES (?, ?, ?, ?)");
$insert_sth->execute($user, $password, $lastName, $firstName);

# Devolver el resultado en formato XML
print $q->header('text/xml');
print "<?xml version='1.0' encoding='utf-8'?>\n";
print "<response>\n";
print "<status>success</status>\n";
print "<message>Usuario registrado exitosamente.</message>\n";
print "</response>\n";

# Cerrar la conexión
$dbh->disconnect;
