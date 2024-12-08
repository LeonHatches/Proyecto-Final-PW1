#!/usr/bin/perl

# Modulos
use strict;
use warnings;
use CGI;
use DBI;
use utf8;

# CGI
my $cgi = CGI->new;
print $cgi->header('text/html');
      $cgi->charset('UTF-8');

#Si viene de nuevo.html o editor.pl
my $pagina = $cgi->param('direccion');

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
    mysql_enable_utf8 => 1,
});

#-----------------------------------------------------------------

print<<HTML;
<!DOCTYPE html>
<html>
    <head>
        <!--fuente de letra-->
        <link
            href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap"
            rel="stylesheet"
            type="text/css">

        <!--CSS-->
        <link rel = "stylesheet" type = "text/css" href = "/css/style.css">
        
        <title>Eliminar</title>
    </head>
    
    <body>
        <!--CABECERA-->
        <header>
            <nav>
                <ul>
                    <li><a href="index.html">INICIO</a></li>
                    <li><a href="cgi-bin/lista.pl">LISTA</a></li>
                </ul>
            </nav>
        </header>

        <!--CAJA DE TITULO-->
        <div>
            PAGINA EN PROCESO...
        </div>

        <!--CREACION DE PAGINA-->
        <div>   
HTML

if ($dbh) {
    print "\t    <p class='mensaje'>Conexión a la base de datos establecida correctamente.</p>\n";
    $dbh->disconnect();
} else {
    print "\t    <p class='error'>No se pudo conectar a la base de datos: " . DBI->errstr . "</p>\n";
}


print<<HTML;
            <a href="lista.pl">Volver a Lista</a>
            <a href="index.html">Volver al Inicio</a>
        </div>
    </body>
</html>
HTML
