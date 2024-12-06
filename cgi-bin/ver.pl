#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI;

my $cgi = CGI->new;
#ID DE LA PÁGINA
my $page_id = $cgi->param('page') || 'default_page';
#CONEXIÓN A LA BASE DE DATOS...
my $dbh = DBI->connect()
#consultar contenido
my $sth = $dbh->prepare("Selecciona el contenido de las páginas donde id = ?");
$sth->execute($page_id);
#contenido de markdown
my ($markdown_contenido) = $sth->fetchrow_array;
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
    my ($markdown) = @_;
        $markdown =~ s/^###### (.*?)$/<h6>$1<\/h6>/gm;  # Encabezado H6
        $markdown =~ s/^##### (.*?)$/<h5>$1<\/h5>/gm;  # Encabezado H5
        $markdown =~ s/^#### (.*?)$/<h4>$1<\/h4>/gm;  # Encabezado H4
        $markdown =~ s/^### (.*?)$/<h3>$1<\/h3>/gm;  # Encabezado H3
        $markdown =~ s/^## (.*?)$/<h2>$1<\/h2>/gm;  # Encabezado H2
        $markdown =~ s/^# (.*?)$/<h1>$1<\/h1>/gm;   # Encabezado H1
        $markdown =~ s/\*\*(.*?)\*\*/<b>$1<\/b>/g;  # Texto en negrita
        $markdown =~ s/\*(.*?)\*/<i>$1<\/i>/g;      # Texto en cursiva
        $markdown =~ s/~~(.*?)~~/<del>$1<\/del>/g;  # Texto tachado
        $markdown =~ s/\[(.*?)\]\((.*?)\)/<a href="$2">$1<\/a>/g;  # Hipervínculos
        $markdown =~ s/`(.*?)`/<code>$1<\/code>/g;  # Código en línea
    return $markdown;
}
