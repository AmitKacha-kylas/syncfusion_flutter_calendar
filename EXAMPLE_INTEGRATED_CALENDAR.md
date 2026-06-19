# Integrated Calendar Example

This example demonstrates how to use the **IntegratedMonthCalendar** widget to combine a month selector with an event calendar.

## Example Overview

The example shows a complete working implementation with:

1. **Sample Appointments**: 6 appointments spread across multiple days
2. **Month Calendar Selector**: Navigate months and select dates
3. **Event Display**: Shows events for the selected date
4. **Event Feedback**: Toast notification showing selected date and event count

## Project Structure

```
example/
├── lib/
│   └── main.dart                 # Complete example app
```

## Key Components

### 1. CalendarApp Widget
The root widget that sets up the Material app with basic theming.

```dart
MaterialApp(
  title: 'Integrated Calendar Demo',
  theme: ThemeData(
    primarySwatch: Colors.blue,
    useMaterial3: true,
  ),
  home: const IntegratedCalendarPage(),
)
```

### 2. IntegratedCalendarPage Widget
Main page containing the IntegratedMonthCalendar.

```dart
IntegratedMonthCalendar(
  dataSource: AppointmentDataSource(appointments),
  monthCalendarHeight: 420,
  onDateSelected: (date) {
    // Handle date selection
    _showDateInfo(date);
  },
)
```

### 3. Sample Appointments

The example includes 6 sample appointments:

| Date | Time | Subject | Color |
|------|------|---------|-------|
| Today | 9:00-10:00 | Team Meeting | Green |
| Today | 14:00-15:30 | Project Review | Purple |
| Tomorrow | 10:00-11:00 | Client Call | Green |
| +3 Days | 9:00-12:00 | Design Sprint | Orange |
| +3 Days | 12:00-13:00 | Lunch with Team | Orange |
| +5 Days | 10:00-11:30 | Sprint Planning | Green |
| +7 Days | 9:00-10:00 | Weekly Sync | Purple |

### 4. Custom Data Source

```dart
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
}
```

### 5. Custom Appointment Class

```dart
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
```

## How It Works

1. **Initial Load**
   - Calendar displays current month with month selector
   - All dates with events show small indicator dots
   - Day view shows today's events in time slots (30-min intervals)
   - Default date is today

2. **Selecting a Date**
   - Tap a date in the month calendar
   - Day view automatically updates to show events for that date
   - Time slots display the duration of each appointment
   - Toast notification shows date and event count

3. **Navigating Months**
   - Use arrow buttons or swipe to change months in the month calendar
   - Event indicators update for the new month
   - Day view updates if you select a date in the new month
   - Calendar maintains smooth transitions between months

## Features Demonstrated

✅ **Event Filtering**: Only events for selected date are shown  
✅ **Date Navigation**: Swipe or tap arrows to change months  
✅ **Event Indicators**: Dots show which dates have events  
✅ **Single Selection**: Only one date can be selected  
✅ **User Feedback**: Toast messages confirm actions  
✅ **Custom Styling**: Appointments with different colors  

## Running the Example

```bash
cd packages/syncfusion_flutter_calendar/example
flutter pub get
flutter run
```

## Key Interactions

1. **Select a Date**: Tap any date in the month calendar
2. **View Events**: See events in the schedule view below
3. **Navigate**: Swipe left/right or tap arrows to change months
4. **Today Button**: Click "Today" to jump back to current date

## Customization Tips

### Add More Appointments
Edit `_generateSampleAppointments()` to add more appointments with different times and colors.

### Change Month Calendar Height
Modify the `monthCalendarHeight` parameter:
```dart
IntegratedMonthCalendar(
  dataSource: AppointmentDataSource(appointments),
  monthCalendarHeight: 500,  // Increase height
  onDateSelected: (date) { ... },
)
```

### Custom Colors
Modify appointment colors in the `_generateSampleAppointments()` method:
```dart
color: const Color(0xFF0F8644),  // Green
color: const Color(0xFF8B3A62),  // Purple
color: const Color(0xFFFF6B00),  // Orange
```

## Example Output

When you run the example:

```
┌────────────────────────────────┐
│    Integrated Calendar         │  ← AppBar
├────────────────────────────────┤
│      June 2026                 │
│  Su Mo Tu We Th Fr Sa          │
│      1  2  3  4  5  6          │
│   7  8  9 10 11 12 13          │  ← Month Calendar
│  14 15 16• 17 18 19•20         │     (dots show dates with events)
│  21 22 23 24•25 26 27•         │
│  28 29 30                      │
├────────────────────────────────┤
│  09:00  ████ Team Meeting      │
│  10:00                         │
│  11:00                         │
│  12:00                         │  ← Day View
│  13:00                         │     (time slots for selected date)
│  14:00  ███████ Project Review │
│  15:00  ███████                │
│  16:00                         │
└────────────────────────────────┘
```

**Key Features Shown:**
- Month calendar on top with event indicators (•)
- Day view below showing hourly time slots
- Events displayed as colored blocks in their time slots
- Each time slot is 30 minutes
- Events span multiple slots based on their duration

## Next Steps

- Customize appointments based on your needs
- Add event creation/editing functionality
- Integrate with a backend API
- Add event filtering or categorization
- Implement calendar syncing features
