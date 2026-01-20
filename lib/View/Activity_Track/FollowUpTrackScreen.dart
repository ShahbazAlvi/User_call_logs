// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../Provider/CustomersTrackProvider/FollowUpTrackProvider.dart';
// import '../../Provider/product/product_provider.dart';
// import '../../Provider/staff/StaffProvider.dart';
//
// class FollowUpTrackScreen extends StatefulWidget {
//   const FollowUpTrackScreen({super.key});
//
//   @override
//   State<FollowUpTrackScreen> createState() => _FollowUpTrackScreenState();
// }
//
// class _FollowUpTrackScreenState extends State<FollowUpTrackScreen> {
//   final List<String> dateOptions = ['today', '1week', '14days', 'all'];
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<StaffProvider>(context, listen: false).fetchStaff();
//       Provider.of<ProductProvider>(context, listen: false).fetchProducts();
//       Provider.of<FollowUpTrackProvider>(context, listen: false).fetchFollowUps();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Follow-Up Tracking',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF5B86E5),Color(0xFF36D1DC)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Consumer<FollowUpTrackProvider>(
//         builder: (context, provider, _) {
//           return Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               children: [
//                 // 🔍 Search bar
//                 TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Search by company or person name...',
//                     prefixIcon: const Icon(Icons.search),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onChanged: provider.setSearch,
//                 ),
//                 const SizedBox(height: 12),
//
//                 // 🔽 Filters
//                 SingleChildScrollView(
//                  // scrollDirection: Axis.horizontal,
//                   child: Column(
//                     children: [
//                       // Staff dropdown
//                       Consumer<StaffProvider>(
//                         builder: (context, staffProvider, _) {
//                           return _buildDropdown(
//                             label: 'Assigned Staff',
//                             value: provider.selectedStaffName,
//                             items: [
//                               const DropdownMenuItem(value: null, child: Text('All Staff')),
//                               ...staffProvider.staffs.map(
//                                     (s) => DropdownMenuItem(
//                                   value: s.username,
//                                   child: Text(s.username ?? 'Unnamed'),
//                                   onTap: () => provider.setStaff(s.sId, s.username),
//                                 ),
//                               ),
//                             ],
//                             onChanged: (value) {
//                               if (value == null) provider.setStaff(null, null);
//                             },
//                           );
//                         },
//                       ),
//                       const SizedBox(width: 8),
//
//                       // Product dropdown
//                       Consumer<ProductProvider>(
//                         builder: (context, productProvider, _) {
//                           return _buildDropdown(
//                             label: 'Product',
//                             value: provider.selectedProductName,
//                             items: [
//                               const DropdownMenuItem(value: null, child: Text('All Products')),
//                               ...productProvider.products.map(
//                                     (p) => DropdownMenuItem(
//                                   value: p.name,
//                                   child: Text(p.name ?? 'Unnamed Product'),
//                                   onTap: () => provider.setProduct(p.sId, p.name),
//                                 ),
//                               ),
//                             ],
//                             onChanged: (value) {
//                               if (value == null) provider.setProduct(null, null);
//                             },
//                           );
//                         },
//                       ),
//                       const SizedBox(width: 8),
//
//                       // Date range
//                       _buildDropdown(
//                         label: 'Date Range',
//                         value: provider.selectedDateRange,
//                         items: dateOptions
//                             .map((d) => DropdownMenuItem(value: d, child: Text(d.toUpperCase())))
//                             .toList(),
//                         onChanged: provider.setDateRange,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//
//                 // 📋 Follow-up list
//                 Expanded(
//                   child: provider.isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : provider.filteredFollowUps.isEmpty
//                       ? const Center(child: Text('No follow-ups found'))
//                       : ListView.builder(
//                     itemCount: provider.filteredFollowUps.length,
//                     itemBuilder: (context, index) {
//                       final followUp = provider.filteredFollowUps[index];
//                       return Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         elevation: 3,
//                         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//                         child: ListTile(
//                           title: Text(
//                             followUp.companyName ?? 'Unknown Company',
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if (followUp.persons != null &&
//                                   followUp.persons!.isNotEmpty)
//                                 Text(
//                                     "👥 ${followUp.persons!.map((p) => p.fullName ?? '').join(', ')}"),
//                               if (followUp.assignedStaff?.username != null)
//                                 Text("👤 Staff: ${followUp.assignedStaff?.username}"),
//                               if (followUp.product?.name != null)
//                                 Text("📦 Product: ${followUp.product?.name}"),
//                               if (followUp.status != null)
//                                 Text("📊 Status: ${followUp.status}"),
//                               if (followUp.timeline != null)
//                                 Text("⏱️ Timeline: ${followUp.timeline}"),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   // 🔹 Reusable dropdown
//   Widget _buildDropdown({
//     required String label,
//     required String? value,
//     required List<DropdownMenuItem<String?>> items,
//     required void Function(String?)? onChanged,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//       child: SizedBox(
//         width: double.infinity,
//        // width: 200,
//         child: DropdownButtonFormField<String?>(
//           decoration: InputDecoration(
//             labelText: label,
//             border: const OutlineInputBorder(),
//           ),
//           value: value,
//           items: items,
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import '../../Provider/CustomersTrackProvider/FollowUpTrackProvider.dart';
import '../../Provider/product/product_provider.dart';
import '../../Provider/staff/StaffProvider.dart';

class FollowUpTrackScreen extends StatefulWidget {
  const FollowUpTrackScreen({super.key});

  @override
  State<FollowUpTrackScreen> createState() => _FollowUpTrackScreenState();
}

class _FollowUpTrackScreenState extends State<FollowUpTrackScreen> {
  final List<String> dateOptions = ['today', '1week', '14days', 'all'];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  String _selectedFilter = 'All';
  List<String> _filters = ['All', 'Hold', 'Follow Up', 'Completed'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StaffProvider>(context, listen: false).fetchStaff();
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<FollowUpTrackProvider>(context, listen: false).fetchFollowUps();
    });
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
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
    // Handle scroll for pagination if needed
  }

  void _refreshFollowUps() {
    Provider.of<FollowUpTrackProvider>(context, listen: false).fetchFollowUps();
  }

  List<dynamic> _getFilteredFollowUps(FollowUpTrackProvider provider) {
    var filtered = provider.filteredFollowUps;

    // Apply local search filter if any
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((followUp) {
        final companyName = followUp.companyName?.toLowerCase() ?? '';
        final persons = followUp.persons
            ?.map((p) => p.fullName?.toLowerCase() ?? '')
            .join(' ') ??
            '';
        final staffName = followUp.assignedStaff?.username?.toLowerCase() ?? '';
        final productName = followUp.product?.name?.toLowerCase() ?? '';
        final status = followUp.status?.toLowerCase() ?? '';
        final timeline = followUp.timeline?.toLowerCase() ?? '';

        return companyName.contains(query) ||
            persons.contains(query) ||
            staffName.contains(query) ||
            productName.contains(query) ||
            status.contains(query) ||
            timeline.contains(query);
      }).toList();
    }

    // Apply status filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((followUp) {
        final status = followUp.status?.toLowerCase() ?? '';
        final timeline = followUp.timeline?.toLowerCase() ?? '';
        return status.contains(_selectedFilter.toLowerCase()) ||
            timeline.contains(_selectedFilter.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toLowerCase()) {
      case 'hold':
      case 'pending':
        return Colors.orange;
      case 'follow up':
      case 'scheduled':
        return Colors.blue;
      case 'completed':
      case 'closed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    if (status == null) return Icons.info_outline_rounded;
    switch (status.toLowerCase()) {
      case 'hold':
      case 'pending':
        return Icons.pause_circle_filled_rounded;
      case 'follow up':
      case 'scheduled':
        return Icons.update_rounded;
      case 'completed':
      case 'closed':
        return Icons.check_circle_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  // UPDATED: Format ISO dates to simple date format
  String? _formatFollowUpDates(List<String>? dates) {
    if (dates == null || dates.isEmpty) return null;

    final formattedDates = dates.map((date) {
      try {
        if (date.contains('T')) {
          // Extract just the date part before 'T' (e.g., "2025-12-27")
          return date.split('T')[0];
        }
        return date;
      } catch (e) {
        return date;
      }
    }).toList();

    return formattedDates.join(', ');
  }

  // NEW: Format a single date string
  String _formatDateString(String dateString) {
    try {
      if (dateString.contains('T')) {
        return dateString.split('T')[0]; // Returns "2025-12-27"
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: Consumer<FollowUpTrackProvider>(
        builder: (context, provider, _) {
          final filteredFollowUps = _getFilteredFollowUps(provider);
          final totalPages = (filteredFollowUps.length / _itemsPerPage).ceil();
          final startIndex = _currentPage * _itemsPerPage;
          final endIndex = startIndex + _itemsPerPage > filteredFollowUps.length
              ? filteredFollowUps.length
              : startIndex + _itemsPerPage;
          final paginatedList = filteredFollowUps.sublist(startIndex, endIndex);

          return NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 140,
                  elevation: 4,
                  backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                  surfaceTintColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  actions: [
                    IconButton(
                      onPressed: _refreshFollowUps,
                      icon: const Icon(Icons.refresh_rounded),
                      tooltip: 'Refresh',
                    ),
                  ],
                  title: Text(
                    'Follow-Up Tracking',
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Search Bar
                            Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  Icon(
                                    Icons.search_rounded,
                                    size: 18,
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      style: const TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: 'Search follow-ups...',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                                        size: 16,
                                        color: Colors.grey[500],
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      constraints: const BoxConstraints(
                                        minWidth: 32,
                                        minHeight: 32,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Status Filter Chips
                            SizedBox(
                              height: 36,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _filters.map((filter) {
                                  final isSelected = _selectedFilter == filter;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: FilterChip(
                                      label: Text(
                                        filter,
                                        style: const TextStyle(
                                          fontSize: 12,
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
                                        borderRadius: BorderRadius.circular(16),
                                        side: BorderSide(
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : Colors.transparent,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      visualDensity: VisualDensity.compact,
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
                : provider.filteredFollowUps.isEmpty
                ? _buildEmptyState(context, _searchQuery, _searchController)
                : _buildFollowUpList(context, paginatedList, totalPages, theme, isDarkMode, provider),
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
            height: 160,
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
            Icons.timeline_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            searchQuery.isNotEmpty ? 'No Follow-Ups Found' : 'No Follow-Ups',
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
                  ? 'No follow-ups match your search criteria'
                  : 'No follow-ups found with the current filters',
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

  Widget _buildFollowUpList(
      BuildContext context,
      List<dynamic> followUps,
      int totalPages,
      ThemeData theme,
      bool isDarkMode,
      FollowUpTrackProvider provider,
      ) {
    return Column(
      children: [
        // Filter Controls Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Material(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Staff Filter
                  Consumer<StaffProvider>(
                    builder: (context, staffProvider, _) {
                      return _buildFilterDropdown(
                        label: 'Assigned Staff',
                        icon: Icons.person_rounded,
                        value: provider.selectedStaffName,
                        items: [
                          _buildDropdownItem('All Staff', null, Icons.group_rounded),
                          ...staffProvider.staffs.map((staff) =>
                              _buildDropdownItem(
                                  staff.username ?? 'Unnamed Staff',
                                  staff.username,
                                  Icons.person_outline_rounded
                              )
                          ),
                        ],
                        onChanged: (value) {
                          provider.setStaff(value == null ? null : '', value);
                        },
                        theme: theme,
                        isDarkMode: isDarkMode,
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Product Filter
                  Consumer<ProductProvider>(
                    builder: (context, productProvider, _) {
                      return _buildFilterDropdown(
                        label: 'Product',
                        icon: Icons.inventory_2_rounded,
                        value: provider.selectedProductName,
                        items: [
                          _buildDropdownItem('All Products', null, Icons.category_rounded),
                          ...productProvider.products.map((product) =>
                              _buildDropdownItem(
                                  product.name ?? 'Unnamed Product',
                                  product.name,
                                  Icons.shopping_bag_outlined
                              )
                          ),
                        ],
                        onChanged: (value) {
                          provider.setProduct(value == null ? null : '', value);
                        },
                        theme: theme,
                        isDarkMode: isDarkMode,
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Date Range Filter
                  _buildFilterDropdown(
                    label: 'Date Range',
                    icon: Icons.calendar_today_rounded,
                    value: provider.selectedDateRange,
                    items: dateOptions.map((option) =>
                        _buildDropdownItem(
                            option.toUpperCase(),
                            option,
                            _getDateRangeIcon(option)
                        )
                    ).toList(),
                    onChanged: provider.setDateRange,
                    theme: theme,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Results Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${followUps.length} Follow-Up${followUps.length != 1 ? 's' : ''}',
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

        // Follow-Up List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: followUps.length,
            itemBuilder: (context, index) {
              final followUp = followUps[index];
              final status = followUp.status ?? 'No Status';
              final timeline = followUp.timeline ?? 'No Timeline';
              final statusColor = _getStatusColor(status);
              final statusIcon = _getStatusIcon(status);

              // UPDATED: Format dates using the new function
              final followUpDates = _formatFollowUpDates(followUp.followDates);

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
                        // Header with company name and status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                followUp.companyName ?? 'Unknown Company',
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

                        // Contact Persons
                        if (followUp.persons != null && followUp.persons!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                icon: Icons.people_rounded,
                                label: 'Contact Persons',
                                value: followUp.persons!
                                    .where((p) => p.fullName != null && p.fullName!.isNotEmpty)
                                    .map((p) => p.fullName!)
                                    .join(', '),
                                theme: theme,
                                isDarkMode: isDarkMode,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),

                        // Assigned Staff
                        if (followUp.assignedStaff?.username != null && followUp.assignedStaff!.username!.isNotEmpty)
                          Column(
                            children: [
                              _buildDetailRow(
                                icon: Icons.person_rounded,
                                label: 'Assigned Staff',
                                value: followUp.assignedStaff!.username!,
                                theme: theme,
                                isDarkMode: isDarkMode,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),

                        // Product
                        if (followUp.product?.name != null && followUp.product!.name!.isNotEmpty)
                          Column(
                            children: [
                              _buildDetailRow(
                                icon: Icons.shopping_bag_rounded,
                                label: 'Product',
                                value: followUp.product!.name!,
                                theme: theme,
                                isDarkMode: isDarkMode,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),

                        // Timeline
                        _buildDetailRow(
                          icon: Icons.timeline_rounded,
                          label: 'Timeline',
                          value: timeline,
                          theme: theme,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 8),

                        // Follow-up Dates - Now shows formatted dates (e.g., "2025-12-27")
                        if (followUpDates != null && followUpDates.isNotEmpty)
                          Column(
                            children: [
                              _buildDetailRow(
                                icon: Icons.calendar_today_rounded,
                                label: 'Follow-up Dates',
                                value: followUpDates, // Now shows "2025-12-27" instead of "2025-12-27T00:00:00.000Z"
                                theme: theme,
                                isDarkMode: isDarkMode,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),

                        // Follow-up Times
                        if (followUp.followTimes != null && followUp.followTimes!.isNotEmpty)
                          Column(
                            children: [
                              _buildDetailRow(
                                icon: Icons.access_time_rounded,
                                label: 'Follow-up Times',
                                value: followUp.followTimes!.join(', '),
                                theme: theme,
                                isDarkMode: isDarkMode,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                      ],
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

  Widget _buildFilterDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<DropdownMenuItem<String?>> items,
    required Function(String?) onChanged,
    required ThemeData theme,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<String?>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.grey[600],
            ),
            border: InputBorder.none,
            icon: Icon(
              icon,
              color: theme.colorScheme.primary,
            ),
          ),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.grey[800],
          ),
          dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  DropdownMenuItem<String?> _buildDropdownItem(String text, String? value, IconData icon) {
    return DropdownMenuItem<String?>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  IconData _getDateRangeIcon(String range) {
    switch (range) {
      case 'today':
        return Icons.today_rounded;
      case '1week':
        return Icons.date_range_rounded;
      case '14days':
        return Icons.calendar_view_week_rounded;
      case 'all':
        return Icons.all_inclusive_rounded;
      default:
        return Icons.calendar_today_rounded;
    }
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