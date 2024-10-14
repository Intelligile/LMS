import 'package:dio/dio.dart';

abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);

  factory ServerFailure.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure("Connection timeout with API server");
      case DioExceptionType.sendTimeout:
        return ServerFailure("Send timeout with API server");
      case DioExceptionType.receiveTimeout:
        return ServerFailure("Receive timeout with API server");
      case DioExceptionType.badCertificate:
        return ServerFailure("Bad certificate with API server");
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(e.response!);
      case DioExceptionType.cancel:
        return ServerFailure("Request to API server was canceled");
      case DioExceptionType.connectionError:
        return ServerFailure("No internet connection");
      case DioExceptionType.unknown:
        return ServerFailure("Unknown error, please try again");
      default:
        return ServerFailure("Unexpected error, please try again");
    }
  }

  factory ServerFailure.fromResponse(Response response) {
    int statusCode = response.statusCode ?? 0;
    String errorMessage = ''; // Default message
    print(errorMessage);
    if (response.data is Map<String, dynamic>) {
      errorMessage = response.data['message'] ?? errorMessage;
    } else if (response.data is String) {
      errorMessage = response.data;
    }

    return ServerFailure(errorMessage);
    //   if (statusCode == 404) {
    //     return ServerFailure("Your request was not found, please try again later");
    //   } else if (statusCode >= 500) {
    //     return ServerFailure("There's a problem with the server, please try again later");
    //   } else if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
    //     return ServerFailure(errorMessage);
    //   } else if (statusCode == 409) { // Conflict error, typically for duplicate entries
    //     return ServerFailure("User already exists, please try with a different username or email");
    //   } else {
    //     return ServerFailure("There was an error, please try again");
    //   }
  }
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}
