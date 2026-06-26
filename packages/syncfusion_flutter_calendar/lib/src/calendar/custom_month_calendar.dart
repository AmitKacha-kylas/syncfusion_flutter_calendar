import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';

enum NavigationMode { monthly, weekly }

/// A custom month calendar widget that displays a clean grid view with navigation.
///
/// Features:
/// - Month/year header with previous/next navigation
/// - Today button to jump to current date
/// - Calendar grid showing all days of the month
/// - Current date highlighted with a filled circle
/// - Event/meeting dates marked with small dots below the date number
/// - Selected date highlighted with a border circle
/// - Support for weekly or monthly navigation based on view state
class CustomMonthCalendar extends StatefulWidget {
  /// Creates a custom month calendar widget.
  const CustomMonthCalendar({
    Key? key,
    this.eventDates = const [],
    this.selectedDate,
    this.onDateSelected,
    this.onMonthChanged,
    this.navigationMode = NavigationMode.monthly,
  }) : super(key: key);

  /// List of dates with events/meetings (shows small indicator dots)
  final List<DateTime> eventDates;

  /// Currently selected date (shows border circle)
  final DateTime? selectedDate;

  /// Callback when a date is selected
  final Function(DateTime)? onDateSelected;

  /// Callback when month is changed
  final Function(DateTime)? onMonthChanged;

  /// Navigation mode: weekly (7 days) or monthly
  final NavigationMode navigationMode;

  @override
  State<CustomMonthCalendar> createState() => _CustomMonthCalendarState();
}

class _CustomMonthCalendarState extends State<CustomMonthCalendar> {
  late DateTime _displayedMonth;
  bool _showYearPickerView = false;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime.now();
  }

  /// Navigate to the week containing the specified date
  void navigateToDate(DateTime date) {
    setState(() {
      _displayedMonth = date;
    });
    widget.onMonthChanged?.call(_displayedMonth);
  }

  void _goToPreviousMonth() {
    if (_showYearPickerView) {
      return;
    }
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
    widget.onMonthChanged?.call(_displayedMonth);
  }

  void _goToNextMonth() {
    if (_showYearPickerView) {
      return;
    }
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
    widget.onMonthChanged?.call(_displayedMonth);
  }

  void _goToPreviousWeek() {
    if (_showYearPickerView) {
      return;
    }
    setState(() {
      _displayedMonth = _displayedMonth.subtract(const Duration(days: 7));
    });
    widget.onMonthChanged?.call(_displayedMonth);
  }

  void _goToNextWeek() {
    if (_showYearPickerView) {
      return;
    }
    setState(() {
      _displayedMonth = _displayedMonth.add(const Duration(days: 7));
    });
    widget.onMonthChanged?.call(_displayedMonth);
  }

  void _goToToday() {
    final today = DateTime.now();
    setState(() {
      _showYearPickerView = false;
      _displayedMonth = today;
    });
    widget.onMonthChanged?.call(_displayedMonth);
    widget.onDateSelected?.call(today);
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    // In weekly mode, return only the 7 days of the current week
    if (widget.navigationMode == NavigationMode.weekly) {
      return _getWeekDays(month);
    }

    // In monthly mode, return full month calendar (42 days)
    final first = DateTime(month.year, month.month);
    final last = DateTime(month.year, month.month + 1, 0);

    final days = <DateTime>[];
    for (var i = 0; i < first.weekday % 7; i++) {
      days.add(first.subtract(Duration(days: first.weekday % 7 - i)));
    }

    for (var i = 1; i <= last.day; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    final remainingDays = 42 - days.length;
    for (var i = 1; i <= remainingDays; i++) {
      days.add(last.add(Duration(days: i)));
    }

    return days;
  }

  List<DateTime> _getWeekDays(DateTime date) {
    // Get the start of the week (Sunday) for the given date
    final weekStart = date.subtract(Duration(days: date.weekday % 7));

    // Return 7 consecutive days starting from Sunday
    return List.generate(7, (index) => weekStart.add(Duration(days: index)));
  }

  bool _isCurrentDate(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  bool _isSelectedDate(DateTime date) {
    final selected = widget.selectedDate;
    if (selected == null) {
      return false;
    }
    return selected.year == date.year &&
        selected.month == date.month &&
        selected.day == date.day;
  }

  bool _hasEvent(DateTime date) {
    return widget.eventDates.any((eventDate) =>
        eventDate.year == date.year &&
        eventDate.month == date.month &&
        eventDate.day == date.day);
  }

  bool _isCurrentMonth(DateTime date) {
    return date.month == _displayedMonth.month &&
        date.year == _displayedMonth.year;
  }

  String _getHeaderText() {
    if (_showYearPickerView) {
      return 'Select Year';
    }
    if (widget.navigationMode == NavigationMode.weekly) {
      final weekStart =
          _displayedMonth.subtract(Duration(days: _displayedMonth.weekday % 7));
      final weekEnd = weekStart.add(const Duration(days: 6));
      return '${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d').format(weekEnd)}';
    }
    return DateFormat('MMMM yyyy').format(_displayedMonth);
  }

  void _toggleYearPicker() {
    setState(() {
      if (_showYearPickerView) {
        _showYearPickerView = false;
        if (widget.selectedDate != null) {
          _displayedMonth = DateTime(widget.selectedDate!.year, widget.selectedDate!.month);
        }
      } else {
        _showYearPickerView = true;
      }
    });
  }

  void _selectYear(int year) {
    setState(() {
      _displayedMonth = DateTime(year, _displayedMonth.month);
      _showYearPickerView = false;
    });
    widget.onMonthChanged?.call(_displayedMonth);
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth(_displayedMonth);
    final headerText = _getHeaderText();

    // Get theme colors
    final themeData = Theme.of(context);
    final calendarTheme = SfCalendarTheme.of(context);

    // Theme-based colors
    final primaryColor = calendarTheme.todayHighlightColor ?? const Color(0xFF5B6EFF);
    final primaryColorLight = calendarTheme.headerBackgroundColor ?? const Color(0xFFEBF3FF);
    final textColorPrimary = themeData.brightness == Brightness.dark ? Colors.white : Colors.black87;
    final textColorSecondary = themeData.brightness == Brightness.dark ? Colors.grey[400] : const Color(0xFF687790);
    final backgroundColor = calendarTheme.activeDatesBackgroundColor ?? const Color(0xFFf5f5f5);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (_showYearPickerView || details.primaryVelocity == null) {
          return;
        }

        if (widget.navigationMode == NavigationMode.weekly) {
          if (details.primaryVelocity! > 0) {
            _goToPreviousWeek();
          } else if (details.primaryVelocity! < 0) {
            _goToNextWeek();
          }
        } else {
          if (details.primaryVelocity! > 0) {
            _goToPreviousMonth();
          } else if (details.primaryVelocity! < 0) {
            _goToNextMonth();
          }
        }
      },
      child: ClipRect(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header with navigation
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: widget.navigationMode == NavigationMode.weekly
                          ? _goToPreviousWeek
                          : _goToPreviousMonth,
                    ),
                    GestureDetector(
                      onTap: _toggleYearPicker,
                      child: Text(
                        headerText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _goToToday,
                          behavior: HitTestBehavior.opaque,
                          child: Builder(
                            builder: (context) {
                              final today = DateTime.now();
                              final isSelectedToday = widget.selectedDate !=
                                      null &&
                                  widget.selectedDate!.year == today.year &&
                                  widget.selectedDate!.month == today.month &&
                                  widget.selectedDate!.day == today.day;

                              return Container(
                                decoration: BoxDecoration(
                                    color: isSelectedToday
                                        ? primaryColorLight
                                        : backgroundColor,
                                    borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Today',
                                  style: TextStyle(
                                    color: isSelectedToday
                                        ? primaryColor
                                        : textColorSecondary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed:
                              widget.navigationMode == NavigationMode.weekly
                                  ? _goToNextWeek
                                  : _goToNextMonth,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_showYearPickerView)
                _YearPickerView(
                  selectedYear:
                      widget.selectedDate?.year ?? _displayedMonth.year,
                  onYearSelected: _selectYear,
                  primaryColor: primaryColor,
                  textColorPrimary: textColorPrimary,
                )
              else ...[
                // Day labels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 7,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 3,
                    children: [
                      'Su',
                      'Mo',
                      'Tu',
                      'We',
                      'Th',
                      'Fr',
                      'Sa',
                    ].map((day) {
                      return Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            color: textColorSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Calendar grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 7,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio:
                        widget.navigationMode == NavigationMode.weekly
                            ? 1.0
                            : 1.0,
                    children: days.map((date) {
                      final isCurrent = _isCurrentDate(date);
                      final isSelected = _isSelectedDate(date);
                      final hasEvent = _hasEvent(date);
                      final isCurrentMonth = _isCurrentMonth(date);

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          widget.onDateSelected?.call(date);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Date number with indicator circle
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Filled circle for current date
                                if (isSelected)
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                // Border circle for selected date
                                if (isCurrent)
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: primaryColor.withValues(alpha: 0.2),
                                      border: Border.all(
                                        color: primaryColor,
                                        width: 1.5,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : isCurrentMonth
                                            ? textColorPrimary
                                            : textColorSecondary,
                                  ),
                                ),
                              ],
                            ),
                            // Indicator dot for event dates (always reserve space)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: (hasEvent && !isCurrent) || isCurrent
                                      ? primaryColor
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _YearPickerView extends StatefulWidget {
  const _YearPickerView({
    required this.selectedYear,
    required this.onYearSelected,
    required this.primaryColor,
    required this.textColorPrimary,
  });

  final int selectedYear;
  final Function(int) onYearSelected;
  final Color primaryColor;
  final Color textColorPrimary;

  @override
  State<_YearPickerView> createState() => _YearPickerViewState();
}

class _YearPickerViewState extends State<_YearPickerView> {
  final int _startYear = 1980;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToSelectedYear();
    });
  }

  void _scrollToSelectedYear() {
    final selectedIndex = widget.selectedYear - _startYear;
    final rowIndex = selectedIndex ~/ 3;
    const rowHeight = 60.0;
    final itemPosition = rowIndex * rowHeight;
    final offset = (itemPosition - 60).clamp(0.0, double.infinity);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const endYear = 2100;
    final years = List.generate(endYear - _startYear, (i) => _startYear + i);

    return LimitedBox(
      maxHeight: 300,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.0,
            crossAxisSpacing: 10,
            children: years.map((year) {
              final isSelected = year == widget.selectedYear;

              return GestureDetector(
                onTap: () => widget.onYearSelected(year),
                child: Center(
                  child: Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? widget.primaryColor
                          : Colors.transparent,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      year.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : widget.textColorPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
