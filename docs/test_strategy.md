# Estrategia de pruebas – UD7 (Firebase + API)
Documento obsoleto perteneciente a la versión anterior. Ver test_results:adv para el documento actualizado.

## Objetivos
- Asegurar funcionamiento correcto de navegación.
- Asegurar estado global (Provider) consistente entre pantallas.
- Confirmar protección frente a regresion (Carrito no negativo)

## Tipos de prueba
- Integración.
- Widget / unidad.

## Matriz de pruebas
| Área       | Caso                                | Tipo        | Éxito                                  |
|-----------|--------------------------------------|-------------|----------------------------------------|
| Navegación| Home -> Cart                         | Integración | Llega a Cart y muestra ítems           |
| Estado    | Añadir item actualiza contador global| Integración | count > 0 tras pulsar "Añadir"         |
| Regresión | Contador nunca < 0                   | Unidad      | count == 0 si se elimina en vacío      |
| Responsive| >=800 px usa NavigationRail          | Manual/doc  | Captura comparativa en README          |
| Responsive| < 800 px usa BottomNavigationBar     | Manual/doc  | Captura comparativa en README          |

## Criterios de paso
- Los tests se pasan sin fallos.
- El layout de la aplicación se adapta como se espera (ver capturas de pantalla).

## Cómo ejecutar
- Pruebas de unidad/widget:

  ```bash
  flutter test

- Pruebas manuales:

  En un emulador que permita redimensionar la ventana (como Chrome):

  flutter run

  Redimensionar la anchura de la ventana para observar cambios.