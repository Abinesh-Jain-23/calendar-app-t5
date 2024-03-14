import 'package:calendar_app_t5/services/api_service.dart';
import 'package:calendar_app_t5/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarComponent extends StatefulWidget {
  const CalendarComponent({super.key, this.onDayTapped});

  final Function(DateTime day)? onDayTapped;

  @override
  State<CalendarComponent> createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {
  final DateFormat dateFormat = DateFormat('dd MMMM yyyy');
  List<Event> events = [];
  SocketService socket = SocketService();

  Widget? defaultBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
  ) {
    return InkWell(
      onTap: () => addEvent(day, null),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        child: Text('${day.day}'),
      ),
    );
  }

  String? getEventName(DateTime date) {
    try {
      return events
          .firstWhere(
            (event) =>
                event.date.year == date.year &&
                event.date.month == date.month &&
                event.date.day == date.day,
          )
          .name;
    } catch (e) {
      return null;
    }
  }

  final ApiService api = ApiService();

  addEvent(DateTime date, String? eventName) {
    final form = GlobalKey<FormState>();
    bool update = eventName != null;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(eventName != null ? 'Edit event' : 'Add event'),
        content: SizedBox(
          child: Form(
            key: form,
            child: TextFormField(
              initialValue: eventName,
              autofocus: true,
              onChanged: (value) => eventName = value,
              validator: (value) => value == null || value.isEmpty
                  ? 'Event name is required'
                  : null,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (form.currentState != null && form.currentState!.validate()) {
                if (update) {
                  updateEvent(date, eventName!);
                } else {
                  events.add(Event(name: eventName!, date: date));
                }
                api.post(events
                    .map((event) => {
                          'event_name': event.name,
                          'event_date':
                              DateFormat("yyyy-MM-dd").format(event.date)
                        })
                    .toList());
                Navigator.of(context).pop();
                setState(() {});
                socket.socket.emit('event', eventName);
              } else {}
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  updateEvent(DateTime day, String name) {
    int index = events.indexWhere((event) =>
        event.date.year == day.year &&
        event.date.month == day.month &&
        event.date.day == day.day);
    events
      ..removeAt(index)
      ..insert(index, Event(name: name, date: day));
  }

  selectDay(DateTime day, Event? event) {
    int selectedDateIndex = events.indexWhere((event) =>
        event.date.year == day.year &&
        event.date.month == day.month &&
        event.date.day == day.day);
    bool selected = selectedDateIndex < 0;
    !selected
        ? events.removeAt(selectedDateIndex)
        : events.add(Event(name: 'name', date: day));
    setState(() {});
    widget.onDayTapped != null ? widget.onDayTapped!(day) : null;
    // addEvent(day, getEvent(day)?.name);
  }

  Widget? selectedBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
  ) {
    return InkWell(
      onTap: () => addEvent(day, getEventName(day)),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Text('${day.day}'),
      ),
    );
  }

  Widget eventsBuilder() => events.isEmpty
      ? const Text('No Events yet')
      : Column(
          children: events
              .map((event) => ListTile(
                    title: Text(event.name),
                    subtitle: Text(dateFormat.format(event.date)),
                    trailing: IconButton(
                        onPressed: () {
                          events.remove(event);
                          setState(() {});
                          api.post(events
                              .map((event) => {
                                    'event_name': event.name,
                                    'event_date': DateFormat("yyyy-MM-dd")
                                        .format(event.date)
                                  })
                              .toList());
                        },
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        )),
                  ))
              .toList(),
        );

  @override
  void initState() {
    super.initState();
    socket.init();
    socket.socket.emit('event', 'event');
    api.getEvents().then((value) {
      events.addAll(value.map((event) => Event(
          name: '${event['event_name']}',
          date: DateTime.parse(
            '${event['event_date']}',
          ))));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          focusedDay: DateTime.now(),
          firstDay: DateTime.now().subtract(const Duration(days: 365)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          calendarStyle: const CalendarStyle(isTodayHighlighted: false),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          selectedDayPredicate: (day) => events.any(
            (event) =>
                day.year == event.date.year &&
                day.month == event.date.month &&
                day.day == event.date.day,
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: defaultBuilder,
            selectedBuilder: selectedBuilder,
          ),
        ),
        eventsBuilder(),
      ],
    );
  }
}

class Event {
  final String name;
  final DateTime date;

  Event({required this.name, required this.date});
}
