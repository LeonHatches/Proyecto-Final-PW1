#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use utf8;

# Crear objeto CGI
my $cgi = CGI->new;

# Encabezado XML
print $cgi->header(-type => 'text/xml', -charset => 'UTF-8');

# Obtener parámetros
my $owner = $cgi->param('owner');
my $title = $cgi->param('title');

# Verificar que los parámetros sean válidos
if (!$owner || !$title) {
    print <<'XML';
<?xml version='1.0' encoding='utf-8'?>
<article>
  <owner></owner>
  <title></title>
  <text></text>
</article>
XML
    exit;
}

# Configuración de conexión a la base de datos
my $database = 'articlesdb';
my $hostname = 'localhost';
my $port     = 3306;
my $user     = 'cgi_user';
my $password = '123456';
my $dsn      = "DBI:mysql:database=$database;host=$hostname;port=$port";

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $user, $password, {
    RaiseError       => 1,
    PrintError       => 0,
    mysql_enable_utf8 => 1,
});

# Consultar el artículo
my $sth = $dbh->prepare("SELECT text FROM Articles WHERE owner = ? AND title = ?");
$sth->execute($owner, $title);

# Obtener resultados y generar XML
if (my $row = $sth->fetchrow_hashref) {
    my $text = $row->{text};
    print <<XML;
<?xml version='1.0' encoding='utf-8'?>
<article>
  <owner>$owner</owner>
  <title>$title</title>
  <text><![CDATA[$text]]></text>
</article>
XML
} else {
    # Si no se encuentra el artículo
    print <<'XML';
<?xml version='1.0' encoding='utf-8'?>
<article>
  <owner></owner>
  <title></title>
  <text></text>
</article>
XML
}

# Liberar recursos y cerrar conexión
$sth->finish();
$dbh->disconnect();

