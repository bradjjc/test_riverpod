import 'package:structure_base/presentation/common/auth_provider.dart';

class AuthToken {
  final String currentToken;
  final String refreshToken;
  final String staffId;
  final DateTime updatedAt;

  AuthToken({
    required this.currentToken,
    required this.refreshToken,
    required this.staffId,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  /// 현재 토큰 만료 상태면 false
  bool get isCurrentTokenAvailable =>
      updatedAt.add(CURRENT_TOKEN_EXPIRE_DURATION).isAfter(DateTime.now());

  /// 리프레시 토큰 만료 상태면 false
  bool get isRefreshTokenAvailable =>
      updatedAt.add(REFRESH_TOKEN_EXPIRE_DURATION).isAfter(DateTime.now());

  /// token header 제작
  Map<String, String> get header => {
    'Authorization': 'bearer $currentToken',
    'Refresh': 'bearer $refreshToken',
  };
}