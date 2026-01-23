// import 'package:flutter/material.dart';
// import 'package:infinity/View/staff/create_staff.dart';
// import 'package:infinity/View/staff/updateScreenStaff.dart';
// import 'package:provider/provider.dart';
//
// import '../../Provider/staff/StaffProvider.dart';
//
//
// class StaffScreen extends StatefulWidget {
//   const StaffScreen({super.key});
//
//   @override
//   State<StaffScreen> createState() => _StaffScreenState();
// }
//
// class _StaffScreenState extends State<StaffScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch staff data when the screen opens
//     Future.microtask(() =>
//         Provider.of<StaffProvider>(context, listen: false).fetchStaff());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<StaffProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Staff Members",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//             letterSpacing: 1.2,
//           ),
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
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.push(context,MaterialPageRoute(builder: (context)=>StaffCreateScreen()));
//               },
//               icon: const Icon(Icons.add_circle_outline, color: Colors.white),
//               label: const Text(
//                 "Add Staffs",
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : provider.staffs.isEmpty
//           ? const Center(child: Text("No staff found"))
//           : ListView.builder(
//         itemCount: provider.staffs.length,
//         padding: const EdgeInsets.all(10),
//         itemBuilder: (context, index) {
//           final staff = provider.staffs[index];
//           return Card(
//             elevation: 3,
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.grey[300],
//                     backgroundImage: (staff.image?.url != null &&
//                         staff.image!.url!.isNotEmpty)
//                         ? NetworkImage(staff.image!.url!)
//                         : null,
//                     child: (staff.image?.url == null ||
//                         staff.image!.url!.isEmpty)
//                         ? const Icon(Icons.person, size: 30, color: Colors.white)
//                         : null,
//                   ),
//
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           staff.username ?? '',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(staff.department ?? '',
//                             style: const TextStyle(color: Colors.black54)),
//                         Text(staff.email ?? '',
//                             style: const TextStyle(color: Colors.black54)),
//                         Text(staff.number ?? '',
//                             style: const TextStyle(color: Colors.black54)),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => EditStaffScreen(staff: staff),
//                             ),
//                           );
//                         },
//                         icon: const Icon(Icons.edit, color: Colors.blue),
//                       ),
//
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () async {
//                           final confirm = await showDialog<bool>(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: const Text('Delete Staff'),
//                               content: const Text('Are you sure you want to delete this staff?'),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context, false),
//                                   child: const Text('No'),
//                                 ),
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context, true),
//                                   child: const Text('Yes'),
//                                 ),
//                               ],
//                             ),
//                           );
//
//                           // If user pressed "Yes"
//                           if (confirm == true) {
//                             provider.DeleteStaff("${staff.sId}");
//
//                             // Optional: show success message/snackbar
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('staff deleted successfully!'),
//                                 backgroundColor: Colors.green,
//                               ),
//                             );
//                           }
//                         },
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:infinity/View/staff/create_staff.dart';
import 'package:infinity/View/staff/updateScreenStaff.dart';
import 'package:infinity/model/staffModel.dart' hide Image;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../Provider/staff/StaffProvider.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<StaffProvider>(context, listen: false).fetchStaff());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Data> _filteredStaffs(StaffProvider provider) {
    var filtered = provider.staffs;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((staff) {
        final username = staff.username?.toLowerCase() ?? '';
        final email = staff.email?.toLowerCase() ?? '';
        final department = staff.department?.toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();

        return username.contains(query) ||
            email.contains(query) ||
            department.contains(query);
      }).toList();
    }

    // Apply category filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((staff) {
        return staff.department == _selectedFilter;
      }).toList();
    }

    return filtered;
  }

  List<String> _availableDepartments(StaffProvider provider) {
    final departments = provider.staffs
        .map((staff) => staff.department)
        .where((dept) => dept != null && dept.isNotEmpty)
        .toSet()
        .toList()
        .cast<String>();

    return ['All', ...departments];
  }

  void _showDeleteDialog(BuildContext context, String staffId, String staffName) {
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
          'Delete Staff Member',
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
              'Are you sure you want to delete "$staffName"?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
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
              Provider.of<StaffProvider>(context, listen: false)
                  .DeleteStaff(staffId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Staff deleted successfully'),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(

      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      floatingActionButton: Consumer<StaffProvider>(
        builder: (context, provider, child) {
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  StaffCreateScreen()),
              );
            },
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: const Icon(Icons.person_add_alt_1_rounded),
            label: const Text('Add Staff'),
          );
        },
      ),
      body: Consumer<StaffProvider>(
        builder: (context, provider, child) {
          final filteredStaffs = _filteredStaffs(provider);
          final departments = _availableDepartments(provider);

          return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<StaffProvider>(context, listen: false).fetchStaff();
            },
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    expandedHeight: 200,
                    elevation: 4,
                    backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                    surfaceTintColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    title: Text(
                      "Staff Members",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        letterSpacing: -0.5,
                      ),
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      icon:  Icon(Icons.arrow_back_ios_new_rounded,color: theme.colorScheme.primary,),
                      onPressed: () => Navigator.pop(context),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => provider.fetchStaff(),
                        icon:  Icon(Icons.refresh_rounded,color: theme.colorScheme.primary,),
                        tooltip: 'Refresh',
                      ),
                    ],
                    // flexibleSpace: FlexibleSpaceBar(
                    //   collapseMode: CollapseMode.pin,
                    //   centerTitle: true,
                    //   titlePadding: const EdgeInsets.only(bottom: 16),
                    //   title: AnimatedOpacity(
                    //     opacity: innerBoxIsScrolled ? 1.0 : 0.0,
                    //     duration: const Duration(milliseconds: 200),
                    //     child: Text(
                    //       'Staff Members',
                    //       style: TextStyle(
                    //         color: theme.colorScheme.primary,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 20,
                    //       ),
                    //     ),
                    //   ),
                    //   background: Container(
                    //     decoration: BoxDecoration(
                    //       gradient: LinearGradient(
                    //         begin: Alignment.topCenter,
                    //         end: Alignment.bottomCenter,
                    //         colors: [
                    //           theme.colorScheme.primary.withOpacity(0.15),
                    //           Colors.transparent,
                    //         ],
                    //       ),
                    //     ),
                    //     // child: Padding(
                    //     //   padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    //     //   child: Column(
                    //     //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     //     mainAxisAlignment: MainAxisAlignment.end,
                    //     //     children: [
                    //     //       // Text(
                    //     //       //   'Staff Members',
                    //     //       //   style: TextStyle(
                    //     //       //     fontSize: 32,
                    //     //       //     fontWeight: FontWeight.bold,
                    //     //       //     color: theme.colorScheme.primary,
                    //     //       //   ),
                    //     //       // ),
                    //     //      // const SizedBox(height: 4),
                    //     //      //  Text(
                    //     //      //    '${provider.staffs.length} team members',
                    //     //      //    style: TextStyle(
                    //     //      //      fontSize: 14,
                    //     //      //      color: Colors.grey[600],
                    //     //      //    ),
                    //     //      //  ),
                    //     //     ],
                    //     //   ),
                    //     // ),
                    //   ),
                    // ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(170),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
                                      decoration: InputDecoration(
                                        hintText: 'Search staff by name, email or department...',
                                        hintStyle: TextStyle(color: Colors.grey[500]),
                                        border: InputBorder.none,
                                        isDense: true,
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
                            const SizedBox(height: 20),
                            // Filter Chips
                            SizedBox(
                              height: 40,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: departments.map((dept) {
                                  final isSelected = _selectedFilter == dept;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      label: Text(dept),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() => _selectedFilter = selected ? dept : 'All');
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
                ];
              },
              body: provider.isLoading
                  ? _buildShimmerLoading()
                  : filteredStaffs.isEmpty
                  ? _buildEmptyState(context, _searchQuery, _searchController)
                  : _buildStaffList(context, filteredStaffs),
            ),
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
            height: 100,
            margin: const EdgeInsets.only(bottom: 16),
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
            Icons.people_alt_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No Staff Members Found',
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
                  ? 'No staff members match your search'
                  : 'Add your first staff member to get started',
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
            )
          else
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  StaffCreateScreen()),
                );
              },
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Add Staff Member'),
            ),
        ],
      ),
    );
  }

  Widget _buildStaffList(BuildContext context, List<Data> staffs) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: staffs.length,
      itemBuilder: (context, index) {
        final staff = staffs[index];
        final initials = staff.username
            ?.split(' ')
            .map((word) => word.isNotEmpty ? word[0] : '')
            .take(2)
            .join()
            .toUpperCase() ?? '?';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // Navigate to staff detail screen
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with error handling
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getAvatarColor(index),
                      ),
                      child: ClipOval(
                        child: _buildStaffAvatar(staff, initials, theme),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Staff Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  staff.username ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  staff.department ?? 'No Dept',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.email_rounded,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  staff.email ?? 'No email',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_rounded,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                staff.number ?? 'No number',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Action Buttons
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditStaffScreen(staff: staff),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.edit_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary
                                .withOpacity(0.1),
                            padding: const EdgeInsets.all(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        IconButton(
                          onPressed: () => _showDeleteDialog(
                            context,
                            staff.sId ?? '',
                            staff.username ?? 'this staff member',
                          ),
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: theme.colorScheme.error,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor:
                            theme.colorScheme.error.withOpacity(0.1),
                            padding: const EdgeInsets.all(8),
                          ),
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

  Widget _buildStaffAvatar(Data staff, String initials, ThemeData theme) {
    final imageUrl = staff.image?.url;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
                : null,
            strokeWidth: 2,
            color: Colors.white,
          ),
        );
      },
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      const Color(0xFF5B86E5),
      const Color(0xFF36D1DC),
      const Color(0xFFF45C43),
      const Color(0xFF6A11CB),
      const Color(0xFF2575FC),
      const Color(0xFF2AF598),
      const Color(0xFFF093FB),
      const Color(0xFF667EEA),
    ];
    return colors[index % colors.length];
  }
}