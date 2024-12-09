#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use CGI;
use utf8;
use Encode;

my $cgi = CGI->new;

# Generar el encabezado HTTP con UTF-8
print $cgi->header(-type => 'text/html', -charset => 'UTF-8');

# HTML inicial
print <<'HTML';
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>WikiPweb - Ver</title>
    <link rel="stylesheet" href="./css/Ver.css">
</head>
<body>
HTML

# Obtener el ID desde la URL
my $id = $cgi->param('id');

if ($id) {
    #Configuración de conexión
    my $database = 'wikipweb1';
    my $hostname = 'localhost';
    my $port = 3306;
    my $user = 'cgi_user';
    my $password = '1234567890';

    #DSN de conexión
    my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

    # Conectar a la base de datos
    my $dbh = DBI->connect($dsn, $user, $password, {
        RaiseError       => 1,
        PrintError       => 0,
        mariadb_enable_utf8 => 1,  # Soporte para UTF-8
    });

    if ($dbh) {
        # Consultar título y texto
        my $sth = $dbh->prepare("SELECT titulo, texto FROM wiki WHERE id = ?");
        $sth->execute($id);

        my $row = $sth->fetchrow_hashref;
        if ($row) {
            # Convertir el texto de Markdown a HTML
            my $html_content = convertir_markdown_a_html($row->{texto});

            # Mostrar el título y el texto convertido
            print "<h1>" . encode_utf8($row->{titulo}) . "</h1>\n";
            print "<div class='texto'>\n$html_content\n</div>\n";
        } else {
            print "<p>No se encontró el registro con el ID: $id</p>\n";
        }

        $sth->finish();
        $dbh->disconnect();
    } else {
        print "<p>Error al conectar con la base de datos.</p>\n";
    }
} else {
    print "<p>ID no proporcionado.</p>\n";
}

# HTML final
print <<'HTML';
<a href="./index.html">Volver al inicio</a>
</body>
</html>
HTML

# Subrutina para convertir Markdown a HTML
sub convertir_markdown_a_html {
    my ($markdown) = @_;

    # Convertir encabezados
    $markdown =~ s/^###### (.+)$/<h6>$1<\/h6>/gm;
    $markdown =~ s/^## (.+)$/<h2>$1<\/h2>/gm;
    $markdown =~ s/^# (.+)$/<h1>$1<\/h1>/gm;

    # Convertir negrita, cursiva y tachado
    $markdown =~ s/\*\*\*(.+?)\*\*\*/<strong><em>$1<\/em><\/strong>/g;
    $markdown =~ s/\*\*(.+?)\*\*/<strong>$1<\/strong>/g;
    $markdown =~ s/\*(.+?)\*/<em>$1<\/em>/g;
    $markdown =~ s/~~(.+?)~~/<del>$1<\/del>/g;

    # Convertir bloques de código
    $markdown =~ s/```(.+?)```/<pre><code>$1<\/code><\/pre>/gs;

    # Convertir enlaces
    $markdown =~ s/\[(.+?)\]\((.+?)\)/<a href="$2">$1<\/a>/g;

    # Reemplazar saltos de línea con <br>
    $markdown =~ s/\n/<br>\n/g;

    return encode_utf8($markdown);
}
#modelo basico