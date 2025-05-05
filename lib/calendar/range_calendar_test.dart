import 'package:flutter/material.dart';

class RangeCalendarTestPage extends StatelessWidget {
  const RangeCalendarTestPage({super.key});

  void _showRangeDialog(BuildContext context, ShadDateTimeRange? range) {
    if (range != null) {
      showShadDialog(
        context: context,
        builder: (context) => ShadDialog.alert(
          title: const Text('Selected Date Range'),
          description: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
                'Start: ${range.start?.toLocal()}\nEnd: ${range.end?.toLocal()}'),
          ),
          actions: [
            ShadButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Range Calendar Test')),
      body: Center(
        child: RangeCalendar(
          min: 3,
          max: 7,
          onRangeSelected: (ShadDateTimeRange? range) {
            _showRangeDialog(context, range);
          },
        ),
      ),
    );
  }
}
