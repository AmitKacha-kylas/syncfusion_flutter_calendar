# Custom Month Calendar Widget

A clean, modern month calendar widget with event indicators and single date selection.

## Features

- **Month Navigation**: Previous/Next buttons to navigate between months
- **Swipe Navigation**: Swipe left/right to change months
- **Today Button**: Quick navigation to the current month
- **Current Date Indicator**: Filled blue circle for today's date
- **Event Indicators**: Small dots below dates with events/meetings
- **Single Date Selection**: Border circle for the selected date
- **Month Change Callback**: Get notified when the displayed month changes

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? selectedDate;
  List<DateTime> eventDates = [
    DateTime(2026, 9, 16),
    DateTime(2026, 9, 19),
    DateTime(2026, 9, 24),
    DateTime(2026, 9, 27),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomMonthCalendar(
        eventDates: eventDates,
        selectedDate: selectedDate,
        onDateSelected: (date) {
          setState(() {
            selectedDate = date;
          });
        },
        onMonthChanged: (date) {
          // Handle month change if needed
        },
      ),
    );
  }
}
```

## Widget Properties

- **eventDates** `List<DateTime>` - Dates with events/meetings (shows small indicator dots)
- **selectedDate** `DateTime?` - Currently selected date (shows border circle)
- **onDateSelected** `Function(DateTime)?` - Callback when a date is tapped
- **onMonthChanged** `Function(DateTime)?` - Callback when month navigation occurs

## Visual Design

- **Current Date (Today)**: Filled blue circle (#5B6EFF) with white text
- **Selected Date**: Border circle with blue outline
- **Event Dates**: Small blue dot below the date number
- **Other Dates**: Regular black text
- **Previous/Next Month Dates**: Grayed out text

## File Location

`lib/src/calendar/custom_month_calendar.dart`

## Example App

See the example app at `example/lib/main.dart` for a working implementation.
