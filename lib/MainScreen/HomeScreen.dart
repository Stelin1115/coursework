// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:coursework/MainScreen/Reusable/SharedPreferences.dart';
import 'package:coursework/MainScreen/Reusable/YogaclassCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../Api/Api.dart';
import '../Constants/Colors/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController itemScrollController = ItemScrollController();

  // List<Map<String, String>> classes = [
  //   {
  //     'teacher': 'Rosselll',
  //     'classDay': "Wednesday",
  //     'date': '12/12/2023',
  //     'classTime': '12:00'
  //   },
  //   {
  //     'teacher': 'Rosselll',
  //     'classDay': "Wednesday",
  //     'date': '12/12/2023',
  //     'classTime': '13:00'
  //   },
  //   {
  //     'teacher': 'Rosselll',
  //     'classDay': "Wednesday",
  //     'date': '12/12/2023',
  //     'classTime': '14:00'
  //   },
  //   {
  //     'teacher': 'Rosselll',
  //     'classDay': "Wednesday",
  //     'date': '12/12/2023',
  //     'classTime': '15:00'
  //   },
  //   {
  //     'teacher': 'Rosselll',
  //     'classDay': "Wednesday",
  //     'date': '12/12/2023',
  //     'classTime': '16:00'
  //   },
  //   {
  //     'teacher': 'Rosselll',
  //     'classDay': "Wednesday",
  //     'date': '12/12/2023',
  //     'classTime': '17:00'
  //   },
  //   // Add more classes as needed
  // ];

  List<Map<String, String>> displayedClasses = [];

  bool isLoading = true;
  var classbody;

  void getClasses() async {
    setState(() {
      isLoading = true;
    });

    try {
      var data = {
        "userId": 'Sm0740r',
      };
      print('object');
      print(classbody);

      print('0');

      var box = await CallApi().postData(data, 'GetInstances');
      print('1');

      classbody = json.decode(box.body);
      print('2');

      displayedClasses = List.from(classbody);

      print('OOOOOOOKKKKKKKKAAAAAAAAYYYYYYYYYY');

      print(classbody);

      print('OOOOOOOKKKKKKKKAAAAAAAAYYYYYYYYYY');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getClasses();
    // displayedClasses = List.from(classes);
  }

  void filterClasses(String query) {
    setState(() {
      displayedClasses = classbody
          .where((classInfo) =>
              classInfo['teacher']!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              classInfo['classTime']!
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: TextField(
                  onChanged: filterClasses,
                  decoration: InputDecoration(
                    labelText: 'Search classes',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ),
                  ),
                ),
              ),
              isLoading
                  ? SizedBox(
                      height: screenHeight * 0.75,
                      child: Center(child: CupertinoActivityIndicator()),
                    )
                  : classbody == null
                      ? SizedBox(
                          height: screenHeight * 0.75,
                          child: Center(child: Text('No classes available')),
                        )
                      : SizedBox(
                          height: screenHeight * 0.75,
                          child: ScrollablePositionedList.separated(
                            itemScrollController: itemScrollController,
                            itemPositionsListener: itemPositionsListener,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  print('object');
                                },
                                child: YogaClassCard(
                                  teacher:
                                      classbody[index]['teacher'].toString(),
                                  classDay:
                                      classbody[index]['classDay'].toString(),
                                  date: classbody[index]['date'].toString(),
                                  classTime:
                                      classbody[index]['classTime'].toString(),
                                  function: () {
                                    print(classbody[index]['classTime']
                                        .toString());
                                    postBooking(
                                        classbody[index]['instanceId'],
                                        classbody[index]['teacher'].toString()!,
                                        classbody[index]['classDay']
                                            .toString()!,
                                        classbody[index]['date'].toString()!,
                                        classbody[index]['classTime']
                                            .toString()!);
                                  },
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 15,
                              );
                            },
                            itemCount: classbody == null ? 0 : classbody.length,
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  var bookbody;
  void postBooking(int instanceId, String teacher, String classDay, String date,
      String classTime) async {
    setState(() {
      isLoading = true;
    });

    try {
      var data = {
        "userId": "Sm0740r",
        "bookingList": [
          {"instanceId": instanceId}
        ]
      };
      var box = await CallApi().postData(data, 'SubmitBookings');
      bookbody = json.decode(box.body);
      _addToCart(teacher, classDay, date, classTime);
      print('OOOOOOOKKKKKKKKAAAAAAAAYYYYYYYYYY');

      print(bookbody);

      print('OOOOOOOKKKKKKKKAAAAAAAAYYYYYYYYYY');
    } catch (e) {}
    setState(() {
      isLoading = false;
    });
  }

  void _addToCart(
      String teacher, String classDay, String date, String classTime) async {
    // Retrieve existing cart items from shared preferences
    List<String> cartItems = await SharedPreferencesHelper.getCartItems();

    // Add the current class details to the cart
    Map<String, String> classDetails = {
      'teacher': teacher,
      'classDay': classDay,
      'date': date,
      'classTime': classTime
    };
    cartItems.add(jsonEncode(classDetails));

    // Save the updated cart items back to shared preferences
    await SharedPreferencesHelper.saveCartItems(cartItems);

    // Show a confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to Cart'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
