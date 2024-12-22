# Usa una imagen base de Debian
FROM debian:latest

ENV DEBIAN_FRONTEND="noninteractive"

# Instala Apache, Perl, MariaDB y módulos necesarios
RUN apt-get update && \
    apt-get install -y vim apache2 libapache2-mod-perl2 perl mariadb-server \
    libdbi-perl libdbd-mysql-perl && \
    apt-get clean

# Habilita el módulo CGI de Apache
RUN a2enmod cgi

# Crea el directorio CGI y da permisos
RUN mkdir -p /home/pweb
RUN useradd pweb -m && echo "pweb:12345678" | chpasswd
RUN echo "root:12345678" | chpasswd
RUN chown pweb:www-data /usr/lib/cgi-bin/
RUN chown pweb:www-data /var/www/html/
RUN mkdir -p /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin
RUN chmod 750 /usr/lib/cgi-bin/
RUN chmod 750 /var/www/html/

RUN ln -s /usr/lib/cgi-bin /home/pweb/cgi-bin
RUN ln -s /var/www/html/ /home/pweb/html

RUN ln -s /home/pweb /usr/lib/cgi-bin/toHome
RUN ln -s /home/pweb /var/www/html/toHome

# Copia los scripts Perl en el directorio CGI
COPY ./cgi-bin/ /usr/lib/cgi-bin

# Copia los HTML, IMAGES y CSS
COPY ./html/ /var/www/html
COPY ./css/ /var/www/html/css
COPY ./images/ /var/www/html/images

RUN chmod +x /usr/lib/cgi-bin/conexion.pl
RUN chmod +x /usr/lib/cgi-bin/ver.pl
RUN chmod +x /usr/lib/cgi-bin/editor.pl
RUN chmod +x /usr/lib/cgi-bin/eliminar.pl
RUN chmod +x /usr/lib/cgi-bin/lista.pl

# Copia el archivo de configuración de Apache
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Configura MariaDB
RUN service mariadb start && \
    mysql -e "CREATE USER 'root'@'%' IDENTIFIED BY '1234567890';" && \
    mysql -e "CREATE USER 'cgi_user'@'localhost' IDENTIFIED BY '1234567890';" && \
    mysql -e "GRANT ALL PRIVILEGES ON wikipweb1.* TO 'cgi_user'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES" && \
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;" && \
    mysql -e "FLUSH PRIVILEGES;" && \
    mysql -u root -p'1234567890' -e "CREATE DATABASE wikipweb1;" && \
    mysql -u root -p'1234567890' -e "USE wikipweb1; \
	CREATE TABLE Users (UserName VARCHAR(60) NOT NULL PRIMARY KEY, password VARCHAR(200) NOT NULL, firstName TEXT NOT NULL, lastName TEXT NOT NULL); \
	CREATE TABLE Articles (owner VARCHAR(60) NOT NULL, title VARCHAR(100) NOT NULL, text TEXT NOT NULL, FOREIGN KEY (owner) REFERENCES Users(userName) ON DELETE CASCADE,PRIMARY KEY (title, owner));"

# Ajustar permisos de MariaDB para que funcione correctamente
RUN sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf && \
    echo "[mysqld]\nskip-networking=0\nskip-bind-address\n" >> /etc/mysql/my.cnf

# Exponer el puerto 80 para Apache y 3306 para MariaDB
EXPOSE 80 3306

# Comando para iniciar Apache y MariaDB con formato JSON
CMD ["bash", "-c", "service mariadb start && apache2ctl -D FOREGROUND"]
