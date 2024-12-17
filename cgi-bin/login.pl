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
print "<?xml version='1.0' encoding='utf-8'?>\n";

my $username = $cgi->param('user');
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
	$sth->execute($user, $passw);

	my @row = $sth->fetchrow_array;

	$sth->finish;
	$dbh->disconnect;

	return @row;
}

sub xmlCuenta {
	my @row = @_;
	my ($username, $firstName, $lastName) = ($row[0], $row[1], $row[3]);

	print<<XML;
<user>
	<owner>$user</owner>
	<firstName>$firstName</firstName>
	<lastName>$lastName</lastName>
</user>
XML
}