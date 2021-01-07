import 'package:chater/data/auth/auth_check.dart';
import 'package:chater/provider/theme_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, theme, widget) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chater',
            theme: theme.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
            home: AuthCheck(),
          );
        },
      ),
    );
  }
}
