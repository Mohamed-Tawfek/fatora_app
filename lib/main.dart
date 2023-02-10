
import 'package:fatora_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cubit/fatora_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FatoraCubit.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fatora',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
          primarySwatch: Colors.grey,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF15202B),
            elevation: 0.0,
            iconTheme:IconThemeData(color: Colors.white) ,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color(0xFF15202B),

            )
          ),
          scaffoldBackgroundColor: const Color(0xFF15202B)),
      themeMode: ThemeMode.dark,
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomeScreen(),
      ),
    );
  }
}
