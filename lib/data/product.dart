class Product {
  final int id;
  final String title;
  final double price;
  final String descripcion;
  final String category;
  final String image;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.descripcion,
    required this.category,
    required this.image,
  });

  // mappea los datos de la API a una instancia de un producto
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num)
          .toDouble(), //  en dart web esto sucedía automaticamente, en movil no.
      descripcion: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
    );
  }

  // mappea datos de Firestore a un producto
  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(), // idem
      descripcion: json['descripcion'],
      category: json['category'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'price': price,
    'category': category,
    'descripcion': descripcion,
    'image': image,
  };
}
