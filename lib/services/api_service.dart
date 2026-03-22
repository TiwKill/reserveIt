import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseUrl = 'https://multipoth.ddns.net/api/reserve_it';
  static const String minioBaseUrl = 'https://multipoth.ddns.net/minio';

  static String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?auto=format&fit=crop&q=80&w=400';
    if (path.startsWith('http')) return path;
    
    // URL-encode path segments to handle spaces and special characters
    final encodedPath = path.split('/').map((s) => Uri.encodeComponent(s)).join('/');
    
    // Check if the path already starts with 'cars/' to avoid duplicates
    if (path.startsWith('cars/')) {
       return '$minioBaseUrl/$encodedPath';
    }
    return '$minioBaseUrl/cars/$encodedPath';
  }

  // === 1. Cars CRUD ===

  static Future<List<Map<String, dynamic>>> getCars() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cars'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching cars: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getCar(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cars/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching car $id: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> createCar({
    required String brand,
    required String model,
    required int year,
    required String plateNumber,
    String? imageUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cars'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'brand': brand,
          'model': model,
          'year': year,
          'plate_number': plateNumber,
          'image_url': imageUrl,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('Error creating car: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> updateCar(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/cars/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('Error updating car $id: $e');
      return null;
    }
  }

  static Future<bool> deleteCar(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/cars/$id'));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error deleting car $id: $e');
      return false;
    }
  }

  // === 2. AI Prediction ===

  static Future<Map<String, dynamic>?> predict(File imageFile, {String? carId}) async {
    try {
      final uri = Uri.parse('$baseUrl/predict');
      final request = http.MultipartRequest('POST', uri);
      
      request.files.add(await http.MultipartFile.fromPath(
        'file', 
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      if (carId != null) {
        request.fields['car_id'] = carId;
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error predicting: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> ocr(File imageFile, {String? carId}) async {
    try {
      final uri = Uri.parse('$baseUrl/ocr');
      final request = http.MultipartRequest('POST', uri);
      
      request.files.add(await http.MultipartFile.fromPath(
        'file', 
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      if (carId != null) {
        request.fields['car_id'] = carId;
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error predicting OCR: $e');
      return null;
    }
  }

  // === 3. Timeline ===

  static Future<List<Map<String, dynamic>>> getTimeline({String? carId}) async {
    try {
      var url = '$baseUrl/timeline';
      if (carId != null) url += '?car_id=$carId';
      
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching timeline: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getTimelineDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/timeline/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching timeline detail $id: $e');
      return null;
    }
  }

  // === 4. Upload ===

  static Future<String?> uploadFile(File file) async {
    try {
      final uri = Uri.parse('$baseUrl/upload');
      final request = http.MultipartRequest('POST', uri);
      
      request.files.add(await http.MultipartFile.fromPath(
        'file', 
        file.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['url']; // This is the relative path/filename
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error uploading file: $e');
      return null;
    }
  }
}
