#!/Strawberry/perl/bin/perl.exe
#/usr/bin/perl

# Modulos
use strict;
use warnings;
use CGI;
use DBI;
use utf8;
use Encode;

#Configuración de conexión
my $database = "wikipweb1";
my $hostname = "127.0.0.1";
my $port = 3306;
my $user = "root";
my $password = "";

#DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

#Conexión a la DB
my $ dbh = DBI->connect($dsn, $user, $password, {
	RaiseError => 1,
	PrintError => 0,
	mysql_enable_utf8 => 1,
});

#Consulta de lineas de la página creada
my $query = "SELECT id FROM wiki";
my $sth = $dbh->prepare($query);
my$sth->execute();


sub imprimir {
	while (my @row = $sth->fetchrow_array)
	{
		print join(",",@row), "\n";
	}
}


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
    	
		<!--Style-->
		<style type="text/css">
			body { margin: 0px 0px 100px; }
		</style>

		<title>Editor</title>
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
			EDITOR DE PÁGINA
		</div>

		<p>
			Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--
		</p>

		<!--CREACION DE PAGINA-->
		<div>
			<!--FORMULARIO-->
			<form action="cgi-bin/nuevo.pl" method="GET">
			<input type="text" name="titulo" value="$titulo">
			<input type="text" name="contenido" value="
HTML

imprimir();

print<<HTML;
			">
			<input type="submit" value="Enviar">
		</div>
	</body>
HTML