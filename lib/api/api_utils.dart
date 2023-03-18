class APIResponse<T> {
  final bool? isOk;
  final String? message;
  final T? result;
  final int? status;

  APIResponse({this.isOk, this.message, this.result, this.status});

  @override
  String toString() =>
      'APIResponse{isOk: $isOk, status: $status, message: $message, result: $result}';
}

Map<String, String> createAuthorizedJsonHeaders(final String token) =>
    <String, String>{
      'Accept': 'application/json',
      'content-type': 'application/json',
      // 'Authorization': 'Bearer $token',
      'Cookie': 'Authentication=$token',
    };

Map<String, String> createJsonHeaders() => <String, String>{
      'Accept': 'application/json',
      'content-type': 'application/json'
    };
