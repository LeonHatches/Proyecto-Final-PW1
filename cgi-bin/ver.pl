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

my $owner = $cgi->param('owner');
my $title = $cgi->param('title');

if (defined $owner && defined $title) {

    #-----------------------------------------------------------------

    # Configuración de conexión
    my $db = 'wikipweb1';
    my $db_host = 'localhost';
    my $db_port = 3306;
    my $db_user = 'cgi_user';
    my $db_password = '1234567890';

    # DSN de conexión
    my $dsn = "DBI:mysql:database=$db;host=$db_host;port=$db_port";

    # Conexión a la base de datos
    my $dbh = DBI->connect(
        $dsn, 
        $db_user, 
        $db_password, 
        {
            RaiseError => 1,
            PrintError => 0,
            AutoCommit => 1,
            mysql_enable_utf8mb4 => 1
        }
    ) or die "Error al conectar a la base de datos MariaDB: $DBI::errstr\n";

    $dbh->do("SET NAMES utf8mb4");

    #-----------------------------------------------------------------

    if ($dbh) {
        my $sth = $dbh->prepare("SELECT title, text FROM Articles WHERE owner = ? AND title = ?");
        $sth->execute($owner, $title);

        my $row = $sth->fetchrow_hashref;
        if ($row) {
            # Convertir Markdown a HTML
            my $html_content = convertir_markdown_a_html($row->{text});

            # Mostrar el texto y el título
            print "<h1>" . $row->{title} . "</h1>\n";
            print "\n$html_content\n";
        } else {
            print "<p>No se encontró la página.</p>\n";
        }

        $sth->finish();
        $dbh->disconnect();
    } else {
        print "<p>Error al conectar con la base de datos.</p>\n";
    }
} else {
    print "<p>ID no proporcionado o inválido.</p>\n";
}

# Subrutina para convertir Markdown a HTML
sub convertir_markdown_a_html {
    my ($markdown) = @_;

    # Convertir encabezados
    $markdown =~ s/^###### (.+)$/<h6>$1<\/h6>/gm;
    $markdown =~ s/^## (.+)$/<h2>$1<\/h2>/gm;
    $markdown =~ s/^# (.+)$/<h1>$1<\/h1>/gm;

    # Convertir estilos de texto
    $markdown =~ s/\*\*\*(.+?)\*\*\*/<strong><em>$1<\/em><\/strong>/g;
    $markdown =~ s/\*\*(.+?)\*\*/<strong>$1<\/strong>/g;
    $markdown =~ s/\*(.+?)\*/<em>$1<\/em>/g;
    $markdown =~ s/~~(.+?)~~/<del>$1<\/del>/g;

    # Convertir bloques de código
    $markdown =~ s/```(.+?)```/<pre><code>$1<\/code><\/pre>/gs;

    # Convertir enlaces
    $markdown =~ s/\[(.+?)\]\((.+?)\)/<a href="$2">$1<\/a>/g;

    # Convertir saltos de línea a <br>
    $markdown =~ s/\n/<br>\n/g;

    return $markdown;
}

