import 'package:dio/dio.dart';
import 'package:drink/utility/constants.dart';
import 'package:drink/utility/network_utility.dart';

class ContentRepository {
  Future<dynamic> getPrivacyPolicy() async {
    final Response response = await Network.instance.getRequest(
        endPoint: API.CONTENT, queryParameters: {API.TYPE: API.PrivacyPolicy});
    return response.data['data']['body'];
  }

  Future<dynamic> getTermsAndConditions() async {
    final Response response = await Network.instance.getRequest(
        endPoint: API.CONTENT,
        queryParameters: {API.TYPE: API.TermsAndConditions});
    print(response.data['data']['body'].toString());
    return response.data['data']['body'];
  }
}
