import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iosreminder/screens/view_list/view_list_screen.dart';
import 'package:provider/provider.dart';

import '../../../common/helpers/helpers.dart' as helpers;
import '../../../common/widgets/cateogry_icon.dart';
import '../../../common/widgets/dismissible_background.dart';
import '../../../models/common/custom_color_collection.dart';
import '../../../models/common/custom_icon_collection.dart';
import '../../../models/todo_list/todo_list.dart';
import '../../../services/database_service.dart';

class TodoLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoLists = Provider.of<List<TodoList>>(context);
    final user = Provider.of<User?>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Lists',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: todoLists.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    onDismissed: (direction) async {
                      try {
                        await DatabaseService(uid: user!.uid).deleteTodoList(todoLists[index]);
                        helpers.showSnackBar(context, 'List deleted');
                      } catch (e) {
                        helpers.showSnackBar(context, 'Unable to delete List');
                      }
                    },
                    background: DismissibleBackground(),
                    direction: DismissDirection.endToStart,
                    key: UniqueKey(),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        onTap: todoLists[index].reminderCount > 0
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewListScreen(
                                      todoList: todoLists[index],
                                    ),
                                  ),
                                );
                              }
                            : null,
                        leading: CategoryIcon(
                          bgColor: CustomColorCollection()
                              .findColorById(todoLists[index].icon['color'])
                              .color,
                          iconData: (CustomIconCollection()
                              .findIconById(todoLists[index].icon['id'])
                              .icon),
                        ),
                        title: Text(todoLists[index].title),
                        trailing: Text(
                          todoLists[index].reminderCount.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
