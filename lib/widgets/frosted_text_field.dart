import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FrostedTextField extends StatelessWidget {
  const FrostedTextField({
    super.key,
    required this.name,
    required this.label,
    this.obscureText = false,
  });

  final String name;
  final String label;
  final bool obscureText;

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
          child: FormBuilderTextField(
            name: name,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.white70),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
