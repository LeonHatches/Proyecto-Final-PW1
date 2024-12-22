

**UNIVERSIDAD NACIONAL DE SAN AGUSTIN**

**FACULTAD DE INGENIERÍA DE PRODUCCIÓN Y SERVICIOS**

**ESCUELA PROFESIONAL DE INGENIERÍA DE SISTEMAS**

##

**Curso:** Programación Web 1

**Fecha:**  21/12/2024 

##

![image](https://github.com/user-attachments/assets/e81c5d77-da88-4437-81a6-cc9aba28c36f)

##

# **WIKIPEDIA MARKDOWN**


## **Integrantes**

* Chipana Mamani, Andhy Brayan  
* Choque Sánchez, Alejandra Camila  
* Hatches Curo, José León Enrique  
* Huamaní Machaca, Gael Alexander  
* Pacheco Medina, Geisel Reymar

## **Descripción**

El proyecto abarca el desarrollo de una página web funcional que simula una plataforma web similar a Wikipedia, utilizando el lenguaje de marcado Markdown como base para la creación y edición de páginas, los cuales serán convertidos a HTML para su visualización. Los usuarios podrán registrar, iniciar sesión, y gestionar artículos (crear, editar, eliminar, ver y listar) asociados a su cuenta. Todos los artículos estarán almacenados en una base de datos MariaDB y el sistema usará CGI para interactuar con el servidor, devolviendo respuestas en formato XML.

## **Tecnologías usadas**

![tecnologias](https://github.com/user-attachments/assets/2675de7c-1831-484f-9d75-fcbc5e9744d7)


## **Principales funcionalidades y descripción de pantallas**

**1\. Página de inicio (index.html)**

* **Propósito:** Punto de entrada al contenido de la página.  
* **Contenido:** Breve descripción del curso, grupo, integrantes y una breve descripción del proyecto.  
* **Acciones disponibles:**  
  * Enlace a la página de listado de artículos.  
  * Enlace a la página para crear una nueva página/artículo.

**2\. Página de inicio de sesión (login.pl)**

* **Propósito:** Permitir a los usuarios iniciar sesión dentro de la página.  
* **Contenido:** Formulario con campos para nombre de usuario y contraseña.  
* **Acciones disponibles:**  
  * Botón para iniciar sesión.  
  * Enlace a la página de registro de nuevos usuarios.

**3\. Página de registro (register.pl)**

* **Propósito:** Permitir el registro de nuevos usuarios.  
* **Contenido:** Formulario con campos para nombre, apellido, nombre de usuario y contraseña.  
* **Acciones disponibles:**  
  * Botón para enviar los datos de registro.

**4\. Página de listado (lista.pl)**

* **Propósito:** Mostrar una lista de los artículos creados por el usuario que ha iniciado sesión.  
* **Contenido:**  
  * Títulos de los artículos como hiperenlaces.  
* **Acciones disponibles:**  
  * Enlace a cada artículo para ver su contenido.  
  * Botón para regresar a la página de inicio y demás opciones.

**5\. Página de creación de artículos (nuevo.html)**

* **Propósito:** Permitir a los usuarios crear un nuevo artículo.  
* **Contenido:**  
  * Formulario con campos para el título y contenido del artículo en formato Markdown.  
* **Acciones disponibles:**  
  * Botón para guardar el artículo.  
  * Enlace para regresar al listado.

**6\. Página de visualización (ver.pl)**

* **Propósito:** Mostrar el contenido de un artículo específico preseleccionado.  
* **Contenido:**  
  * Contenido del artículo en formato HTML (convertido desde Markdown).  
* **Acciones disponibles:**  
  * Botón o enlace para regresar al listado de artículos y demás hipervínculos de relevancia.

**7\. Página de edición (editor.pl)**

* **Propósito:** Permitir modificar un artículo existente.  
* **Contenido:**  
  * Formulario precargado con el contenido actual del artículo.  
* **Acciones disponibles:**  
  * Botón para guardar los cambios.  
  * Enlace para regresar al listado sin guardar.  
  * Hipervínculos de relevancia

**8\. Página de eliminación (eliminar.pl)**

* **Propósito:** Confirmar la eliminación de un artículo.  
* **Contenido:** Mensaje de confirmación con el título del artículo a eliminar.  
* **Acciones disponibles:**  
  * Botón para confirmar la eliminación.  
  * Botón para cancelar la acción y regresar al listado.

## **Diagrama de base de datos**  
![diagrama de flujo](https://github.com/user-attachments/assets/32e3bde2-0799-4a67-b39e-b18796d799a9)

## **Comandos para el Dockerfile**

###### docker build . \-t i\_proyecto  
###### docker run \-d \-p 8140:80 \-p 3307:3306 \--name c\_proyecto i\_proyecto  

## **Conclusiones**

Dentro del proyecto se ha logrado integrar múltiples tecnologías como HTML, CSS, JavaScript, AJAX, CGI, y MariaDB para crear una página que genera nuevas páginas en base al lenguaje de marcado Markdown. Los usuarios pueden gestionar su contenido, además de registrarse e iniciar sesión. Además, la implementación de variables de sesión permite la personalización de la página, aumentando la seguridad en un supuesto en el que se desarrolle una página que tenga estos requerimientos.

El uso de AJAX, permite que las interacciones sean más rápidas y fluidas, lo que elimina la necesidad de recargar la página constantemente y la mejora significativamente. El proyecto cumple con las expectativas definidas inicialmente, logrando el desarrollo de una plataforma para la creación, lectura, edición y eliminación de artículos.

GitHub como herramienta colaborativa nos ha permitido la distribución de tareas y control de versiones, facilitando la integración de las partes trabajadas. 

## **Recomendaciones**

Recomendamos trabajar en el proyecto de manera organizada, avanzando por etapas y enfocándose en funcionalidades específicas, como el inicio de sesión o la gestión de artículos. Es fundamental utilizar GitHub como herramienta principal para la colaboración, creando ramas para cada funcionalidad y fusionándolas regularmente para mantener la organización dentro del proyecto. 

Además, se sugiere realizar pruebas constantes después de desarrollar cada parte, asegurando su correcto funcionamiento antes de continuar. Documentar tanto el proceso como las configuraciones que se establezcan permitirá facilitar las mejoras que se requieran.

##
