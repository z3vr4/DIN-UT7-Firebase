# Manual de usuario

## Público y requisitos
- Profesorado que realice la evaluación / público general.
- Flutter 3.19+; probado en Web/Chrome y Android emulador.
- Conexión a Internet para API/Firebase; no cuenta con datos locales en caso de fallo de conexión o que la API no esté disponible.

## Flujo de uso
1. **Inicio/Home**: se listan productos desde la API (FakeStoreAPI). Botón “Añadir al carrito” para sumarlos al carrito. Tap abre vista detalle.
2. **Login/Favoritos**: se accede a la vista de login / usuario mediante el botón de usuario en el navigationrail a la izquierda en pantallas anchas,
o el bottombar en pantallas estrechas. Si el usuario ha iniciado sesión (email o anónima), puede ver sus favoritos en esta vista.
3. **Carrito**: accede desde la barra/rail; puedes quitar ítems o vaciar y ver el total.
4. **Informe**: botón de barra de acciones → muestra tabla + gráfico; filtra “solo favoritos” y filtra por precio máximo mediante slider.

## Mensajes y errores habituales
- “No se han podido cargar los datos" - La aplicación no ha podido acceder a los datos. Los motivos principales pueden ser:
    - Falta de permisos de conexión a internet en android.
    - API no disponible.
- “Firebase pendiente de configurar” - no se ha generado el fichero firebase_options.dart según las instrucciones.
    - En android, es posible que además falte el google-services.json necesario. Ver readme principal.

## Accesibilidad básica
- Colores no predeterminados que cumplen estándares de contraste recomendados.
- Iconos con "tooltip" y etiqueta en acciones principales (perfil/login, informe, favoritos).
- Layout Responsive: BottomNavigationBar en móvil y NavigationRail en pantallas de anchura superior a 600 pixeles.
