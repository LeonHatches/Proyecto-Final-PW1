#!/Strawberry/perl/bin/perl.exe
#/usr/bin/perl

use strict;
use warnings;
use CGI;
use utf8;
use DBI;


# Encabezado XML
my $cgi = CGI->new;
print $cgi->header('application/xml');
print "<?xml version='1.0' encoding='utf-8'?>\n";

# Obtener parámetros
my $owner = $cgi->param('owner');
my $title = $cgi->param('title');

# Verificar que los parámetros sean válidos
if (!$owner || !$title) {
    XMLvacio();
    exit;
}

#-----------------------------------------------------------------

# Configuración de conexión
my $db = 'wikipweb1';
my $db_host = 'localhost';
my $db_port = 3306;
my $db_user = 'root';
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


# Consultar el artículo
my $sth = $dbh->prepare("SELECT text FROM Articles WHERE owner = ? AND title = ?");
$sth->execute($owner, $title);

# Obtener resultados y generar XML
if (my $row = $sth->fetchrow_hashref) {
    my $text = $row->{text};
    print<<XML;
<article>
  <owner>$owner</owner>
  <title>$title</title>
  <text>$text</text>
</article>
XML

} else {
  XMLvacio();
}

# Liberar recursos y cerrar conexión
$sth->finish();
$dbh->disconnect();

sub XMLvacio {
  print<<XML;
<article>
  <owner></owner>
  <title></title>
  <text></text>
</article>
XML
}