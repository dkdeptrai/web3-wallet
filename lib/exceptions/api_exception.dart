// ignore_for_file: public_member_api_docs, sort_constructors_first
class ApiException implements Exception {
  String message;
  ApiException({
    required this.message,
  });
}
