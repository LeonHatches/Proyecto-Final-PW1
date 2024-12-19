
#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $cgi = CGI->new;
print $cgi->header('application/xml');
print "<?xml version='1.0' encoding='utf-8'?>\n";

my $titulo = $cgi->param('titulo');
my $texto = $cgi->param('text_intro');
my $user = $cgi->param('owner'); 

if (defined $titulo and defined $texto and defined $user) {
    print <<XML;
<article>
    <title>$titulo</title>
    <text>$texto</text>
    <owner>$user</owner>
</article>
XML
} else {
    print "<error>Faltan parámetros</error>\n";
}
