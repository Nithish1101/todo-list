import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final int pending;
  final Function addTask;

  Header({@required this.pending, @required this.addTask});

  @override
  Widget build(BuildContext context) {
    final DateTime current = DateTime.now();
    final String date =
        '${DAYS[current.weekday - 1]}, ${current.day} ${MONTHS[current.month - 1]}';
    final String message = pending == 0
        ? 'All Done!'
        : '$pending ${pending == 1 ? 'task' : 'tasks'} pending';
    return SliverAppBar(
      collapsedHeight: 90,
      expandedHeight: 180,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            SizedBox(height: 4),
            Text(date,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.white)),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.post_add),
          onPressed: () => addTask(),
        )
      ],
    );
  }
}

const DAYS = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

const MONTHS = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
