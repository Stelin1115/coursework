// ignore_for_file: prefer_const_constructors

import 'package:coursework/MainScreen/Reusable/YogaclassCard.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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

  List<Map<String, String>> classes = [
    {
      'className': 'Class1',
      'classTime': '9:00 AM',
      'imageURL': 'https://picsum.photos/200/300'
    },
    {
      'className': 'Class2',
      'classTime': '12:00 PM',
      'imageURL': 'https://picsum.photos/200/300'
    },
    {
      'className': 'Class3',
      'classTime': '4:00 PM',
      'imageURL': 'https://picsum.photos/200/300'
    },
    {
      'className': 'Class4',
      'classTime': '9:00 AM',
      'imageURL': 'https://picsum.photos/200/300'
    },
    {
      'className': 'Class5',
      'classTime': '12:00 PM',
      'imageURL': 'https://picsum.photos/200/300'
    },
    {
      'className': 'Class6',
      'classTime': '4:00 PM',
      'imageURL': 'https://picsum.photos/200/300'
    },
    // Add more classes as needed
  ];

  List<Map<String, String>> displayedClasses = [];

  @override
  void initState() {
    super.initState();
    displayedClasses = List.from(classes);
  }

  void filterClasses(String query) {
    setState(() {
      displayedClasses = classes
          .where((classInfo) =>
              classInfo['className']!
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
              SizedBox(
                height: screenHeight * 0.75,
                child: ScrollablePositionedList.separated(
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: YogaClassCard(
                        className:
                            displayedClasses[index]['className'].toString(),
                        classTime:
                            displayedClasses[index]['classTime'].toString(),
                        imageURL:
                            displayedClasses[index]['imageURL'].toString(),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 15,
                    );
                  },
                  itemCount: displayedClasses.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
