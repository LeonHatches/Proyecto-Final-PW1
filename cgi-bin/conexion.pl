#!/usr/bin/perl

# Modulos
use strict;
use warnings;
use CGI;
use DBI;
use utf8;
use Encode;

# CGI
my $cgi = CGI->new;
print $cgi->header('text/html');
      $cgi->charset('UTF-8');

#Si viene de nuevo.html o editor.pl
my $direccion = $cgi->param('direccion');
my $consulta;
my $sth;
my $titulo;
my $texto;

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
    AutoCommit => 1,
    mysql_enable_utf8mb4 => 1
});

$dbh->do("SET NAMES utf8mb4");

#-----------------------------------------------------------------

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

        <!--CONTENEDOR NUEVA PÁGINA-->
        <div class="container">
            <div id="crear-pagina" class="contenedor-nuevapagina"
                style="margin: 0; border-top-right-radius: 0px; border-top-left-radius: 0px;">
                <h2>CONECTANDO CON LA <span class="textos-rojos">PÁGINA</span></h2>   
HTML

if ($dbh) {
    
    $titulo = $cgi->param("titulo");
    $texto  = $cgi->param("texto");

    if ($direccion eq 'nuevo')
    {
        $consulta = "INSERT INTO wiki (titulo, texto) VALUES (?, ?)";
        $sth = $dbh->prepare($consulta);
        $sth->execute($titulo, $texto);

        print "<p>El contenido fue agregado con éxito.</p>";
    
    } elsif ($direccion eq 'editor') {
        
        my $id = $cgi->param('id');
        $consulta = "UPDATE wiki SET titulo = ?, texto = ? WHERE id = ?";
        
        $sth = $dbh->prepare($consulta);
        $sth->execute($titulo, $texto, $id);

        print "<p>El contenido fue modificado con éxito.</p>";

    } else {
        print "<p>Error en la información de entrada.</p>";
    }

    $sth->finish();
    $dbh->disconnect();

} else {
    print "\t    <p>No se pudo conectar a la base de datos.</p>\n";
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

