import 'package:caloric/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PastPage extends StatelessWidget {
  const PastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: theme.colorScheme.surface));

    return ListView(children: [Heading(text: 'Previous 7 days')]);
  }
}
