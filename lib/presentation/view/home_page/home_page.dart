import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:structure_base/data/data_source/api/photo_api.dart';
import 'package:structure_base/data/repository/photo_api_repository_impl.dart';
import 'package:structure_base/presentation/view/home_page/components/photo_widget.dart';
import 'package:structure_base/presentation/view/home_page/home_page_view_model.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<HomePage> {
  String _udid = 'Unknown';
  String _uuid = 'Unknown';
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initPlatformState() async {
    String udid;
    try {
      // udid = await FlutterUdid.udid;
      udid = await FlutterUdid.consistentUdid;
    } on PlatformException {
      udid = 'Failed to get UDID.';
    }
    final iosInfo = await deviceInfo.iosInfo;
    String? deviceId = iosInfo.identifierForVendor;

    if (!mounted) return;

    print('udid: $udid');
    print('uuid: $deviceId');
    setState(() {
      _udid = udid;
      _uuid = deviceId ?? 'null';
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homePageViewModelProvider);
    final notifier = ref.read(homePageViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Image Search',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Center(
                child: Text('uuid: $_uuid,\n\nudid: $_udid'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: notifier.controller,
              onSubmitted: (value) async {
                notifier.fetch(value);
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                suffixIcon: IconButton(
                  onPressed: () async {
                    notifier.fetch(notifier.controller.text);
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: state.when(
              data: (data) {
                return data == null || data.isEmpty
                    ? const Center(child: Text('관련된 이미지가 없습니다.'))
                    : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length ?? 0, //item 개수
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                    mainAxisSpacing: 16, //수평 Padding
                    crossAxisSpacing: 16, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    //item 의 반목문 항목 형성
                    final photo = state.value![index];
                    return PhotoWidget(
                      photo: photo,
                    );
                  },
                );
              },
              error: (error, stackTrace) => const Center(child: Text('에러')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}


