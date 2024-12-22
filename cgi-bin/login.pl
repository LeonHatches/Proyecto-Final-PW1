#!/usr/bin/perl

# Modulos
use strict;
use warnings;
use CGI;
use DBI;
use utf8;

# CGI
my $cgi = CGI->new;
print $cgi->header('application/xml');
      $cgi->charset('UTF-8');
      
print "<?xml version='1.0' encoding='utf-8'?>\n";

my $username = $cgi->param('user');
my $passw = $cgi->param('password');

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

#-----------------------------------------------------------------

if (defined ($username) and defined ($passw) ) {
	if ( my @row = verificarCuenta($username, $passw) ) {
		xmlCuenta(@row);
	} else {
		xmlVacio();
	}

} else {
	xmlVacio();
}


sub xmlVacio {
	print<<XML;
<user>
	<owner></owner>
	<firstName></firstName>
	<lastName></lastName>
</user>
XML
}


sub verificarCuenta {
	my $username = $_[0];
	my $passw = $_[1];

	my $consulta = "SELECT userName, firstName, lastName FROM Users WHERE userName = ? AND password = ?";
	my $sth = $dbh->prepare($consulta);
	$sth->execute($username, $passw);

	my @row = $sth->fetchrow_array;

	$sth->finish;
	$dbh->disconnect;

	return @row;
}

sub xmlCuenta {
	my @row = @_;
	my ($username, $firstName, $lastName) = ($row[0], $row[1], $row[2]);

	print<<XML;
<user>
	<owner>$username</owner>
	<firstName>$firstName</firstName>
	<lastName>$lastName</lastName>
</user>
XML
}