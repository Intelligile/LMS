import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api {
  final Dio _dio;
  final String baseUrl = "http://localhost:8082/";
  final String baseUrlForLicenses = "http://localhost:8081/";

  Api(this._dio);

  Future<dynamic> get(
      {required String endPoint, @required String? token}) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    var response = await _dio.get("$baseUrl$endPoint");
    return response.data as List<dynamic>;
  }

  Future<dynamic> delete2({
    required String endPoint,
    required dynamic body,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        "$baseUrl$endPoint",
        data: body,
        options: options,
      );
      return response.data;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        print('Resource not found (404).'); // Specific handling for 404 errors
      } else {
        print('Failed to delete: $e'); // General error handling
      }
      throw Exception('Failed to delete: $e');
    }
  }

  Future<Map<String, dynamic>> getUser({
    required String endPoint,
    String? token,
  }) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    var response = await _dio.get("$baseUrl$endPoint");
    return response.data as Map<String, dynamic>; // Ensure this is a Map
  }

  Future<List<dynamic>> getUserLicenses({
    required String endPoint,
    String? token,
  }) async {
    // Add more detailed logging
    print("Preparing to make a request to: $baseUrlForLicenses$endPoint");

    // Log headers, token, and other important information
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      print("Added Authorization Bearer Token: $token");
    } else {
      print("No token provided.");
    }

    // Log final URL before sending the request
    print("Full API URL: $baseUrlForLicenses$endPoint");

    try {
      // Send the request
      var response = await _dio.get("$baseUrlForLicenses$endPoint");

      // Log the response status and data
      print("Response Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print(
            "Failed with status code: ${response.statusCode}, message: ${response.statusMessage}");
        throw Exception(
            'Failed to fetch licenses: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (dioError) {
      // Handle Dio-specific errors with detailed logs

      print("DioException occurred. Details:");
      print("Error Type: ${dioError.type}");
      print("Error Message: ${dioError.message}");
      print("Request URL: ${dioError.requestOptions.uri}");

      if (dioError.response != null) {
        print("Response data: ${dioError.response?.data}");
        print("Response headers: ${dioError.response?.headers}");
        print("Response status code: ${dioError.response?.statusCode}");
      } else {
        print("No response data. Error sending request: ${dioError.message}");
      }

      rethrow;
    } catch (e) {
      // Handle any other types of exceptions
      print("An unexpected error occurred: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put({
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

  Future<dynamic> post({
    required String endPoint,
    required dynamic body,
    String? token,
  }) async {
    try {
      // Set the authorization header if a token is provided
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      // Make the POST request
      final response = await _dio.post(
        "$baseUrl$endPoint",
        data: body,
        options: Options(
          headers: {
            'Content-Type':
                'application/json', // Ensure the content type is set
          },
        ),
      );

      // Log the response for debugging
      print("POST response: ${response.data}");

      // Check if response data is a string and return it directly
      if (response.data is String) {
        return response.data;
      }

      // Check response status code and handle accordingly
      if (response.statusCode == 200) {
        print('Users assigned successfully');
        return response.data; // Return the data if successful
      } else {
        print('Failed to assign users: ${response.statusCode}');
        return response.data; // Return the error data or message
      }
    } catch (e) {
      print('Error making POST request: $e');
      // Handle and rethrow or return error as needed
      throw Exception('Error making POST request: $e');
    }
  }

  Future<dynamic> post2({
    required String endPoint,
    required List<dynamic> body,
    @required String? token,
  }) async {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }

    var response = await _dio.post("$baseUrl$endPoint", data: body);
    print("POST response: ${response.data}"); // Log the response

    // Check the type of the response and return accordingly
    if (response.data is String) {
      return response.data;
    } else if (response.data is List) {
      return response.data; // Return the list if the response is a list
    } else if (response.data is Map<String, dynamic>) {
      return response.data; // Return the map if the response is a map
    } else {
      throw Exception("Unexpected response type: ${response.data.runtimeType}");
    }
  }

  Future<dynamic> delete({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        "$baseUrl$endPoint",
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        print('Resource not found (404).'); // Specific handling for 404 errors
      } else {
        print('Failed to delete: $e'); // General error handling
      }
      throw Exception('Failed to delete: $e');
    }
  }
}
