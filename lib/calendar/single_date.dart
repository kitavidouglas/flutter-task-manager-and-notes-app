import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SingleCalendar extends StatelessWidget {
  final DateTime? selectedDate;
  final DateTime? fromMonth;
  final DateTime? toMonth;
  final ValueChanged<DateTime?>? onDateSelected; // ✅ Corrected Type

  const SingleCalendar({
    super.key,
    this.selectedDate,
    this.fromMonth,
    this.toMonth,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return ShadCalendar(
      selected: selectedDate ?? today,
      fromMonth: fromMonth ?? DateTime(today.year - 1),
      toMonth: toMonth ?? DateTime(today.year, 12),
      onChanged: onDateSelected, // ✅ Now matches expected type
    );
  }
}
