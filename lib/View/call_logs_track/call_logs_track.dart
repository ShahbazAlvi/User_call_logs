// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../Provider/callLogsProvider/callLogsProvider.dart';
//
// class CallLogsScreen extends StatefulWidget {
//   const CallLogsScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CallLogsScreen> createState() => _CallLogsScreenState();
// }
//
// class _CallLogsScreenState extends State<CallLogsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<CallLogsProvider>(context, listen: false).fetchCallLogs();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CallLogsProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: const Text('Meeting Call Logs Track',
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
//
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : provider.callLogs.isEmpty
//           ? const Center(child: Text("No call logs found."))
//           : ListView.builder(
//         padding: const EdgeInsets.all(8),
//         itemCount: provider.callLogs.length,
//         itemBuilder: (context, index) {
//           final log = provider.callLogs[index];
//
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 6),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 3,
//             child: ListTile(
//               contentPadding: const EdgeInsets.all(10),
//               title: Text(
//                 log.customerName,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("📞 ${log.phoneNumber}"),
//                   Text("👩‍💼 ${log.staffName}"),
//                   Text("🕒 ${log.date} - ${log.time}"),
//                   Text("📍 ${log.location}"),
//                 ],
//               ),
//               trailing: IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.red),
//                 onPressed: () async {
//                   final confirm = await showDialog<bool>(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: const Text("Delete Call Log"),
//                       content: const Text(
//                           "Are you sure you want to delete this call log?"),
//                       actions: [
//                         TextButton(
//                           onPressed: () =>
//                               Navigator.pop(context, false),
//                           child: const Text("Cancel"),
//                         ),
//                         TextButton(
//                           onPressed: () =>
//                               Navigator.pop(context, true),
//                           child: const Text(
//                             "Delete",
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//
//                   if (confirm == true) {
//                     final body = {
//                       "customerName": log.customerName,
//                       "phoneNumber": log.phoneNumber,
//                       "staffName": log.staffName,
//                       "date": log.date,
//                       "time": log.time,
//                       "mode": log.mode,
//                       "location": log.location,
//                     };
//
//                     final success = await provider.deleteCallLog(
//                       id: log.id,
//                       body: body,
//                     );
//
//                     if (success) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content:
//                           Text("✅ Call log deleted successfully"),
//                         ),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content:
//                           Text("❌ Failed to delete call log"),
//                         ),
//                       );
//                     }
//                   }
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import '../../Provider/callLogsProvider/callLogsProvider.dart';

class CallLogsScreen extends StatefulWidget {
  const CallLogsScreen({Key? key}) : super(key: key);

  @override
  State<CallLogsScreen> createState() => _CallLogsScreenState();
}

class _CallLogsScreenState extends State<CallLogsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  String _selectedMode = 'All';
  List<String> _modes = ['All', 'Call', 'WhatsApp'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CallLogsProvider>(context, listen: false).fetchCallLogs();
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Handle scroll for any future features
  }

  void _refreshCallLogs() {
    Provider.of<CallLogsProvider>(context, listen: false).fetchCallLogs();
  }

  // Use dynamic type or check your actual model name
  List<dynamic> _getFilteredCallLogs(CallLogsProvider provider) {
    var filtered = provider.callLogs;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((log) {
        final customerName = (log.customerName ?? '').toString().toLowerCase();
        final staffName = (log.staffName ?? '').toString().toLowerCase();
        final phoneNumber = (log.phoneNumber ?? '').toString().toLowerCase();
        final location = (log.location ?? '').toString().toLowerCase();

        return customerName.contains(query) ||
            staffName.contains(query) ||
            phoneNumber.contains(query) ||
            location.contains(query);
      }).toList();
    }

    // Apply mode filter
    if (_selectedMode != 'All') {
      filtered = filtered.where((log) => (log.mode ?? '') == _selectedMode).toList();
    }

    // Sort by date and time (newest first)
    filtered.sort((a, b) {
      try {
        final dateTimeA = DateTime.parse("${a.date} ${a.time}");
        final dateTimeB = DateTime.parse("${b.date} ${b.time}");
        return dateTimeB.compareTo(dateTimeA);
      } catch (e) {
        return 0;
      }
    });

    return filtered;
  }

  void _showDeleteDialog(BuildContext context, dynamic log) {
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
          'Delete Call Log',
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
              'Are you sure you want to delete this call log?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '"${log.customerName ?? 'Unknown'}"',
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
            onPressed: () async {
              final success = await Provider.of<CallLogsProvider>(context, listen: false)
                  .deleteCallLog(
                id: log.id ?? '',
                body: {
                  "customerName": log.customerName ?? '',
                  "phoneNumber": log.phoneNumber ?? '',
                  "staffName": log.staffName ?? '',
                  "date": log.date ?? '',
                  "time": log.time ?? '',
                  "mode": log.mode ?? '',
                  "location": log.location ?? '',
                },
              );

              if (success) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Call log deleted successfully'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Failed to delete call log'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              }
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

  Color _getModeColor(String mode) {
    switch (mode.toLowerCase()) {
      case 'call':
        return Colors.green;
      case 'whatsapp':
        return Color(0xFF25D366);
      default:
        return Colors.blue;
    }
  }

  IconData _getModeIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'call':
        return Icons.call_rounded;
      case 'whatsapp':
        return Icons.message_rounded;
      default:
        return Icons.phone_android_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: Consumer<CallLogsProvider>(
        builder: (context, provider, child) {
          final filteredCallLogs = _getFilteredCallLogs(provider);
          final totalPages = (filteredCallLogs.length / _itemsPerPage).ceil();
          final startIndex = _currentPage * _itemsPerPage;
          final endIndex = startIndex + _itemsPerPage > filteredCallLogs.length
              ? filteredCallLogs.length
              : startIndex + _itemsPerPage;
          final paginatedList = filteredCallLogs.sublist(startIndex, endIndex);

          return NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 160,
                  elevation: 4,
                  backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                  surfaceTintColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  actions: [
                    IconButton(
                      onPressed: _refreshCallLogs,
                      icon: const Icon(Icons.refresh_rounded),
                      tooltip: 'Refresh',
                    ),
                  ],
                  title: Text(
                    'Call Logs',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  centerTitle: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(140),
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
                                        hintText: 'Search call logs...',
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
                            const SizedBox(height: 12),

                            // Mode Filter Chips
                            SizedBox(
                              height: 40,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _modes.map((mode) {
                                  final isSelected = _selectedMode == mode;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      label: Text(
                                        mode,
                                        style: TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() => _selectedMode = selected ? mode : 'All');
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
                : provider.callLogs.isEmpty && _searchQuery.isEmpty
                ? _buildEmptyState(context, _searchQuery, _searchController)
                : filteredCallLogs.isEmpty
                ? _buildNoResultsState()
                : _buildCallLogList(context, paginatedList, totalPages, theme, isDarkMode),
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

  Widget _buildEmptyState(BuildContext context, String searchQuery, TextEditingController searchController) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No Call Logs',
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
              'Start making calls to see logs here',
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

  Widget _buildNoResultsState() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No Results Found',
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
              'No call logs match your search criteria',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
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

  Widget _buildCallLogList(BuildContext context, List<dynamic> callLogs,
      int totalPages, ThemeData theme, bool isDarkMode) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: callLogs.length,
            itemBuilder: (context, index) {
              final log = callLogs[index];
              final modeColor = _getModeColor(log.mode ?? '');
              final modeIcon = _getModeIcon(log.mode ?? '');

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with customer name and mode
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  log.customerName ?? 'Unknown',
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
                                  color: modeColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: modeColor.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      modeIcon,
                                      size: 14,
                                      color: modeColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      log.mode ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: modeColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Phone Number
                          _buildDetailRow(
                            icon: Icons.phone_rounded,
                            label: 'Phone Number',
                            value: log.phoneNumber ?? 'N/A',
                            theme: theme,
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 8),

                          // Staff Name
                          _buildDetailRow(
                            icon: Icons.person_rounded,
                            label: 'Staff',
                            value: log.staffName ?? 'N/A',
                            theme: theme,
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 8),

                          // Date and Time in row
                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailRow(
                                  icon: Icons.calendar_today_rounded,
                                  label: 'Date',
                                  value: _formatDate(log.date ?? ''),
                                  theme: theme,
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDetailRow(
                                  icon: Icons.access_time_rounded,
                                  label: 'Time',
                                  value: log.time ?? 'N/A',
                                  theme: theme,
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Location
                          _buildDetailRow(
                            icon: Icons.location_on_rounded,
                            label: 'Location',
                            value: log.location ?? 'N/A',
                            theme: theme,
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 16),

                          // Delete Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => _showDeleteDialog(context, log),
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: theme.colorScheme.error,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: theme.colorScheme.error.withOpacity(0.1),
                                  padding: const EdgeInsets.all(8),
                                ),
                                tooltip: 'Delete Call Log',
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
          ),
        ),

        // Pagination
        if (totalPages > 1)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: _currentPage > 0
                      ? () {
                    setState(() => _currentPage--);
                  }
                      : null,
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: const Text('Previous'),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Page ${_currentPage + 1} of $totalPages',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _currentPage < totalPages - 1
                      ? () {
                    setState(() => _currentPage++);
                  }
                      : null,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: const Text('Next'),
                ),
              ],
            ),
          ),
      ],
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}