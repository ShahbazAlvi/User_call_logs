//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../Provider/MeetingProvider/NoDateMeetingProvider.dart';
// import 'NotdateMeetingUpdate.dart';
//
// class NoDateMeetingScreen extends StatefulWidget {
//   const NoDateMeetingScreen({super.key});
//
//   @override
//   State<NoDateMeetingScreen> createState() => _NoDateMeetingScreenState();
// }
//
// class _NoDateMeetingScreenState extends State<NoDateMeetingScreen> {
//   String? userRole;
//   @override
//   void initState() {
//     super.initState();
//     _loadUserRole();
//     Future.microtask(() {
//       Provider.of<NoDateMeetingProvider>(context, listen: false)
//           .fetchMeetings();
//     });
//   }
//   Future<void> _loadUserRole() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userRole = prefs.getString('role') ?? 'user'; // default = user
//     });
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<NoDateMeetingProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: const Text('Meetings Without Follow-Up',
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
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : provider.meetings.isEmpty
//           ? const Center(child: Text('No meetings found'))
//           : ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: provider.meetings.length,
//         itemBuilder: (context, index) {
//           final item = provider.meetings[index];
//           final personName = (item.person?.persons.isNotEmpty ?? false)
//               ? item.person!.persons.first.fullName ?? "Unknown"
//               : "Unknown";
//           final productName = item.product?.name ?? "N/A";
//           final staffName =
//               item.person?.assignedStaff?.username ?? "Unassigned";
//
//           return Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 2,
//             margin: const EdgeInsets.symmetric(vertical: 6),
//             child: ListTile(
//               contentPadding: const EdgeInsets.all(10),
//               title: Text(
//                 item.companyName ?? "Unknown Company",
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("👤 Person: $personName"),
//                   Text("📦 Product: $productName"),
//                   Text("🧑‍💼 Staff: $staffName"),
//                   Text("📅 Status: ${item.status ?? 'N/A'}"),
//                 ],
//               ),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon:
//                     const Icon(Icons.edit, color: Color(0xFF5B86E5)),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               EditMeetingScreen(meeting: item),
//                         ),
//                       );
//                     },
//                   ),
//                   if (userRole == 'admin')
//                   IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: () async {
//                       await provider.deleteMeeting(item.id ?? '');
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//





import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Provider/MeetingProvider/NoDateMeetingProvider.dart';
import 'NotdateMeetingUpdate.dart';

class NoDateMeetingScreen extends StatefulWidget {
  const NoDateMeetingScreen({super.key});

  @override
  State<NoDateMeetingScreen> createState() => _NoDateMeetingScreenState();
}

class _NoDateMeetingScreenState extends State<NoDateMeetingScreen> {
  String? userRole;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    Future.microtask(() {
      Provider.of<NoDateMeetingProvider>(context, listen: false)
          .fetchMeetings();
    });
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role') ?? 'user';
    });
  }

  void _refreshMeetings() {
    Provider.of<NoDateMeetingProvider>(context, listen: false).fetchMeetings();
  }

  List<dynamic> _getFilteredMeetings(NoDateMeetingProvider provider) {
    var filtered = provider.meetings;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((meeting) {
        final companyName = meeting.companyName?.toLowerCase() ?? '';
        final personName = (meeting.person?.persons.isNotEmpty ?? false)
            ? meeting.person!.persons.first.fullName?.toLowerCase() ?? ''
            : '';
        final staffName =
            meeting.person?.assignedStaff?.username?.toLowerCase() ?? '';
        final productName = meeting.product?.name?.toLowerCase() ?? '';

        return companyName.contains(query) ||
            personName.contains(query) ||
            staffName.contains(query) ||
            productName.contains(query);
      }).toList();
    }

    return filtered;
  }

  void _showDeleteDialog(BuildContext context, String meetingId, String companyName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 48,
          ),
        ),
        title: Text(
          'Delete Meeting',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to delete this meeting?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '"$companyName"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<NoDateMeetingProvider>(context, listen: false)
                  .deleteMeeting(meetingId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Meeting deleted successfully'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'rescheduled':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Icons.access_time_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'rescheduled':
        return Icons.calendar_today_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: Consumer<NoDateMeetingProvider>(
        builder: (context, provider, child) {
          final filteredMeetings = _getFilteredMeetings(provider);

          return NestedScrollView(
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
                    'With Out Follow Up',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  centerTitle: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(80),
                    child: Container(
                      color: isDarkMode ? Colors.grey[900] : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          children: [
                            // Search Bar
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.search_rounded,
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: (value) {
                                        setState(() => _searchQuery = value);
                                      },
                                      style: const TextStyle(fontSize: 15),
                                      decoration: InputDecoration(
                                        hintText: 'Search meetings...',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  if (_searchQuery.isNotEmpty)
                                    IconButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                      icon: Icon(
                                        Icons.close_rounded,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: provider.isLoading
                ? _buildShimmerLoading()
                : provider.errorMessage.isNotEmpty
                ? _buildErrorState(provider.errorMessage, theme, isDarkMode)
                : filteredMeetings.isEmpty
                ? _buildEmptyState(context, _searchQuery, _searchController)
                : _buildMeetingList(context, filteredMeetings, theme, isDarkMode),
          );
        },
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

  Widget _buildErrorState(String error, ThemeData theme, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 20),
          Text(
            'Error Loading Meetings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<NoDateMeetingProvider>(context, listen: false).fetchMeetings();
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String searchQuery, TextEditingController searchController) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.meeting_room_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            searchQuery.isNotEmpty ? 'No Meetings Found' : 'No Pending Meetings',
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
              searchQuery.isNotEmpty
                  ? 'No meetings match your search'
                  : 'All meetings have been scheduled or completed',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (searchQuery.isNotEmpty)
            ElevatedButton.icon(
              onPressed: () {
                searchController.clear();
                setState(() => _searchQuery = '');
              },
              icon: const Icon(Icons.clear_all_rounded),
              label: const Text('Clear Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                foregroundColor: isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMeetingList(BuildContext context, List<dynamic> meetings, ThemeData theme, bool isDarkMode) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: meetings.length,
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        final personName = (meeting.person?.persons.isNotEmpty ?? false)
            ? meeting.person!.persons.first.fullName ?? "Unknown"
            : "Unknown";
        final productName = meeting.product?.name ?? "N/A";
        final staffName = meeting.person?.assignedStaff?.username ?? "Unassigned";
        final companyName = meeting.companyName ?? "Unknown Company";
        final status = meeting.status ?? 'Pending';
        final statusColor = _getStatusColor(status);
        final statusIcon = _getStatusIcon(status);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // Navigate to meeting details if needed
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with company name and status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            companyName,
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
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: statusColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcon,
                                size: 14,
                                color: statusColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Meeting details
                    _buildDetailRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Contact Person',
                      value: personName,
                      theme: theme,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 8),

                    _buildDetailRow(
                      icon: Icons.inventory_2_outlined,
                      label: 'Product',
                      value: productName,
                      theme: theme,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 8),

                    _buildDetailRow(
                      icon: Icons.engineering_outlined,
                      label: 'Assigned Staff',
                      value: staffName,
                      theme: theme,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditMeetingScreen(meeting: meeting),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.edit_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                            padding: const EdgeInsets.all(8),
                          ),
                          tooltip: 'Edit Meeting',
                        ),
                        const SizedBox(width: 8),
                        if (userRole == 'admin')
                          IconButton(
                            onPressed: () => _showDeleteDialog(
                              context,
                              meeting.id ?? '',
                              companyName,
                            ),
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: theme.colorScheme.error,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.error.withOpacity(0.1),
                              padding: const EdgeInsets.all(8),
                            ),
                            tooltip: 'Delete Meeting',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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