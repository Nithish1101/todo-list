import 'dart:convert';
import 'package:http/http.dart' as http;

import './models/Todo.dart';

const END_POINT = 'https://todo-list-a3fa0-default-rtdb.firebaseio.com';

Future<List<Todo>> getTodos() async {
  List<Todo> todos;
  await http.get('$END_POINT/todos.json').then((response) {
    final Map todoList = json.decode(response.body);
    todos = todoList?.entries?.map((todo) {
      return Todo(
        id: todo.key,
        title: todo.value['title'],
        description: todo.value['description'],
        completed: todo.value['completed'],
        createdOn:
            DateTime.fromMicrosecondsSinceEpoch(todo?.value['createdOn'] ?? 0),
      );
    })?.toList();
    // Get rid of invalid todos due to backend issue
    todos.removeWhere((todo) => todo.createdOn.microsecondsSinceEpoch == 0);
    todos?.sort((a, b) => b.createdOn.compareTo(a.createdOn));
  });
  return todos ?? [];
}

Future<bool> addTodo(title, description, state) async {
  final todoData = {
    'title': title,
    'description': description,
    'completed': state,
    'createdOn': DateTime.now().toUtc().microsecondsSinceEpoch,
  };
  return await http
      .post('$END_POINT/todos.json', body: json.encode(todoData))
      .then((response) {
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  });
}

Future<bool> updateTodo(
  todoId,
  newState, {
  String title,
  String description,
}) async {
  final requestData = {'completed': newState};
  if (title?.isNotEmpty ?? false) requestData['title'] = title;
  if (description?.isNotEmpty ?? false)
    requestData['description'] = description;
  return await http
      .patch('$END_POINT/todos/$todoId.json', body: json.encode(requestData))
      .then((response) {
    return response.statusCode == 200;
  });
}

Future<bool> deleteTodo(todoId) async {
  return await http
      .delete('$END_POINT/todos/$todoId.json')
      .then((response) => response.statusCode == 200 ? true : false);
}
