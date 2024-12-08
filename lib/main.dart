import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_pool/common/theme/app_theme.dart';
import 'package:share_pool/features/authentication/providers/authentication_provider.dart';
import 'package:share_pool/features/authentication/screens/login_view/login_view.dart';
import 'package:share_pool/firebase_options.dart';
import 'package:share_pool/splash_screen.dart';

import 'features/home/screens/navigation_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(create: (_) => AuthenticationProvider()),
      ],
       child:  MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Share Pool',
          key: navigatorKey,
          theme: AppTheme.darkTheme,
          home: const SplashScreen(),
        ),
    );
  }
}
