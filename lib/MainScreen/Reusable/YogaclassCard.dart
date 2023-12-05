import 'dart:convert';
import 'package:coursework/Constants/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'SharedPreferences.dart';

class YogaClassCard extends StatelessWidget {
  final String teacher;
  final String classDay;
  final String date;
  final String classTime;
  final Function() function;

  const YogaClassCard({
    super.key,
    required this.teacher,
    required this.classDay,
    required this.date,
    required this.classTime,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: HexColor("#e6ffe6"), width: 2.0),
      ),
      color: HexColor("#f2fcf8"),
      elevation: 5.0,
      child: SizedBox(
        height: 100.0,
        child: Center(
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage('https://picsum.photos/200/300'),
            ),
            title: Text(teacher),
            subtitle: Container(
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(classDay),
                    Row(
                      children: [
                        Text('$date '),
                        Text(classTime),
                      ],
                    ),
                  ],
                )),
            trailing: IconButton(
              onPressed: function,
              icon: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  // void _addToCart(BuildContext context) async {
  //   // Retrieve existing cart items from shared preferences
  //   List<String> cartItems = await SharedPreferencesHelper.getCartItems();

  //   // Add the current class details to the cart
  //   Map<String, String> classDetails = {
  //     'className': className,
  //     'classTime': classTime,
  //     'imageURL': imageURL,
  //   };
  //   cartItems.add(jsonEncode(classDetails));

  //   // Save the updated cart items back to shared preferences
  //   await SharedPreferencesHelper.saveCartItems(cartItems);

  //   // Show a confirmation snackbar
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Added to Cart'),
  //       duration: Duration(seconds: 1),
  //     ),
  //   );
  // }
}
