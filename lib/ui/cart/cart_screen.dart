import 'package:flutter/material.dart';
import 'package:myshop/ui/orders/order_manager.dart';
import 'cart_manager.dart';
import 'cart_item_card.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          buildCartSummary(cart, context),
          const SizedBox(height: 10,),
          Expanded(child: buildCartDetails(cart)),
        ],
      ),
    );
  }

  buildCartSummary(CartManager cart, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total", style: TextStyle(fontSize: 20),),
            const Spacer(),
            Chip(
              label: Text(
                "\$${cart.totalAmount.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            TextButton(
              onPressed: cart.totalAmount <= 0 ? null
              : (){
                context.read<OrdersManager>().addOrder(
                  cart.product,
                  cart.totalAmount
                );
                cart.clear();
              },
              style: TextButton.styleFrom(
                textStyle: TextStyle(color: Theme.of(context).primaryColor)
              ),
              child: const Text("ORDER NOW"),
            ),
          ],
        ),
      ),
    );
  }

  buildCartDetails(CartManager cart) {
    return ListView(
      children: cart.productEntries.map((entry) => CartItemCard(
        productId: entry.key,
        cartItem: entry.value,
      )).toList(),
    );
  }
}
