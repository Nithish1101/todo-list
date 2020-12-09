import 'package:flutter/material.dart';

import '../../models/Todo.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final Function toggleTodoStatus;
  final Function showTodoDetails;

  TodoList({
    @required this.todos,
    @required this.toggleTodoStatus,
    @required this.showTodoDetails,
  });

  Text detail(text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: const Text('Go ahead and add some tasks!'),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final Todo todo = todos.elementAt(index);
          return ListTile(
            key: Key(todo.id),
            title: detail(todo.title),
            subtitle: detail(todo.description),
            onTap: () => showTodoDetails(todo.id),
            trailing: Checkbox(
              value: todo.completed,
              onChanged: (bool state) {
                toggleTodoStatus(todo.id, state);
              },
            ),
          );
        },
        childCount: todos.length,
      ),
    );
  }
}
