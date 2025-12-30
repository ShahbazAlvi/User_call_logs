
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../Provider/customer/customer_provider.dart';
// import 'add_customer.dart';
// import 'customer detail.dart';
// import 'customerUpdate.dart';
//
// class CompanyListScreen extends StatefulWidget {
//   const CompanyListScreen({super.key});
//
//   @override
//   State<CompanyListScreen> createState() => _CompanyListScreenState();
// }
//
// class _CompanyListScreenState extends State<CompanyListScreen> {
//   String? userRole;
//   TextEditingController searchController = TextEditingController();
//   String searchQuery = "";
//   int currentPage = 0;
//   final int itemsPerPage = 10;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserRole();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<CompanyProvider>(context, listen: false).fetchCompanies();
//     });
//   }
//   Future<void> _loadUserRole() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userRole = prefs.getString('role') ?? 'user'; // default = user
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CompanyProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Customers",
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
//                 Navigator.push(context,MaterialPageRoute(builder:(context)=>AddCustomerScreen()));
//               },
//               icon: const Icon(Icons.add_circle_outline, color: Colors.white),
//               label: const Text(
//                 "Add",
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
//
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : provider.errorMessage.isNotEmpty
//           ? Center(child: Text(provider.errorMessage))
//           : Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: TextField(
//                   controller: searchController,
//                   onChanged: (value) {
//                     setState(() {
//                       searchQuery = value.toLowerCase();
//                     });
//                   },
//                   style: const TextStyle(color: Colors.black),
//                   decoration: InputDecoration(
//                     hintText: "Search by Company Name",
//                     hintStyle: const TextStyle(color: Colors.black),
//                     prefixIcon: const Icon(Icons.search, color: Colors.black),
//                    // filled: true,
//                    // fillColor: Colors.black.withOpacity(0.2),
//                     contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: const BorderSide(color: Colors.black),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: const BorderSide(color: Colors.black),
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Builder(
//                   builder: (context) {
//                     final filteredList = provider.companies.where((company) {
//                       return company.companyName
//                           .toLowerCase()
//                           .contains(searchQuery);
//                     }).toList();
//                     final totalPages =
//                     (filteredList.length / itemsPerPage).ceil();
//
//                     final startIndex = currentPage * itemsPerPage;
//                     final endIndex =
//                     (startIndex + itemsPerPage > filteredList.length)
//                         ? filteredList.length
//                         : startIndex + itemsPerPage;
//
//                     final paginatedList =
//                     filteredList.sublist(startIndex, endIndex);
//                     return Column(
//                       children: [
//                         Expanded(
//                           child: ListView.builder(
//
//
//                             itemCount: paginatedList.length,
//                             itemBuilder: (context, index) {
//                               final c = paginatedList[index];
//
//                               // itemCount: provider.companies.length,
//                                   // itemBuilder: (context, index) {
//                                   //   final c = provider.companies[index];
//                           return Card(
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 6),
//                             elevation: 3,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8)),
//                             child: GestureDetector(
//                               onTap:(){
//                                // Navigate to detail/edit screen
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) =>
//                                         CompanyDetailScreen(company: c),
//                                   ),
//                                 );
//                               } ,
//                               child: ListTile(
//                                 leading: ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Image.network(
//                                     c.companyLogo?.url ?? "",
//                                     width: 50,
//                                     height: 50,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return const Icon(Icons.business, size: 40, color: Colors.grey);
//                                     },
//                                   ),
//                                 ),
//
//                                 title: Text(
//                                   c.companyName,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold, fontSize: 16),
//                                 ),
//                                 subtitle: Text('${c.businessType} • ${c.city}'),
//                                 trailing: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     // 🟢 Edit Button
//                                     IconButton(
//                                       icon: const Icon(Icons.edit, color: Colors.blue),
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (_) => UpdateCustomerScreen(customerId: c.id),
//                                           ),
//                                         );
//                                       },
//
//                                     ),
//
//                                     //
//                                     // 🔴 Delete Button
//                                     if (userRole == 'admin')
//                                       IconButton(
//                                       icon: const Icon(Icons.delete, color: Colors.red),
//                                       onPressed: () async {
//                                         final confirm = await showDialog<bool>(
//                                           context: context,
//                                           builder: (context) => AlertDialog(
//                                             title: const Text('Delete Company'),
//                                             content: Text(
//                                                 'Are you sure you want to delete "${c.companyName}"?'),
//                                             actions: [
//                                               TextButton(
//                                                 onPressed: () =>
//                                                     Navigator.pop(context, false),
//                                                 child: const Text('Cancel'),
//                                               ),
//                                               ElevatedButton(
//                                                 onPressed: () =>
//                                                     Navigator.pop(context, true),
//                                                 child: const Text('Delete'),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//
//                                         if (confirm == true) {
//                                           provider.deleteCompany(c.id);
//                                         }
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                                   },
//                                 ),
//                         ),
//                         if (totalPages > 1)
//                           Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Previous
//                                 ElevatedButton(
//                                   onPressed: currentPage > 0
//                                       ? () {
//                                     setState(() {
//                                       currentPage--;
//                                     });
//                                   }
//                                       : null,
//                                   child: const Text("Previous"),
//                                 ),
//
//                                 Text(
//                                   "Page ${currentPage + 1} / $totalPages",
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold),
//                                 ),
//
//                                 // Next
//                                 ElevatedButton(
//                                   onPressed: currentPage < totalPages - 1
//                                       ? () {
//                                     setState(() {
//                                       currentPage++;
//                                     });
//                                   }
//                                       : null,
//                                   child: const Text("Next"),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                       ],
//                     );
//                   }
//                 ),
//               ),
//             ],
//           ),
//
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Provider/customer/customer_provider.dart';
import 'add_customer.dart';
import 'customer detail.dart';
import 'customerUpdate.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  String? userRole;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  bool _showFloatingButton = true;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompanyProvider>(context, listen: false).fetchCompanies();
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

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role') ?? 'user';
    });
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

  void _refreshCompanies() {
    Provider.of<CompanyProvider>(context, listen: false).fetchCompanies();
  }

  List<String> _getBusinessTypes(CompanyProvider provider) {
    final types = provider.companies
        .map((c) => c.businessType)
        .where((type) => type != null && type.isNotEmpty)
        .toSet()
        .toList()
        .cast<String>();
    return ['All', ...types];
  }

  List<dynamic> _getFilteredCompanies(CompanyProvider provider) {
    var filtered = provider.companies;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((company) {
        final name = company.companyName.toLowerCase();
        final city = company.city?.toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || city.contains(query);
      }).toList();
    }

    // Apply business type filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((company) {
        return company.businessType == _selectedFilter;
      }).toList();
    }

    return filtered;
  }

  void _showDeleteDialog(BuildContext context, String companyId, String companyName) {
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
          'Delete Company',
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
              'Are you sure you want to delete "$companyName"?',
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
              Provider.of<CompanyProvider>(context, listen: false)
                  .deleteCompany(companyId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Company deleted successfully'),
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
      body: Consumer<CompanyProvider>(
        builder: (context, provider, child) {
          final filteredCompanies = _getFilteredCompanies(provider);
          final totalPages = (filteredCompanies.length / _itemsPerPage).ceil();
          final startIndex = _currentPage * _itemsPerPage;
          final endIndex = startIndex + _itemsPerPage > filteredCompanies.length
              ? filteredCompanies.length
              : startIndex + _itemsPerPage;
          final paginatedList = filteredCompanies.sublist(startIndex, endIndex);
          final businessTypes = _getBusinessTypes(provider);

          return NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 180,
                  elevation: 4,
                  backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                  surfaceTintColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      onPressed: _refreshCompanies,
                      icon: const Icon(Icons.refresh_rounded),
                      tooltip: 'Refresh',
                    ),
                    if (userRole == 'admin')
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddCustomerScreen(),
                              ),
                            );
                          },
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                  title: Text(
                    'Customers',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  centerTitle: true,





                  // flexibleSpace: FlexibleSpaceBar(
                  //  // collapseMode: CollapseMode.pin,
                  //   centerTitle: true,
                  //  // titlePadding: const EdgeInsets.only(bottom: 16),
                  //   title: Text(
                  //     'Customers',
                  //     style: TextStyle(
                  //       color: theme.colorScheme.primary,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 20,
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
                  //     child: Padding(
                  //       padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         children: [
                  //           Text(
                  //             'Customers',
                  //             style: TextStyle(
                  //               fontSize: 32,
                  //               fontWeight: FontWeight.bold,
                  //               color: theme.colorScheme.primary,
                  //             ),
                  //           ),
                  //           const SizedBox(height: 4),
                  //           Consumer<CompanyProvider>(
                  //             builder: (context, provider, child) {
                  //               return Text(
                  //                 '${provider.companies.length} companies',
                  //                 style: TextStyle(
                  //                   fontSize: 14,
                  //                   color: Colors.grey[600],
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(92), // Reduced from 100 to 92
                    child: Container(
                      color: isDarkMode ? Colors.grey[900] : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reduced vertical padding
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Changed from default to min
                          children: [
                            // Search Bar
                            Container(
                              height: 44, // Reduced from 48
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 12), // Reduced from 16
                                  Icon(
                                    Icons.search_rounded,
                                    size: 20, // Added explicit size
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 8), // Reduced from 12
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: (value) {
                                        setState(() => _searchQuery = value);
                                      },
                                      style: TextStyle(
                                        fontSize: 14, // Reduced font size
                                        height: 1.2, // Tighter line height
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Search companies...',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                          height: 1.2,
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
                                        size: 18, // Reduced size
                                        color: Colors.grey[500],
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
                            const SizedBox(height: 8), // Reduced from 12

                            // Filter Chips - More compact
                            Consumer<CompanyProvider>(
                              builder: (context, provider, child) {
                                final businessTypes = _getBusinessTypes(provider);
                                return SizedBox(
                                  height: 36, // Reduced from 40
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: businessTypes.map((type) {
                                      final isSelected = _selectedFilter == type;
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 6), // Reduced from 8
                                        child: FilterChip(
                                          label: Text(
                                            type,
                                            style: TextStyle(
                                              fontSize: 12, // Reduced font size
                                            ),
                                          ),
                                          selected: isSelected,
                                          onSelected: (selected) {
                                            setState(() => _selectedFilter = selected ? type : 'All');
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
                                            borderRadius: BorderRadius.circular(16), // Reduced from 20
                                            side: BorderSide(
                                              color: isSelected
                                                  ? theme.colorScheme.primary
                                                  : Colors.transparent,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8, // Reduced padding
                                            vertical: 4,
                                          ),
                                          visualDensity: VisualDensity.compact, // Added compact density
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
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
                : filteredCompanies.isEmpty
                ? _buildEmptyState(context, _searchQuery, _searchController)
                : _buildCompanyList(context, paginatedList, totalPages, theme, isDarkMode),
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
            'Error Loading Data',
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
              Provider.of<CompanyProvider>(context, listen: false).fetchCompanies();
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
            Icons.business_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            searchQuery.isNotEmpty ? 'No Companies Found' : 'No Companies',
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
                  ? 'No companies match your search'
                  : 'Add your first company to get started',
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
          else if (userRole == 'admin')
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCustomerScreen()),
                );
              },
              icon: const Icon(Icons.add_business_rounded),
              label: const Text('Add Company'),
            ),
        ],
      ),
    );
  }

  Widget _buildCompanyList(BuildContext context, List<dynamic> companies,
      int totalPages, ThemeData theme, bool isDarkMode) {
    final provider = Provider.of<CompanyProvider>(context, listen: false);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: companies.length,
            itemBuilder: (context, index) {
              final company = companies[index];
              final initials = company.companyName
                  .split(' ')
                  .map((word) => word.isNotEmpty ? word[0] : '')
                  .take(2)
                  .join()
                  .toUpperCase();

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CompanyDetailScreen(company: company),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Company Logo
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getCompanyColor(index),
                            ),
                            child: ClipOval(
                              child: company.companyLogo?.url != null &&
                                  company.companyLogo!.url!.isNotEmpty
                                  ? Image.network(
                                company.companyLogo!.url!,
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
                              )
                                  : Center(
                                child: Text(
                                  initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Company Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        company.companyName,
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
                                        company.businessType ?? 'Unknown',
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
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: Colors.grey[500],
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        company.city ?? 'No location',
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
                                if (company.email != null && company.email!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.email_outlined,
                                        size: 14,
                                        color: Colors.grey[500],
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          company.email!,
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
                                ],
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
                                      builder: (_) =>
                                          UpdateCustomerScreen(customerId: company.id),
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
                              if (userRole == 'admin')
                                IconButton(
                                  onPressed: () => _showDeleteDialog(
                                    context,
                                    company.id,
                                    company.companyName,
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
                // Previous Button
                OutlinedButton.icon(
                  onPressed: _currentPage > 0
                      ? () {
                    setState(() => _currentPage--);
                  }
                      : null,
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: const Text('Previous'),
                ),

                // Page Info
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

                // Next Button
                OutlinedButton.icon(
                  onPressed: _currentPage < totalPages - 1
                      ? () {
                    setState(() => _currentPage++);
                  }
                      : null,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: const Text('Next'),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Color _getCompanyColor(int index) {
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