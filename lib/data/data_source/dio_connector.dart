import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:structure_base/data/data_source/const/end_points.dart';
import 'package:structure_base/presentation/util/result.dart';
import 'package:structure_base/domain/model/auth_token.dart';
import 'package:structure_base/presentation/common/auth_provider.dart';

class DioConnector {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static final _dio = Dio();
  static const _encoder = Utf8Encoder();
  static const _decoder = Utf8Decoder();
  static final Map<String, dynamic> _baseheader = {};

  static Future init() async {
    String device = 'error';
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) {
      device = (await _deviceInfoPlugin.androidInfo).device;
    } else if (Platform.isIOS) {
      device = (await _deviceInfoPlugin.iosInfo).localizedModel;
    }
    _baseheader['platform'] = device;

    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    _baseheader['appname'] = packageName;
    _baseheader['version'] = version;
  }

  static Options _optionMaker(Map<String, dynamic> header, AuthToken? auth) =>
      Options(
          headers: {..._baseheader, ...header, ...(auth?.header ?? {})},
          validateStatus: (status) => true,
          requestEncoder: (request, options) => _encoder.convert(request),
          responseDecoder: (responseBytes, options, responseBody) =>
              _decoder.convert(responseBytes),

          /// 보내는 타임아웃
          sendTimeout: const Duration(seconds: 10),
          //받는 타임아웃
          receiveTimeout: const Duration(seconds: 10));

  static Future<Result> post(
      {required API_ENDPOINT url,
        Map<String, String> urlArg = const {},
        AuthToken? auth,
        Map<String, String> header = const {},
        Map<String, dynamic> body = const {}}) async {
    try{
      var response = await _dio.post<Map<String, dynamic>>(url.value(urlArg),
          data: body, options: _optionMaker(header, auth));

      if (auth != null) {
        if (response.statusCode == 401 || response.statusCode == 403) {
          final refreshedToken = await AuthRepository().refreshToken(expiredAuth: auth);
          if (refreshedToken == null) {
            AuthRepository().removeTokenFromDB();
          } else {
            response = await _dio.post<Map<String, dynamic>>(url.value(urlArg),
                data: body, options: _optionMaker(header, refreshedToken));
          }
        }
      }
      if ((response.statusCode ?? 999) > 299) {
        return Result.error('''
        status: ${response.statusCode}
        url: ${url.value(urlArg)}
        method: 'POST_form_data'
        requestParam: ${body.toString()}
        message: ${response.data?['msg']}''');
      } else {
        return Result.success(response.data);
      }
    } on DioException catch (dioError){
      return Result.error('''
        status: ${dioError.response?.statusCode ?? 'dio error'}
        url: ${url.value(urlArg)}
        method: 'POST_form_data'
        requestParam: ${body.toString()}
        message: 네드워크 에러 ${dioError.message ?? ''}''');
    } catch(e){
      return Result.error('''
        status: $e
        url: ${url.value(urlArg)}
        method: 'POST_form_data'
        requestParam: ${body.toString()}
        message: error''');
    }
  }

  static Future<Result> postWithFormData(
      {required API_ENDPOINT url,
        Map<String, String> urlArg = const {},
        AuthToken? auth,
        Map<String, String> header = const {},
        Map<String, dynamic> body = const {}}) async {
    try{
      final form = FormData.fromMap(
        body,
      );
      var response = await _dio.post<Map<String, dynamic>>(url.value(urlArg),
          data: form, options: _optionMaker(header, auth));

      if (auth != null) {
        if (response.statusCode == 401 || response.statusCode == 403) {
          final refreshedToken =
          await AuthRepository().refreshToken(expiredAuth: auth);
          if (refreshedToken == null) {
            AuthRepository().removeTokenFromDB();
          } else {
            response = await _dio.post<Map<String, dynamic>>(url.value(urlArg),
                data: form, options: _optionMaker(header, refreshedToken));
          }
        }
      }

      if ((response.statusCode ?? 999) > 299) {
        return Result.error('''
        status: ${response.statusCode}
        url: ${url.value(urlArg)}
        method: 'POST_form_data'
        requestParam: ${body.toString()}
        message: ${response.data?['msg']}''');
      } else {
        return Result.success(response.data);
      }
    } on DioException catch (dioError){
      return Result.error('''
              status: ${dioError.response?.statusCode ?? 'dio error'}
              url: ${url.value(urlArg)}
              method: 'POST_form_data'
              requestParam: ${body.toString()}
              message: 네드워크 에러 ${dioError.message ?? ''}''');
    } catch(e){
      return Result.error('''
              status: ${e}
              url: ${url.value(urlArg)}
              method: 'POST_form_data'
              requestParam: ${body.toString()}
              message: error''');
    }
  }

  static Future<Result> postFileUpload(
      {required API_ENDPOINT url,
        Map<String, String> urlArg = const {},
        AuthToken? auth,
        Map<String, String> header = const {},
        Map<String, dynamic> body = const {},

        /// 업로드 상황. 올라간 데이터/전체 데이터 (content-length기준)
        void Function(int, int)? onProgress}) async {
    try{
      final form = FormData.fromMap(
        body,
      );

      var response = await _dio.post<Map<String, dynamic>>(url.value(urlArg),
          data: form,
          options: _optionMaker(header, auth),
          onSendProgress: onProgress);

      if (auth != null) {
        if (response.statusCode == 401 || response.statusCode == 403) {
          final refreshedToken =
          await AuthRepository().refreshToken(expiredAuth: auth);
          if (refreshedToken == null) {
            AuthRepository().removeTokenFromDB();
          } else {
            response = await _dio.post<Map<String, dynamic>>(url.value(urlArg),
                data: form, options: _optionMaker(header, refreshedToken));
          }
        }
      }

      if ((response.statusCode ?? 999) > 299) {
        throw Result.error('''
        status: ${response.statusCode}
        url: ${url.value(urlArg)}
        method: 'POST_form_data'
        requestParam: ${body.toString()}
        message: ${response.data?['msg']}''');
      } else {
        return Result.success(response.data);
      }
    } on DioException catch (dioError){
    return Result.error('''
          status: ${dioError.response?.statusCode ?? 'dio error'}
          url: ${url.value(urlArg)}
          method: 'POST_form_data'
          requestParam: ${body.toString()}
          message: 네드워크 에러 ${dioError.message ?? ''}''');
    } catch(e){
    return Result.error('''
          status: ${e}
          url: ${url.value(urlArg)}
          method: 'POST_form_data'
          requestParam: ${body.toString()}
          message: error''');
    }
  }

  static Future<Response> get({
    required API_ENDPOINT url,
    Map<String, String> urlArg = const {},
    AuthToken? auth,
    Map<String, String> header = const {},
    Map<String, String> params = const {},
  }) async {
      var response = await _dio.get<Map<String, dynamic>>(url.value(urlArg),
          queryParameters: params);
        return response;
  }

  static Future<Result> patch({
    required API_ENDPOINT url,
    Map<String, String> urlArg = const {},
    AuthToken? auth,
    Map<String, String> header = const {},
    Map<String, dynamic> body = const {},
    Map<String, String> params = const {},
  }) async {
    try{
      var response = await _dio.patch<Map<String, dynamic>>(url.value(urlArg),
          data: body,
          queryParameters: params,
          options: _optionMaker(header, auth));

      if (auth != null) {
        if (response.statusCode == 401 || response.statusCode == 403) {
          final refreshedToken =
          await AuthRepository().refreshToken(expiredAuth: auth);
          if (refreshedToken == null) {
            AuthRepository().removeTokenFromDB();
          } else {
            response = await _dio.patch<Map<String, dynamic>>(url.value(urlArg),
                data: body,
                queryParameters: params,
                options: _optionMaker(header, auth));
          }
        }
      }
      if ((response.statusCode ?? 999) > 299) {
        throw Result.error('''
        status: ${response.statusCode}
        url: ${url.value(urlArg)}
        method: 'PATCH'
        requestParam: ${params.toString()}
        message: ${response.data?['msg']}''');
      } else {
        return Result.success(response.data);
      }
    } on DioException catch (dioError){
    return Result.error('''
          status: ${dioError.response?.statusCode ?? 'dio error'}
          url: ${url.value(urlArg)}
          method: 'PATCH'
          requestParam: ${params.toString()}
          message: 네드워크 에러 ${dioError.message ?? ''}''');
    } catch(e){
    return Result.error('''
          status: ${e}
          url: ${url.value(urlArg)}
          method: 'PATCH'
          requestParam: ${params.toString()}
          message: error''');
    }
  }

  static Future<Result> put({
    required API_ENDPOINT url,
    Map<String, String> urlArg = const {},
    AuthToken? auth,
    Map<String, String> header = const {},
    Map<String, dynamic> body = const {},
  }) async {
    try{
      var response = await _dio.put<Map<String, dynamic>>(url.value(urlArg),
          data: body, options: _optionMaker(header, auth));

      if (auth != null) {
        if (response.statusCode == 401 || response.statusCode == 403) {
          final refreshedToken =
          await AuthRepository().refreshToken(expiredAuth: auth);
          if (refreshedToken == null) {
            AuthRepository().removeTokenFromDB();
          } else {
            response = await _dio.put<Map<String, dynamic>>(url.value(urlArg),
                data: body, options: _optionMaker(header, refreshedToken));
          }
        }
      }
      if ((response.statusCode ?? 999) > 299) {
        throw Result.error('''
        status: ${response.statusCode}
        url: ${url.value(urlArg)}
        method: 'PUT'
        requestParam: ${body.toString()}
        message: ${response.data?['msg']}''');
      } else {
        return Result.success(response.data);
      }
    } on DioException catch (dioError){
    return Result.error('''
          status: ${dioError.response?.statusCode ?? 'dio error'}
          url: ${url.value(urlArg)}
          method: 'PUT'
          requestParam: ${body.toString()}
          message: 네드워크 에러 ${dioError.message ?? ''}''');
    } catch(e){
    return Result.error('''
          status: ${e}
          url: ${url.value(urlArg)}
          method: 'PUT'
          requestParam: ${body.toString()}
          message: error''');
    }
  }

  static Future<Result> delete({
    required API_ENDPOINT url,
    Map<String, String> urlArg = const {},
    AuthToken? auth,
    Map<String, String> header = const {},
    Map<String, dynamic> body = const {},
  }) async {
    try{
      var response = await _dio.delete(url.value(urlArg),
          data: body, options: _optionMaker(header, auth));

      if (auth != null) {
        if (response.statusCode == 401 || response.statusCode == 403) {
          final refreshedToken =
          await AuthRepository().refreshToken(expiredAuth: auth);
          if (refreshedToken == null) {
            AuthRepository().removeTokenFromDB();
          } else {
            response = await _dio.delete(url.value(urlArg),
                data: body, options: _optionMaker(header, auth));
          }
        }
      }
      if ((response.statusCode ?? 999) > 299) {
        throw Result.error('''
        status: ${response.statusCode}
        url: ${url.value(urlArg)}
        method: 'DELETE'
        requestParam: ${body.toString()}
        message: ${response.data?['msg']}''');
      } else {
        return Result.success(response.data);
      }
    } on DioException catch (dioError){
    return Result.error('''
          status: ${dioError.response?.statusCode ?? 'dio error'}
          url: ${url.value(urlArg)}
          method: 'DELETE'
          requestParam: ${body.toString()}
          message: 네드워크 에러 ${dioError.message ?? ''}''');
    } catch(e){
    return Result.error('''
          status: ${e}
          url: ${url.value(urlArg)}
          method: 'DELETE'
          requestParam: ${body.toString()}
          message: error''');
    }
  }

  /// 파일 업로드용 multipart
  static Future<Result> fileUpload({
    required API_ENDPOINT url,
    Map<String, String> urlArg = const {},
    AuthToken? auth,
    Map<String, String> header = const {},
    required String filePath,
    required void Function(int percentage) onProgress,
  }) async {
    try{
      String fileName = filePath.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
      });
      var response = await _dio.post(
        url.value(urlArg),
        data: formData,
        options: _optionMaker(header, auth),
        onSendProgress: (count, total) =>
            onProgress(((count / total) * 100).toInt()),
      );
      if (auth != null) {
        if (response.statusCode == 401 || response.statusCode == 403) {
          final refreshedToken =
          await AuthRepository().refreshToken(expiredAuth: auth);
          if (refreshedToken == null) {
            AuthRepository().removeTokenFromDB();
          } else {
            response = await _dio.post<Map<String, dynamic>>(
              url.value(urlArg),
              data: formData,
              options: _optionMaker(header, refreshedToken),
              onSendProgress: (count, total) =>
                  onProgress(((count / total) * 100).toInt()),
            );
          }
        }
      }

      if ((response.statusCode ?? 999) > 299) {
        throw Result.error('''
        status: ${response.statusCode}
        url: ${url.value(urlArg)}
        method: 'POST file upload'
        requestParam: ${filePath.toString()}
        message: ${response.data?['msg']}''');
      } else {
        return Result.success(response.data);
      }
    } on DioException catch (dioError){
    return Result.error('''
          status: ${dioError.response?.statusCode ?? 'dio error'}
          url: ${url.value(urlArg)}
          method: 'POST file upload'
          requestParam: ${filePath.toString()}
          message: 네드워크 에러 ${dioError.message ?? ''}''');
    } catch(e){
    return Result.error('''
          status: ${e}
          url: ${url.value(urlArg)}
          method: 'POST file upload'
          requestParam: ${filePath.toString()}
          message: error''');
    }
  }

  static Future<Result> getImage({
    required API_ENDPOINT url,
    required AuthToken auth,
    Map<String, String> urlArg = const {},
    Map<String, String> header = const {},
    Map<String, String> params = const {},
  }) async {
    try{
      final response = await _dio.get<Uint8List>(
        url.value(urlArg),
        queryParameters: params,
        options: Options(
          headers: header,
          validateStatus: (status) => true,
          requestEncoder: (request, options) => _encoder.convert(request),
          responseType: ResponseType.bytes,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        return Result.success('${response.realUri.origin}${response.realUri.path}?${response.realUri.query}');
      } else if ((response.statusCode == 401 || response.statusCode == 403)) {
        final refreshedToken =
          await AuthRepository().refreshToken(expiredAuth: auth);
        if (refreshedToken == null) {
          AuthRepository().removeTokenFromDB();
          return Result.error('no refreshedToken');  // You can handle this case according to your needs.
        } else {
          final response = await _dio.get<Uint8List>(url.value(urlArg),
              queryParameters: params,
              options: _optionMaker(header, refreshedToken));
          return Result.success('${response.realUri.origin}${response.realUri.path}?${response.realUri.query}');
        }
      } else if (response.statusCode != 200) {
        throw Result.error('''
        status: ${response.statusCode}
        url: ${url.value(urlArg)}
        method: 'GET'
        requestParam: ${params.toString()}
        message: ''');
      } else {
        return Result.error('''
          status: ${response.statusCode ?? 'statusCode'}
          url: ${url.value(urlArg)}
          method: 'GET'
          requestParam: ${params.toString()}
          message: statusCode: ${response.statusCode}''');
      }
    } on DioException catch (dioError){
    return Result.error('''
          status: ${dioError.response?.statusCode ?? 'dio error'}
          url: ${url.value(urlArg)}
          method: 'GET'
          requestParam: ${params.toString()}
          message: 네드워크 에러 ${dioError.message ?? ''}''');
    } catch(e){
    return Result.error('''
          status: ${e}
          url: ${url.value(urlArg)}
          method: 'GET'
          requestParam: ${params.toString()}
          message: error''');
    }
  }
}