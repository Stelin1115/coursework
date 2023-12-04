import 'dart:convert';

import 'package:coursework/MainScreen/Reusable/SharedPreferences.dart';
import 'package:flutter/material.dart';

import '../Constants/Colors/colors.dart';

class AddToCartScreen extends StatefulWidget {
  const AddToCartScreen({Key? key}) : super(key: key);

  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              const Text(
                "Saved Classes",
                style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<List<String>>(
                future: SharedPreferencesHelper.getCartItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<String> cartItems = snapshot.data ?? [];

                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshCart,
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            Map<String, String> classDetails =
                                Map<String, String>.from(
                                    jsonDecode(cartItems[index].toString()));

                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(
                                  color: HexColor("#e6ffe6"),
                                  width: 2.0,
                                ),
                              ),
                              color: HexColor("#f2fcf8"),
                              elevation: 5.0,
                              child: SizedBox(
                                height: 100.0,
                                child: Center(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage(
                                        classDetails['imageURL'] ?? '',
                                      ),
                                    ),
                                    title:
                                        Text(classDetails['className'] ?? ''),
                                    subtitle: Text(
                                      'Time: ${classDetails['classTime'] ?? ''}',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        _removeFromCart(index);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshCart() async {
    // Add a delay to simulate a network request
    await Future.delayed(const Duration(seconds: 1));

    // Call setState to trigger a rebuild and refresh the data
    setState(() {});

    return Future.value();
  }

  void _removeFromCart(int index) async {
    // Retrieve existing cart items from shared preferences
    List<String> cartItems = await SharedPreferencesHelper.getCartItems();

    // Remove the item at the specified index
    cartItems.removeAt(index);

    // Save the updated cart items back to shared preferences
    await SharedPreferencesHelper.saveCartItems(cartItems);

    // Trigger a rebuild by calling setState
    setState(() {});
  }
}
