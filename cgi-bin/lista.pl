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

        <title>Lista</title>
    </head>
    
    <body>
        <!--CABECERA-->
        <header>
            <nav>
                <ul>
                    <li><a href="descripcion.html">NOSOTROS</a></li>
                    <li><a href="cgi-bin/listaPag.pl">LISTA</a></li>
                </ul>
            </nav>
        </header>


        <!--CAJA DE TITULO-->
        <div>
            TODAS LAS PÁGINAS
        </div>

        <!--LISTA - TABKA DE PAGINAS-->
        <div>   
HTML

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
        AutoCommit => 1
    }
) or die "Error al conectar a la base de datos MariaDB: $DBI::errstr\n";

$dbh->do("SET NAMES 'utf8'");

#-------------------------------------------------------------

if ($dbh) {
    # Consultas a la tabla wiki
    my $sql = "SELECT id, titulo FROM wiki";
    my $sth = $dbh->prepare($sql);
    $sth->execute();

    print<<HTML;
            <table>
                <tr>
                    <th>ID</th>
                    <th>Titulo</th>
                    <th>Acciones</th>
                </tr>
HTML

    while (my $row = $sth->fetchrow_hashref) {

        print<<HTML;
                <tr>
                    <td>$row->{id}</td>
                    <td>$row->{titulo}</td>
                    <td>
                        <a href='ver.pl?id=$row->{id}'>V</a>
                        <a href='editor.pl?id=$row->{id}'>E</a>
                        <a href='eliminar.pl?id=$row->{id}'>X</a>
                    </td>
                </tr>
HTML
    }
    
        print "\t    </table>\n";

    $sth->finish();
    $dbh->disconnect();
} else {
    die "Error al conectar a la base de datos de MariaDB: " . DBI->errstr;
}

print<<HTML;
            <a id="nuevo" href='nuevo.html'><button>Nueva página</button></a>
        </div>
    </body>
</html>
HTML