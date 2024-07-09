import 'package:commerceapp/Model/cartcontroller.dart';
import 'package:commerceapp/checkout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:commerceapp/Model/product.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Obx(() => cartController.cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.white, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartController.cartItems.length,
                      itemBuilder: (context, index) {
                        final product = cartController.cartItems[index];
                        return Card(
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            leading: Image.network(
                              product.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(product.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('\$${product.price.toString()}'),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        cartController.decrementItem(product);
                                      },
                                    ),
                                    Obx(() => Text(
                                        '${cartController.getItemCount(product)}')),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        cartController.incrementItem(product);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                cartController.removeFromCart(product);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() => Text(
                          'Total Amount: \$${cartController.getTotalAmount().toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckoutPage()));
                    },
                    child: Text('Proceed to Checkout'),
                  ),
                ],
              ),
            )),
    );
  }
}
