import 'package:calendar_app_t5/component/calendar_component.dart';
import 'package:calendar_app_t5/pages/calendar_page/calendar_page.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarPageView extends GetResponsiveView<CalendarPageController> {
  CalendarPageView({super.key});

  @override
  Widget? builder() {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: ListView(
        children: [
          CalendarComponent(
            onDayTapped: (day) => print(day),
          ),
          ElevatedButton(
              onPressed: () {
                controller.calendarClient.insert('title', DateTime.now(),
                    DateTime.now().add(const Duration(days: 1)));
              },
              child: Text('Insert'))
        ],
      ),
    );
  }
}
