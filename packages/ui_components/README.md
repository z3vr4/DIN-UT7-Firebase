## UI_Components

Contiene un widget (ProductCard) parametrizado para usarlo en una aplicación.

## Uso de ProductCard

ProductCard muestra una tarjeta con información básica sobre un producto (nombre y precio),
y muestra un botón de acción configurable (en lo que se refiere a la acción que realiza y texto del botón).

Esto significa que se puede usar ProductCard tanto para una vista Home en la que se listan productos,
como para una vista de Carrito, cambiando la lógica y texto del botón.

Por defecto, el botón tiene un texto asignado de "Añadir", y los siguientes parámetros estilisticos preasignados:

    borderColor = const Color(0xFFDB3657),
    backgroundColor = const Color(0xFFF3F3F3),

Ejemplo de uso:

ProductCard(
  title: product.title,
  price: product.price,
  onPressed: () => cart.add(product),
  buttonText: 'Añadir al carrito',
);

## Como importarlo

Desde la aplicación principal, el widget se importa directamente desde el paquete:

import 'package:ui_components/product_card.dart';
