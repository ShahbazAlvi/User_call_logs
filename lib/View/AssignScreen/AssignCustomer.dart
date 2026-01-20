
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../Provider/AssignCustomerProvider/AssignProvider.dart';
// import '../../Provider/product/product_provider.dart';
// import '../../Provider/staff/StaffProvider.dart';
//
// class UnassignCustomerScreen extends StatefulWidget {
//   const UnassignCustomerScreen({super.key});
//
//   @override
//   State<UnassignCustomerScreen> createState() => _UnassignCustomerScreenState();
// }
//
// class _UnassignCustomerScreenState extends State<UnassignCustomerScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() =>
//         Provider.of<UnassignCustomerProvider>(context, listen: false)
//             .fetchUnassignedCustomers());
//   }
//
//   Future<void> _showAssignDialog(BuildContext context) async {
//     final assignProvider =
//     Provider.of<UnassignCustomerProvider>(context, listen: false);
//     final staffProvider =
//     Provider.of<StaffProvider>(context, listen: false);
//     final productProvider =
//     Provider.of<ProductProvider>(context, listen: false);
//
//     await Future.wait([
//       staffProvider.fetchStaff(),
//       productProvider.fetchProducts(),
//     ]);
//
//     String? selectedStaff;
//     String? selectedProduct;
//
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Assign Staff & Product'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Staff Dropdown
//                 Consumer<StaffProvider>(
//                   builder: (context, staffProv, _) {
//                     if (staffProv.isLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     return DropdownButtonFormField<String>(
//                       decoration: const InputDecoration(
//                         labelText: 'Select Staff',
//                         border: OutlineInputBorder(),
//                       ),
//                       value: selectedStaff,
//                       items: staffProv.staffs.map((staff) {
//                         return DropdownMenuItem<String>(
//                           value: staff.sId,
//                           child: Text(staff.username ?? 'Unnamed Staff'),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         selectedStaff = value;
//                       },
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 12),
//
//                 // Product Dropdown
//                 Consumer<ProductProvider>(
//                   builder: (context, productProv, _) {
//                     if (productProv.isLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     return DropdownButtonFormField<String>(
//                       decoration: const InputDecoration(
//                         labelText: 'Select Product',
//                         border: OutlineInputBorder(),
//                       ),
//                       value: selectedProduct,
//                       items: productProv.products.map((product) {
//                         return DropdownMenuItem<String>(
//                           value: product.sId,
//                           child: Text(product.name ?? 'Unnamed Product'),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         selectedProduct = value;
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () => Navigator.pop(context),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (selectedStaff == null || selectedProduct == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Please select both fields')),
//                   );
//                   return;
//                 }
//
//                 await assignProvider.assignSelectedCustomers(
//                   staffId: selectedStaff!,
//                   productId: selectedProduct!,
//                 );
//
//                 if (context.mounted) {
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Customers Assigned Successfully')),
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5B86E5)),
//               child: const Text('Assign', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<UnassignCustomerProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text( provider.selectedIds.isEmpty
//             ? 'Unassigned Customers'
//             : 'Selected: ${provider.selectedIds.length}',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 22,
//               letterSpacing: 1.2,
//             ))),
//           actions: [
//             if (provider.selectedIds.isNotEmpty)
//               IconButton(
//                 icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
//                 onPressed: () => _showAssignDialog(context),
//               ),
//           ],
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
//       //   title: Text(
//       //     provider.selectedIds.isEmpty
//       //         ? 'Unassigned Customers'
//       //         : 'Selected: ${provider.selectedIds.length}',
//       //     style: const TextStyle(color: Colors.white),
//       //   ),
//       //   actions: [
//       //     if (provider.selectedIds.isNotEmpty)
//       //       IconButton(
//       //         icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
//       //         onPressed: () => _showAssignDialog(context),
//       //       ),
//       //   ],
//       // ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           // Search bar
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: TextField(
//               onChanged: provider.searchCustomer,
//               decoration: InputDecoration(
//                 hintText: 'Search company...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//
//           // List of customers
//           Expanded(
//             child: ListView.builder(
//               itemCount: provider.customers.length,
//               itemBuilder: (context, index) {
//                 final item = provider.customers[index];
//                 final person = (item.persons?.isNotEmpty ?? false)
//                     ? item.persons!.first.fullName ?? 'N/A'
//                     : 'N/A';
//                 final phone = (item.persons?.isNotEmpty ?? false)
//                     ? item.persons!.first.phoneNumber ?? 'N/A'
//                     : 'N/A';
//
//                 return Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   elevation: 3,
//                   child: ListTile(
//                     leading: Checkbox(
//                       value: provider.selectedIds.contains(item.id),
//                       onChanged: (_) => provider.toggleSelection(item.id!),
//                     ),
//                     title: Text(
//                       item.companyName ?? 'Unknown Company',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Business: ${item.businessType ?? '-'}'),
//                         Text('Person: $person'),
//                         Text('Phone: $phone'),
//                       ],
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../Provider/AssignCustomerProvider/AssignProvider.dart';
import '../../Provider/product/product_provider.dart';
import '../../Provider/staff/StaffProvider.dart';

class UnassignCustomerScreen extends StatefulWidget {
  const UnassignCustomerScreen({super.key});

  @override
  State<UnassignCustomerScreen> createState() => _UnassignCustomerScreenState();
}

class _UnassignCustomerScreenState extends State<UnassignCustomerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<UnassignCustomerProvider>(context, listen: false)
            .fetchUnassignedCustomers());
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshCustomers() {
    Provider.of<UnassignCustomerProvider>(context, listen: false)
        .fetchUnassignedCustomers();
  }

  Future<void> _showAssignDialog(BuildContext context) async {
    final assignProvider =
    Provider.of<UnassignCustomerProvider>(context, listen: false);
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    await Future.wait([
      staffProvider.fetchStaff(),
      productProvider.fetchProducts(),
    ]);

    String? selectedStaff;
    String? selectedProduct;

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          surfaceTintColor: isDarkMode ? Colors.grey[800] : Colors.white,
          title: Text(
            'Assign Staff & Product',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Staff Dropdown
                Consumer<StaffProvider>(
                  builder: (context, staffProv, _) {
                    if (staffProv.isLoading) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      );
                    }
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
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Staff',
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                            ),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.person_rounded,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          value: selectedStaff,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.grey[800],
                          ),
                          dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                          items: staffProv.staffs.map((staff) {
                            return DropdownMenuItem<String>(
                              value: staff.sId,
                              child: Text(staff.username ?? 'Unnamed Staff'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedStaff = value;
                          },
                          validator: (value) => value == null
                              ? 'Please select a staff member'
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Product Dropdown
                Consumer<ProductProvider>(
                  builder: (context, productProv, _) {
                    if (productProv.isLoading) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      );
                    }
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
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Product',
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                            ),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.inventory_2_rounded,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          value: selectedProduct,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.grey[800],
                          ),
                          dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                          items: productProv.products.map((product) {
                            return DropdownMenuItem<String>(
                              value: product.sId,
                              child: Text(product.name ?? 'Unnamed Product'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedProduct = value;
                          },
                          validator: (value) =>
                          value == null ? 'Please select a product' : null,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedStaff == null || selectedProduct == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please select both fields'),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                  return;
                }

                try {
                  await assignProvider.assignSelectedCustomers(
                    staffId: selectedStaff!,
                    productId: selectedProduct!,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Customers assigned successfully'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to assign: $e'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Assign'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: Consumer<UnassignCustomerProvider>(
        builder: (context, provider, child) {
          final filteredCustomers = _searchQuery.isEmpty
              ? provider.customers
              : provider.customers.where((customer) {
            final companyName = customer.companyName?.toLowerCase() ?? '';
            final businessType = customer.businessType?.toLowerCase() ?? '';
            final query = _searchQuery.toLowerCase();
            return companyName.contains(query) || businessType.contains(query);
          }).toList();

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
                      onPressed: _refreshCustomers,
                      icon: const Icon(Icons.refresh_rounded),
                      tooltip: 'Refresh',
                    ),
                    if (provider.selectedIds.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          onPressed: () => _showAssignDialog(context),
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.person_add_alt_1_rounded,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                          tooltip: 'Assign Selected',
                        ),
                      ),
                  ],
                  title: Text(
                    provider.selectedIds.isEmpty
                        ? 'Unassigned Customers'
                        : 'Selected: ${provider.selectedIds.length}',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  centerTitle: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(90),
                    child: Container(
                      color: isDarkMode ? Colors.grey[900] : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(fontSize: 15),
                                  decoration: InputDecoration(
                                    hintText: 'Search unassigned customers...',
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
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: provider.isLoading
                ? _buildShimmerLoading()
                : provider.errorMessage != null
                ? _buildErrorState(provider.errorMessage!, theme, isDarkMode)
                : filteredCustomers.isEmpty
                ? _buildEmptyState(context, _searchQuery, _searchController)
                : _buildCustomerList(context, filteredCustomers, provider, theme, isDarkMode),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 100,
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
            'Error Loading Customers',
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
              Provider.of<UnassignCustomerProvider>(context, listen: false)
                  .fetchUnassignedCustomers();
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
            Icons.group_remove_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            searchQuery.isNotEmpty ? 'No Customers Found' : 'No Unassigned Customers',
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
                  ? 'No unassigned customers match your search'
                  : 'All customers have been assigned to staff',
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

  Widget _buildCustomerList(
      BuildContext context,
      List<dynamic> customers,
      UnassignCustomerProvider provider,
      ThemeData theme,
      bool isDarkMode,
      ) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        final person = (customer.persons?.isNotEmpty ?? false)
            ? customer.persons!.first.fullName ?? 'N/A'
            : 'N/A';
        final phone = (customer.persons?.isNotEmpty ?? false)
            ? customer.persons!.first.phoneNumber ?? 'N/A'
            : 'N/A';
        final isSelected = provider.selectedIds.contains(customer.id);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                provider.toggleSelection(customer.id!);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (_) => provider.toggleSelection(customer.id!),
                        activeColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Customer Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  customer.companyName ?? 'Unknown Company',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  customer.businessType ?? '-',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Contact Person
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.person_outline_rounded,
                                size: 16,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Contact Person',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      person,
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
                          ),
                          const SizedBox(height: 8),

                          // Phone Number
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 16,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phone Number',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      phone,
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
                          ),
                        ],
                      ),
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
}