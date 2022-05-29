import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iosreminder/config/custom_theme.dart';
import 'package:iosreminder/models/category/category_collection.dart';
import 'package:iosreminder/screens/home/widgets/list_view_items.dart';
import 'package:iosreminder/screens/home/widgets/todo_lists.dart';
import 'package:provider/provider.dart';

import '../../models/todo_list/todo_list.dart';
import 'widgets/footer.dart';
import 'widgets/grid_view_items.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CategoryCollection categoryCollection = CategoryCollection();
  String layoutType = 'grid';

  List<TodoList> todoLists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            onPressed: () {
              final customTheme =
                  Provider.of<CustomTheme>(context, listen: false);
              customTheme.toggleTheme();
            },
            icon: Icon(Icons.wb_sunny),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
          TextButton(
            onPressed: () {
              if (layoutType == 'grid') {
                setState(() {
                  layoutType = 'list';
                });
              } else {
                setState(() {
                  layoutType = 'grid';
                });
              }
            },
            child: Text(
              layoutType == 'grid' ? 'Edit' : 'Done',
            ),
          )
        ]),
        body: Container(
            child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  AnimatedCrossFade(
                      duration: Duration(milliseconds: 350),
                      crossFadeState: layoutType == 'grid'
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: GridViewItems(
                          categories: categoryCollection.selectedCategories),
                      secondChild: ListViewItems(
                          categoryCollection: categoryCollection)),
                  TodoLists()
                ],
              ),
            ),
            Footer()
          ],
        )));
  }
}
