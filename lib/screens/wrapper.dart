import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iosreminder/config/custom_theme.dart';
import 'package:iosreminder/models/todo_list/todo_list.dart';
import 'package:iosreminder/services/database_service.dart';
import 'package:provider/provider.dart';

import '../models/reminder/reminder.dart';
import '../models/todo_list/todo_list.dart';
import 'add_list/add_list_screen.dart';
import 'add_reminder/add_reminder_screen.dart';
import 'auth/authenticate_screen.dart';
import 'home/home_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final customTheme = Provider.of<CustomTheme>(context);

    return MultiProvider(
      providers: [
        StreamProvider<List<TodoList>>.value(
          initialData: [],
          value: user != null
              ? DatabaseService(uid: user.uid).todoListStream()
              : null,
        ),
        StreamProvider<List<Reminder>>.value(
          initialData: [],
          value: user != null
              ? DatabaseService(uid: user.uid).reminderStream()
              : null,
        )
      ],
      child: MaterialApp(
        routes: {
          '/home': (context) => HomeScreen(),
          '/addList': (context) => AddListScreen(),
          '/addReminder': (context) => AddReminderScreen(),
        },
        home: user != null ? HomeScreen() : AuthenticateScreen(),
        theme: customTheme.lightTheme,
        darkTheme: customTheme.darkTheme,
        themeMode: customTheme.currentTheme(),
      ),
    );
  }
}
