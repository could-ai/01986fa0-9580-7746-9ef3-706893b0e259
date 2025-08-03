import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

extension ShowSnackBar on BuildContext {
  void showSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(this).colorScheme.primary,
      ),
    );
  }
  void showErrorSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(this).colorScheme.error,
      ),
    );
  }
}
