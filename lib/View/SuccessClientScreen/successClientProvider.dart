// import 'package:flutter/material.dart';
// import '../../Provider/successClient/SuccessClientProvider.dart';
// import '../../model/SuccessClient.dart';
//
// class SuccessClientScreen extends StatefulWidget {
//   const SuccessClientScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SuccessClientScreen> createState() => _SuccessClientScreenState();
// }
//
// class _SuccessClientScreenState extends State<SuccessClientScreen> {
//   late Future<SuccessClientModel?> _futureClients;
//   final _service = SuccessClientService();
//
//   @override
//   void initState() {
//     super.initState();
//     _futureClients = _service.fetchSuccessClients();
//   }
//
//   Future<void> _deleteClient(String id) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Client"),
//         content: const Text("Are you sure you want to delete this client?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
//           TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
//         ],
//       ),
//     );
//
//     if (confirm != true) return;
//
//     final success = await _service.deleteClient(id);
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("✅ Client deleted successfully")),
//       );
//       setState(() {
//         _futureClients = _service.fetchSuccessClients(); // refresh list
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("❌ Failed to delete client")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: const Text('Success Clients',
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
//       body: FutureBuilder<SuccessClientModel?>(
//         future: _futureClients,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data == null) {
//             return const Center(child: Text('No data found.'));
//           }
//
//           final clients = snapshot.data!.data;
//
//           return ListView.builder(
//             itemCount: clients.length,
//             itemBuilder: (context, index) {
//               final client = clients[index];
//               return Card(
//                 margin: const EdgeInsets.all(8),
//                 child: ListTile(
//                   title: Text(client.companyName),
//                   subtitle: Text('${client.designation} • ${client.status}'),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(client.product?.name ?? 'No Product'),
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () => _deleteClient(client.id),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//



import 'package:flutter/material.dart';

import '../../Provider/successClient/SuccessClientProvider.dart';
import '../../model/SuccessClient.dart';

class SuccessClientScreen extends StatefulWidget {
  const SuccessClientScreen({Key? key}) : super(key: key);

  @override
  State<SuccessClientScreen> createState() => _SuccessClientScreenState();
}

class _SuccessClientScreenState extends State<SuccessClientScreen> {
  late Future<SuccessClientModel?> _futureClients;
  final _service = SuccessClientService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureClients = _service.fetchSuccessClients();
  }

  Future<void> _deleteClient(String id, String companyName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Confirm Deletion",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: Text(
          "Are you sure you want to delete '$companyName'? This action cannot be undone.",
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.1),
              foregroundColor: Colors.red,
            ),
            child: const Text("DELETE"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await _service.deleteClient(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Client deleted successfully"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      setState(() {
        _futureClients = _service.fetchSuccessClients();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Failed to delete client"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        break;
      case 'pending':
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
      case 'completed':
        bgColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Check what type your client data actually is
  Widget _buildClientCard(dynamic client, BuildContext context) {
    // Try to access properties - you might need to adjust these based on your actual model
    final companyName = client.companyName?.toString() ?? 'Unknown Company';
    final designation = client.designation?.toString() ?? 'No Designation';
    final status = client.status?.toString() ?? 'Unknown';
    final productName = client.product?.name?.toString() ?? 'No Product';
    final clientId = client.id?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          companyName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          designation,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(status),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.category,
                          size: 16,
                          color: Colors.blue.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          productName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: const [
                            Icon(Icons.edit, size: 20, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: const [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'delete') {
                        _deleteClient(clientId, companyName);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Clients Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first client to get started',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text(
          'Success Clients',
          style: TextStyle(
            color: Color(0xFF667EEA),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [
        //         const Color(0xFF667EEA),
        //         const Color(0xFF764BA2),
        //       ],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.blue.shade200.withOpacity(0.3),
        //         blurRadius: 15,
        //         offset: const Offset(0, 4),
        //       ),
        //     ],
        //   ),
        // ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search clients...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<SuccessClientModel?>(
              future: _futureClients,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            const Color(0xFF667EEA),
                          ),
                          strokeWidth: 2,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Loading Clients...',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Error Loading Clients',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _futureClients = _service.fetchSuccessClients();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF667EEA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return _buildEmptyState();
                }

                // Try to access the clients list - check your actual model structure
                final clients = snapshot.data!.data ?? [];

                if (clients.isEmpty) {
                  return _buildEmptyState();
                }

                // Filter clients based on search query
                final filteredClients = _searchQuery.isEmpty
                    ? clients
                    : clients.where((client) {
                  final companyName = client.companyName?.toString().toLowerCase() ?? '';
                  final designation = client.designation?.toString().toLowerCase() ?? '';
                  final productName = client.product?.name?.toString().toLowerCase() ?? '';

                  return companyName.contains(_searchQuery.toLowerCase()) ||
                      designation.contains(_searchQuery.toLowerCase()) ||
                      productName.contains(_searchQuery.toLowerCase());
                }).toList();

                if (filteredClients.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _futureClients = _service.fetchSuccessClients();
                    });
                  },
                  color: const Color(0xFF667EEA),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filteredClients.length,
                    itemBuilder: (context, index) {
                      final client = filteredClients[index];
                      return _buildClientCard(client, context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}