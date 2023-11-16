import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:structure_base/domain/model/photo/photo.dart';
import 'package:structure_base/domain/repository/photo_api_repository.dart';
import 'package:structure_base/presentation/util/result.dart';
import 'package:structure_base/presentation/view/home_page/home_page_view_model.dart';

part 'fake_home_data.g.dart';

@riverpod
class FakeHomeData extends _$FakeHomeData implements HomePageViewModel {
  late final PhotoApiRepository repository;
  bool isLoading = true;
  final _controller = TextEditingController();

  get controller => _controller;

  @override
  Future<List<Photo>?> build() async {
    repository = FackPhotoApiRepository();
    final Result<List<Photo>> result = await repository.get('iphone');

    List<Photo> _photos = [];

    result.when(
      success: (data) {
        _photos = data;
      },
      error: (error) {
        print('error');
      },
    );
    return _photos;
  }

  Future<void> fetch(String query) async {
    // state.isLoading;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(microseconds: 100));
      final Result<List<Photo>> result = await repository.get(query);
      List<Photo> _photos = [];
      result.when(
        success: (data) {
          _photos = data;
          // update((state) => state = data);
        },
        error: (error) {
          print('error');
          throw Exception('error');
        },
      );
      return _photos;
    });
  }
}


class FackPhotoApiRepository extends PhotoApiRepository {
  @override
  Future<Result<List<Photo>>> get(String query) async {
    return Result.success(fakeJson.map((e) => Photo.fromJson(e)).toList());
  }
}

List<Map<String, dynamic>> fakeJson = [
  {
    "id": 2681039,
    "pageURL": "https://pixabay.com/photos/watercolor-painting-colorful-art-2681039/",
    "type": "photo",
    "tags": "watercolor, painting, colorful",
    "previewURL": "",
    "previewWidth": 99,
    "previewHeight": 150,
    "webformatURL": "https://pixabay.com/get/g715d336ebe56819c5d207bcc72c2d42bc140bae52bb5c7e87bc17164e7910e11fc24565076faef9365efdf3215cc952936ea81752091ad6b7dfb450a4c756499_640.jpg",
    "webformatWidth": 424,
    "webformatHeight": 640,
    "largeImageURL": "https://pixabay.com/get/g8ff7a293775d6511d01199a0be606f9d6a2dd9c9f493ffbb163608a6a904608a1c817b1998f8f1e98a7095f50fe55e90434b065d160eed3f40a3b1c8f266f232_1280.jpg",
    "imageWidth": 3264,
    "imageHeight": 4928,
    "imageSize": 5021313,
    "views": 1496938,
    "downloads": 1158005,
    "collections": 2186,
    "likes": 1456,
    "comments": 153,
    "user_id": 4894494,
    "user": "eluela31",
    "userImageURL": "https://cdn.pixabay.com/user/2017/04/24/19-55-29-652_250x250.jpg"
  },
  {
    "id": 1599527,
    "pageURL": "https://pixabay.com/photos/mystery-island-dinosaur-skull-1599527/",
    "type": "photo",
    "tags": "mystery, island, dinosaur",
    "previewURL": "",
    "previewWidth": 116,
    "previewHeight": 150,
    "webformatURL": "https://pixabay.com/get/g8fa03a0cd88dd38a0eab9f5933d871eb6e832283895bf30d66313babd7aedf6e2440399c91ca8a7e612419b817943c0b5a5589e81cb281f75d9ec0bc95a92d02_640.jpg",
    "webformatWidth": 495,
    "webformatHeight": 640,
    "largeImageURL": "https://pixabay.com/get/g4cfc21a4d1008ec80d73dc45c1b9fcc40a3bee02a92774eaa1c0670a03df9bc79c30d88778217362d83ee877af7e51deb7db0d359b233b26675b736c3a5e6908_1280.jpg",
    "imageWidth": 3022,
    "imageHeight": 3907,
    "imageSize": 3563541,
    "views": 1084639,
    "downloads": 634516,
    "collections": 1615,
    "likes": 1645,
    "comments": 184,
    "user_id": 2633886,
    "user": "intographics",
    "userImageURL": "https://cdn.pixabay.com/user/2019/02/11/15-00-48-80_250x250.jpg"
  },
  {
    "id": 620817,
    "pageURL": "https://pixabay.com/photos/office-notes-notepad-entrepreneur-620817/",
    "type": "photo",
    "tags": "office, notes, notepad",
    "previewURL": "https://cdn.pixabay.com/photo/2015/02/02/11/08/office-620817_150.jpg",
    "previewWidth": 150,
    "previewHeight": 99,
    "webformatURL": "https://pixabay.com/get/ga9676443e7e2031ad2326d2662e28f2bebd142996235c2bb6cac3c81b998850b88c871ca01d5ba4fc653fe71a6518c75_640.jpg",
    "webformatWidth": 640,
    "webformatHeight": 425,
    "largeImageURL": "https://pixabay.com/get/g1d3f0bff9e4196e3041e74eafb6ee153f7a0412ec0189ce4f92a631208cb09bf487d3282f3dc674c4f21bcfc07dad4762c8cdcb4744144ec1654bfcd1b46a243_1280.jpg",
    "imageWidth": 4288,
    "imageHeight": 2848,
    "imageSize": 2800224,
    "views": 841081,
    "downloads": 386679,
    "collections": 1454,
    "likes": 1223,
    "comments": 286,
    "user_id": 663163,
    "user": "Firmbee",
    "userImageURL": "https://cdn.pixabay.com/user/2020/11/25/09-38-28-431_250x250.png"
  },
  {
    "id": 1914130,
    "pageURL": "https://pixabay.com/photos/spices-spoons-salt-pepper-1914130/",
    "type": "photo",
    "tags": "spices, spoons, salt",
    "previewURL": "",
    "previewWidth": 133,
    "previewHeight": 150,
    "webformatURL": "https://pixabay.com/get/g2334c5b13bd1c39b4a00deba54f632cd19a4a295fb1d448e060cffa08a17354ccea4a887c6b4818b54de042d0c0c268e88b2a2d8b9531b6c874c71d30cba1f8e_640.jpg",
    "webformatWidth": 571,
    "webformatHeight": 640,
    "largeImageURL": "https://pixabay.com/get/gc2723a73f1e514f9f54f6b9c6729362f3e64712e177e93958775084a70e785eb8acfe44b5d2a78ec73fff4227898112f35bfa5a2e094edeb4f500ec9be553313_1280.jpg",
    "imageWidth": 3581,
    "imageHeight": 4013,
    "imageSize": 6193655,
    "views": 627010,
    "downloads": 421318,
    "collections": 1291,
    "likes": 1365,
    "comments": 178,
    "user_id": 3938704,
    "user": "Daria-Yakovleva",
    "userImageURL": "https://cdn.pixabay.com/user/2016/12/06/15-05-11-524_250x250.jpg"
  },
  {
    "id": 1979674,
    "pageURL": "https://pixabay.com/photos/relaxing-lounging-saturday-cozy-1979674/",
    "type": "photo",
    "tags": "relaxing, lounging, saturday",
    "previewURL": "",
    "previewWidth": 150,
    "previewHeight": 102,
    "webformatURL": "https://pixabay.com/get/g4705f4203a1147c0b43553000453349facca720245f285098b4546f7e45e5311d87143b74cfdb2aad88b1f589bd8b460239fff39cfabbbc7faa8eda86d91322b_640.jpg",
    "webformatWidth": 640,
    "webformatHeight": 438,
    "largeImageURL": "https://pixabay.com/get/g75c92068f214f84080bd44734a942f2bfb4d6112c1344a49bd944a3953990e93edaa3bae642dcd129c2c858dcb6a1c99881a8fef3038d8dd48746d51d9782a08_1280.jpg",
    "imageWidth": 5310,
    "imageHeight": 3637,
    "imageSize": 3751070,
    "views": 481641,
    "downloads": 285074,
    "collections": 1094,
    "likes": 1262,
    "comments": 158,
    "user_id": 334088,
    "user": "JillWellington",
    "userImageURL": "https://cdn.pixabay.com/user/2018/06/27/01-23-02-27_250x250.jpg"
  }
];