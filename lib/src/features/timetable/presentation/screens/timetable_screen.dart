import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/reform_timetable_model.dart';
import 'package:hubtsocial_mobile/src/features/timetable/presentation/bloc/timetable_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../main_wrapper/presentation/widgets/main_app_bar.dart';
import '../widgets/timetable_card.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late final ValueNotifier<List<ReformTimetable>> _selectedEvents =
      ValueNotifier([]);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late LinkedHashMap<DateTime, List<ReformTimetable>> eventsForDay;
  bool _isEventsInitialized = false;
  @override
  void initState() {
    context.read<TimetableBloc>().add(const InitTimetableEvent());
    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<ReformTimetable> _getEventsForDay(DateTime day) {
    return eventsForDay[day] ?? [];
  }

  // List<ReformTimetable> _getEventsForRange(DateTime start, DateTime end) {
  //   // Implementation example
  //   final days = daysInRange(start, end);

  //   return [
  //     for (final d in days) ..._getEventsForDay(d),
  //   ];
  // }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      // _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  Map<DateTime, List<ReformTimetable>> convertTimetableListToMap(
      List<ReformTimetable> timetableList) {
    final Map<DateTime, List<ReformTimetable>> timetableMap = {};

    for (final timetable in timetableList) {
      if (timetable.startTime != null) {
        final date = DateTime(
          timetable.startTime!.year,
          timetable.startTime!.month,
          timetable.startTime!.day,
        );

        if (timetableMap.containsKey(date)) {
          timetableMap[date]!.add(timetable);
        } else {
          timetableMap[date] = [timetable];
        }
      }
    }

    return timetableMap;
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        MainAppBar(
          title: context.loc.timetable,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                context.read<TimetableBloc>().add(const InitTimetableEvent());
              },
            ),
          ],
        )
      ],
      body:
          BlocBuilder<TimetableBloc, TimetableState>(builder: (context, state) {
        if (state is TimetableLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TimetableError) {
          return Center(
            child: Text(
              state.message,
              style: context.textTheme.titleMedium,
            ),
          );
        }
        if (state is InitTimetableSuccess) {
          eventsForDay = LinkedHashMap<DateTime, List<ReformTimetable>>(
            equals: isSameDay,
            hashCode: getHashCode,
          )..addAll(
              convertTimetableListToMap(state.timetableModel.reformTimetables));
          _selectedDay = _focusedDay;

          if (!_isEventsInitialized) {
            _selectedEvents.value = _getEventsForDay(_selectedDay!);
            _isEventsInitialized = true;
          }
          return Column(
            children: [
              TableCalendar<ReformTimetable>(
                firstDay: state.timetableModel.starttime,
                lastDay: state.timetableModel.endtime,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                ),
                onDaySelected: _onDaySelected,
                onRangeSelected: _onRangeSelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ValueListenableBuilder<List<ReformTimetable>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return TimetableCard(
                          reformTimetable: value[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const Center(
          child: Text("No data"),
        );
      }),
    );
  }
}
