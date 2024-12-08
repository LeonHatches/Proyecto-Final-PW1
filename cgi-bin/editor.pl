#!/Strawberry/perl/bin/perl.exe
#/usr/bin/perl

#Cambiar segun se use en Docker (2da linea) o prueba local

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

my $id = $cgi->param('id');

#Configuración de conexión
my $database = "wikipweb1";
my $hostname = "localhost";
my $port = 3306;
my $user = "root";
my $password = 1234567890;

#DSN de conexión
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

#Conexión a la DB
my $ dbh = DBI->connect($dsn, $user, $password, {
	RaiseError => 1,
	PrintError => 0,
	mysql_enable_utf8 => 1,
});


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
HTML


if ($dbh)
{
	print "<form action=\"cgi-bin/nuevo.pl\" method=\"GET\">\n";
	

	my $query = "SELECT titulo, texto FROM wiki WHERE id = ?";
	my $sth = $dbh->prepare($query);
	   $sth->execute($id);
	my $titulo = "No se encontró un titulo.";
	my $texto = "No se encontró un texto.";

	if (my $row = $sth->fetchrow_hashref) {
		$titulo = $row->{titulo};
		$texto  = $row->{texto};
	}
	else {
		$titulo = "No se encontró un titulo.";
		$texto = "No se encontró un texto.";
	}


	print "\t\t\t<input type=\"text\" name=\"titulo\" value=\"$titulo\">\n";
	print "\t\t\t<input type=\"text\" name=\"contenido\" value=\"$texto\">\n";
	print "\t\t\t<input type=\"submit\" value=\"Enviar\">\n";
}

else {
	print "No se pudo conectar a la base de datos.\n";
}


print<<HTML;
		</div>
	</body>
HTML

