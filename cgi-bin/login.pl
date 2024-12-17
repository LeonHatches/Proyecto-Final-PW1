#!/Strawberry/perl/bin/perl.exe
#/usr/bin/perl

# Modulos
use strict;
use warnings;
use CGI;
use DBI;
use utf8;

# CGI
my $cgi = CGI->new;
print $cgi->header('application/xml');
print "<?xml version='1.0' encoding='utf-8'?>";

my $user = $cgi->param('user');
my $passw = $cgi->param('password');

#-----------------------------------------------------------------

#Configuración de conexión
my $database = 'wikipweb1';
my $hostname = 'localhost';
my $port = 3306;
my $user = 'root';
my $password = '1234567890';

#DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

#Conexión a la DB
my $ dbh = DBI->connect($dsn, $user, $password, {
	RaiseError => 1,
	PrintError => 0,
	mysql_enable_utf8 => 1,
});

#-----------------------------------------------------------------

if (defined ($user) and defined ($passw) ) {
	if ( verificarCuenta() ) {

	} else {
		xmlVacio();
	}
} else {
	xmlVacio();
}