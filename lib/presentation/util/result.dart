import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
abstract class Result<T> with _$Result<T> {
  // 성공시
  factory Result.success(T data) = Success;
  // 실패시
  factory Result.error(String e) = Error;
}