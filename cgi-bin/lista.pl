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


#-------------------------------------------------------------

#Configuración de conexión
my $database = 'wikipweb1';
my $hostname = 'localhost';
my $port = 3306;
my $user = 'cgi_user';
my $password = '1234567890';

#DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

my $dbh = DBI->connect(
    $dsn, 
    $user, 
    $password, 
    {
        RaiseError => 1,
        PrintError => 0,
        AutoCommit => 1,
	mysql_enable_utf8mb4 => 1
    }
) or die "Error al conectar a la base de datos MariaDB: $DBI::errstr\n";

$dbh->do("SET NAMES utf8mb4");

#-------------------------------------------------------------


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

        <title>LISTA</title>
    </head>
    
    <body>

        <!--CABECERA-->
        
        <header> <a class="logo" href="/index.html">Wikipedia</a>
          <nav>
            <ul>
              <li><a href="/index.html">Inicio</a></li>
              <li><a href="/nuevo.html">Nueva Página</a></li>
            </ul>
          </nav>
        </header>

        <!--CONTENEDOR NUEVA PÁGINA-->
        <div class="container">
            <div class="contenedor-nuevapagina"
                style="margin: 0; border-top-right-radius: 0px; border-top-left-radius: 0px;">
                <h2>LISTA DE <span class="textos-rojos">PÁGINAS</span></h2>   
HTML



if ($dbh) {
    # Consultas a la tabla wiki
    my $sql = "SELECT id, titulo FROM wiki";
    my $sth = $dbh->prepare($sql);
    $sth->execute();

    print<<HTML;
            <table class="tabla-markdown">
                <thead>
                    <tr>
                        <th><h2>ID</h2></th>
                        <th><h2>Titulo<h2></th>
                        <th><h2>Acciones</h2></th>
                    </tr>
                </thead> 
HTML

    while (my $row = $sth->fetchrow_hashref) {

        print<<HTML;
                <tbody>
                    <tr>
                        <td style="text-align: center;">$row->{id}</td>
                        <td>$row->{titulo}</td>
                        <td style="justify-content: center;" class="botones">
                            <a href='ver.pl?id=$row->{id}' class="btn-accion btn-gris">V</a>
                            <a href='editor.pl?id=$row->{id}' class="btn-accion btn-gris">E</a>
                            <a href='eliminar.pl?id=$row->{id}' class="btn-accion btn-crear">X</a>
                        </td>
                    </tr>
                </tbody>
HTML
    }
    
        print "\t    </table>\n";

    $sth->finish();
    $dbh->disconnect();
} else {
    die "Error al conectar a la base de datos de MariaDB: " . DBI->errstr;
}


print<<HTML;
                <!--BOTONES-->
                <br>
                <div class="botones" style="justify-content: center;">
                    <a href="/nuevo.html" class="btn-accion btn-crear">Crear página</a>
                    <a href="/index.html" class="btn-accion btn-gris">Volver al Inicio</a>
                </div>
            </div>
        </div>
    </body>
</html>
HTML

