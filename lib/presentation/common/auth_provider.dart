// ignore: constant_identifier_names
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:structure_base/data/data_source/const/end_points.dart';
import 'package:structure_base/data/data_source/dio_connector.dart';
import 'package:structure_base/domain/model/auth_token.dart';

const String AUTH_CONTAIN_CURRENT_TOKEN_STORE =
    'THERAPS_adfklasmflkmalskmflkas';
// ignore: constant_identifier_names
const String AUTH_CONTAIN_REFRESH_TOKEN_STORE =
    'THERAPS_qomvlkmlptopsalmklvhlw';
// ignore: constant_identifier_names
const String AUTH_CONTAIN_TOKEN_EXPIRED_DATE_STORE =
    'THERAPS_opdskapklmvlknlthluslv';
// ignore: constant_identifier_names
const String AUTH_CONTAIN_STAFF_ID_STORE = 'THERAPS_szxzzxwldsmlksmdafklsd';

/// 현재 토큰 만료 기간
// ignore: constant_identifier_names
const Duration CURRENT_TOKEN_EXPIRE_DURATION = Duration(minutes: 15);

/// 리프레시 토큰 만료 기간
// ignore: constant_identifier_names
const Duration REFRESH_TOKEN_EXPIRE_DURATION = Duration(hours: 48);

class AuthRepository {
  AuthRepository._privateConstructor();
  static final AuthRepository _instance = AuthRepository._privateConstructor();

  factory AuthRepository() {
    return _instance;
  }

  /// Android 내부 보안 저장소
  final _secureStorage = const FlutterSecureStorage();

  /// 로그인
  Future<AuthToken?> signIn() async {
    // try {
    //   final body = await DioConnector.post(
    //       url: API_ENDPOINT.signIn, body: signIn.toJson());
    //   final auth = AuthToken(
    //       currentToken: body?['tokens']['access'],
    //       refreshToken: body?['tokens']['refresh'],
    //       staffId: signIn.userId);
    //
    //   /// 로그인으로 가져온 토큰 및 기타 정보 보안 저장소에 저장
    //   _secureStorage.write(
    //     key: AUTH_CONTAIN_CURRENT_TOKEN_STORE,
    //     value: auth.currentToken,
    //   );
    //   _secureStorage.write(
    //     key: AUTH_CONTAIN_REFRESH_TOKEN_STORE,
    //     value: auth.refreshToken,
    //   );
    //   _secureStorage.write(
    //     key: AUTH_CONTAIN_TOKEN_EXPIRED_DATE_STORE,
    //     value: auth.updatedAt.microsecondsSinceEpoch.toString(),
    //   );
    //   _secureStorage.write(
    //     key: AUTH_CONTAIN_STAFF_ID_STORE,
    //     value: auth.staffId,
    //   );
    //   return auth;
    // } on TRHttpException catch (e) {
    //   logger.e(e);
    // } on Exception catch (e) {
    //   logger.e(e);
    // }
    return null;
  }

  /// staffid 로그인
  Future<AuthToken?> signInWithStaffId() async {
    // try {
    //   final body = await DioConnector.post(
    //       url: API_ENDPOINT.signInWithStaffId, body: signIn.toJson());
    //   final auth = AuthToken(
    //       currentToken: body?['tokens']['access'],
    //       refreshToken: body?['tokens']['refresh'],
    //       staffId: signIn.staffId ?? '');
    //
    //   /// 로그인으로 가져온 토큰 및 기타 정보 보안 저장소에 저장
    //   _secureStorage.write(
    //     key: AUTH_CONTAIN_CURRENT_TOKEN_STORE,
    //     value: auth.currentToken,
    //   );
    //   _secureStorage.write(
    //     key: AUTH_CONTAIN_REFRESH_TOKEN_STORE,
    //     value: auth.refreshToken,
    //   );
    //   _secureStorage.write(
    //     key: AUTH_CONTAIN_TOKEN_EXPIRED_DATE_STORE,
    //     value: auth.updatedAt.microsecondsSinceEpoch.toString(),
    //   );
    //   _secureStorage.write(
    //     key: AUTH_CONTAIN_STAFF_ID_STORE,
    //     value: auth.staffId,
    //   );
    //   return auth;
    // } on TRHttpException catch (e) {
    //   logger.e(e);
    // } on Exception catch (e) {
    //   logger.e(e);
    // }
    return null;
  }

  /// 내부 보안 저장소에서 token 가져오기
  Future<AuthToken?> getToken() async {
    final updateAtRaw = await _secureStorage.read(
      key: AUTH_CONTAIN_TOKEN_EXPIRED_DATE_STORE,
    );
    if (updateAtRaw == null) return null;
    final updateAt =
    DateTime.fromMicrosecondsSinceEpoch(int.parse(updateAtRaw));

    /// 리프레시 토큰 만료 체크
    if (updateAt.add(REFRESH_TOKEN_EXPIRE_DURATION).isBefore(DateTime.now())) {
      return null;
    }

    /// 현재 토큰 만료 체크
    if (updateAt.add(CURRENT_TOKEN_EXPIRE_DURATION).isAfter(DateTime.now())) {
      /// 만료 안된경우 저장된 토큰 그대로 전달
      final current = await _secureStorage.read(
        key: AUTH_CONTAIN_CURRENT_TOKEN_STORE,
      );
      final refresh = await _secureStorage.read(
        key: AUTH_CONTAIN_REFRESH_TOKEN_STORE,
      );
      final staffId = await _secureStorage.read(
        key: AUTH_CONTAIN_STAFF_ID_STORE,
      );
      return (current != null && refresh != null && staffId != null)
          ? AuthToken(
        currentToken: current,
        refreshToken: refresh,
        staffId: staffId,
        updatedAt: updateAt,
      )
          : null;
    } else {
      /// 만료된경우 refreshToken
      final current = await _secureStorage.read(
        key: AUTH_CONTAIN_CURRENT_TOKEN_STORE,
      );
      final refresh = await _secureStorage.read(
        key: AUTH_CONTAIN_REFRESH_TOKEN_STORE,
      );
      final staffId = await _secureStorage.read(
        key: AUTH_CONTAIN_STAFF_ID_STORE,
      );
      if (refresh == null) return null;
      return await refreshToken(
        expiredAuth: AuthToken(
          currentToken: current!,
          refreshToken: refresh,
          staffId: staffId!,
          updatedAt: updateAt,
        ),
      );
    }
  }

  /// token refresh
  Future<AuthToken?> refreshToken({
    required AuthToken expiredAuth,
  }) async {
    // try {
    //   final body = await DioConnector.post(
    //       url: API_ENDPOINT.refreshToken,
    //       header: expiredAuth.header,
    //       body: ModelsRenew(refreshToken: expiredAuth.refreshToken).toJson());
    //   final auth = AuthToken(
    //     currentToken: body?['tokens']['access'],
    //     refreshToken: body?['tokens']['refresh'],
    //     staffId: expiredAuth.staffId,
    //   );
    //   return auth;
    // } on TRHttpException catch (e) {
    //   logger.e(e);
    // } on Exception catch (e) {
    //   logger.e(e);
    // }
    return null;
  }

  /// 보안 저장소에 저장된 정보 삭제
  Future<bool> removeTokenFromDB() async {
    // try {
    //   await _secureStorage.delete(key: AUTH_CONTAIN_CURRENT_TOKEN_STORE);
    //   await _secureStorage.delete(key: AUTH_CONTAIN_REFRESH_TOKEN_STORE);
    //   await _secureStorage.delete(key: AUTH_CONTAIN_TOKEN_EXPIRED_DATE_STORE);
    //   await _secureStorage.delete(key: AUTH_CONTAIN_STAFF_ID_STORE);
    //
    //   return true;
    // } on Exception catch (e) {
    //   logger.e(e);
    // }
    return false;
  }
}
