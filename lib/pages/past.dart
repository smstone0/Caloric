import 'package:caloric/databases/settings.dart';
import 'package:caloric/functions/dates.dart';
import 'package:caloric/widgets/heading.dart';
import 'package:caloric/widgets/past_breakdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PastPage extends StatelessWidget {
  const PastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: theme.colorScheme.surface));
    List<DateTime> dates = getPastWeekDates();

    return FutureBuilder<Settings>(
        future: SettingsDatabase().getSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Settings settings = snapshot.data!;
            return ListView(
              children: [
                Heading(text: 'Past week'),
                ...dates.map(
                    (date) => PastBreakdown(settings: settings, date: date)),
              ],
            );
          }
        });
  }
}
