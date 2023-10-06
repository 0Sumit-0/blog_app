
import 'dart:ui';

import 'package:blogtask/helper/db_helper.dart';
import 'package:blogtask/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async{
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DBHelper();

  await dbHelper.database;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: ()=>const HomePage()),
      ],
    );
  }
}

