import '../../models/cart_item.dart';
import 'package:flutter/foundation.dart';
import '../../models/product.dart';

class CartManager with ChangeNotifier {
  final Map<String, CartItem> _items = {
    'p1': CartItem(id: 'p1', title: "Red Shirt", quantity: 2, price: 29.99),
  };

  int get productCount => _items.length;

  List <CartItem> get product => _items.values.toList();

  Iterable<MapEntry<String, CartItem>> get productEntries => {..._items}.entries;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  //

  void addItem (Product product){
    if(_items.containsKey(product.id)){
      // change quantity ...
      _items.update(
        product.id!,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id!,
        () => CartItem(
          id: 'c${DateTime.now().toIso8601String()}',
          title: product.title,
          price: product.price,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId){
    if(!_items.containsKey(productId)){
      return;
    }
    if(_items[productId]?.quantity as num > 1){
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }

    notifyListeners();

  }

  void clear(){
    _items.clear();
    notifyListeners();
  }

}