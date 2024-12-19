#!/Strawberry/perl/bin/perl.exe
#/usr/bin/perl

# Modulos
use strict;
use warnings;
use CGI;
use DBI;
use utf8;
use Encode;

# CGI
my $cgi = CGI->new;
print $cgi->header('application/xml');
      $cgi->charset('UTF-8');
      
print "<?xml version='1.0' encoding='utf-8'?>\n";

my $username = $cgi->param('user');
my $passw = $cgi->param('password');
my $firstName = $cgi->param('firstName');
my $lastName = $cgi->param('lastName');

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
	mysql_enable_utf8mbd4 => 1,
});

#-----------------------------------------------------------------

if (defined ($username) and defined ($passw) and defined ($firstName) and defined ($lastName) ) {
	
	if ( my @row = crearCuenta($username, $passw, $firstName, $lastName) ) {
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


sub crearCuenta {

	my ($username, $passw, $firstName, $lastName) = @_;
	my @row;

	my $consulta = "INSERT INTO Users (userName, password, firstName, lastName) VALUES (?, ?, ?, ?)";
	my $sth_INSERT = $dbh->prepare($consulta);

	eval {
	   $sth_INSERT->execute($username, $passw, $firstName, $lastName);
	};

	if (!$@) {

		$consulta = "SELECT userName, firstName, lastName FROM Users WHERE userName = ? AND firstName = ? AND lastName = ?";
		my $sth_SELECT = $dbh->prepare($consulta);
		$sth_SELECT->execute($username, $firstName, $lastName) or die;

		@row = $sth_SELECT->fetchrow_array;

		$sth_SELECT->finish;
		$sth_INSERT->finish;

	}
	
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