

import 'package:flutter/material.dart';
import 'package:structure_base/data/data_source/api/photo_api.dart';
import 'package:structure_base/data/repository/photo_api_repository_impl.dart';
import 'package:structure_base/domain/model/photo/photo.dart';
import 'package:structure_base/domain/repository/photo_api_repository.dart';
import 'package:structure_base/presentation/util/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_page_view_model.g.dart';

@riverpod
class HomePageViewModel extends _$HomePageViewModel {
  late final PhotoApiRepository repository;
  bool isLoading = true;
  final _controller = TextEditingController();

  get controller => _controller;

  @override
  Future<List<Photo>?> build() async {
    repository = PhotoApiRepositoryImpl(PhotoApi());
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


    // final Result<List<Photo>> result = await repository.get(query);
    // result.when(
    //   success: (data) {
    //     update((state) => state = data);
    //     // const AsyncSnapshot.nothing();
    //   },
    //   error: (error) {
    //     print('error');
    //     state.error;
    //   },
    // );
  }
}