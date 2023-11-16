

import 'package:structure_base/presentation/util/result.dart';
import 'package:structure_base/domain/model/photo/photo.dart';

abstract class PhotoApiRepository {
  const PhotoApiRepository();

  Future<Result<List<Photo>>> get(String query);
}