#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;

my $cgi = CGI->new;
#ID DE LA PÁGINA
my $page_id = $cgi->param('page') || 'default_page';
#CONEXIÓN A LA BASE DE DATOS...
#consultar contenido
my $sth = $dbh->prepare("Selecciona el contenido de las páginas donde id = ?");
$sth->execute($page_id);
#contenido de markdown
#markdown a html
my $html_contenido = markdown_a_html($markdown_contenido);
print $cgi->header(-type => 'text/html');
print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Visualización de Página</title>
</head>
<body>
    <h1>Visualización de la página: $page_id</h1>
    <div>$html_content</div>
    <a href="/cgi-bin/list_pages.pl">Volver al listado</a>
</body>
</html>
HTML
sub markdown_a_html{
  return $markdown;
}
