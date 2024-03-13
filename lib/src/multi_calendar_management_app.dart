import 'package:calendar_app_t5/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiCalendarManagementApp extends StatelessWidget {
  const MultiCalendarManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/calendar',
      getPages: AppRoutes.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
