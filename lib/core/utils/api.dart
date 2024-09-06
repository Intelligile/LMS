import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api {
  final Dio _dio;
  final String baseUrl = "http://localhost:8080/";

  Api(this._dio);

  Future<List<dynamic>> get(
      {required String endPoint, @required String? token}) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    var response = await _dio.get("$baseUrl$endPoint");
    return response.data as List<dynamic>;
  }

  Future<dynamic> put({
    required String endPoint,
    required dynamic body,
    required String?
        token, // Ensure token is not nullable or handle it properly
  }) async {
    // Set the Content-Type to application/json
    _dio.options.headers['Content-Type'] = 'application/json';
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    var response = await _dio.put("$baseUrl$endPoint", data: body);
    print("PUT response: ${response.data}");
    if (response.statusCode == 200) {
      if (response.data is String) {
        return response.data;
      }
    } else {
      throw Exception('Failed to update group');
    }

    return response.data as Map<String, dynamic>;
  }

  Future<dynamic> post(
      {required String endPoint,
      required dynamic body,
      @required String? token}) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    var response = await _dio.post("$baseUrl$endPoint", data: body);
    print("POST response: ${response.data}"); // Log the response

    if (response.data is String) {
      // Return the string message if that's what the response contains
      return response.data;
    }

    // Otherwise, return the JSON map
    return response.data as Map<String, dynamic>;
  }

  Future<dynamic> delete(
      {required String endPoint, @required String? token}) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    final response = await _dio.delete(
      "$baseUrl$endPoint",
    );
    return response.data;
  }
}
