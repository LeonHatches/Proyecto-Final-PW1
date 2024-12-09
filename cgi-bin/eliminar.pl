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

my $id = $cgi->param('id');

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
                <h2>ELIMINANDO LA <span class="textos-rojos">PÁGINA</span></h2>   
HTML


if ($id) {
    
    #ACCION PARA ELIMINAR REGISTRO
    if ($dbh)
    {
        # ELIMINACION
        my $consulta = "DELETE FROM wiki WHERE id = ?";
        my $sth = $dbh->prepare($consulta);
        my $delete = $sth->execute($id);

        if ($delete) {
            print "\t    <p>Página eliminada correctamente.</p>\n";
        } else {
            print "\t    <p>Error al intentar eliminar la página.</p>\n";
        }

        $dbh->disconnect();

    } else {
        print "\t    <p>No se pudo conectar a la base de datos.</p>\n";
    }

} else {
    print "\t    <p>Página no proporcionada o inválida.</p>\n";
}

print<<HTML;
                <a href="lista.pl" class="conexion-ref">Volver a Lista</a>  -  
                <a href="/index.html" class="conexion-ref">Volver al Inicio</a>
            </div>
        </div>
    </body>
</html>
HTML

