import 'package:flutter/material.dart';
import 'screens/lock_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الخزنة الآمنة',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Tajawal', // يمكن تغيير الخط ليدعم العربية
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
        ),
      ),
      home: LockScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
