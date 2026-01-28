import 'package:flutter/material.dart';

/// ProductCard muestra título, precio y un botón [onAdd].
class ProductCard extends StatelessWidget {
  final String title;
  final double price;
  final VoidCallback onPressed;
  final String buttonText; // Texto del botón
  final Color borderColor; // Color del borde
  final Color backgroundColor; // Fondo de la tarjeta

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.onPressed,
    this.buttonText = 'Añadir',
    this.borderColor = const Color(0xFFDB3657),
    this.backgroundColor = const Color(0xFFF3F3F3),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          title: Text(title),
          subtitle: Text('${price.toStringAsFixed(2)} €'),
          trailing: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(backgroundColor: borderColor),
            child: Text(buttonText, style: TextStyle(color: Color(0xFFF3F3F3))),
          ),
        ),
      ),
    );
  }
}
