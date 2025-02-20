class ApiResponse {
  int get totalDataCount => body["meta"]["total"];
  int get totalPageCount => body["pagination"]["total_pages"];
  List get data => body["data"];
  // Just a way of saying there was no error with the request and response return
  bool get allGood => errors!.isEmpty;
  int? code;
  String? message;
  dynamic body;
  List? errors;
  String? errorMessage;

  ApiResponse({
    this.code,
    this.message,
    this.body,
    this.errors,
    this.errorMessage,
  });
}