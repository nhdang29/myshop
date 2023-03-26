import 'package:flutter/foundation.dart';


class Product{
  final String? id;
  final String title, description, imageUrl;
  final double price;
  final ValueNotifier<bool> _isFavorite;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    isFavorite = false
  }) : _isFavorite = ValueNotifier(isFavorite);


  set isFavorite(bool newValue){
    _isFavorite.value = newValue;
  }

  bool get isFavorite => _isFavorite.value;

  ValueNotifier<bool> get isFavoriteListenable => _isFavorite;

  Product copyWith({String? id, String? title, String? description, String? imageUrl, double? price, bool? isFavorite}){
   return Product(
     id: id ?? this.id,
     title: title ?? this.title,
     description: description ?? this.description,
     price: price ?? this.price,
     imageUrl: imageUrl ?? this.imageUrl,
     isFavorite: isFavorite ?? this.isFavorite
   ) ;
  }


  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl
    };
  }

  static Product fromJson(Map<String, dynamic> json){
    return Product(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageUrl: json['imageUrl'],
        price: json['price']
    );
  }


}