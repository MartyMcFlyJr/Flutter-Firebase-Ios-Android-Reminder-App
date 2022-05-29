import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iosreminder/models/todo_list/todo_list.dart';
import 'package:iosreminder/screens/add_list/add_list_screen.dart';
import 'package:iosreminder/screens/add_reminder/add_reminder_screen.dart';
import 'package:provider/provider.dart';

class Footer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final todoLists = Provider.of<List<TodoList>>(context);
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
                icon: const Icon(Icons.add_circle),
                onPressed: todoLists.length > 0 ? () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddReminderScreen(),
                          fullscreenDialog: true
                      ));
                } : null,
                label: Text('Add Reminder')),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddListScreen(),
                        fullscreenDialog: true
                      ));
                },
                child: Text('Add List'))
          ],
        ));
  }
}
