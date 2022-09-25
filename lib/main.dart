import 'package:crud_user_registration/provider/theme_provider.dart';
import 'package:crud_user_registration/provider/user_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserListProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..initialize()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          title: 'User Registration',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.blueGrey,
            fontFamily: 'Poppins',
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.blueGrey,
            fontFamily: 'Poppins',
          ),
          themeMode: theme.themeMode,
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        ),
      ),
    );
  }
}
