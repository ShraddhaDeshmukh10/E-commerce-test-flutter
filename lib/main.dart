import 'package:commerceapp/Model/cartadd.dart';
import 'package:commerceapp/Model/productlistingpage.dart';
import 'package:commerceapp/checkout.dart';
import 'package:commerceapp/firebase_options.dart';
import 'package:commerceapp/home.dart'; // Import Home
import 'package:commerceapp/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Login01(),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => Home()),
        GetPage(name: '/products', page: () => ProductListingPage()),
        GetPage(name: '/cart', page: () => CartPage()),
        GetPage(name: '/checkout', page: () => CheckoutPage()),
      ],
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
