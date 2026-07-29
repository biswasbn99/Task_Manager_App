class ApiResponse {
  final int responseCode;
  final dynamic responseDate;
  final bool isSuccess;
  final String? errorMessage;

  ApiResponse({
    required this.responseCode,
    required this.responseDate,
    required this.isSuccess,
     this.errorMessage
    
  });
}