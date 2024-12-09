#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use utf8;
use Encode;

my $cgi = CGI->new;
print $cgi->header(-type => 'text/html', -charset => 'UTF-8');

# HTML inicial con estructura similar a editor.pl
print <<'HTML';
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Visualizar Página</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<header>
    <nav>
        <ul>
            <li><a href="../index.html">Inicio</a></li>
            <li><a href="listaPag.pl">Listado</a></li>
        </ul>
    </nav>
</header>

<div class="container">
    <div class="contenido-left">
HTML

# Obtener el ID desde la URL
my $id = $cgi->param('id');

if ($id) {
    # Configuración de conexión a la base de datos
    my $database = "wikipweb1";
    my $hostname = "db";  # Servicio configurado en Docker
    my $port     = 3306;
    my $user     = "root";
    my $password = "password";
    my $dsn      = "DBI:mysql:database=$database;host=$hostname;port=$port";

    # Conectar a la base de datos
    my $dbh = DBI->connect($dsn, $user, $password, {
        RaiseError       => 1,
        PrintError       => 0,
        mysql_enable_utf8 => 1,
    });

    if ($dbh) {
        my $sth = $dbh->prepare("SELECT titulo, contenido FROM wiki WHERE id = ?");
        $sth->execute($id);

        my $row = $sth->fetchrow_hashref;
        if ($row) {
            # Convertir Markdown a HTML
            my $html_content = convertir_markdown_a_html($row->{contenido});

            # Mostrar el contenido y el título
            print "<h1 class='titulo'>" . encode_utf8($row->{titulo}) . "</h1>\n";
            print "<div class='contenido'>\n$html_content\n</div>\n";
        } else {
            print "<p>No se encontró la página con el ID: $id</p>\n";
        }

        $sth->finish();
        $dbh->disconnect();
    } else {
        print "<p>Error al conectar con la base de datos.</p>\n";
    }
} else {
    print "<p>ID no proporcionado o inválido.</p>\n";
}

# HTML final con un enlace de regreso al listado
print <<'HTML';
    </div>
</div>
<footer>
    <a href="listaPag.pl" class="btn-accion btn-gris">Volver al Listado</a>
</footer>
</body>
</html>
HTML

# Subrutina para convertir Markdown a HTML con soporte para subíndices
sub convertir_markdown_a_html {
    my ($markdown) = @_;

    # Convertir encabezados
    $markdown =~ s/^###### (.+)$/<h6>$1<\/h6>/gm;
    $markdown =~ s/^## (.+)$/<h2>$1<\/h2>/gm;
    $markdown =~ s/^# (.+)$/<h1>$1<\/h1>/gm;

    # Convertir estilos de texto
    $markdown =~ s/\*\*\*(.+?)\*\*\*/<strong><em>$1<\/em><\/strong>/g;
    $markdown =~ s/\*\*(.+?)\*\*/<strong>$1<\/strong>/g;
    $markdown =~ s/\*(.+?)\*/<em>$1<\/em>/g;
    $markdown =~ s/~~(.+?)~~/<del>$1<\/del>/g;

    # Convertir bloques de código
    $markdown =~ s/```(.+?)```/<pre><code>$1<\/code><\/pre>/gs;

    # Convertir enlaces
    $markdown =~ s/\[(.+?)\]\((.+?)\)/<a href="$2">$1<\/a>/g;

    # Convertir subíndices (usando `~texto~` como marcador)
    $markdown =~ s/~(.+?)~/<sub>$1<\/sub>/g;

    # Convertir saltos de línea a <br>
    $markdown =~ s/\n/<br>\n/g;

    return encode_utf8($markdown);
}
