#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use utf8;
use Encode;

my $cgi = CGI->new;
print $cgi->header(-type => 'text/html', -charset => 'UTF-8');

print <<'HTML';
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>WikiPweb - Visualizar Página</title>
    <link rel="stylesheet" href="../css/Ver.css">
</head>
<body>
HTML

#ID desde la URL
my $id = $cgi->param('id');

if ($id) {
    # Configuración de conexión (adoptando configuración de `backend-pl-2`)
    my $database = "wikipweb1";
    my $host     = "127.0.0.1";
    my $port     = 3306;
    my $user     = "root";
    my $password = "";
    # DSN para la conexión
    my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

    # Conectar a la base de datos
    my $dbh = DBI->connect($dsn, $user, $password, {
        RaiseError       => 1,
        PrintError       => 0,
        mysql_enable_utf8 => 1,
    });

    if ($dbh) {
        # Consulta para obtener título y contenido según el ID
        my $sth = $dbh->prepare("SELECT titulo, contenido FROM wiki WHERE id = ?");
        $sth->execute($id);

        my $row = $sth->fetchrow_hashref;
        if ($row) {
            #De Markdown a HTML
            my $html_content = convertir_markdown_a_html($row->{contenido});

            #Título y el contenido
            print "<h1>" . encode_utf8($row->{titulo}) . "</h1>\n";
            print "<div class='contenido'>\n$html_content\n</div>\n";
        } else {
            print "<p>No se encontró la página con ID: $id</p>\n";
        }

        $sth->finish();
        $dbh->disconnect();
    } else {
        print "<p>Error al conectar con la base de datos.</p>\n";
    }
} else {
    print "<p>No se proporcionó un ID válido.</p>\n";
}

print <<'HTML';
<a href="../index.html">Volver al inicio</a>
</body>
</html>
HTML

#Markdown a HTML
sub convertir_markdown_a_html {
    my ($markdown) = @_;

    #Encabezados
    $markdown =~ s/^###### (.+)$/<h6>$1<\/h6>/gm;
    $markdown =~ s/^## (.+)$/<h2>$1<\/h2>/gm;
    $markdown =~ s/^# (.+)$/<h1>$1<\/h1>/gm;

    #En negrita, cursiva y tachado
    $markdown =~ s/\*\*\*(.+?)\*\*\*/<strong><em>$1<\/em><\/strong>/g;
    $markdown =~ s/\*\*(.+?)\*\*/<strong>$1<\/strong>/g;
    $markdown =~ s/\*(.+?)\*/<em>$1<\/em>/g;
    $markdown =~ s/~~(.+?)~~/<del>$1<\/del>/g;

    #Bloques de código
    $markdown =~ s/```(.+?)```/<pre><code>$1<\/code><\/pre>/gs;

    # Reemplazar enlaces
    $markdown =~ s/\[(.+?)\]\((.+?)\)/<a href="$2">$1<\/a>/g;

    # Reemplazar saltos de línea
    $markdown =~ s/\n/<br>\n/g;

    return encode_utf8($markdown);
}
