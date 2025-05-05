import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RangeCalendar extends StatelessWidget {
  final int min;
  final int max;
  final ValueChanged<ShadDateTimeRange?>? onRangeSelected; // ✅ Corrected Type

  const RangeCalendar({
    super.key,
    this.min = 2,
    this.max = 5,
    this.onRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ShadCalendar.range(
      min: min,
      max: max,
      onChanged: onRangeSelected, // ✅ Now matches expected type
    );
  }
}
