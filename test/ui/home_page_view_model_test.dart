import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:structure_base/presentation/view/home_page/components/photo_widget.dart';
import 'package:structure_base/presentation/view/home_page/home_page.dart';
import 'package:structure_base/presentation/view/home_page/home_page_view_model.dart';

import 'fake_home_data.dart';

void main() {
  testWidgets('override repositoryProvider', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
         overrides: [
           homePageViewModelProvider.overrideWith(() => FakeHomeData()),
         ],
        child: const MaterialApp(home: HomePage()),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump();
    // No longer loading
    expect(find.byType(CircularProgressIndicator), findsNothing);
    // 위젯 확인
    expect(find.byType(PhotoWidget), findsWidgets);

    // // // Rendered one TodoItem with the data returned by FakeRepository
    expect(tester.widgetList(find.byType(PhotoWidget).first), [
      isA<PhotoWidget>()
          .having((s) => s.photo.previewUrl, 'previewUrl', '')
          .having((s) => s.photo.id, 'photo.id', 2681039)
    ]);

  });
}