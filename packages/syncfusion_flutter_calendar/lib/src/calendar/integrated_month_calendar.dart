import 'package:flutter/material.dart';

import 'appointment_engine/calendar_datasource.dart';
import 'custom_month_calendar.dart' as month_cal;
import 'settings/time_slot_view_settings.dart';
import 'sfcalendar.dart';

/// An integrated calendar widget combining CustomMonthCalendar with SfCalendar.
///
/// Features:
/// - Month calendar view
/// - Day view calendar showing events for selected date
/// - Clean integrated layout without modal appearance
class IntegratedMonthCalendar extends StatefulWidget {
  /// Creates an integrated month calendar widget.
  const IntegratedMonthCalendar({
    Key? key,
    required this.dataSource,
    this.onDateSelected,
    this.timeSlotViewSettings,
  }) : super(key: key);

  /// Calendar data source containing all appointments/events
  final CalendarDataSource dataSource;

  /// Callback when a date is selected in the month calendar
  final Function(DateTime)? onDateSelected;

  /// Time slot view settings for SfCalendar (default: 30 min intervals)
  final TimeSlotViewSettings? timeSlotViewSettings;

  @override
  State<IntegratedMonthCalendar> createState() =>
      _IntegratedMonthCalendarState();
}

class _IntegratedMonthCalendarState extends State<IntegratedMonthCalendar> {
  late DateTime selectedDate;
  late List<DateTime> eventDates;
  double monthCalendarHeight = 380;
  double dayViewHeight = 450;
  bool _isDragging = false;
  month_cal.NavigationMode _previousNavigationMode = month_cal.NavigationMode.monthly;
  final _calendarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    eventDates = _extractEventDates();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _isDragging = true;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      monthCalendarHeight += details.delta.dy;
      dayViewHeight -= details.delta.dy;
      monthCalendarHeight = monthCalendarHeight.clamp(120, 600);
      dayViewHeight = dayViewHeight.clamp(450, 600);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _isDragging = false;
  }

  List<DateTime> _extractEventDates() {
    final dates = <DateTime>{};
    if (widget.dataSource.appointments == null) {
      return [];
    }

    for (var i = 0; i < widget.dataSource.appointments!.length; i++) {
      final startTime = widget.dataSource.getStartTime(i);
      dates.add(DateTime(startTime.year, startTime.month, startTime.day));
    }
    return dates.toList();
  }

  bool _isWeekMode(double height) {
    return height <= 150;
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        const dragHandleHeight = 12.0;
        final availableHeight = totalHeight - dragHandleHeight;

        final ratio = monthCalendarHeight / (monthCalendarHeight + dayViewHeight);
        var monthHeight = availableHeight * ratio;

        monthHeight = monthHeight.clamp(100.0, availableHeight - 150);

        final navigationMode = _isWeekMode(monthHeight)
            ? month_cal.NavigationMode.weekly
            : month_cal.NavigationMode.monthly;

        // When switching from monthly to weekly mode, navigate to the selected date's week
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_previousNavigationMode == month_cal.NavigationMode.monthly &&
              navigationMode == month_cal.NavigationMode.weekly) {
            final state = _calendarKey.currentState;
            if (state != null) {
              (state as dynamic).navigateToDate(selectedDate);
            }
          }
          _previousNavigationMode = navigationMode;
        });

        return Column(
          children: [
            ClipRect(
              child: SizedBox(
                height: monthHeight,
                child: month_cal.CustomMonthCalendar(
                  key: _calendarKey,
                  eventDates: eventDates,
                  selectedDate: selectedDate,
                  navigationMode: navigationMode,
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                    widget.onDateSelected?.call(date);
                  },
                ),
              ),
            ),
            GestureDetector(
              onVerticalDragStart: _onVerticalDragStart,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeRow,
                child: Container(
                  height: dragHandleHeight,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: Colors.white,
                child: _buildSfCalendar(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSfCalendar() {
    final timeSettings = widget.timeSlotViewSettings ??
        const TimeSlotViewSettings(
          timeInterval: Duration(minutes: 30),
          timeIntervalHeight: 90,
        );

    return SfCalendar(
      dataSource: _FilteredDataSource(
        widget.dataSource,
        selectedDate,
      ),
      timeSlotViewSettings: timeSettings,
    );
  }
}

/// Custom data source that filters appointments by selected date
class _FilteredDataSource extends CalendarDataSource {
  _FilteredDataSource(this._baseDataSource, this._selectedDate) {
    _filteredAppointments = _getFilteredAppointments();
    appointments = _filteredAppointments;
  }

  final CalendarDataSource _baseDataSource;
  final DateTime _selectedDate;
  late List<dynamic> _filteredAppointments;

  List<dynamic> _getFilteredAppointments() {
    if (_baseDataSource.appointments == null) {
      return [];
    }

    final filtered = <dynamic>[];
    for (var i = 0; i < _baseDataSource.appointments!.length; i++) {
      final startTime = _baseDataSource.getStartTime(i);
      if (startTime.year == _selectedDate.year &&
          startTime.month == _selectedDate.month &&
          startTime.day == _selectedDate.day) {
        filtered.add(_baseDataSource.appointments![i]);
      }
    }
    return filtered;
  }

  @override
  DateTime getStartTime(int index) {
    return _baseDataSource.getStartTime(
      _baseDataSource.appointments!.indexOf(_filteredAppointments[index]),
    );
  }

  @override
  DateTime getEndTime(int index) {
    return _baseDataSource.getEndTime(
      _baseDataSource.appointments!.indexOf(_filteredAppointments[index]),
    );
  }

  @override
  String getSubject(int index) {
    return _baseDataSource.getSubject(
      _baseDataSource.appointments!.indexOf(_filteredAppointments[index]),
    );
  }

  @override
  Color getColor(int index) {
    return _baseDataSource.getColor(
      _baseDataSource.appointments!.indexOf(_filteredAppointments[index]),
    );
  }

  @override
  bool isAllDay(int index) {
    return _baseDataSource.isAllDay(
      _baseDataSource.appointments!.indexOf(_filteredAppointments[index]),
    );
  }
}
