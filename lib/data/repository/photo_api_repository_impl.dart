
import 'package:structure_base/data/data_source/api/photo_api.dart';
import 'package:structure_base/presentation/util/result.dart';
import 'package:structure_base/domain/model/photo/photo.dart';
import 'package:structure_base/domain/repository/photo_api_repository.dart';

class PhotoApiRepositoryImpl implements PhotoApiRepository {
  PhotoApi api;

  PhotoApiRepositoryImpl(this.api);

  @override
  Future<Result<List<Photo>>> get(String quary) async {
    String serchText = quary.replaceAll(' ', '+');
    final Result<Iterable> result = await api.get(serchText);
    return result.when(
      success: (iterable) {
        return Result.success(iterable.map((e) => Photo.fromJson(e)).toList());
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}