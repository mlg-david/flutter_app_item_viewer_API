import 'dart:convert';

class ProductModel {
  final int? stock;
  final int? id;
  final int? price;
  final double? discountPercentage;
  final double? rating;
  final String? title;
  final String? description;
  final String? thumbnail;
  final String? brand;
  final String? category;
  final List<String>? images;

  const ProductModel(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.discountPercentage,
      this.rating,
      this.stock,
      this.brand,
      this.category,
      this.thumbnail,
      this.images});

  // It create an Album from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        price: json["price"],
        discountPercentage: json["discountPercentage"]?.toDouble(),
        rating: json["rating"]?.toDouble(),
        stock: json["stock"],
        brand: json["brand"],
        category: json["category"],
        thumbnail: json["thumbnail"],
        images: List<String>.from(json["images"].map((x) => x)),
      );
}
