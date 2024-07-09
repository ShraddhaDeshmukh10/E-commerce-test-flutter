import 'package:get/get.dart';
import 'package:commerceapp/Model/product.dart';

class CartController extends GetxController {
  final RxList<Product> cartItems = <Product>[].obs;
  final RxMap<Product, int> itemCounts = <Product, int>{}.obs;
  void addToCart(Product product) {
    if (itemCounts.containsKey(product)) {
      itemCounts[product] = itemCounts[product]! + 1;
    } else {
      itemCounts[product] = 1;
      cartItems.add(product);
    }
    update();
  }

  void removeFromCart(Product product) {
    if (itemCounts.containsKey(product) && itemCounts[product]! > 1) {
      itemCounts[product] = itemCounts[product]! - 1;
    } else {
      itemCounts.remove(product);
      cartItems.remove(product);
    }
    update();
  }

  double getTotalAmount() {
    double total = 0;
    for (var product in cartItems) {
      total += product.price * itemCounts[product]!;
    }
    return total;
  }

  void incrementItem(Product product) {
    if (itemCounts.containsKey(product)) {
      itemCounts[product] = itemCounts[product]! + 1;
      update();
    }
  }

  void decrementItem(Product product) {
    if (itemCounts.containsKey(product) && itemCounts[product]! > 1) {
      itemCounts[product] = itemCounts[product]! - 1;
    } else {
      itemCounts.remove(product);
      cartItems.remove(product);
    }
    update();
  }

  int getItemCount(Product product) {
    if (itemCounts.containsKey(product)) {
      return itemCounts[product]!;
    }
    return 0;
  }
}
