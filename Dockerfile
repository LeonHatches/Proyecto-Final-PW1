# Usa una imagen base de Debian
FROM debian:latest

# Instala Apache, Perl, MariaDB y módulos necesarios
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl mariadb-server \
    libdbi-perl libdbd-mysql-perl && \
    apt-get clean

# Habilita el módulo CGI de Apache
RUN a2enmod cgi

# Crea el directorio CGI y da permisos
RUN mkdir -p /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin

# Copia el script Perl en el directorio CGI (AGREGAR SI ES NECESARIO CHMOD A TODOS LOS PLs)
COPY ./cgi-bin/ /usr/lib/cgi-bin

# Copia el archivo de configuración de Apache
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Configura MariaDB
RUN service mysql start && \
    mysql -u root -e "CREATE USER 'root'@'localhost' IDENTIFIED BY '1234567890';" && \
    mysql -u root -e "GRANT ALL PRIVILEGES ON wikipweb1.* TO 'root'@'localhost';" && \
    mysql -u root -e "FLUSH PRIVILEGES;" && \
    mysql -u root -p '1234567890' -e "CREATE DATABASE wikipweb1;" && \
    mysql -u root -p '1234567890' -e "USE wikipweb1; \
        CREATE TABLE wiki (id INT AUTO_INCREMENT PRIMARY KEY, titulo VARCHAR(100) NOT NULL, texto TEXT NOT NULL);"

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar Apache y MariaDB
CMD service mysql start && apache2ctl -D FOREGROUND
