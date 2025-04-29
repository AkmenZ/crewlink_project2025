import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FrostedDatePicker extends StatelessWidget {
  const FrostedDatePicker({
    super.key,
    required this.name,
    required this.label,
  });

  final String name;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: FormBuilderDateTimePicker(
            name: name,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            style: const TextStyle(color: Colors.white),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            timePickerInitialEntryMode: TimePickerEntryMode.dialOnly,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.white70),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ),
    );
  }
}
