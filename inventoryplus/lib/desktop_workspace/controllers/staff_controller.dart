// lib/desktop_workspace/controllers/staff_controller.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StaffController extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  List<Map<String, dynamic>> staffList = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchStaff() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      // 1. UPDATED: Only fetch accounts where role is 'staff'
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('role', 'staff')
          .order('id');

      staffList = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      errorMessage = 'Failed to load staff: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveStaff(Map<String, dynamic> staffData) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      if (staffData['id'] == null) {
        await _supabase.from('profiles').insert({
          'name': staffData['name'],
          'username': staffData['username'],
          'password': staffData['password'],
          'role':
              'staff', // 2. UPDATED: Hardcoded to 'staff' to prevent admin creation
        });
      } else {
        await _supabase
            .from('profiles')
            .update({
              'name': staffData['name'],
              'username': staffData['username'],
              'password': staffData['password'],
              // We don't update the role here to ensure it stays 'staff'
            })
            .eq('id', staffData['id']);
      }

      await fetchStaff();
      return true;
    } catch (e) {
      errorMessage = 'Failed to save: ${e.toString()}';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
