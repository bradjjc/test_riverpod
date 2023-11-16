import 'package:flutter_test/flutter_test.dart';
import 'package:structure_base/data/data_source/api/photo_api.dart';
import 'package:structure_base/data/repository/photo_api_repository_impl.dart';
import 'package:structure_base/presentation/util/result.dart';
import 'package:structure_base/domain/model/photo/photo.dart';


// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
void main() {
  test("Photo test", () async {
    print('Photo start');
    final result = await PhotoApiRepositoryImpl(PhotoApi()).get('iphone');

    expect((result as Success<List<Photo>>).data.length, 30);
    expect((result as Success<List<Photo>>).data.first.id, 2681039);
  });
}
