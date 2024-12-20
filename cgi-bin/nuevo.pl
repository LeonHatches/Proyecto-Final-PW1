
#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use utf8;
use DBI;

my $cgi = CGI->new;
print $cgi->header('application/xml');
print "<?xml version='1.0' encoding='utf-8'?>\n";

# Obtener los parámetros
my $titulo = $cgi->param('titulo');
my $texto = $cgi->param('text_intro');
my $user = $cgi->param('owner'); # El "owner" viene del login.pl

# Verificar que se recibieron los datos necesarios
if (defined $user and defined $titulo and defined $texto) {
    # Configuración de conexión a la base de datos
    my $database = 'wikipweb1';
    my $hostname = 'localhost';
    my $port = 3306;
    my $db_user = 'root';
    my $db_password = '1234567890';
    my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

    # Conexión a la base de datos
    my $dbh = DBI->connect($dsn, $db_user, $db_password, {
        RaiseError => 1,
        PrintError => 0,
        mysql_enable_utf8 => 1,
    });

    # Comprobar si ya existe un artículo con el mismo título y propietario
    my $check_sql = "SELECT * FROM Articles WHERE title = ? AND owner = ?";
    my $check_sth = $dbh->prepare($check_sql);
    $check_sth->execute($titulo, $user);

    if ($check_sth->fetchrow_array) {
        # Ya existe un artículo con ese título y propietario
        print "<user>\n</user>\n";
    } else {
        # Insertar un nuevo artículo
        my $sql = "INSERT INTO Articles (title, owner, content) VALUES (?, ?, ?)";
        my $sth = $dbh->prepare($sql);
        $sth->execute($titulo, $user, $texto);

        # Finalizar la operación
        $sth->finish;
        $dbh->disconnect;

        # Mostrar éxito
        successLogin($titulo, $user, $texto);
    }
} else {
    # Parámetros faltantes
    print "<user>\n</user>\n";
}

# Subrutina para imprimir el XML de éxito
sub successLogin {
    my ($titulo, $user, $texto) = @_;
    print <<XML;
<article>
    <title>$titulo</title>
    <text>$texto</text>
    <owner>$user</owner>
</article>
XML
}

