# IntegratedMonthCalendar Widget

A comprehensive calendar widget that combines CustomMonthCalendar with SfCalendar. Automatically syncs date selection and filters events based on the selected date.

## Features

- **Month Selector Calendar**: CustomMonthCalendar for easy date navigation
- **Day View Calendar**: SfCalendar showing time slots for the selected date
- **Time Slots**: Default 30-minute intervals with 90-pixel height
- **Automatic Sync**: Changes in month calendar automatically update day view
- **Event Indicators**: Small dots on calendar show dates with events
- **Default Selection**: Defaults to current date with today's events shown
- **Single Date Selection**: Only one date can be selected at a time
- **Customizable Time Slots**: Pass custom TimeSlotViewSettings

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Appointment> appointments;

  @override
  void initState() {
    super.initState();
    appointments = _getAppointments();
  }

  List<Appointment> _getAppointments() {
    final List<Appointment> meetings = <Appointment>[];
    final DateTime today = DateTime.now();
    
    // Add some sample appointments
    meetings.add(
      Appointment(
        startTime: DateTime(today.year, today.month, today.day, 9, 0),
        endTime: DateTime(today.year, today.month, today.day, 10, 0),
        subject: 'Meeting 1',
        color: Colors.blue,
      ),
    );
    
    meetings.add(
      Appointment(
        startTime: DateTime(today.year, today.month, today.day + 1, 14, 0),
        endTime: DateTime(today.year, today.month, today.day + 1, 15, 0),
        subject: 'Team Standup',
        color: Colors.green,
      ),
    );
    
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Integrated Calendar')),
      body: IntegratedMonthCalendar(
        dataSource: _AppointmentDataSource(appointments),
        monthCalendarHeight: 400,
        onDateSelected: (selectedDate) {
          print('Selected date: $selectedDate');
        },
      ),
    );
  }
}

// Custom data source for appointments
class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
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
}

class Appointment {
  Appointment({
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.color,
  });

  final DateTime startTime;
  final DateTime endTime;
  final String subject;
  final Color color;
}
```

## Widget Properties

- **dataSource** `CalendarDataSource` (Required) - The data source containing appointments/events
- **onDateSelected** `Function(DateTime)?` - Callback when a date is selected
- **monthCalendarHeight** `double` (Default: 400) - Height of the month calendar selector
- **sfCalendarViewSettings** `dynamic?` - Custom view settings for SfCalendar
- **monthViewSettings** `MonthViewSettings?` - Custom month view settings
- **timeSlotViewSettings** `TimeSlotViewSettings?` - Custom time slot view settings

## How It Works

1. **Month Calendar at Top**: Shows current month with navigation controls
2. **Event Indicators**: Small dots below dates that have appointments
3. **Day View Below**: Shows time slots (30-min intervals) with appointments for the selected date
4. **Auto-Filtering**: When you select a date in the month calendar, the day view automatically updates to show only events for that date
5. **Time Slots**: Each time slot is 90 pixels high, making it easy to see time distribution
6. **Default Date**: Calendar defaults to today's date on load

## Visual Layout

```
┌─────────────────────────────────┐
│  CustomMonthCalendar            │
│  (Month Selector with dots)     │  Height: 400 (configurable)
│                                 │
└─────────────────────────────────┘
┌─────────────────────────────────┐
│  SfCalendar (Day View)          │
│  09:00  Team Meeting            │
│         ████████                │  Height: Flexible
│  09:30                          │  (fills remaining space)
│  10:00  Client Call             │
│         ████████                │
│  10:30                          │
│  ...                            │
└─────────────────────────────────┘
```

## Files

- `lib/src/calendar/integrated_month_calendar.dart` - Main widget
- Exported from `lib/calendar.dart` as `IntegratedMonthCalendar`

## Key Features

- **Responsive**: Adapts to different screen sizes
- **Type-Safe**: Uses proper type checking for appointments
- **Flexible**: Supports custom CalendarDataSource implementations
- **Event Filtering**: Automatically filters events by selected date
- **Theme Support**: Works with your app's Material theme
