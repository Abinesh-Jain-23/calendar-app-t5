import 'package:calendar_app_t5/pages/calendar_page/calendar_page.binding.dart';
import 'package:calendar_app_t5/pages/calendar_page/calendar_page.view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: '/calendar',
      page: () => CalendarPageView(),
      binding: CalendarPageBinding(),
    ),
  ];
}
