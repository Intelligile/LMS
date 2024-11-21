import 'dart:convert';

int? extractExpiration(String jwtToken) {
  try {
    final parts = jwtToken.split('.');
    if (parts.length != 3) {
      throw Exception("Invalid JWT token format");
    }
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = json.decode(payload) as Map<String, dynamic>;
    if (!payloadMap.containsKey('exp')) {
      throw Exception("Token does not contain 'exp'");
    }
    return payloadMap['exp'] as int?;
  } catch (e) {
    print("Error decoding JWT token: $e");
    return null;
  }
}
