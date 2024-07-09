import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:commerceapp/Model/product.dart';
import 'Model/cartcontroller.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final CartController cartController = Get.put(CartController());
  ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RxInt quantity = 1.obs;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.white, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(product.category,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Image.network(product.image, height: 200, width: 200),
                SizedBox(height: 10),
                Text(product.title,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('\$${product.price}',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Center(
                    child: Text(product.description,
                        style: TextStyle(fontSize: 18))),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (quantity.value > 1) {
                          quantity.value--;
                        }
                      },
                    ),
                    Obx(() => Text(
                          '${quantity.value}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        quantity.value++;
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    for (int i = 0; i < quantity.value; i++) {
                      cartController.addToCart(product);
                    }
                    Get.snackbar("Success", "Product Added Successfully");
                  },
                  child: Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
