
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
// import '../../Provider/MeetingProvider/Meeting_provider.dart';
//
// class UpcomingMeetingsScreen extends StatefulWidget {
//   const UpcomingMeetingsScreen({super.key});
//
//   @override
//   State<UpcomingMeetingsScreen> createState() =>
//       _UpcomingMeetingsScreenState();
// }
//
// class _UpcomingMeetingsScreenState extends State<UpcomingMeetingsScreen> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() =>
//         Provider.of<MeetingProvider>(context, listen: false)
//             .fetchUpcomingMeetings());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<MeetingProvider>(context);
//     final meetingsForSelectedDate = _selectedDay != null
//         ? provider.getMeetingsForDate(_selectedDay!)
//         : [];
//
//     final currentMonth = DateFormat.MMMM().format(_focusedDay);
//
//     return Scaffold(
//       appBar: AppBar(
//
//
//         title: Center(child: Text( "$currentMonth - All Meetings",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 22,
//               letterSpacing: 1.2,
//             )),
//         ),
//         centerTitle: true,
//         elevation: 6,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       // appBar: AppBar(
//       //   backgroundColor: Colors.indigo,
//       //   iconTheme: const IconThemeData(color: Colors.white),
//       //   title: Text(
//       //     "$currentMonth - All Meetings",
//       //     style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
//       //   ),
//       // ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           // 🔹 Calendar
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TableCalendar(
//               firstDay: DateTime.utc(2024, 1, 1),
//               lastDay: DateTime.utc(2026, 12, 31),
//               focusedDay: _focusedDay,
//               selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//               calendarFormat: CalendarFormat.month,
//               onDaySelected: (selectedDay, focusedDay) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//               },
//               onPageChanged: (focusedDay) {
//                 setState(() => _focusedDay = focusedDay);
//               },
//               calendarStyle: CalendarStyle(
//                 todayDecoration: BoxDecoration(
//                   color: Colors.indigo.shade300,
//                   shape: BoxShape.circle,
//                 ),
//                 selectedDecoration: BoxDecoration(
//                   color: Colors.indigo,
//                   shape: BoxShape.circle,
//                 ),
//                 outsideDaysVisible: false,
//               ),
//               // ✅ Highlight days with meetings
//               calendarBuilders: CalendarBuilders(
//                 defaultBuilder: (context, day, _) {
//                   final meetings = provider.getMeetingsForDate(day);
//                   final hasMeeting = meetings.isNotEmpty;
//
//                   if (hasMeeting) {
//                     // 🟢 Highlight meeting days
//                     return Container(
//                       margin: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: Colors.greenAccent.withOpacity(0.4),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Text(
//                           '${day.day}',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.indigo,
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//
//                   // Normal day
//                   return Center(
//                     child: Text(
//                       '${day.day}',
//                       style: const TextStyle(color: Colors.black),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           // 🔹 Meeting list
//           Expanded(
//             child: meetingsForSelectedDate.isEmpty
//                 ? const Center(
//               child: Text(
//                 "No meetings on this day",
//                 style: TextStyle(fontSize: 16),
//               ),
//             )
//                 : ListView.builder(
//               itemCount: meetingsForSelectedDate.length,
//               itemBuilder: (context, index) {
//                 final meeting = meetingsForSelectedDate[index];
//                 final company =
//                     meeting['companyName'] ?? "Unknown";
//                 final person = meeting['person'] ?? "";
//                 final times = (meeting['times'] as List)
//                     .map((t) => t.toString())
//                     .join(", ");
//                 final timeline = meeting['timeline'] ?? '';
//
//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                       horizontal: 12, vertical: 6),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: ListTile(
//                     leading: const Icon(Icons.business,
//                         color: Colors.indigo),
//                     title: Text(company),
//                     subtitle:
//                     Text("Person: $person\nTime: $times"),
//                     trailing: Text(
//                       timeline,
//                       style: TextStyle(
//                         color: timeline == 'Hold'
//                             ? Colors.orange
//                             : Colors.green,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../Provider/MeetingProvider/Meeting_provider.dart';

class UpcomingMeetingsScreen extends StatefulWidget {
  const UpcomingMeetingsScreen({super.key});

  @override
  State<UpcomingMeetingsScreen> createState() =>
      _UpcomingMeetingsScreenState();
}

class _UpcomingMeetingsScreenState extends State<UpcomingMeetingsScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _selectedFilter = 'All';
  List<String> _filters = ['All', 'Hold', 'Follow Up', 'Completed'];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    Future.microtask(() =>
        Provider.of<MeetingProvider>(context, listen: false)
            .fetchUpcomingMeetings());
  }

  void _refreshMeetings() {
    Provider.of<MeetingProvider>(context, listen: false)
        .fetchUpcomingMeetings();
  }

  Color _getTimelineColor(String timeline) {
    switch (timeline.toLowerCase()) {
      case 'hold':
        return Colors.orange;
      case 'follow up':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getTimelineIcon(String timeline) {
    switch (timeline.toLowerCase()) {
      case 'hold':
        return Icons.pause_circle_filled_rounded;
      case 'follow up':
        return Icons.update_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final provider = Provider.of<MeetingProvider>(context);

    final meetingsForSelectedDate = _selectedDay != null
        ? provider.getMeetingsForDate(_selectedDay!)
        : [];

    // Apply filter
    final filteredMeetings = _selectedFilter == 'All'
        ? meetingsForSelectedDate
        : meetingsForSelectedDate.where((meeting) {
      final timeline = meeting['timeline']?.toString().toLowerCase() ?? '';
      return timeline.contains(_selectedFilter.toLowerCase());
    }).toList();

    final currentMonth = DateFormat.MMMM().format(_focusedDay);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 120,
              elevation: 4,
              backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
              surfaceTintColor: isDarkMode ? Colors.grey[800] : Colors.white,
              actions: [
                IconButton(
                  onPressed: _refreshMeetings,
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh',
                ),
              ],
              title: Text(
                '$currentMonth - Meetings',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _filters.map((filter) {
                          final isSelected = _selectedFilter == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(
                                filter,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() => _selectedFilter = selected ? filter : 'All');
                              },
                              backgroundColor: isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                              selectedColor: theme.colorScheme.primary
                                  .withOpacity(0.2),
                              checkmarkColor: theme.colorScheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : Colors.grey[700],
                                fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : Colors.transparent,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: provider.isLoading
            ? _buildShimmerLoading()
            : _buildContent(theme, isDarkMode, provider, filteredMeetings),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 140,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
      ThemeData theme,
      bool isDarkMode,
      MeetingProvider provider,
      List<dynamic> filteredMeetings,
      ) {
    final selectedDateText = _selectedDay != null
        ? DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay!)
        : DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Column(
      children: [
        // Calendar Container
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
                CalendarFormat.week: 'Week',
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
              },
              onPageChanged: (focusedDay) {
                setState(() => _focusedDay = focusedDay);
              },
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
                weekendTextStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
                outsideTextStyle: TextStyle(
                  color: Colors.grey[500],
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                todayTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                todayDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                weekendDecoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                outsideDecoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                defaultDecoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                holidayDecoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                cellPadding: const EdgeInsets.all(4),
                tableBorder: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.grey[300]!,
                    width: 0.5,
                  ),
                  verticalInside: BorderSide(
                    color: Colors.grey[300]!,
                    width: 0.5,
                  ),
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                formatButtonTextStyle: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                titleTextStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left_rounded,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                headerPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Highlight days with meetings
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final meetings = provider.getMeetingsForDate(day);
                  final hasMeeting = meetings.isNotEmpty;
                  final isToday = isSameDay(day, DateTime.now());
                  final isSelected = isSameDay(day, _selectedDay);

                  if (hasMeeting && !isSelected && !isToday) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.grey[800],
                          ),
                        ),
                      ),
                    );
                  }

                  return null;
                },
                markerBuilder: (context, day, events) {
                  final meetings = provider.getMeetingsForDate(day);
                  if (meetings.isNotEmpty) {
                    return Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),

        // Selected Date Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: theme.colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                selectedDateText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${filteredMeetings.length} Meeting${filteredMeetings.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Meeting List
        Expanded(
          child: filteredMeetings.isEmpty
              ? _buildEmptyState(isDarkMode)
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: filteredMeetings.length,
            itemBuilder: (context, index) {
              final meeting = filteredMeetings[index];
              final company = meeting['companyName'] ?? "Unknown";
              final person = meeting['person'] ?? "No Contact";
              final times = (meeting['times'] as List)
                  .map((t) => t.toString())
                  .join(", ");
              final timeline = meeting['timeline']?.toString() ?? '';
              final timelineColor = _getTimelineColor(timeline);
              final timelineIcon = _getTimelineIcon(timeline);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with company and timeline
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                company,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: timelineColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: timelineColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    timelineIcon,
                                    size: 14,
                                    color: timelineColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    timeline.isNotEmpty ? timeline : 'No Status',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: timelineColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Contact Person
                        _buildDetailRow(
                          icon: Icons.person_outline_rounded,
                          label: 'Contact Person',
                          value: person,
                          theme: theme,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 8),

                        // Meeting Time
                        _buildDetailRow(
                          icon: Icons.access_time_rounded,
                          label: 'Meeting Time',
                          value: times,
                          theme: theme,
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No Meetings Scheduled',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'No meetings are scheduled for the selected date',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
    required bool isDarkMode,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}