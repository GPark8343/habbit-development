import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:habbit/Screen/auth_screen.dart';
import 'package:habbit/Screen/edit_profile_screen.dart';
import 'package:habbit/Screen/fame_detail_screen.dart';
import 'package:habbit/Screen/fame_repository_screen.dart';
import 'package:habbit/Screen/post_detail_screen.dart';
import 'package:habbit/Screen/repository_screen.dart';
import 'package:habbit/Screen/splash_screen.dart';
import 'package:habbit/Screen/story_detail_screen.dart';
import 'package:habbit/Screen/tap_screen.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/providers/deco_manage.dart';
import 'package:habbit/providers/fame_repository_manage.dart';
import 'package:habbit/providers/folder_manage.dart';
import 'package:habbit/providers/marker_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:habbit/providers/time_manage.dart';
import 'package:habbit/providers/upload.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart'; //이거 필수 await initializeDateFormatting(); 때문에

void main() async {
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  MobileAds.instance.initialize();
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
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlutterChat',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
           
            appBarTheme: const AppBarTheme(
              color: Colors.white,
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
                return AuthScreen();
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
          },
        ));
  }
}
