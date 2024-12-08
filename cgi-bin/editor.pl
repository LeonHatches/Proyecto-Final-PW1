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
    	
		<title>Editor</title>
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
			EDITOR DE PÁGINA
		</div>

		<p>
			Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--Funcionalidades-agregar-tabla--
		</p>

		<!--CREACION DE PAGINA-->
		<div>	
HTML


if ($dbh)
{
	print "\t\t\t<form action=\"cgi-bin/conexion.pl\" method=\"GET\">\n";
	
	my $query = "SELECT titulo, texto FROM wiki WHERE id = ?";
	my $sth = $dbh->prepare($query);
	   $sth->execute($id);
	my $titulo = "";
	my $texto = "";

	if (my $row = $sth->fetchrow_hashref) {
		$titulo = $row->{titulo};
		$texto  = $row->{texto};
	}
	else {
		$titulo = "No se encontró un titulo.";
		$texto = "No se encontró un texto.";
	}

	print<<HTML;
			<input type="text" name="titulo" value="$titulo">
			<input type="text" name="contenido" value="$texto">
			<input type="submit" value="Enviar">
HTML
}

else {
	print "No se pudo conectar a la base de datos.\n";
}

print<<HTML;
		</div>
	</body>
HTML

