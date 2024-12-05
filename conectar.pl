
#!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $database = "wikipweb1";
my $host     = "127.0.0.1";
my $port     = 3306;
my $user     = "root";
my $password = "";

my $dsn = "DBI:mysql:database=$database;host=$host;port=$port";

my $dbh = DBI->connect($dsn, $user, $password, { RaiseError => 1, PrintError => 0 });

if ($dbh) {
    print "Conexión exitosa a MariaDB\n";
    $dbh->disconnect();
} else {
    die "Error al conectar a MariaDB: " . DBI->errstr;
}

