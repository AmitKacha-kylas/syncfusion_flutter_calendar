import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'appointment_engine/calendar_datasource.dart';
import 'common/calendar_controller.dart';
import 'common/enums.dart';
import 'common/event_args.dart';
import 'custom_month_calendar.dart' as month_cal;
import 'settings/drag_and_drop_settings.dart';
import 'settings/header_style.dart';
import 'settings/month_view_settings.dart';
import 'settings/resource_view_settings.dart';
import 'settings/schedule_view_settings.dart';
import 'settings/time_region.dart';
import 'settings/time_slot_view_settings.dart';
import 'settings/view_header_style.dart';
import 'settings/week_number_style.dart';
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
    this.onMonthChanged,
    this.timeSlotViewSettings,
    this.view = CalendarView.day,
    this.firstDayOfWeek = 7,
    this.headerHeight = 40,
    this.viewHeaderHeight = -1,
    this.todayHighlightColor,
    this.todayTextStyle,
    this.cellBorderColor,
    this.backgroundColor,
    this.timeZone,
    this.selectionDecoration,
    this.onViewChanged,
    this.onTap,
    this.onLongPress,
    this.onSelectionChanged,
    this.appointmentTimeTextFormat,
    this.blackoutDates,
    this.scheduleViewMonthHeaderBuilder,
    this.monthCellBuilder,
    this.appointmentBuilder,
    this.timeRegionBuilder,
    this.headerDateFormat,
    this.headerStyle = const CalendarHeaderStyle(),
    this.viewHeaderStyle = const ViewHeaderStyle(),
    this.resourceViewSettings = const ResourceViewSettings(),
    this.monthViewSettings = const MonthViewSettings(),
    this.initialDisplayDate,
    this.initialSelectedDate,
    this.scheduleViewSettings = const ScheduleViewSettings(),
    this.appointmentTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: -1,
      fontWeight: FontWeight.w500,
    ),
    this.showNavigationArrow = false,
    this.showDatePickerButton = false,
    this.showTodayButton = false,
    this.allowViewNavigation = false,
    this.showCurrentTimeIndicator = true,
    this.cellEndPadding = -1,
    this.viewNavigationMode = ViewNavigationMode.snap,
    this.allowedViews,
    this.specialRegions,
    this.loadMoreWidgetBuilder,
    this.blackoutDatesTextStyle,
    this.showWeekNumber = false,
    this.weekNumberStyle = const WeekNumberStyle(),
    this.resourceViewHeaderBuilder,
    this.allowAppointmentResize = false,
    this.onAppointmentResizeStart,
    this.onAppointmentResizeUpdate,
    this.onAppointmentResizeEnd,
    this.allowDragAndDrop = false,
    this.dragAndDropSettings = const DragAndDropSettings(),
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.minDate,
    this.maxDate,
    this.dayViewTopWidget,
    this.minMonthCalendarHeight = 120,
    this.maxMonthCalendarHeight = 600,
    this.minDayViewHeight = 150,
    this.maxDayViewHeight = 600,
  }) : super(key: key);

  /// Calendar data source containing all appointments/events
  final CalendarDataSource dataSource;

  /// Callback when a date is selected in the month calendar
  final Function(DateTime)? onDateSelected;

  /// Callback when the visible month is changed in the month calendar, provides the displayed month and year
  final Function(DateTime)? onMonthChanged;

  /// Time slot view settings for SfCalendar (default: 30 min intervals)
  final TimeSlotViewSettings? timeSlotViewSettings;

  /// The view of the calendar to be displayed
  final CalendarView view;

  /// The first day of the week (1-7, where 7 is Sunday)
  final int firstDayOfWeek;

  /// The height of the header view in calendar
  final double headerHeight;

  /// The height of the view header in calendar
  final double viewHeaderHeight;

  /// The color used to highlight today in the calendar
  final Color? todayHighlightColor;

  /// The text style for today in the calendar
  final TextStyle? todayTextStyle;

  /// The color of the cell border in calendar
  final Color? cellBorderColor;

  /// The background color of the calendar
  final Color? backgroundColor;

  /// The time zone for the calendar
  final String? timeZone;

  /// The selection decoration for the selected cell
  final Decoration? selectionDecoration;

  /// Called when the calendar view is changed
  final ViewChangedCallback? onViewChanged;

  /// Called when a calendar element is tapped
  final CalendarTapCallback? onTap;

  /// Called when a calendar element is long pressed
  final CalendarLongPressCallback? onLongPress;

  /// Called when the selection is changed
  final CalendarSelectionChangedCallback? onSelectionChanged;

  /// The appointment time text format
  final String? appointmentTimeTextFormat;

  /// The list of blackout dates
  final List<DateTime>? blackoutDates;

  /// The builder for the schedule view month header
  final ScheduleViewMonthHeaderBuilder? scheduleViewMonthHeaderBuilder;

  /// The builder for month cells
  final MonthCellBuilder? monthCellBuilder;

  /// The builder for appointments
  final CalendarAppointmentBuilder? appointmentBuilder;

  /// The builder for time regions
  final TimeRegionBuilder? timeRegionBuilder;

  /// The header date format
  final String? headerDateFormat;

  /// The style for the calendar header
  final CalendarHeaderStyle headerStyle;

  /// The style for the view header
  final ViewHeaderStyle viewHeaderStyle;

  /// The settings for the resource view
  final ResourceViewSettings resourceViewSettings;

  /// The settings for the month view
  final MonthViewSettings monthViewSettings;

  /// The initial display date
  final DateTime? initialDisplayDate;

  /// The initial selected date
  final DateTime? initialSelectedDate;

  /// The settings for the schedule view
  final ScheduleViewSettings scheduleViewSettings;

  /// The text style for appointments
  final TextStyle appointmentTextStyle;

  /// Whether to show the navigation arrow
  final bool showNavigationArrow;

  /// Whether to show the date picker button
  final bool showDatePickerButton;

  /// Whether to show the today button
  final bool showTodayButton;

  /// Whether to allow view navigation
  final bool allowViewNavigation;

  /// Whether to show the current time indicator
  final bool showCurrentTimeIndicator;

  /// The end padding for cells
  final double cellEndPadding;

  /// The view navigation mode
  final ViewNavigationMode viewNavigationMode;

  /// The allowed views for navigation
  final List<CalendarView>? allowedViews;

  /// The special time regions
  final List<TimeRegion>? specialRegions;

  /// The builder for the load more widget
  final LoadMoreWidgetBuilder? loadMoreWidgetBuilder;

  /// The text style for blackout dates
  final TextStyle? blackoutDatesTextStyle;

  /// Whether to show week numbers
  final bool showWeekNumber;

  /// The style for week numbers
  final WeekNumberStyle weekNumberStyle;

  /// The builder for the resource view header
  final ResourceViewHeaderBuilder? resourceViewHeaderBuilder;

  /// Whether to allow appointment resizing
  final bool allowAppointmentResize;

  /// Called when appointment resize starts
  final AppointmentResizeStartCallback? onAppointmentResizeStart;

  /// Called when appointment resize is updated
  final AppointmentResizeUpdateCallback? onAppointmentResizeUpdate;

  /// Called when appointment resize ends
  final AppointmentResizeEndCallback? onAppointmentResizeEnd;

  /// Whether to allow drag and drop
  final bool allowDragAndDrop;

  /// The settings for drag and drop
  final DragAndDropSettings dragAndDropSettings;

  /// Called when drag starts
  final AppointmentDragStartCallback? onDragStart;

  /// Called when drag is updated
  final AppointmentDragUpdateCallback? onDragUpdate;

  /// Called when drag ends
  final AppointmentDragEndCallback? onDragEnd;

  /// The minimum date for the calendar
  final DateTime? minDate;

  /// The maximum date for the calendar
  final DateTime? maxDate;

  /// Optional widget to display above the day view calendar
  final Widget? dayViewTopWidget;

  /// Minimum height for the month calendar view
  final double minMonthCalendarHeight;

  /// Maximum height for the month calendar view
  final double maxMonthCalendarHeight;

  /// Minimum height for the day view calendar
  final double minDayViewHeight;

  /// Maximum height for the day view calendar
  final double maxDayViewHeight;

  @override
  State<IntegratedMonthCalendar> createState() =>
      _IntegratedMonthCalendarState();
}

class _IntegratedMonthCalendarState extends State<IntegratedMonthCalendar> {
  late DateTime selectedDate;
  late List<DateTime> eventDates;
  double monthCalendarHeight = 380;
  double dayViewHeight = 450;
  month_cal.NavigationMode _previousNavigationMode =
      month_cal.NavigationMode.monthly;
  final _calendarKey = GlobalKey();
  late CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    eventDates = _extractEventDates();
    _calendarController = CalendarController();
  }

  void _onVerticalDragStart(DragStartDetails details) {}

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      monthCalendarHeight += details.delta.dy;
      dayViewHeight -= details.delta.dy;
      monthCalendarHeight = monthCalendarHeight.clamp(
        widget.minMonthCalendarHeight,
        widget.maxMonthCalendarHeight,
      );
      dayViewHeight = dayViewHeight.clamp(
        widget.minDayViewHeight,
        widget.maxDayViewHeight,
      );
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {}

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
        const dragHandleMargin = 175.0;
        final availableHeight =
            totalHeight - dragHandleHeight - dragHandleMargin;

        final ratio =
            monthCalendarHeight / (monthCalendarHeight + dayViewHeight);
        var monthHeight = availableHeight * ratio;

        monthHeight = monthHeight.clamp(150.0, availableHeight);

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
                  onMonthChanged: (month) {
                    widget.onMonthChanged?.call(month);
                  },
                ),
              ),
            ),
            Builder(
              builder: (context) {
                final calendarTheme = SfCalendarTheme.of(context);
                final handleBackgroundColor =
                    calendarTheme.headerBackgroundColor ?? Colors.white;
                final handleIndicatorColor =
                    calendarTheme.cellBorderColor ?? Colors.grey[400];

                return GestureDetector(
                  onVerticalDragStart: _onVerticalDragStart,
                  onVerticalDragUpdate: _onVerticalDragUpdate,
                  onVerticalDragEnd: _onVerticalDragEnd,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeRow,
                    child: Container(
                      height: dragHandleHeight,
                      color: handleBackgroundColor,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Container(
                          width: 50,
                          height: 4,
                          decoration: BoxDecoration(
                            color: handleIndicatorColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (widget.dayViewTopWidget != null) widget.dayViewTopWidget!,
            Expanded(
              child: _buildSfCalendar(),
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

    final minDate = widget.minDate ?? DateTime(01);
    final maxDate = widget.maxDate ?? DateTime(9999, 12, 31);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calendarController.displayDate = selectedDate;
    });

   final calendar = SfCalendar(
      dataSource: _FilteredDataSource(
        widget.dataSource,
        selectedDate,
      ),
      view: widget.view,
      firstDayOfWeek: widget.firstDayOfWeek,
      headerHeight: widget.headerHeight,
      viewHeaderHeight: widget.viewHeaderHeight,
      todayHighlightColor: widget.todayHighlightColor,
      todayTextStyle: widget.todayTextStyle,
      cellBorderColor: widget.cellBorderColor,
      backgroundColor: widget.backgroundColor,
      timeZone: widget.timeZone,
      selectionDecoration: widget.selectionDecoration,
      onViewChanged: widget.onViewChanged,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onSelectionChanged: widget.onSelectionChanged,
      controller: _calendarController,
      appointmentTimeTextFormat: widget.appointmentTimeTextFormat,
      blackoutDates: widget.blackoutDates,
      scheduleViewMonthHeaderBuilder: widget.scheduleViewMonthHeaderBuilder,
      monthCellBuilder: widget.monthCellBuilder,
      appointmentBuilder: widget.appointmentBuilder,
      timeRegionBuilder: widget.timeRegionBuilder,
      headerDateFormat: widget.headerDateFormat,
      headerStyle: widget.headerStyle,
      viewHeaderStyle: widget.viewHeaderStyle,
      timeSlotViewSettings: timeSettings,
      resourceViewSettings: widget.resourceViewSettings,
      monthViewSettings: widget.monthViewSettings,
      initialDisplayDate: selectedDate,
      initialSelectedDate: selectedDate,
      scheduleViewSettings: widget.scheduleViewSettings,
      appointmentTextStyle: widget.appointmentTextStyle,
      showNavigationArrow: widget.showNavigationArrow,
      showDatePickerButton: widget.showDatePickerButton,
      showTodayButton: widget.showTodayButton,
      allowViewNavigation: widget.allowViewNavigation,
      showCurrentTimeIndicator: widget.showCurrentTimeIndicator,
      cellEndPadding: widget.cellEndPadding,
      viewNavigationMode: widget.viewNavigationMode,
      allowedViews: widget.allowedViews,
      specialRegions: widget.specialRegions,
      loadMoreWidgetBuilder: widget.loadMoreWidgetBuilder,
      blackoutDatesTextStyle: widget.blackoutDatesTextStyle,
      showWeekNumber: widget.showWeekNumber,
      weekNumberStyle: widget.weekNumberStyle,
      resourceViewHeaderBuilder: widget.resourceViewHeaderBuilder,
      allowAppointmentResize: widget.allowAppointmentResize,
      onAppointmentResizeStart: widget.onAppointmentResizeStart,
      onAppointmentResizeUpdate: widget.onAppointmentResizeUpdate,
      onAppointmentResizeEnd: widget.onAppointmentResizeEnd,
      allowDragAndDrop: widget.allowDragAndDrop,
      dragAndDropSettings: widget.dragAndDropSettings,
      onDragStart: widget.onDragStart,
      onDragUpdate: widget.onDragUpdate,
      onDragEnd: widget.onDragEnd,
      minDate: minDate,
      maxDate: maxDate,
    );

    return SfCalendarTheme(
      data: SfCalendarTheme.of(context),
      child: calendar,
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
