#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use utf8;

my $cgi  = CGI->new;
print $cgi->header('text/xml;charset=UTF-8');
print "<?xml version='1.0' encoding='utf-8'?>\n";

# Parámetros CGI
my $username = $cgi->param('user');
my $passw = $cgi->param('password');
my $id = $cgi->param('id');

if (defined $username && defined $passw && defined $id) {
    
    my $database = 'wikipweb1';
    my $hostname = 'localhost';
    my $port = 3306;
    my $user = 'root';
    my $password = '1234567890';

    my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";
    my $dbh = DBI->connect($dsn, $user, $password, {RaiseError => 1, PrintError => 0, mysql_enable_utf8 => 1});

    # Verificar cuenta del usuario
    if (verificarCuenta($dbh, $username, $passw)) {
        
        #  eliminar el artículo
        my $sql = "DELETE FROM wiki WHERE id = ?";
        my $sth = $dbh->prepare($sql);
        $sth->execute($id);
        
        print "<article>\n";
        if ($sth->rows > 0) {
            print "    <id>$id</id>\n";
            print "    <status>Artículo eliminado correctamente.</status>\n";
        } else {
            print "    <id>$id</id>\n";
            print "    <status>Error: Artículo no encontrado o no eliminado.</status>\n";
        }
        print "</article>\n";
        $sth->finish;
    } else {
        # Usuario no válido
        print "<error>\n";
        print "    <message>Usuario o contraseña incorrectos.</message>\n";
        print "</error>\n";
    }
    
    $dbh->disconnect;
} else {

    print "<error>\n";
    print "    <message>Faltan parámetros: usuario, contraseña o ID de artículo.</message>\n";
    print "</error>\n";
}

#verificar la cuenta del usuario
sub verificarCuenta {
    my ($dbh, $username, $passw) = @_;
    my $sql = "SELECT 1 FROM Users WHERE userName = ? AND password = ?";
    my $sth = $dbh->prepare($sql);
    $sth->execute($username, $passw);
    my @row = $sth->fetchrow_array;
    $sth->finish;
    return @row ? 1 : 0;
}
