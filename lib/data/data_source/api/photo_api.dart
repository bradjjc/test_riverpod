import 'dart:convert';

import 'package:structure_base/data/data_source/const/end_points.dart';
import 'package:structure_base/data/data_source/dio_connector.dart';
import 'package:structure_base/presentation/util/result.dart';

class PhotoApi {
  Future<Result<Iterable>> get(String quary) async {
    print('엥???');
    try {
      final response = await DioConnector.get(
        url: API_ENDPOINT.photo,
        params: {"key" : key, 'q' : quary, 'image_type' : 'photo', 'per_page' : '30'},
      );

      if ((response.statusCode ?? 999) > 299) {
        throw Result.error('''
        status: ${response.statusCode}
        url: ${API_ENDPOINT.photo}
        method: 'GET'
        requestParam: 'q: $quary'
        message: ${response.data?['msg']}''');
      } else {
        Map<String, dynamic> jsonResponse = response.data;
        // Iterable 반복자 타입
        Iterable hits = jsonResponse['hits'];
        return Result.success(hits);
      }
    } catch (e) {
      return Result.error("Network error $e");
    }
  }
}