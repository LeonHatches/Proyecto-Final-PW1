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

		<title>EDITAR</title>
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

		<!--CONTENEDOR EDITOR DE LA PÁGINA-->
		<div class="container">
			<div id="crear-pagina" class="contenedor-nuevapagina"
				style="margin: 0; border-top-right-radius: 0px; border-top-left-radius: 0px;">
				<h2>EDITANDO LA <span class="textos-rojos">PÁGINA</span></h2>
HTML


if ($dbh)
{
	print "\t\t\t\t\t<form action=\"conexion.pl\" method=\"GET\" class=\"formulario-estilizado\" accept-charset=\"utf-8\">\n";
	
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
						<input type="hidden" name="direccion" value="editor">

						<label for="titulo">Título:</label>
						<input type="text" id="titulo" name="titulo" value="$titulo">

						<label for="texto">Contenido:</label>
						<textarea id="texto" name="texto">$texto</textarea>
						
						<input type="hidden" name='id' value='$id'>
						<input type="submit" value="Enviar" class="btn-accion btn-crear">
				</form>		
HTML

    $sth->finish();
    $dbh->disconnect();
}

else {
	print "No se pudo conectar a la base de datos.\n";
}

print<<HTML;
			</div>
		</div>

		<!--TABLA DE FUNCIONALIDADES-->
		<div class="tabla-markdown-container">
			<div class="titulo-funcionalidad">
				<h2>Funcionalidades<span class="textos-rojos"> Markdown</span></h2>
			</div>
				<p>Esta tabla muestra cómo se convierten los elementos de Markdown a HTML y su salida renderizada.</p>
				<table class="tabla-markdown">
					<thead>
						<tr>
							<th>Elemento</th>
							<th>Markdown</th>
							<th>HTML</th>
							<th>Resultado</th>
						</tr>
					</thead>
					<tbody>
						<!-- Encabezados -->
						<tr>
							<td>Encabezado o heading</td>
							<td>
								# Encabezado 1<br>
								## Encabezado 2<br>
								###### Encabezado 6
							</td>
							<td>
								&lt;h1&gt;Encabezado 1&lt;/h1&gt;<br>
								&lt;h2&gt;Encabezado 2&lt;/h2&gt;<br>
								&lt;h6&gt;Encabezado 6&lt;/h6&gt;
							</td>
							<td>
								<h1>Encabezado 1</h1>
								<h2>Encabezado 2</h2>
								<h6>Encabezado 6</h6>
							</td>
						</tr>

						<!-- Estilos de texto -->
						<tr>
							<td>Estilos de texto</td>
							<td>
								***Texto negrita y cursiva***<br>
								**Texto negrita**<br>
							  *Texto cursiva*
						  </td>
							<td>
								&lt;strong&gt;&lt;em&gt;Texto&lt;/em&gt;&lt;/strong&gt;<br>
								&lt;strong&gt;Texto&lt;/strong&gt;<br>
								&lt;em&gt;Texto&lt;/em&gt;
							</td>
							<td>
								<strong><em>Texto</em></strong><br>
								<strong>Texto</strong><br>
								<em>Texto</em>
							</td>
						</tr>

						<!-- Enlaces -->
						<tr>
							<td>Enlaces</td>
							<td>[Texto](https://example.com)</td>
							<td>&lt;a href="https://example.com"&gt;Texto&lt;/a&gt;</td>
							<td><a href="https://example.com">Texto</a></td>
						</tr>

						<!-- Saltos de línea -->
						<tr>
							<td>Saltos de línea</td>
							<td>Línea 1<br>Línea 2</td>
							<td>Línea 1&lt;br&gt;Línea 2</td>
							<td>Línea 1<br>Línea 2</td>
						</tr>
					</tbody>
				</table>
		</div>
	</body>
HTML

