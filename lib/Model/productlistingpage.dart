import 'package:commerceapp/Model/product.dart';
import 'package:commerceapp/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListingPage extends StatefulWidget {
  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  final ApiService apiService = ApiService();
  List<Product> products = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    products = await apiService.fetchProducts();
    setState(() {
      filteredProducts = products;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: filterProducts,
          decoration: InputDecoration(hintText: 'Search...'),
        ),
      ),
      body: Row(
        children: [
          // Filters and Sorting Section
          Container(
            width: 200,
            color: Colors.grey[200],
            child: Column(
              children: [
                Text('Sort by:'),
                ElevatedButton(
                  onPressed: () => sortProducts('price'),
                  child: Text('Price'),
                ),
                ElevatedButton(
                  onPressed: () => sortProducts('rating'),
                  child: Text('Rating'),
                ),
                // Add more filters as needed
              ],
            ),
          ),
          // Products Listing Section
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  child: Column(
                    children: [
                      Image.network(product.image, height: 150, width: 150),
                      Text(product.title),
                      Text('\$${product.price}'),
                      ElevatedButton(
                        onPressed: () {
                          // Add to cart functionality
                        },
                        child: Text('Add to Cart'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
