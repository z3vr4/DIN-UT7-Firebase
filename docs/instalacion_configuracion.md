# Instalación y configuración del proyecto
## Requisitos previos

Para poder ejecutar o desplegar la aplicación es necesario disponer de:
- Flutter SDK versión 3.19 o superior.
- Un navegador web moderno (se recomienda Chrome para desarrollo).
- Conexión a Internet para el acceso a la API REST y a los servicios de Firebase.

No se requiere ningún software adicional para el canal Web.

## Configuración de claves y ficheros sensibles

El repositorio no incluye claves privadas ni credenciales.

La aplicación depende de Firebase para la autenticación y la persistencia de favoritos, por lo que es imprescindible generar la configuración correspondiente en entorno local.

## Configuración de Firebase

El proyecto utiliza Firebase Authentication (modo anónimo y con email) y Firestore.

Para habilitar Firebase en local:
- Instalar el CLI de FlutterFire y asegurarse de que Flutter está correctamente configurado.
- Ejecutar el comando:

flutterfire configure

- Seleccionar el proyecto de Firebase y las plataformas a utilizar (Web y/o Android).
El asistente generará automáticamente el fichero:

lib/firebase_options.dart

- Este archivo es obligatorio para que la aplicación funcione correctamente.
Si Firebase no está configurado, la aplicación puede fallar en tiempo de ejecución.

## Ejecución en entorno local

Una vez configurado el proyecto:

flutter pub get
flutter run -d chrome


Opcionalmente, el proyecto también puede ejecutarse en Android tras añadir los ficheros nativos de Firebase correspondientes.

## API REST utilizada

La aplicación consume una API REST pública para la obtención de productos.

URL base: https://fakestoreapi.com


Si se desea usar otra API compatible, basta con modificar la propiedad baseUrl del ApiClient y ajustar los endpoints necesarios.

## Persistencia y autenticación

Autenticación mediante Firebase Auth en modo anónimo, y con email + contraseña.

Persistencia de favoritos en Firestore bajo la estructura:

/users/{uid}/favorites/{productId}

Esta funcionalidad es central para el correcto funcionamiento de la sección de favoritos.

## Distribución de la aplicación
### Canal Web (utilizado en este proyecto)
La aplicación se distribuye como build Web:

flutter build web

El contenido de build/web se comprime y se incluye como artefacto de entrega:

releases/build_web.zip

Para servirlo en local con Python, se puede ejecutar (desde la raíz del proyecto una vez descomprimido)
```
cd build/web
python -m http.server 8080
```

Alternativamente, está disponible el script build_web.sh con el que realizar la build a web (ejecutable con Git Bash en windows)

### Canal Android (no utilizado para la entrega)

El proyecto es compatible con Android, pero para la entrega de este proyecto se ha configurado lo necesario para la version web.
En caso de generar builds Android, sería necesaria una firma digital de pruebas.

#### Firma digital

Para distribuciones Android se puede emplear una firma simulada mediante un keystore local.

El keystore no se incluye en el repositorio. Este keystore se genera con keytool, y se referencia desde android/key.properties.

Las contraseñas y rutas reales no se deben documentar.

## Desinstalación

Web: eliminar los ficheros desplegados o desactivar el servicio de hosting.

Android (si se usa): Ajustes del sistema → Aplicaciones → seleccionar la app → Desinstalar.