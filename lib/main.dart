import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habbit/Screen/auth_screen.dart';
import 'package:habbit/Screen/ban_screen.dart';
import 'package:habbit/Screen/edit_profile_screen.dart';
import 'package:habbit/Screen/error_screen.dart';
import 'package:habbit/Screen/explain_screen.dart';
import 'package:habbit/Screen/fame_detail_screen.dart';
import 'package:habbit/Screen/fame_repository_screen.dart';
import 'package:habbit/Screen/other_post_detail_screen.dart';
import 'package:habbit/Screen/post_chat_screen.dart';
import 'package:habbit/Screen/post_detail_screen.dart';
import 'package:habbit/Screen/service_screen.dart';
import 'package:habbit/Screen/tutorial_screen.dart';
import 'package:habbit/Screen/repository_screen.dart';
import 'package:habbit/Screen/splash_screen.dart';
import 'package:habbit/Screen/story_detail_screen.dart';
import 'package:habbit/Screen/tap_screen.dart';
import 'package:habbit/Screen/other_profile_screen.dart';

import 'package:habbit/colors.dart';
import 'package:habbit/design_course/course_info_screen.dart';
import 'package:habbit/fitness_app/fitness_app_theme.dart';
import 'package:habbit/introduction_animation/introduction_animation_screen.dart';
import 'package:habbit/introduction_animation/tutorial_screen.dart';
import 'package:habbit/providers/ban_manage.dart';
import 'package:habbit/providers/category_manage.dart';
import 'package:habbit/providers/deco_manage.dart';
import 'package:habbit/providers/fame_repository_manage.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/marker_manage.dart';
import 'package:habbit/providers/post_message_manage.dart';
import 'package:habbit/providers/report_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/providers/time_manage.dart';
import 'package:habbit/providers/upload.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart'; //이거 필수 await initializeDateFormatting(); 때문에
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

void main() async {
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  MobileAds.instance.initialize();
  InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: TimeManage(),
          ),
          ChangeNotifierProvider.value(
            value: StoryManage(),
          ),
          ChangeNotifierProvider.value(
            value: Upload(),
          ),
          ChangeNotifierProvider.value(
            value: FolderManage(),
          ),
          ChangeNotifierProvider.value(
            value: MarkerManage(),
          ),
          ChangeNotifierProvider.value(
            value: DecoManage(),
          ),
          ChangeNotifierProvider.value(
            value: FameRepositoryManage(),
          ),
          ChangeNotifierProvider.value(
            value: ReportManage(),
          ),
          ChangeNotifierProvider.value(
            value: BanManage(),
          ),
          ChangeNotifierProvider.value(
            value: PostMessageManage(),
          ),
          //  ChangeNotifierProvider.value(
          //   value: CategoryManage(),
          // ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlutterChat',
          theme: ThemeData(
            scaffoldBackgroundColor: FitnessAppTheme.background,
            appBarTheme: const AppBarTheme(
              color: FitnessAppTheme.background,
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
              if (userSnapshot
                  .hasData /*|| FirebaseAuth.instance.currentUser != null*/) {
                return TapScreen();
              } else
                return IntroductionAnimationScreen();
            },
          ),
          routes: {
            // PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
            // UploadScreen.routeName: (ctx) =>  UploadScreen(),
            StoryDetailScreen.routeName: (ctx) => StoryDetailScreen(),
            PostDetailScreen.routeName: (ctx) => PostDetailScreen(),
            EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
            RepositoryScreen.routeName: (ctx) => RepositoryScreen(),
            FameRepositoryScreen.routeName: (ctx) => FameRepositoryScreen(),
            FameDetailScreen.routeName: (ctx) => FameDetailScreen(),
            TapScreen.routeName: (ctx) => TapScreen(),
            TutorialScreen.routeName: (ctx) => TutorialScreen(),
            OtherProfileScreen.routeName: (ctx) => OtherProfileScreen(),
            OtherPostDetailScreen.routeName: (ctx) => OtherPostDetailScreen(),
            PrivacyScreen.routeName: (ctx) => PrivacyScreen(),
            ServiceScreen.routeName: (ctx) => ServiceScreen(),
            BanScreen.routeName: (ctx) => BanScreen(),
            PostChatScreen.routeName: (ctx) => PostChatScreen(),
            IntroductionAnimationScreen.routeName: (ctx) =>
                IntroductionAnimationScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ErrorScreen.routeName: (ctx) => ErrorScreen(),
            CourseInfoScreen.routeName: (ctx) => CourseInfoScreen(),

            // ExplainScreen.routeName: (ctx) =>  ExplainScreen(),
          },
        ));
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
