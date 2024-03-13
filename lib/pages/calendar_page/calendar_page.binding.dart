import 'package:calendar_app_t5/pages/calendar_page/calendar_page.controller.dart';
import 'package:get/get.dart';

class CalendarPageBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(() => CalendarPageController());
}
