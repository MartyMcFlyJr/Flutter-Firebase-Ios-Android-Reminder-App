import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iosreminder/common/widgets/cateogry_icon.dart';
import 'package:iosreminder/models/reminder/reminder.dart';
import 'package:iosreminder/screens/add_reminder/select_reminder_category_screen.dart';
import 'package:iosreminder/screens/add_reminder/select_reminder_list_screen.dart';
import 'package:iosreminder/services/database_service.dart';
import 'package:provider/provider.dart';

import '../../common/helpers/helpers.dart' as helpers;
import '../../models/category/category.dart';
import '../../models/category/category_collection.dart';
import '../../models/todo_list/todo_list.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({Key? key}) : super(key: key);

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _notesTextController = TextEditingController();
  String _title = '';
  TodoList? _selectedList;
  Category _selectedCategory = CategoryCollection().categories[0];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  _updateSelectedList(TodoList todoList) {
    setState(() {
      _selectedList = todoList;
    });
  }

  _updateSelectedCategory(Category category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  void initState() {
    super.initState();
    _titleTextController.addListener(() {
      setState(() {
        _title = _titleTextController.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleTextController.dispose();
    _notesTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _todoLists = Provider.of<List<TodoList>>(context);
    final user = Provider.of<User?>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('New Reminder'),
        actions: [
          TextButton(
            onPressed: _title.isEmpty || _selectedDate == null || _selectedTime == null
                ? null
                : () async {
                    if (_selectedList == null) {
                      _selectedList = _todoLists.first;
                    }

                    var reminder = Reminder(
                        id: null,
                        title: _titleTextController.text,
                        notes: _notesTextController.text,
                        categoryId: _selectedCategory.id,
                        list: _selectedList!.toJson(),
                        dueDate: _selectedDate!.millisecondsSinceEpoch,
                        dueTime: {
                          'hour': _selectedTime!.hour,
                          'minute': _selectedTime!.minute
                        });

                    try {
                      DatabaseService(uid: user!.uid).addReminder(reminder: reminder);
                      Navigator.pop(context);
                      helpers.showSnackBar(context, 'Reminder added');
                    } catch (e) {
                      helpers.showSnackBar(context, 'Unable to add reminder');
                    }

                  },
            child: Text('Add'),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  children: [
                    TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _titleTextController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    SizedBox(
                        height: 100,
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: _notesTextController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Notes',
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                ),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectReminderListScreen(
                            selectedList: _selectedList != null
                                ? _selectedList!
                                : _todoLists.first,
                            todoLists: _todoLists,
                            selectListCallback: _updateSelectedList,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    tileColor: Theme.of(context).cardColor,
                    leading: Text(
                      'List',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CategoryIcon(
                          bgColor: Colors.blueAccent,
                          iconData: Icons.calendar_today,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_selectedList != null
                            ? _selectedList!.title
                            : _todoLists.first.title),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                ),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectReminderCategoryScreen(
                                  selectCategory: _selectedCategory,
                                  selectCategoryCallback: _updateSelectedCategory,
                                )),
                      );
                    },
                    tileColor: Theme.of(context).cardColor,
                    leading: Text(
                      'Category',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CategoryIcon(
                          bgColor: _selectedCategory.icon.bgColor,
                          iconData: _selectedCategory.icon.iconData,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_selectedCategory.name),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                ),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)));
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    tileColor: Theme.of(context).cardColor,
                    leading: Text(
                      'Date',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CategoryIcon(
                          bgColor: Colors.red.shade300,
                          iconData: CupertinoIcons.calendar_badge_plus,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_selectedDate != null
                            ? DateFormat.yMMMd().format(_selectedDate!).toString()
                            : 'Select Date'),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                ),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (pickedTime != null) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                    tileColor: Theme.of(context).cardColor,
                    leading: Text(
                      'Time',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CategoryIcon(
                          bgColor: Colors.red.shade300,
                          iconData: CupertinoIcons.time,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_selectedTime != null
                            ? _selectedTime!.format(context).toString()
                            : 'Select Time'),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
