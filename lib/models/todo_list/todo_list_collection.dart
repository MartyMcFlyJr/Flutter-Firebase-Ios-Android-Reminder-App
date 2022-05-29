import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:iosreminder/models/todo_list/todo_list.dart';

class TodoListCollection with ChangeNotifier {
  List<TodoList> _todoLists = [];

  UnmodifiableListView<TodoList> get todoLists =>
      UnmodifiableListView(_todoLists);

  addTodoList(TodoList todoList) {
    _todoLists.add(todoList);
    notifyListeners();
  }

  removeTodoList(TodoList todoList) {
    _todoLists.removeWhere((element) => element.id == todoList.id);
    notifyListeners();
  }
}
