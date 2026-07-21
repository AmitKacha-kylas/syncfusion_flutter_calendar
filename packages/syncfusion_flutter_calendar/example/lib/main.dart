import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

void main() {
  runApp(const CalendarApp());
}

/// The app which hosts the integrated calendar
class CalendarApp extends StatefulWidget {
  const CalendarApp({super.key});

  @override
  State<CalendarApp> createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Integrated Calendar Demo',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: Colors.yellow,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: IntegratedCalendarPage(
        onThemeChanged: (isDark) {
          setState(() {
            _isDarkMode = isDark;
          });
        },
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

/// Page displaying the integrated calendar
class IntegratedCalendarPage extends StatefulWidget {
  const IntegratedCalendarPage({
    Key? key,
    required this.onThemeChanged,
    required this.isDarkMode,
  }) : super(key: key);

  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  @override
  State<IntegratedCalendarPage> createState() => _IntegratedCalendarPageState();
}

class _IntegratedCalendarPageState extends State<IntegratedCalendarPage> {
  late List<Appointment> appointments;
  late DateTime selectedDate;
  bool _isInitialBuild = true;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    appointments = _generateSampleAppointments();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isInitialBuild = false;
      });
    }
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

  Widget appointmentView(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final appointments = details.appointments.toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: appointments.isNotEmpty
          ? (appointments[0] as Appointment).color
          : Colors.grey,
      ),
      padding: const EdgeInsets.all(4),
      child: Text(
        appointments.isNotEmpty
          ? (appointments[0] as Appointment).subject
          : 'No event',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define theme colors based on brightness
    final primaryColor = isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);

    final calendarThemeData = SfCalendarThemeData(
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      headerBackgroundColor: isDarkMode
          ? const Color(0xFF2A2A2A)
          : const Color(0xFFF3F4F6),
      todayHighlightColor: Colors.blueAccent,  // ← This is what CustomMonthCalendar reads!
      selectionBorderColor: Colors.yellow,
      cellBorderColor: isDarkMode
          ? const Color(0xFF404040)
          : const Color(0xFFE5E7EB),
      activeDatesBackgroundColor: isDarkMode
          ? const Color(0xFF262626)
          : const Color(0xFFF9FAFB),
      todayTextStyle: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrated Calendar with Theme'),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: () {
              widget.onThemeChanged(!widget.isDarkMode);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 38.0),
            child: Text("sdfvdsfnv;lgbnl;rg"),
          ),
          Expanded(
            child: SfCalendarTheme(
              data: calendarThemeData,
              child: IntegratedMonthCalendar(
                key: ValueKey<bool>(widget.isDarkMode),
                dataSource: AppointmentDataSource(appointments),
                initialSelectedDate: null,
                selectionDecoration: BoxDecoration(
                  border: Border.all(color: Colors.yellow, width: 2),
                  shape: BoxShape.circle,
                ),
                appointmentBuilder: appointmentView,
                timeSlotViewSettings: const TimeSlotViewSettings(
                  timeInterval: Duration(minutes: 30),
                ),
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                  _showDateInfo(date);
                },
                onMonthChanged: (month) {
                  print('Month changed: ${month.year}-${month.month}');
                },
                onSelectionChanged: (CalendarSelectionDetails details) {
                  if (!_isInitialBuild && details.date != null) {
                    DateTime startTime = details.date!;
                    DateTime endTime = startTime.add(const Duration(minutes: 30));
                    _handleThirtyMinSelection(startTime, endTime);
                  }
                },
              ),
            ),
          ),
        ],
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

  void _handleThirtyMinSelection(DateTime startTime, DateTime endTime) {
    final timeStr = '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}';
    print("timeStr===??? $timeStr");
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('30-min slot selected: $timeStr'),
    //     duration: const Duration(seconds: 2),
    //   ),
    // );
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
