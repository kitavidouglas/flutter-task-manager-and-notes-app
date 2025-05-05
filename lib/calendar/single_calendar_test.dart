import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zafarm/components/calendar/single_date.dart';

class SingleCalendarTestPage extends StatelessWidget {
  const SingleCalendarTestPage({super.key});

  void _showDateDialog(BuildContext context, DateTime? date) {
    if (date != null) {
      showShadDialog(
        context: context,
        builder: (context) => ShadDialog.alert(
          title: const Text('Selected Date'),
          description: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('You selected: ${date.toLocal()}'),
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
      appBar: AppBar(title: const Text('Single Calendar Test')),
      body: Center(
        child: SingleCalendar(
          selectedDate: DateTime.now(),
          onDateSelected: (DateTime? date) {
            _showDateDialog(context, date);
          },
        ),
      ),
    );
  }
}
