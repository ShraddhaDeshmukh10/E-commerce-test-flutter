import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:commerceapp/Model/product.dart';
import 'package:commerceapp/productdetails.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        products = jsonData.map((json) => Product.fromJson(json)).toList();
        filteredProducts = products;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void filterProducts(String query) {
    final filtered = products.where((product) {
      return product.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredProducts = filtered;
    });
  }

  void sortProducts(String criteria) {
    filteredProducts.sort((a, b) {
      if (criteria == 'price') {
        return a.price.compareTo(b.price);
      } else if (criteria == 'rating') {
        return b.rating.compareTo(a.rating);
      }
      return 0;
    });
    setState(() {});
  }

  void navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  void navigateToCart() {
    Get.toNamed('/cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            onPressed: navigateToCart,
            color: Colors.blue,
            icon: Icon(Icons.shopping_cart),
          ),
          IconButton(
            onPressed: () {
              Get.toNamed('/checkout');
            },
            color: Colors.blue,
            icon: Icon(Icons.payment),
          )
        ],
      ),
      body: Container(
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                  filterProducts(query);
                },
                decoration: InputDecoration(
                  labelText: 'Search...',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => sortProducts('price'),
                  child: Text('Sort by Price'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => sortProducts('rating'),
                  child: Text('Sort by Rating'),
                ),
              ],
            ),
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
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
                            subtitle: Text('\$${product.price.toString()}'),
                            onTap: () {
                              navigateToProductDetail(product);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
