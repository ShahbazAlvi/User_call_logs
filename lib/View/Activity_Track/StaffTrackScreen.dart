// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../Provider/CustomersTrackProvider/StaffTrackProvider.dart';
//
//
// class StaffTrackScreen extends StatefulWidget {
//   const StaffTrackScreen({super.key});
//
//   @override
//   State<StaffTrackScreen> createState() => _StaffTrackScreenState();
// }
//
// class _StaffTrackScreenState extends State<StaffTrackScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<StaffTrackProvider>(context, listen: false).fetchStaffTrack();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Staff Login Tracking',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF5B86E5),Color(0xFF36D1DC), ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: Consumer<StaffTrackProvider>(
//         builder: (context, provider, _) {
//           if (provider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (provider.staffList.isEmpty) {
//             return const Center(child: Text('No staff data available.'));
//           }
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: provider.staffList.length,
//             itemBuilder: (context, index) {
//               final staff = provider.staffList[index];
//               return Card(
//                 elevation: 4,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ExpansionTile(
//                   title: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         staff.username ?? 'Unknown',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                       Chip(
//                         label: Text(
//                           (staff.status ?? '').toUpperCase(),
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                         backgroundColor: staff.status == 'active'
//                             ? Colors.green
//                             : Colors.grey,
//                       ),
//                     ],
//                   ),
//                   subtitle: Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('📞 Phone: ${staff.phone ?? 'N/A'}'),
//                         Text('⏱️ Last Login: ${staff.lastLoginAt ?? '-'}'),
//                         Text('🚪 Last Logout: ${staff.lastLogoutAt?.isNotEmpty == true ? staff.lastLogoutAt! : '-'}'),
//                         Text('🔢 Total Logins: ${staff.totalLogins ?? 0}'),
//                       ],
//                     ),
//                   ),
//                   children: [
//                     if (staff.loginHistory != null &&
//                         staff.loginHistory!.isNotEmpty)
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         color: Colors.grey[50],
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Login History:',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 15),
//                             ),
//                             const SizedBox(height: 6),
//                             ...staff.loginHistory!.map((history) => ListTile(
//                               dense: true,
//                               title: Text(
//                                   'Login: ${history.loginAt ?? 'N/A'}'),
//                               subtitle: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Logout: ${history.logoutAt ?? '-'}'),
//                                 ],
//                               ),
//                             )),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
//
// import '../../Provider/CustomersTrackProvider/StaffTrackProvider.dart';
//
// class StaffTrackScreen extends StatefulWidget {
//   const StaffTrackScreen({super.key});
//
//   @override
//   State<StaffTrackScreen> createState() => _StaffTrackScreenState();
// }
//
// class _StaffTrackScreenState extends State<StaffTrackScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = "";
//   String _selectedFilter = 'All';
//   final List<String> _filters = ['All', 'Active', 'Inactive'];
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<StaffTrackProvider>(context, listen: false).fetchStaffTrack();
//     });
//     _searchController.addListener(() {
//       setState(() => _searchQuery = _searchController.text);
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _refreshStaff() {
//     Provider.of<StaffTrackProvider>(context, listen: false).fetchStaffTrack();
//   }
//
//   String _formatDateTime(String? dateTime) {
//     if (dateTime == null || dateTime.isEmpty || dateTime == '-') {
//       return 'Never';
//     }
//
//     try {
//       final parsedDate = DateTime.parse(dateTime);
//       final now = DateTime.now();
//       final difference = now.difference(parsedDate);
//
//       if (difference.inDays == 0) {
//         if (difference.inHours < 1) {
//           return '${difference.inMinutes}m ago';
//         }
//         return '${difference.inHours}h ago';
//       } else if (difference.inDays == 1) {
//         return 'Yesterday';
//       } else if (difference.inDays < 7) {
//         return '${difference.inDays}d ago';
//       } else if (difference.inDays < 30) {
//         return '${difference.inDays ~/ 7}w ago';
//       }
//
//       return DateFormat('MMM dd, yyyy').format(parsedDate);
//     } catch (e) {
//       return dateTime;
//     }
//   }
//
//   List<dynamic> _getFilteredStaff(StaffTrackProvider provider) {
//     var filtered = provider.staffList;
//
//     if (_searchQuery.isNotEmpty) {
//       final query = _searchQuery.toLowerCase();
//       filtered = filtered.where((staff) {
//         final username = staff.username?.toLowerCase() ?? '';
//         final phone = staff.phone?.toLowerCase() ?? '';
//         final status = staff.status?.toLowerCase() ?? '';
//
//         return username.contains(query) ||
//             phone.contains(query) ||
//             status.contains(query);
//       }).toList();
//     }
//
//     if (_selectedFilter != 'All') {
//       filtered = filtered.where((staff) {
//         return (staff.status?.toLowerCase() ?? '') == _selectedFilter.toLowerCase();
//       }).toList();
//     }
//
//     return filtered;
//   }
//
//   // Helper method to safely get property values from LoginHistory object
//   String _getLoginAt(dynamic history) {
//     // Try to access as object property first
//     try {
//       return history.loginAt?.toString() ?? '';
//     } catch (e) {
//       // If that fails, try to access as map
//       try {
//         return (history as Map<String, dynamic>)['loginAt']?.toString() ?? '';
//       } catch (e) {
//         return '';
//       }
//     }
//   }
//
//   String _getLogoutAt(dynamic history) {
//     // Try to access as object property first
//     try {
//       return history.logoutAt?.toString() ?? '';
//     } catch (e) {
//       // If that fails, try to access as map
//       try {
//         return (history as Map<String, dynamic>)['logoutAt']?.toString() ?? '';
//       } catch (e) {
//         return '';
//       }
//     }
//   }
//
//   Widget _buildLoginHistoryItem(dynamic history) {
//     final loginAt = _getLoginAt(history);
//     final logoutAt = _getLogoutAt(history);
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.green.shade50,
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Icon(
//                       Icons.login_rounded,
//                       size: 16,
//                       color: Colors.green.shade700,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Login',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.green.shade700,
//                     ),
//                   ),
//                 ],
//               ),
//               Text(
//                 _formatDateTime(loginAt),
//                 style: const TextStyle(
//                   fontSize: 13,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           if (logoutAt.isNotEmpty && logoutAt != 'null')
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.shade50,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Icon(
//                     Icons.logout_rounded,
//                     size: 16,
//                     color: Colors.orange.shade700,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Logout',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.orange.shade700,
//                   ),
//                 ),
//                 const Spacer(),
//                 Text(
//                   _formatDateTime(logoutAt),
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildShimmerLoading() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(24),
//       itemCount: 6,
//       itemBuilder: (context, index) {
//         return Container(
//           height: 200,
//           margin: const EdgeInsets.only(bottom: 16),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(20),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildEmptyState(BuildContext context, String searchQuery,
//       TextEditingController searchController, bool isDarkMode) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(40),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFF5B86E5).withOpacity(0.1),
//                     Color(0xFF36D1DC).withOpacity(0.1),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.people_alt_outlined,
//                 size: 60,
//                 color: Color(0xFF5B86E5).withOpacity(0.5),
//               ),
//             ),
//             const SizedBox(height: 32),
//             Text(
//               searchQuery.isNotEmpty ? 'No Staff Found' : 'No Staff Data',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w800,
//                 color: isDarkMode ? Colors.white : Colors.grey.shade800,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               searchQuery.isNotEmpty
//                   ? 'Try adjusting your search or filters to find what you\'re looking for'
//                   : 'Staff tracking data will appear here once available',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.grey.shade500,
//                 height: 1.5,
//               ),
//             ),
//             const SizedBox(height: 32),
//             if (searchQuery.isNotEmpty)
//               FilledButton.icon(
//                 onPressed: () {
//                   searchController.clear();
//                   setState(() => _searchQuery = '');
//                 },
//                 icon: Icon(Icons.clear_all_rounded, size: 20),
//                 label: Text('Clear Search'),
//                 style: FilledButton.styleFrom(
//                   backgroundColor: Color(0xFF5B86E5),
//                   foregroundColor: Colors.white,
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//     required bool isDarkMode,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(
//             icon,
//             size: 20,
//             color: color,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey.shade500,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: isDarkMode ? Colors.white : Colors.grey.shade800,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//     final backgroundColor = isDarkMode ? Color(0xFF121212) : Color(0xFFF8F9FA);
//
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Consumer<StaffTrackProvider>(
//         builder: (context, provider, _) {
//           final filteredStaff = _getFilteredStaff(provider);
//
//           return Column(
//             children: [
//               // Modern Header
//               Container(
//                 decoration: BoxDecoration(
//                   color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 20,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 padding:  EdgeInsets.only(
//                   top: MediaQuery.of(context).padding.top + 16,
//                   left: 24,
//                   right: 24,
//                   bottom: 20,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Staff Tracking',
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.w800,
//                                 color: isDarkMode ? Colors.white : Color(0xFF2D3748),
//                                 letterSpacing: -0.5,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'Monitor staff login activity',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: isDarkMode
//                                     ? Colors.grey.shade400
//                                     : Colors.grey.shade600,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                         CircleAvatar(
//                           backgroundColor: Color(0xFF5B86E5).withOpacity(0.1),
//                           child: IconButton(
//                             onPressed: _refreshStaff,
//                             icon: Icon(
//                               Icons.refresh_rounded,
//                               color: Color(0xFF5B86E5),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//
//                     // Search Bar
//                     Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: isDarkMode ? Color(0xFF2D2D2D) : Colors.white,
//                         borderRadius: BorderRadius.circular(14),
//                         border: Border.all(
//                           color: isDarkMode
//                               ? Colors.grey.shade800
//                               : Colors.grey.shade200,
//                           width: 1.5,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.03),
//                             blurRadius: 10,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           const SizedBox(width: 16),
//                           Icon(
//                             Icons.search_rounded,
//                             size: 20,
//                             color: Colors.grey.shade500,
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: TextField(
//                               controller: _searchController,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                                 color: isDarkMode
//                                     ? Colors.white
//                                     : Colors.grey.shade800,
//                               ),
//                               decoration: InputDecoration(
//                                 hintText: 'Search by name or phone...',
//                                 hintStyle: TextStyle(
//                                   fontSize: 15,
//                                   color: Colors.grey.shade500,
//                                 ),
//                                 border: InputBorder.none,
//                                 isDense: true,
//                                 contentPadding:
//                                 const EdgeInsets.symmetric(vertical: 14),
//                               ),
//                             ),
//                           ),
//                           if (_searchQuery.isNotEmpty)
//                             IconButton(
//                               onPressed: () {
//                                 _searchController.clear();
//                                 setState(() => _searchQuery = '');
//                               },
//                               icon: Icon(
//                                 Icons.close_rounded,
//                                 size: 18,
//                                 color: Colors.grey.shade500,
//                               ),
//                               padding: const EdgeInsets.all(8),
//                             ),
//                           const SizedBox(width: 8),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//
//                     // Status Filter Chips
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: _filters.map((filter) {
//                           final isSelected = _selectedFilter == filter;
//                           return Container(
//                             margin: const EdgeInsets.only(right: 8),
//                             child: Material(
//                               color: isSelected
//                                   ? Color(0xFF5B86E5)
//                                   : (isDarkMode
//                                   ? Color(0xFF2D2D2D)
//                                   : Colors.white),
//                               borderRadius: BorderRadius.circular(12),
//                               elevation: isSelected ? 2 : 0,
//                               child: InkWell(
//                                 onTap: () {
//                                   setState(
//                                           () => _selectedFilter = isSelected ? 'All' : filter);
//                                 },
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 10,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? Color(0xFF5B86E5)
//                                           : (isDarkMode
//                                           ? Colors.grey.shade800
//                                           : Colors.grey.shade200),
//                                       width: 1.5,
//                                     ),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       if (filter == 'Active')
//                                         Container(
//                                           width: 8,
//                                           height: 8,
//                                           margin: const EdgeInsets.only(right: 6),
//                                           decoration: BoxDecoration(
//                                             color: isSelected
//                                                 ? Colors.white
//                                                 : Colors.green,
//                                             shape: BoxShape.circle,
//                                           ),
//                                         )
//                                       else if (filter == 'Inactive')
//                                         Container(
//                                           width: 8,
//                                           height: 8,
//                                           margin: const EdgeInsets.only(right: 6),
//                                           decoration: BoxDecoration(
//                                             color: isSelected
//                                                 ? Colors.white
//                                                 : Colors.grey,
//                                             shape: BoxShape.circle,
//                                           ),
//                                         ),
//                                       Text(
//                                         filter,
//                                         style: TextStyle(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w600,
//                                           color: isSelected
//                                               ? Colors.white
//                                               : (isDarkMode
//                                               ? Colors.grey.shade300
//                                               : Colors.grey.shade700),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Results Header
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(
//                       color: isDarkMode
//                           ? Colors.grey.shade800
//                           : Colors.grey.shade200,
//                     ),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '${filteredStaff.length} Staff Members',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: isDarkMode ? Colors.white : Colors.grey.shade800,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.green.shade50,
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: Text(
//                             '${filteredStaff.where((s) => (s.status?.toLowerCase() ?? '') == 'active').length} Active',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.green.shade700,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade100,
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: Text(
//                             '${filteredStaff.where((s) => (s.status?.toLowerCase() ?? '') != 'active').length} Inactive',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Content Area
//               Expanded(
//                 child: provider.isLoading
//                     ? _buildShimmerLoading()
//                     : filteredStaff.isEmpty
//                     ? _buildEmptyState(
//                     context, _searchQuery, _searchController, isDarkMode)
//                     : ListView.builder(
//                   padding: const EdgeInsets.all(24),
//                   itemCount: filteredStaff.length,
//                   itemBuilder: (context, index) {
//                     final staff = filteredStaff[index];
//                     final isActive = (staff.status?.toLowerCase() ?? '') == 'active';
//
//                     return Container(
//                       margin: const EdgeInsets.only(bottom: 16),
//                       child: Material(
//                         color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         elevation: 2,
//                         shadowColor: Colors.black.withOpacity(0.05),
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Header with status
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Avatar
//                                   Container(
//                                     width: 56,
//                                     height: 56,
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         colors: isActive
//                                             ? [Color(0xFF5B86E5), Color(0xFF36D1DC)]
//                                             : [Colors.grey.shade400, Colors.grey.shade600],
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.bottomRight,
//                                       ),
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         staff.username?.substring(0, 1).toUpperCase() ?? '?',
//                                         style: TextStyle(
//                                           fontSize: 24,
//                                           fontWeight: FontWeight.w800,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Expanded(
//                                               child: Text(
//                                                 staff.username ?? 'Unknown',
//                                                 style: TextStyle(
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.w800,
//                                                   color: isDarkMode
//                                                       ? Colors.white
//                                                       : Colors.grey.shade900,
//                                                 ),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                             Container(
//                                               padding: const EdgeInsets.symmetric(
//                                                 horizontal: 12,
//                                                 vertical: 6,
//                                               ),
//                                               decoration: BoxDecoration(
//                                                 color: isActive
//                                                     ? Colors.green.shade50
//                                                     : Colors.grey.shade100,
//                                                 borderRadius: BorderRadius.circular(20),
//                                                 border: Border.all(
//                                                   color: isActive
//                                                       ? Colors.green.shade200
//                                                       : Colors.grey.shade300,
//                                                 ),
//                                               ),
//                                               child: Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Container(
//                                                     width: 8,
//                                                     height: 8,
//                                                     margin: const EdgeInsets.only(right: 6),
//                                                     decoration: BoxDecoration(
//                                                       color: isActive
//                                                           ? Colors.green
//                                                           : Colors.grey,
//                                                       shape: BoxShape.circle,
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     isActive ? 'Active' : 'Inactive',
//                                                     style: TextStyle(
//                                                       fontSize: 12,
//                                                       fontWeight: FontWeight.w700,
//                                                       color: isActive
//                                                           ? Colors.green.shade700
//                                                           : Colors.grey.shade700,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 8),
//                                         Text(
//                                           staff.phone ?? 'No phone',
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.grey.shade500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 20),
//
//                               // Stats Grid
//                               Container(
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: BoxDecoration(
//                                   color: isDarkMode
//                                       ? Colors.grey.shade900
//                                       : Colors.grey.shade50,
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                                 child: GridView.count(
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   crossAxisCount: 2,
//                                   mainAxisSpacing: 12,
//                                   crossAxisSpacing: 16,
//                                   childAspectRatio: 2,
//                                   children: [
//                                     _buildStatItem(
//                                       icon: Icons.login_rounded,
//                                       label: 'Last Login',
//                                       value: _formatDateTime(staff.lastLoginAt),
//                                       color: Colors.blue.shade600,
//                                       isDarkMode: isDarkMode,
//                                     ),
//                                     _buildStatItem(
//                                       icon: Icons.logout_rounded,
//                                       label: 'Last Logout',
//                                       value: staff.lastLogoutAt?.isNotEmpty == true
//                                           ? _formatDateTime(staff.lastLogoutAt)
//                                           : 'Never',
//                                       color: Colors.orange.shade600,
//                                       isDarkMode: isDarkMode,
//                                     ),
//                                     _buildStatItem(
//                                       icon: Icons.history_rounded,
//                                       label: 'Total Logins',
//                                       value: '${staff.totalLogins ?? 0}',
//                                       color: Colors.purple.shade600,
//                                       isDarkMode: isDarkMode,
//                                     ),
//                                     _buildStatItem(
//                                       icon: Icons.timer_rounded,
//                                       label: 'Status Duration',
//                                       value: isActive ? 'Active' : 'Offline',
//                                       color: isActive
//                                           ? Colors.green.shade600
//                                           : Colors.grey.shade600,
//                                       isDarkMode: isDarkMode,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//
//                               // Login History Section
//                               if (staff.loginHistory != null &&
//                                   staff.loginHistory!.isNotEmpty)
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.history_rounded,
//                                           size: 20,
//                                           color: Colors.grey.shade600,
//                                         ),
//                                         const SizedBox(width: 8),
//                                         Text(
//                                           'Login History',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w700,
//                                             color: isDarkMode
//                                                 ? Colors.white
//                                                 : Colors.grey.shade800,
//                                           ),
//                                         ),
//                                         const Spacer(),
//                                         Text(
//                                           '${staff.loginHistory!.length} sessions',
//                                           style: TextStyle(
//                                             fontSize: 13,
//                                             color: Colors.grey.shade500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 12),
//                                     ...staff.loginHistory!
//                                         .take(3)
//                                         .map((history) => _buildLoginHistoryItem(history)),
//                                     if (staff.loginHistory!.length > 3)
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 8),
//                                         child: Center(
//                                           child: Text(
//                                             '+ ${staff.loginHistory!.length - 3} more sessions',
//                                             style: TextStyle(
//                                               fontSize: 13,
//                                               color: Color(0xFF5B86E5),
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
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

import '../../Provider/CustomersTrackProvider/StaffTrackProvider.dart';

class StaffTrackScreen extends StatefulWidget {
  const StaffTrackScreen({super.key});

  @override
  State<StaffTrackScreen> createState() => _StaffTrackScreenState();
}

class _StaffTrackScreenState extends State<StaffTrackScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingButton = true;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StaffTrackProvider>(context, listen: false).fetchStaffTrack();
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
    if (_scrollController.offset > 100) {
      if (_showFloatingButton) {
        setState(() => _showFloatingButton = false);
      }
    } else {
      if (!_showFloatingButton) {
        setState(() => _showFloatingButton = true);
      }
    }
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty || dateTime == '-') return '-';
    try {
      final parsedDate = DateTime.parse(dateTime);
      return DateFormat('MMM dd, yyyy HH:mm').format(parsedDate);
    } catch (e) {
      return dateTime;
    }
  }

  String _formatRelativeTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty || dateTime == '-') return '-';
    try {
      final parsedDate = DateTime.parse(dateTime);
      final now = DateTime.now();
      final difference = now.difference(parsedDate);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateTime;
    }
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
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_off_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No Staff Data Available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Staff tracking information will appear here',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<StaffTrackProvider>(context, listen: false).fetchStaffTrack();
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          const Text(
            'Failed to Load Data',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<StaffTrackProvider>(context, listen: false).fetchStaffTrack();
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard(BuildContext context, dynamic staff, ThemeData theme, bool isDarkMode) {
    final isActive = staff.status == 'active';
    final loginHistory = staff.loginHistory ?? [];
    final loginHistoryCount = loginHistory.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 3,
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isActive
                                      ? [const Color(0xFF5B86E5), const Color(0xFF36D1DC)]
                                      : [Colors.grey, Colors.grey[400]!],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  staff.username != null && staff.username!.isNotEmpty
                                      ? staff.username![0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    staff.username ?? 'Unknown Staff',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    staff.phone ?? 'No phone number',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive
                            ? Colors.green.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      (staff.status ?? 'inactive').toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  _buildInfoItem(
                    icon: Icons.login_rounded,
                    label: 'Total Logins',
                    value: '${staff.totalLogins ?? 0}',
                    color: theme.colorScheme.primary,
                  ),
                  _buildInfoItem(
                    icon: Icons.schedule_rounded,
                    label: 'Last Login',
                    value: _formatRelativeTime(staff.lastLoginAt),
                    color: Colors.blue,
                  ),
                  _buildInfoItem(
                    icon: Icons.logout_rounded,
                    label: 'Last Logout',
                    value: staff.lastLogoutAt?.isNotEmpty == true
                        ? _formatRelativeTime(staff.lastLogoutAt)
                        : '-',
                    color: Colors.orange,
                  ),
                ],
              ),
            ],
          ),
          children: [
            if (loginHistoryCount > 0) ...[
              Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Login History',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$loginHistoryCount sessions',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...loginHistory.take(5).map((history) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[700] : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.login_rounded,
                                      size: 16,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Signed In',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  _formatDateTime(history.loginAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            if (history.logoutAt != null && history.logoutAt!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.logout_rounded,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Signed Out',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    _formatDateTime(history.logoutAt),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    )).toList(),
                    if (loginHistoryCount > 5) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'And ${loginHistoryCount - 5} more sessions',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color.withOpacity(0.7),
                ),
              ),
            ],
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
      body: NestedScrollView(
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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Staff Activity Tracking',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    Provider.of<StaffTrackProvider>(context, listen: false).fetchStaffTrack();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh',
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Container(
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
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
                            size: 20,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() => _searchQuery = value);
                              },
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search staff by name or phone...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
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
                                Icons.clear_rounded,
                                color: Colors.grey[500],
                                size: 18,
                              ),
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Consumer<StaffTrackProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return _buildShimmerLoading();
            }

            if (provider.errorMessage.isNotEmpty) {
              return _buildErrorState(provider.errorMessage);
            }

            if (provider.staffList.isEmpty) {
              return _buildEmptyState();
            }

            // Filter staff based on search query
            List<dynamic> filteredStaff = provider.staffList;
            if (_searchQuery.isNotEmpty) {
              filteredStaff = filteredStaff.where((staff) {
                final name = staff.username?.toLowerCase() ?? '';
                final phone = staff.phone?.toLowerCase() ?? '';
                final query = _searchQuery.toLowerCase();
                return name.contains(query) || phone.contains(query);
              }).toList();
            }

            // Separate active and inactive staff
            final activeStaff = filteredStaff.where((staff) => staff.status == 'active').toList();
            final inactiveStaff = filteredStaff.where((staff) => staff.status != 'active').toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (activeStaff.isNotEmpty) ...[
                  _buildSectionHeader(
                    context,
                    'Active Staff',
                    activeStaff.length,
                    isActive: true,
                  ),
                  ...activeStaff.map((staff) => _buildStaffCard(context, staff, theme, isDarkMode)),
                  const SizedBox(height: 8),
                ],
                if (inactiveStaff.isNotEmpty) ...[
                  _buildSectionHeader(
                    context,
                    'Inactive Staff',
                    inactiveStaff.length,
                    isActive: false,
                  ),
                  ...inactiveStaff.map((staff) => _buildStaffCard(context, staff, theme, isDarkMode)),
                ],
              ],
            );
          },
        ),
      ),
      floatingActionButton: _showFloatingButton
          ? FloatingActionButton.extended(
        onPressed: () {
          _showAnalyticsDialog(context);
        },
        icon: const Icon(Icons.analytics_rounded),
        label: const Text('Analytics'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      )
          : null,
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count, {bool isActive = true}) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isActive
                    ? [const Color(0xFF5B86E5), const Color(0xFF36D1DC)]
                    : [Colors.grey, Colors.grey[400]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count ${count == 1 ? 'staff' : 'staff'}',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAnalyticsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final provider = Provider.of<StaffTrackProvider>(context, listen: false);
        final staffList = provider.staffList;
        final activeCount = staffList.where((staff) => staff.status == 'active').length;
        final totalLogins = staffList.fold(0, (sum, staff) => sum + (staff.totalLogins ?? 0));

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              const Text('Staff Analytics'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnalyticsItem('Total Staff', '${staffList.length}'),
              _buildAnalyticsItem('Active Staff', '$activeCount'),
              _buildAnalyticsItem('Inactive Staff', '${staffList.length - activeCount}'),
              _buildAnalyticsItem('Total Logins', '$totalLogins'),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Last Updated',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnalyticsItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}