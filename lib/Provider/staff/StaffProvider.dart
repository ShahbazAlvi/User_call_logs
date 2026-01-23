import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'package:image_picker/image_picker.dart';
import 'package:infinity/model/staffModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaffProvider with ChangeNotifier{
  bool isLoading =false;
  List<Data> staffs = [];
  String message = '';
  File? selectedImage;

  final picker = ImagePicker();

  // ✅ Pick image from gallery
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = File(picked.path);
      notifyListeners();
    }
  }

  Future<void>fetchStaff()async{
    const url='https://call-logs-backend.onrender.com/api/staff';
    isLoading=true;
    notifyListeners();
    try{
      final response= await http.get(Uri.parse(url));
      if(response.statusCode==200){
        final JsonResponse=jsonDecode(response.body);
        final staffModel=StaffModel.fromJson(JsonResponse);
        staffs=staffModel.data??[];
        if (kDebugMode) {
          print("✅ Loaded ${staffs.length} products");
        }
      } else {
        if (kDebugMode) {
          print("❌ Failed to load products: ${response.statusCode}");
        }
      }

    }catch(e){
      if (kDebugMode) {
        print("⚠️ Error fetching products: $e");
      }
    }
    isLoading = false;
    notifyListeners();

  }
  
  
  // delete the staff form list 
Future<void>DeleteStaff(String staffId)async{
    final prefs=await SharedPreferences.getInstance();
    final token=prefs.getString('token');
    if(token==null){
      print("❌ No token found for delete staff");
      return;
    }
    isLoading=true;
    notifyListeners();
    try{

    final response=await http.delete(Uri.parse('https://call-logs-backend.onrender.com/api/staff/$staffId'),
      headers: {
        'Authorization': "Bearer $token",
        'Accept': "application/json",
      },);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      fetchStaff();
      print('✅ staff deleted successfully: $data');
    } else {
      print('❌ Failed to delete staff. Status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
} catch (e) {
  print('⚠️ Error deleting staff: $e');
  }
  isLoading = false;
  notifyListeners();
}




  // Future<void> uploadStaff({
  //   required String username,
  //   required String email,
  //   required String department,
  //   required String designation,
  //   required String address,
  //   required String number,
  //   required String password,
  //   required String role,
  // }) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('token') ?? '';
  //     isLoading = true;
  //     message = '';
  //     notifyListeners();
  //
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse('https://call-logs-backend.onrender.com/api/staff'), // your local API
  //     );
  //
  //     // Authorization token
  //     request.headers['Authorization'] = 'Bearer $token';
  //
  //     // Form fields
  //     request.fields.addAll({
  //       'username': username,
  //       'email': email,
  //       'department': department,
  //       'designation': designation,
  //       'address': address,
  //       'number': number,
  //       'password': password,
  //       'role': role,
  //     });
  //
  //     // Attach image if selected
  //     if (selectedImage != null) {
  //       request.files.add(await http.MultipartFile.fromPath('image', selectedImage!.path));
  //     }
  //
  //     var response = await request.send();
  //     var responseBody = await response.stream.bytesToString();
  //     var jsonData = json.decode(responseBody);
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       message = jsonData['message'] ?? 'Staff added successfully';
  //       fetchStaff();
  //
  //     } else {
  //       message = jsonData['message'] ?? 'Failed to add staff';
  //     }
  //   } catch (e) {
  //     message = 'Error: $e';
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }











  Future<void> updateStaff({
    required String id,
    required String username,
    required String email,
    required String number,
    required String department,
    required String address,
    File? image,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); // 🔑 get saved token

      if (token == null || token.isEmpty) {
        debugPrint("❌ No token found in SharedPreferences");
        return;
      }

      final uri = Uri.parse("https://call-logs-backend.onrender.com/api/staff/$id");
      var request = http.MultipartRequest('PUT', uri);

      // ✅ Add token in headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add text fields
      request.fields['username'] = username;
      request.fields['email'] = email;
      request.fields['number'] = number;
      request.fields['department'] = department;
      request.fields['address'] = address;

      // Add image if selected
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        debugPrint("✅ Staff updated successfully");
        await fetchStaff(); // refresh list (assuming you have this method)
      } else {
        final resBody = await response.stream.bytesToString();
        debugPrint("❌ Failed to update staff: ${response.statusCode}");
        debugPrint("Response: $resBody");
      }
    } catch (e) {
      debugPrint("⚠️ Error updating staff: $e");
    }
  }




  Future<bool> uploadStaff({
    required String username,
    required String email,
    required String department,
    required String designation,
    required String address,
    required String number,
    required String password,
    required String role,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        message = 'No authentication token found';
        return false;
      }

      isLoading = true;
      message = '';
      notifyListeners();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://call-logs-backend.onrender.com/api/staff'),
      );

      // Authorization token
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Form fields
      request.fields.addAll({
        'username': username,
        'email': email,
        'department': department,
        'designation': designation,
        'address': address,
        'number': number,
        'password': password,
        'role': role,
      });

      // Attach image if selected
      if (selectedImage != null) {
        try {
          request.files.add(
              await http.MultipartFile.fromPath(
                'image',
                selectedImage!.path,
                filename: selectedImage!.path.split('/').last,
              )
          );
        } catch (e) {
          debugPrint('Error attaching image: $e');
        }
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonData = json.decode(responseBody);

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        message = jsonData['message'] ?? 'Staff added successfully';

        // Add the new staff to the beginning of the list
        if (jsonData['data'] != null) {
          try {
            final newStaff = Data.fromJson(jsonData['data']);
            staffs.insert(0, newStaff); // Add at the beginning
          } catch (e) {
            debugPrint('Error parsing new staff data: $e');
            // If parsing fails, refresh the entire list
            await fetchStaff();
          }
        } else {
          // Refresh the entire list
          await fetchStaff();
        }

        // Clear the selected image
        selectedImage = null;

        notifyListeners();
        return true;
      } else {
        message = jsonData['message'] ??
            jsonData['error'] ??
            'Failed to add staff (Status: ${response.statusCode})';
        return false;
      }
    } catch (e) {
      debugPrint('Error uploading staff: $e');
      message = 'Error: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }



  void clearImage() {
    selectedImage = null;
    notifyListeners();
  }

// Also add a method to clear form
  void clearForm() {
    selectedImage = null;
    notifyListeners();
  }






}