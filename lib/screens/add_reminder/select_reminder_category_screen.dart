import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iosreminder/models/category/category_collection.dart';

import '../../models/category/category.dart';

class SelectReminderCategoryScreen extends StatelessWidget {
  final Category selectCategory;
  final Function(Category) selectCategoryCallback;

  const SelectReminderCategoryScreen(
      {Key? key,
      required this.selectCategory,
      required this.selectCategoryCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var categories = CategoryCollection().categories;

    return Scaffold(
      appBar: AppBar(title: Text('Select Category')),
      body: ListView.builder(
          itemCount: categories.length, itemBuilder: (context, index) {
            final item = categories[index];
            if (item.id == 'all') {
              return Container();
            }
            return ListTile(
              onTap: () {
                selectCategoryCallback(item);
                Navigator.pop(context);
              },
              title: Text(item.name),
              trailing: item.name == selectCategory.name ? Icon(Icons.check) : null,
            );
      }),
    );
  }
}
