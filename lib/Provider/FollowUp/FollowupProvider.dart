import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/FollowUpModel.dart';


class FollowUpProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<FollowUpData> _followUps = [];


  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<FollowUpData> get followUps => _followUps;

  /// Replace with your actual API endpoint
  final String apiUrl = 'https://call-logs-backend.onrender.com/api/meetings/follow-date';

  Future<void> fetchFollowUps() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ No token found for calendar meetings");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final followUpResponse = FollowUpResponse.fromJson(data);
        _followUps = followUpResponse.data;
      } else {
        _errorMessage =
        'Error ${response.statusCode}: ${response.reasonPhrase}';
      }
    } catch (e) {
      _errorMessage = 'Failed to load follow-ups: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }




  // 🔹 PATCH API call to update follow-up
  // Future<void> updateFollowUp({
  //   required String id,
  //   required String date,
  //   required String time,
  //   required String remark,
  //   required String status,
  //   String? companyName,
  //   String? phone,
  // }) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //
  //   if (token == null) {
  //     print("❌ No token found for calendar meetings");
  //     return;
  //   }
  //
  //   try {
  //     _isLoading = true;
  //     notifyListeners();
  //
  //     // 🔹 Map frontend statuses to valid backend enum values
  //     final validStatuses = {
  //       'Follow Up Required': 'Hold',
  //       'In Progress': 'Hold',
  //       'Completed': 'Completed',
  //       'Closed': 'Close',
  //     };
  //
  //     final timelineValue = validStatuses[status] ?? status;
  //
  //     final url = Uri.parse(
  //         'https://call-logs-backend.onrender.com/api/meetings/$id/followup');
  //
  //     final response = await http.patch(
  //       url,
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         "date": date,
  //         "time": time,
  //         "detail": remark,
  //         "timeline": timelineValue,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final resData = jsonDecode(response.body);
  //       debugPrint('✅ Follow-up updated: $resData');
  //       await fetchFollowUps();
  //     } else {
  //       debugPrint('❌ Failed to update: ${response.body}');
  //       _errorMessage = 'Failed to update follow-up';
  //     }
  //   } catch (e) {
  //     debugPrint('⚠️ Exception: $e');
  //     _errorMessage = e.toString();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }


  // 🔹 Optional: Delete follow-up
  Future<void> deleteFollowUp(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint("❌ No token found for deleting meeting");
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final url = Uri.parse(
          'https://call-logs-backend.onrender.com/api/meetings/$id');

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Meeting deleted successfully');
        // Optionally refresh list after deletion
        _followUps.removeWhere((item) => item.id == id);
        notifyListeners();
      } else {
        debugPrint('❌ Failed to delete: ${response.body}');
        _errorMessage = 'Failed to delete meeting';
      }
    } catch (e) {
      debugPrint('⚠️ Exception while deleting: $e');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }




  // Future<void> updateFollowUp({
  //   required String id,
  //   required String date,
  //   required String time,
  //   required String remark,
  //   required String status,
  //   String? companyName,
  //   String? phone,
  // }) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //
  //   if (token == null) {
  //     print("❌ No token found for calendar meetings");
  //     return;
  //   }
  //
  //   try {
  //     _isLoading = true;
  //     notifyListeners();
  //
  //     // 🔹 Map frontend statuses to valid backend enum values
  //     final validStatuses = {
  //       'Follow Up Required': 'Hold',
  //       'In Progress': 'Hold',
  //       'Completed': 'Completed',
  //       'Closed': 'Close',
  //       'Complete': 'Completed', // Add mapping for 'Complete'
  //       'Hold': 'Hold', // Add mapping for 'Hold'
  //       'Close': 'Close', // Add mapping for 'Close'
  //     };
  //
  //     // 🔹 Map action values
  //     final actionMap = {
  //       'Visit Done': 'Done', // or whatever backend expects
  //       'Call Done': 'Done',
  //       'Done': 'Done',
  //     };
  //
  //     // 🔹 Map contact method values
  //     final contactMethodMap = {
  //       'Phone': 'Call',
  //       'Call': 'Call',
  //       'Visit': 'Visit',
  //       'Email': 'Email',
  //     };
  //
  //     final timelineValue = validStatuses[status] ?? status;
  //     final actionValue = actionMap[remark] ?? remark;
  //     final contactMethodValue = contactMethodMap['Phone'] ?? 'Call';
  //
  //     final url = Uri.parse(
  //         'https://call-logs-backend.onrender.com/api/meetings/$id/followup');
  //
  //     final response = await http.patch(
  //       url,
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         "date": date,
  //         "time": time,
  //         "detail": remark,
  //         "timeline": timelineValue,
  //         "action": actionValue, // Add this if required
  //         "contactMethod": contactMethodValue, // Add this if required
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final resData = jsonDecode(response.body);
  //       debugPrint('✅ Follow-up updated: $resData');
  //       await fetchFollowUps();
  //     } else {
  //       debugPrint('❌ Failed to update: ${response.body}');
  //       _errorMessage = 'Failed to update follow-up';
  //     }
  //   } catch (e) {
  //     debugPrint('⚠️ Exception: $e');
  //     _errorMessage = e.toString();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> updateFollowUp({
    required String id,
    required String date,
    required String time,
    required String remark,
    required String status,
    String? companyName,
    String? phone,
     dynamic context,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ No token found for calendar meetings");
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      // 🔹 Map frontend statuses to valid backend enum values
      final validStatuses = {
        'Follow Up Required': 'Hold',
        'In Progress': 'Hold',
        'Completed': 'Completed',
        'Closed': 'Close',
        'Complete': 'Completed', // Add mapping for 'Complete'
        'Hold': 'Hold', // Add mapping for 'Hold'
        'Close': 'Close', // Add mapping for 'Close'
      };

      // 🔹 Map action values
      final actionMap = {
        'Visit Done': 'Done', // or whatever backend expects
        'Call Done': 'Done',
        'Done': 'Done',
      };

      // 🔹 Map contact method values
      final contactMethodMap = {
        'Phone': 'Call',
        'Call': 'Call',
        'Visit': 'Visit',
        'Email': 'Email',
      };

      final timelineValue = validStatuses[status] ?? status;
      final actionValue = actionMap[remark] ?? remark;
      final contactMethodValue = contactMethodMap['Phone'] ?? 'Call';

      final url = Uri.parse(
          'https://call-logs-backend.onrender.com/api/meetings/$id/followup');

      // 🔹 **PRINT THE DATA BEING SENT**
      final requestBody = {
        "date": date,
        "time": time,
        "detail": remark,
        "timeline": timelineValue,
        "action": actionValue,
        "contactMethod": contactMethodValue,
      };

      debugPrint('📡 [REQUEST] URL: $url');
      debugPrint('📡 [REQUEST] Headers: Authorization: Bearer $token');
      debugPrint('📡 [REQUEST] Body: ${jsonEncode(requestBody)}');
      debugPrint('📡 [REQUEST] Mapped Values:');
      debugPrint('📡   - Original status: $status');
      debugPrint('📡   - Mapped timeline: $timelineValue');
      debugPrint('📡   - Original remark: $remark');
      debugPrint('📡   - Mapped action: $actionValue');
      debugPrint('📡   - Mapped contactMethod: $contactMethodValue');

      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // 🔹 **PRINT THE RESPONSE**
      debugPrint('📡 [RESPONSE] Status Code: ${response.statusCode}');
      debugPrint('📡 [RESPONSE] Body: ${response.body}');

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        debugPrint('✅ Follow-up updated: $resData');
        await fetchFollowUps();
      } else {
        debugPrint('❌ Failed to update: ${response.body}');
        _errorMessage = 'Failed to update follow-up';

        // Show error in dialog or snackbar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Update failed: ${response.body}'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('⚠️ Exception: $e');
      debugPrint('⚠️ Stack trace: ${e.toString()}');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
