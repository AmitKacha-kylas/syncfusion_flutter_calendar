import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(const CalendarApp());
}

/// The app which hosts the integrated calendar
class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Integrated Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const IntegratedCalendarPage(),
    );
  }
}

/// Page displaying the integrated calendar
class IntegratedCalendarPage extends StatefulWidget {
  const IntegratedCalendarPage({Key? key}) : super(key: key);

  @override
  State<IntegratedCalendarPage> createState() => _IntegratedCalendarPageState();
}

class _IntegratedCalendarPageState extends State<IntegratedCalendarPage> {
  late List<Appointment> appointments;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    appointments = _generateSampleAppointments();
  }

  List<Appointment> _generateSampleAppointments() {
    final DateTime today = DateTime.now();
    final List<Appointment> meetingList = <Appointment>[];

    // Today's appointments
    meetingList.add(
      Appointment(
        subject: 'Team Meeting',
        startTime: DateTime(today.year, today.month, today.day, 9),
        endTime: DateTime(today.year, today.month, today.day, 10),
        color: const Color(0xFF0F8644),
      ),
    );

    meetingList.add(
      Appointment(
        subject: 'Project Review',
        startTime: DateTime(today.year, today.month, today.day, 14),
        endTime: DateTime(today.year, today.month, today.day, 15, 30),
        color: const Color(0xFF8B3A62),
      ),
    );

    // Tomorrow's appointments
    final DateTime tomorrow = today.add(const Duration(days: 1));
    meetingList.add(
      Appointment(
        subject: 'Client Call',
        startTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 10),
        endTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 11),
        color: const Color(0xFF0F8644),
      ),
    );

    // Day 3
    final DateTime dayThree = today.add(const Duration(days: 3));
    meetingList.add(
      Appointment(
        subject: 'Design Sprint',
        startTime: DateTime(dayThree.year, dayThree.month, dayThree.day, 9),
        endTime: DateTime(dayThree.year, dayThree.month, dayThree.day, 12),
        color: const Color(0xFFFF6B00),
      ),
    );

    meetingList.add(
      Appointment(
        subject: 'Lunch with Team',
        startTime: DateTime(dayThree.year, dayThree.month, dayThree.day, 12),
        endTime: DateTime(dayThree.year, dayThree.month, dayThree.day, 13),
        color: const Color(0xFFFFA500),
      ),
    );

    // Day 5
    final DateTime dayFive = today.add(const Duration(days: 5));
    meetingList.add(
      Appointment(
        subject: 'Sprint Planning',
        startTime: DateTime(dayFive.year, dayFive.month, dayFive.day, 10),
        endTime: DateTime(dayFive.year, dayFive.month, dayFive.day, 11, 30),
        color: const Color(0xFF0F8644),
      ),
    );

    // Day 7
    final DateTime daySeven = today.add(const Duration(days: 7));
    meetingList.add(
      Appointment(
        subject: 'Weekly Sync',
        startTime: DateTime(daySeven.year, daySeven.month, daySeven.day, 9),
        endTime: DateTime(daySeven.year, daySeven.month, daySeven.day, 10),
        color: const Color(0xFF8B3A62),
      ),
    );

    return meetingList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrated Calendar'),
        elevation: 2,
      ),
      body: IntegratedMonthCalendar(
        dataSource: AppointmentDataSource(appointments),
        onDateSelected: (date) {
          setState(() {
            selectedDate = date;
          });
          _showDateInfo(date);
        },
      ),
    );
  }

  void _showDateInfo(DateTime date) {
    final eventsOnDate = appointments
        .where((apt) =>
            apt.startTime.year == date.year &&
            apt.startTime.month == date.month &&
            apt.startTime.day == date.day)
        .toList();

    final dateStr = '${date.day}/${date.month}/${date.year}';
    final eventCount = eventsOnDate.length;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          eventCount > 0
              ? '$dateStr: $eventCount event(s)'
              : '$dateStr: No events',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Custom appointment data source
class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].startTime;

  @override
  DateTime getEndTime(int index) => appointments![index].endTime;

  @override
  String getSubject(int index) => appointments![index].subject;

  @override
  Color getColor(int index) => appointments![index].color;

  @override
  bool isAllDay(int index) => appointments![index].isAllDay ?? false;
}

/// Custom appointment class
class Appointment {
  Appointment({
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.color,
    this.isAllDay = false,
  });

  final String subject;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final bool? isAllDay;
}
