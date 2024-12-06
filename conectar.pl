
#!/usr/bin/perl
use strict;
use warnings;
use DBI;

print "Content-type: text/plain\n\n";

# Datos de conexión
my $database = "wikipweb1";
my $host     = "127.0.0.1";
my $port     = 3306;
my $user     = "root";
my $password = "";

my $dsn = "DBI:mysql:database=$database;host=$host;port=$port";
my $dbh = DBI->connect($dsn, $user, $password, { RaiseError => 1, PrintError => 0 });

if ($dbh) {
    print "Conexión exitosa.\n";

    # Realizar consulta
    my $sql = "SELECT id, titulo FROM wiki";
    my $sth = $dbh->prepare($sql);
    $sth->execute();

    # Mostrar resultados
    while (my $row = $sth->fetchrow_hashref) {
        print "ID: $row->{id}, Título: $row->{titulo}\n";
    }

    $sth->finish();
    $dbh->disconnect();
} else {
    die "Error al conectar a la base de datos: " . DBI->errstr;
}
