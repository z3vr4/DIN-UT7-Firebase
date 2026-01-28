# ut7_firebase - Tarea de Desarrollo de Interfaces - Unidad 7
En este readme se muestra en primer lugar las funcionalidades y notas de cambio de esta aplicación respecto a la versión de la UD6.

Las funcionalidades añadidas (elaboradas en los siguientes apartados) han sido:
- Uso de API REST https://fakestoreapi.com/ , específicamente los recursos de los productos.

- Implementación de funcionalidades de firebase: autenticación (login via email y login anónimo) y
Cloud Firestore para el almacenamiento de los productos marcados como favoritos de cada usuario.

- Pantalla de informe, usando el paquete fl_chart

## API REST
Los datos que muestra la aplicación ya no provienen de una fuente de datos fake, si no que se cargan en tiempo real de la API de fakestoreapi.

De esta API se muestran los datos de productos, que exponen los siguientes datos para cada producto:
- id
- title
- price
- description
- category
- image

## Firebase
En una nueva pantalla, presente tanto en el bottombar como en el navigationrail del responsivescaffold, se puede
acceder a la pantalla de perfil.

Esta contiene un widget que según el estado de la autenticación (usuario autenticado o no) muestra la pantalla para inicio de sesión, o la pantalla con el usuario cuya sesión está activa actualmente y la lista de los productos que haya marcado como favoritos.

## Pantalla de informe
Accesible desde el action del scaffold anidado en el responsive scaffold.

Muestra los productos de la API con opciones de filtrado según si son productos marcados como favoritos por el usuario, y/o por precio máximo determinable mediante slider.

Esta pantalla muestra una datatable, un gráfico de barras con el precio medio de cada producto según la categoría,
y un gráfico de secciones que permite la visualización rápida de la distribución del número de objetos según la categoría.

## Otros cambios y asuntos mencionables
En esta sección se comentarán rápidamente algunos cambios realizados en este proyecto respecto a la versión de la UD6.

### Configuración
#### API
Para cambiar la URL de la API, se ha de modificar el archivo api_client, que contiene un valor para la URL base y una llamada a un recurso de la API.

#### Configurar claves de Firebase
El proyecto está diseñado para usar los servicios de Firebase para la autenticación y almacenamiento de favoritos.

Por lo tanto, es necesario el archivo firebase_options.dart para el funcionamiento de la aplicación.

Dado que este archivo contiene información sensible como apikeys, en el proyecto presentado se muestra solo una plantilla sin la información mencionada.

Asi mismo, tampoco se incluye el archivo necesario para el proyecto google-services.json (necesario para android).

Para generar la configuración completa en local, se debe:

1. Instalar el CLI de FlutterFire y tener configurado Flutter.
2. Ejecutar el comando " flutterfire configure ".
3. Seleccionar el proyecto de Firebase y las plataformas (Android / Web).
4. El comando genera automáticamente " lib/firebase_options.dart ".
5. Colocar el archivo " google-services.json " en " android/app/ ".

### Expansión del ResponsiveScaffold
Se ha adaptado el ResponsiveScaffold para que muestre 3 iconos en ambas modalidades (ancho y estrecho) para acomodar el icono de la vista de perfil de usuario / login

### Nuevas dependencias
Ahora el proyecto tiene las siguientes dependencias adicionales respecto a la versión previa:
  - firebase_core: ^4.3.0
  - http: ^1.6.0
  - firebase_auth: ^6.1.3
  - cloud_firestore: ^6.1.1
  - fl_chart: ^1.1.1


## Arquitectura (actualizada)
La app ha sido construida siguiendo la arquitectura MVVM.
Tenemos presentes los siguientes elementos (por carpeta y contenido)

### lib/
- app_router : contiene el GoRouter con las rutas de navegación (cart, home y detail)

- main : entrypoint de la aplicación.

### lib/api
Contiene la clase encargada de realizar las llamadas a la API y devolver los productos a utilizar.
- api_client : obtiene el recurso de fakestoreapi de los productos.

### lib/data
Contiene las clases relacionadas con lógica de negocio y datos.
- cart_repository : contiene la implementación de los métodos relacionados con el carrito,
los cuales el viewmodel emplea.

- product : la clase modelo de datos del producto (clase Product), que define sus atributos (nombre, precio y una descripción breve)

- producto_source : obsoleto y eliminado, ahora se obtienen de la API.

### lib/screens
Contiene las pantallas de la aplicación, es decir, la UI.
- cart_screen : la vista del carrito con los productos que se hayan añadido.

- detail_screen : la vista detalle de un producto, desde la cual se puede acceder al carrito mediante pushNamed(),
para ver el carrito actual y volver al producto que se estaba examinando de forma agil (evitando tener que volver a encontrar el producto)

- home_screen : la vista con el listado de productos existentes.

- report_screen : la vista de informe explicada previamente con datos sobre los productos cargados de la API.

#### lib/screens/auth
Contiene los widgets relacionados con la vista de perfil, favoritos y autenticación.
- profile_auth : widget principal, según el estado de sesión muestra dentro de sí login_screen o account_screen

- account_screen : widget que contiene el nombre del usuario, botón para cerrar sesión y favoritos del usuario.

- login_screen : widget con las opciones de login (mediante email y password, o anónimo)

### services
Contiene los servicios, en este caso el único servicio presente.
- firebase_service : implementa las llamadas al backend de firebase para autenticación y guardado de datos.

### lib/viewmodels
Contiene los viewmodels.

- cart_view_model : el viewmodel de la aplicación encargado de la gestión de carrito

- favorites_viewmodel : viewmodel encargado de llamar a los métodos de firebase_service relacionados con almacenamiento de datos en firestore y autenticación.

### lib/widgets
Contiene el ResponsiveScaffold, el cual se trata en el siguiente apartado del readme.

## Criterios Responsive
Tal y como se especifica en la tarea, se ha utilizado el ResponsiveScaffold, que detecta la anchura de la aplicación para determinar
si mostrar un BottomBar en pantallas pequeñas, o un NavigationRail en pantallas anchas; estableciendo el punto de corte en 800px.

## Paquete ui_components
Igualmente, se ha empleado un ProductCard personalizado reutilizable, diferente del propuesto, ya que la versión implementada en
esta aplicación toma parámetros para la acción y texto del botón, con el fin de poder usar el ProductCard para mostrar y añadir elementos al carrito
en la pantalla Home (Productos) y para poder mostrar y eliminar elementos del carrito en la pantalla Cart (Carrito).
