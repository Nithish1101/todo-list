import 'package:flutter/material.dart';

import '../components/Button.dart';
import '../components/Check.dart';
import '../components/TextBox.dart';
import '../components/Loading.dart';

import '../../apis.dart' as api;
import '../../models/Todo.dart';

class TodoDetails extends StatefulWidget {
  final Todo todo;

  TodoDetails({Key key, this.todo}) : super(key: key);

  @override
  _TodoDetailsState createState() => _TodoDetailsState();
}

class _TodoDetailsState extends State<TodoDetails> {
  String id;
  String title;
  String description;
  bool completed = false;

  bool shouldUpdate = false;
  bool isNew = true;
  var overlay;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final Function titleValidator = (value) {
    if (value.isEmpty) {
      return 'Please enter the title';
    }
    return null;
  };

  @override
  void initState() {
    super.initState();
    overlay = Loading.of(context);
    id = widget.todo?.id;
    title = widget.todo?.title ?? '';
    description = widget.todo?.description ?? '';
    completed = widget.todo?.completed ?? false;
    isNew = widget.todo == null ? true : false;
  }

  IconButton backButton() {
    return IconButton(
      icon: Icon(Icons.chevron_left),
      onPressed: () => Navigator.of(context).pop(shouldUpdate),
    );
  }

  showAlertDialog(BuildContext context, String title) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Are you sure you want to delete $title?"),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("DELETE")
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    );
  }

  IconButton deleteButton() {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () async {
        var confirmDelete = await showAlertDialog(context, title);
        if(confirmDelete) {
          overlay.show();
            final success = await api.deleteTodo(id);
            overlay.hide();
            if (success) Navigator.of(context).pop(true);
        }
      },
    );
  }

  onTitleChange(String text) {
    setState(() {
      title = text.trim();
    });
  }

  onDescriptionChange(String text) {
    setState(() {
      description = text.trim();
    });
  }

  onTodoStateChange(state) {
    setState(() {
      completed = state;
    });
  }

  void addTask() async {
    overlay.show();
    final bool success = await api.addTodo(title, description, completed);
    overlay.hide();
    Navigator.of(context).pop(success);
  }

  void updateTask() async {
    overlay.show();
    final bool success = await api.updateTodo(id, completed,
        title: title, description: description);
    overlay.hide();
    if (success) {
      setState(() {
        shouldUpdate = true;
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: const Text('Task Updated!'),
        backgroundColor: Colors.green,
      ));
    }
  }

  void submitForm() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      if (isNew) {
        addTask();
      } else {
        updateTask();
      }
    }
  }

  Container todoForm() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextBox(
              label: 'Title',
              value: title,
              onChange: onTitleChange,
              validator: titleValidator,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: TextBox(
                label: 'Description',
                value: description,
                onChange: onDescriptionChange,
                multiLine: true,
              ),
            ),
            Check(
              label: completed ? 'Pending' : 'Complete',
              value: completed,
              onChange: onTodoStateChange,
            ),
            Button(
              label: isNew ? 'Add Task' : 'Update Task',
              onPress: submitForm,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String header = isNew ? 'Add Task' : 'Update Task';
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(header),
        leading: backButton(),
        actions: [if (!isNew) deleteButton()],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: todoForm(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    overlay = null;
  }
}
