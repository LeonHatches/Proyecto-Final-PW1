#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use DBI;
use utf8;

# CGI
my $cgi = CGI->new;
print $cgi->header('text/html');
      $cgi->charset('UTF-8');

my $id = $cgi->param('id');


print<<HTML;
<!DOCTYPE html>
<html>

    <head>
        <!--Extensión para caracteres especiales-->
        <meta charset="utf-8">

        <!--fuente de letra-->
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;700&display=swap"
              rel="stylesheet"
              type="text/css">

        <!--fuente de letra-->
        <link
            href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap"
            rel="stylesheet"
            type="text/css">

        <!--CSS-->
        <link rel = "stylesheet" type = "text/css" href = "/css/style.css">

        <title>CONEXIÓN</title>
    </head>
    
    <body>

        <!--CABECERA-->
        
        <header> <a class="logo" href="/index.html">Wikipedia</a>
          <nav>
            <ul>
              <li><a href="/index.html">Inicio</a></li>
              <li><a href="lista.pl">Ver lista</a></li>
            </ul>
          </nav>
        </header>

        <!--CONTENEDOR VISUAL DE LA PÁGINA-->
        <div class="container">
            <div id="crear-pagina" class="contenedor-nuevapagina"
                style="margin: 0; border-top-right-radius: 0px; border-top-left-radius: 0px;"> 
HTML


if ($id) {

        #-----------------------------------------------------------------

        #Configuración de conexión
        my $database = 'wikipweb1';
        my $hostname = 'localhost';
        my $port = 3306;
        my $user = 'cgi_user';
        my $password = '1234567890';

        #DSN de conexión
        my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

        #Conexión a la DB
        my $ dbh = DBI->connect($dsn, $user, $password, {
            RaiseError => 1,
            PrintError => 0,
            mysql_enable_utf8mb4 => 1,
        });

	$dbh->do("SET NAMES utf8mb4");

        #-----------------------------------------------------------------

    if ($dbh) {
        my $sth = $dbh->prepare("SELECT titulo, texto FROM wiki WHERE id = ?");
        $sth->execute($id);

        my $row = $sth->fetchrow_hashref;
        if ($row) {
            # Convertir Markdown a HTML
            my $html_content = convertir_markdown_a_html($row->{texto});

            # Mostrar el texto y el título
            print "<h1 class='titulo'>" . $row->{titulo} . "</h1>\n";
            print "<div class='texto'>\n$html_content\n</div>\n";
        } else {
            print "<p>No se encontró la página.</p>\n";
        }

        $sth->finish();
        $dbh->disconnect();
    } else {
        print "<p>Error al conectar con la base de datos.</p>\n";
    }
} else {
    print "<p>ID no proporcionado o inválido.</p>\n";
}

print<<HTML;
                <!--BOTONES-->
                <br>
                <div class="botones" style="justify-content: center;">
                    <a href="lista.pl" class="btn-accion btn-crear">Volver a Lista</a>
                    <a href="/index.html" class="btn-accion btn-gris">Volver al Inicio</a>
                </div>
            </div>
        </div>
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

    # Convertir estilos de texto
    $markdown =~ s/\*\*\*(.+?)\*\*\*/<strong><em>$1<\/em><\/strong>/g;
    $markdown =~ s/\*\*(.+?)\*\*/<strong>$1<\/strong>/g;
    $markdown =~ s/\*(.+?)\*/<em>$1<\/em>/g;
    $markdown =~ s/~~(.+?)~~/<del>$1<\/del>/g;

    # Convertir bloques de código
    $markdown =~ s/```(.+?)```/<pre><code>$1<\/code><\/pre>/gs;

    # Convertir enlaces
    $markdown =~ s/\[(.+?)\]\((.+?)\)/<a href="$2">$1<\/a>/g;

    # Convertir saltos de línea a <br>
    $markdown =~ s/\n/<br>\n/g;

    return $markdown;
}

