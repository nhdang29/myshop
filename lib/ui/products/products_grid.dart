import 'package:flutter/material.dart';
import 'package:myshop/ui/products/product_grid_tile.dart';
import '../../models/product.dart';
import 'products_manager.dart';
import 'package:provider/provider.dart';


class ProductsGrid extends StatelessWidget {
  const ProductsGrid(this.showFavorite, {Key? key}) : super(key: key);

  final bool showFavorite;

  @override
  Widget build(BuildContext context) {
    // final productManager = ProductsManager();
    // Đọc ra List<Product> sẽ được hiển thị từ ProductsManager
    final products = context.select<ProductsManager, List<Product>>(
            (productsManager) => showFavorite
            ? productsManager.favoriteItems
            : productsManager.items);

    // final products = showFavorite ? productManager.favoriteItems : productManager.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductGridTile(products[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
