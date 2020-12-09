import 'package:flutter/material.dart';
import 'package:todos/widgets/screens/TodoDetails.dart';

import '../components/Header.dart';
import '../components/TodoList.dart';
import '../components/Loading.dart';
import '../../models/Todo.dart';
import '../../apis.dart' as api;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos;
  bool fetchingData = true;
  bool isActive = true;

  Loading overlay;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    overlay = Loading.of(context);
    fetchTodoData();
  }

  // Fetch todos data on component mount
  void fetchTodoData() async {
    await api.getTodos().then((todos) {
      setState(() {
        this.todos = todos;
        fetchingData = false;
      });
    });
  }

  // Update todos by showing progress indicator
  void updateTodos() async {
    overlay.show();
    final List<Todo> newTodos = await api.getTodos();
    setState(() {
      todos = newTodos;
    });
    overlay.hide();
  }

  // Update without showing progress indicator in UI
  Future<void> refresh() async {
    await api.getTodos().then(
      (todos) {
        setState(() {
          this.todos = todos;
        });
      },
    );
  }

  void toggleTodoState(id, state) async {
    overlay.show();
    final bool updateSuccessful = await api.updateTodo(id, state);
    overlay.hide();
    if (updateSuccessful) {
      final List<Todo> temp = [...todos];
      final Todo task = temp.firstWhere((todo) => todo.id == id);
      task.completed = state;
      setState(() {
        todos = temp;
      });
    }
  }

  Center initialLoadingMessage() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          const Text('Loading your tasks!')
        ],
      ),
    );
  }

  void addNewTask() async {
    final bool shouldUpdate = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoDetails(),
      ),
    );
    if (shouldUpdate) {
      refresh();
    }
  }

  CustomScrollView renderTodoList() {
    final Header header = Header(
      pending: todos.fold(0, (t, e) => t + (e.completed ? 0 : 1)),
      addTask: addNewTask,
    );
    final TodoList todoList = TodoList(
      todos: todos,
      toggleTodoStatus: toggleTodoState,
      showTodoDetails: showTodoDetails,
    );
    return CustomScrollView(
      slivers: [header, todoList],
    );
  }

  void showTodoDetails(id) async {
    Todo task = todos.firstWhere((element) => element.id == id);
    final bool shouldUpdate = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoDetails(
          todo: task,
        ),
      ),
    );
    if(shouldUpdate ?? false) {
      updateTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: fetchingData
          ? initialLoadingMessage()
          : RefreshIndicator(
              child: renderTodoList(),
              onRefresh: refresh,
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    overlay = null;
  }
}
