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
                    <li><a href="/index.html">INICIO</a></li>
                    <li><a href="lista.pl">LISTA</a></li>
                </ul>
            </nav>
        </header>


        <!--CAJA DE TITULO-->
        <div>
            ELIMINAR PAGINA
        </div>

        <!--CREACION DE PAGINA-->
        <div>   
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
            print "\t    <p>Página con ID $id eliminada correctamente.</p>\n";
        } else {
            print "\t    <p>Error al intentar eliminar la página con ID $id.</p>\n";
        }

        $dbh->disconnect();

    } else {
        print "\t    <p>No se pudo conectar a la base de datos.</p>\n";
    }

} else {
    print "\t    <p>ID no proporcionado o inválido.</p>\n";
}

print<<HTML;
            <a href="lista.pl">Volver a Lista</a>
        </div>
    </body>
</html>
HTML

