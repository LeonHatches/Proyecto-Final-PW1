# Usa una imagen base de Debian
FROM debian:latest

# Instala Apache, Perl, MariaDB y módulos necesarios
RUN apt-get update && \
    apt-get install -y vim apache2 libapache2-mod-perl2 perl mariadb-server \
    libdbi-perl libdbd-mysql-perl && \
    apt-get clean

# Habilita el módulo CGI de Apache
RUN a2enmod cgi

# Crea el directorio CGI y da permisos
RUN mkdir -p /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin

# Copia los scripts Perl en el directorio CGI
COPY ./cgi-bin/ /usr/lib/cgi-bin

# Copia el archivo de configuración de Apache
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Configura MariaDB
RUN service mysql start && \
    mysql -e "CREATE USER 'root'@'%' IDENTIFIED BY '1234567890';" && \
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;" && \
    mysql -e "FLUSH PRIVILEGES;" && \
    mysql -u root -p'1234567890' -e "CREATE DATABASE wikipweb1;" && \
    mysql -u root -p'1234567890' -e "USE wikipweb1; \
        CREATE TABLE wiki (id INT AUTO_INCREMENT PRIMARY KEY, titulo VARCHAR(100) NOT NULL, texto TEXT NOT NULL);"

# Ajustar permisos de MariaDB para que funcione correctamente
RUN sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf && \
    echo "[mysqld]\nskip-networking=0\nskip-bind-address\n" >> /etc/mysql/my.cnf

# Exponer el puerto 80 para Apache y 3306 para MariaDB
EXPOSE 80 3306

# Comando para iniciar Apache y MariaDB
CMD service mysql start && apache2ctl -D FOREGROUND
