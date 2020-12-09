import 'package:flutter/material.dart';

class Todo {
  String id;
  String title;
  String description;
  DateTime createdOn;
  bool completed;

  Todo({
    @required id,
    @required title,
    @required createdOn,
    description,
    completed = false,
  }) {
    this.id = id;
    this.title = title;
    this.description = description;
    this.createdOn = createdOn;
    this.completed = completed;
  }
}
