import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_sdk_playground/constant/constant.dart';

// API call to create meeting
Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse(url),
    headers: {'Authorization': token},
  );

//Destructuring the roomId from the response
  return json.decode(httpResponse.body)['roomId'];
}
