// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:riverpod/riverpod.dart';
// import 'package:structure_base/presentation/view/splash_page.dart';
//
// Widget fadeTransition(BuildContext context, Animation<double> animation,
//     Animation<double> secondaryAnimation, Widget child) =>
//     FadeTransition(opacity: animation, child: child);
//
// Widget slideTransition(context, animation, secondaryAnimation, child) =>
//     SlideTransition(
//         position: animation.drive(
//           Tween<Offset>(
//             begin: const Offset(1, 0),
//             end: Offset.zero,
//           ).chain(CurveTween(curve: Curves.easeInOutQuart)),
//         ),
//         child: child);
//
// final goRouterProvider = Provider<GoRouter>(
//       (ref) {
//     return GoRouter(
//       initialLocation: '/',
//       errorBuilder: (context, state) {
//         return const Center(
//           child: Text('본사로 연락 바랍니다'),
//         );
//       },
//       routes: [
//         /// splash
//         GoRoute(
//           path: RouterPath.splash.path,
//           name: RouterPath.splash.name,
//           builder: (context, state) => const SplashPage(),
//         ),
//
//         /// login
//         GoRoute(
//           path: RouterPath.login.path,
//           name: RouterPath.login.name,
//           pageBuilder: (context, state) => CustomTransitionPage<void>(
//             // transitionDuration: const Duration(seconds: 2),
//             key: state.pageKey,
//             child: const LoginPage(),
//             transitionsBuilder: fadeTransition,
//           ),
//         ),
//
//         /// home
//         GoRoute(
//           path: RouterPath.home.path,
//           name: RouterPath.home.name,
//           pageBuilder: (context, state) => CustomTransitionPage<void>(
//             transitionDuration: const Duration(seconds: 1),
//             key: state.pageKey,
//             child: HomePage(
//               isFirstRun: state.params['isFirstRun'] == 'true',
//             ),
//             transitionsBuilder: fadeTransition,
//           ),
//           routes: [
//             GoRoute(
//               path: RouterPath.memberPage.path,
//               name: RouterPath.memberPage.name,
//               pageBuilder: (context, state) => CustomTransitionPage<void>(
//                 transitionDuration: const Duration(milliseconds: 500),
//                 key: state.pageKey,
//                 child: const MemberPage(),
//                 transitionsBuilder: slideTransition,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   },
// );
//
// enum RouterPath {
//   splash('/', '/'),
//   login('/login', 'login'),
//   home('/home', 'home'),
//
//   /// 이하 home에서 들어가야함.(push 사용)
//
//   /// 프로모션
//   promotionPage('promotion', 'promotion'),
//
//   //회원페이지
//   memberPage('member_page/:memberId', 'member_page'),
//   ;
//
//   const RouterPath(this.path, this.name);
//   final String path;
//   final String name;
// }