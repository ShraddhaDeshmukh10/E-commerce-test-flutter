import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:upi_india/upi_india.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();

  String _paymentMethod = 'Card'; // Default payment method
  String _selectedUpiApp = 'Google Pay'; // Default UPI app

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Checkout Screen',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _paymentMethod,
                        items: [
                          DropdownMenuItem(
                            value: 'Card',
                            child: Text('Card'),
                          ),
                          DropdownMenuItem(
                            value: 'UPI',
                            child: Text('UPI'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Payment Method',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (_paymentMethod == 'Card') ...[
                        TextFormField(
                          controller: cardNumberController,
                          decoration: InputDecoration(
                            labelText: 'Card Number',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter card number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: expiryDateController,
                                decoration: InputDecoration(
                                  labelText: 'Expiry Date (MM/YY)',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter expiry date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: TextFormField(
                                controller: cvvController,
                                decoration: InputDecoration(
                                  labelText: 'CVV',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter CVV';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ] else if (_paymentMethod == 'UPI') ...[
                        TextFormField(
                          controller: upiIdController,
                          decoration: InputDecoration(
                            labelText: 'UPI ID',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter UPI ID';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedUpiApp,
                          items: [
                            DropdownMenuItem(
                              value: 'Google Pay',
                              child: Text('Google Pay'),
                            ),
                            DropdownMenuItem(
                              value: 'PhonePe',
                              child: Text('PhonePe'),
                            ),
                            DropdownMenuItem(
                              value: 'Paytm',
                              child: Text('Paytm'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedUpiApp = value!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'UPI App',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Process payment
                            if (_paymentMethod == 'Card') {
                              // Process card payment
                              _processCardPayment();
                            } else if (_paymentMethod == 'UPI') {
                              // Redirect to UPI app
                              _processUPIPayment();
                            }
                          }
                        },
                        child: Text('Place Order'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _processCardPayment() {
    String cardNumber = cardNumberController.text;
    String expiryDate = expiryDateController.text;
    String cvv = cvvController.text;

    if (cardNumber.isNotEmpty && expiryDate.isNotEmpty && cvv.isNotEmpty) {
      Get.snackbar('Payment Successful',
          'Your payment has been successfully processed.');
    } else {
      Get.snackbar(
          'Payment Failed', 'There was an error processing your payment.');
    }
  }

  Future<void> _processUPIPayment() async {
    UpiIndia _upiIndia = UpiIndia();
    UpiApp app;

    switch (_selectedUpiApp) {
      case 'Google Pay':
        app = UpiApp.googlePay;
        break;
      case 'PhonePe':
        app = UpiApp.phonePe;
        break;
      case 'Paytm':
        app = UpiApp.paytm;
        break;
      default:
        app = UpiApp.googlePay;
    }

    UpiResponse response = await _upiIndia.startTransaction(
      app: app,
      receiverUpiId: upiIdController.text,
      receiverName: 'Receiver Name',
      transactionRefId: 'TestRefId',
      transactionNote: 'Test Payment',
      amount: 1.00, // Test amount
    );

    if (response.status == UpiPaymentStatus.SUCCESS) {
      Get.snackbar('Payment Successful',
          'Your payment has been successfully processed.');
    } else {
      Get.snackbar(
          'Payment Failed', 'There was an error processing your payment.');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    upiIdController.dispose();
    super.dispose();
  }
}
