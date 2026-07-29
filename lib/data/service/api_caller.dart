import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:http/http.dart';
import 'package:logger/web.dart';
import 'package:task_manager_app/controller/auth_controller.dart';
import 'package:task_manager_app/data/model/api_response.dart';

class ApiCaller {

  static final Logger _logger=Logger();
  static Future<ApiResponse> getRequest({required String URL})async{
    _logger.i(URL);

    Response response=await get(Uri.parse(URL),
    
     headers:{'token':AuthController.accessToken?? ''});
     _logger.i(response.statusCode);
     _logger.i(response.body);
   

   if(response.statusCode==200){
    return ApiResponse(responseCode: response.statusCode, responseDate: jsonDecode(response.body), isSuccess: true);
   }
   else{
    return ApiResponse(responseCode: response.statusCode, responseDate: jsonDecode(response.body),errorMessage: jsonDecode(response.body), isSuccess: false);
   }
  }

  static Future<ApiResponse> postRequest({required String URL ,Map<String,dynamic>? body})async{
   _logger.i(URL);

   Response response=await post(Uri.parse(URL),
   
   headers: {
    "Content-type":"application/json",
    "Accept":"application/json",
    'token':AuthController.accessToken??''
   },
   body: body!=null?jsonEncode(body):null
   );

_logger.i(response.statusCode);
_logger.i(response.body);

   if(response.statusCode==200 || response.statusCode==201){
    return ApiResponse(responseCode: response.statusCode, responseDate: jsonDecode(response.body), isSuccess: true);
   }else{
   return ApiResponse(responseCode: response.statusCode, responseDate: jsonDecode(response.body),errorMessage: jsonDecode(response.body), isSuccess: false);
   }
  }
}