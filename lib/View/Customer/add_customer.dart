
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../Provider/customer/customer_provider.dart';
// import '../../Provider/product/product_provider.dart';
// import '../../Provider/staff/StaffProvider.dart';
//
// class AddCustomerScreen extends StatefulWidget {
//   const AddCustomerScreen({super.key});
//
//   @override
//   State<AddCustomerScreen> createState() => _AddCustomerScreenState();
// }
//
// class _AddCustomerScreenState extends State<AddCustomerScreen> {
//   @override
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       Provider.of<StaffProvider>(context, listen: false).fetchStaff();
//       Provider.of<ProductProvider>(context, listen: false).fetchProducts();
//     });
//   }
//
//   Widget build(BuildContext context) {
//
//
//     final staffProvider = Provider.of<StaffProvider>(context, listen: false);
//
//     final provider = Provider.of<CompanyProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: const Text('Add Customer',
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
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Company Logo
//             GestureDetector(
//               onTap: provider.pickImage,
//               child: provider.companyLogo != null
//                   ? Image.file(provider.companyLogo!,
//                   height: 100, width: 100, fit: BoxFit.cover)
//                   : Container(
//                 height: 100,
//                 width: 100,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(Icons.add_a_photo, size: 40),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             _buildTextField(provider.businessTypeController, 'Business Type'),
//             _buildTextField(provider.companyNameController, 'Company Name'),
//             _buildTextField(provider.addressController, 'Address'),
//             _buildTextField(provider.cityController, 'City'),
//             _buildTextField(provider.emailController, 'Email'),
//             _buildTextField(provider.phoneController, 'Phone Number'),
//
//             const Divider(height: 40),
//             const Text(
//               'Person Details',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//
//             // Dynamic Person Fields
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: provider.personsList.length,
//               itemBuilder: (context, index) {
//                 final person = provider.personsList[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Person ${index + 1}',
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold)),
//                             if (provider.personsList.length > 1)
//                               IconButton(
//                                 icon: const Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () =>
//                                     provider.removePerson(index),
//                               ),
//                           ],
//                         ),
//                         _buildTextField(person['fullName']!, 'Full Name'),
//                         _buildTextField(person['designation']!, 'Designation'),
//                         _buildTextField(person['department']!, 'Department'),
//                         _buildTextField(person['phoneNumber']!, 'Phone Number'),
//                         _buildTextField(person['email']!, 'Email'),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//
//             // Add another person button
//             OutlinedButton.icon(
//               onPressed: provider.addPerson,
//               icon: const Icon(Icons.add),
//               label: const Text('Add Another Person'),
//             ),
//
//             const Divider(height: 40),
//             Consumer<StaffProvider>(
//               builder: (context, staffProvider, _) {
//                 final staffList = staffProvider.staffs;
//
//                 if (staffProvider.isLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (staffList.isEmpty) {
//                   return const Text('No staff available');
//                 }
//
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 6),
//                   child: DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(
//                       labelText: 'Assigned Staff',
//                       border: OutlineInputBorder(),
//                     ),
//                     // ✅ Ensure the selected value exists in list
//                     value: staffList.any((s) => s.username == provider.selectedStaffName)
//                         ? provider.selectedStaffName
//                         : null,
//                     items: staffList.map((staff) {
//                       return DropdownMenuItem<String>(
//                         value: staff.username, // ✅ store name as the value
//                         child: Text(staff.username ?? 'Unnamed Staff'),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       provider.selectedStaffName = value; // ✅ store name in provider
//                       provider.notifyListeners();
//                     },
//                   ),
//                 );
//               },
//             ),
//
//
//             //_buildTextField(provider.assignedProductsController, 'Assigned Product ID'),
//             Consumer<ProductProvider>(
//               builder: (context, productProvider, _) {
//                 final productList = productProvider.products;
//
//                 if (productProvider.isLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (productList.isEmpty) {
//                   return const Text('No products available');
//                 }
//
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 6),
//                   child: DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(
//                       labelText: 'Assigned Product',
//                       border: OutlineInputBorder(),
//                     ),
//                     value: provider.selectedProductId,
//                     items: productList.map((product) {
//                       return DropdownMenuItem<String>(
//                         value: product.sId, // ✅ pass product ID
//                         child: Text(product.name ?? 'Unnamed Product'), // ✅ show product name
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       provider.selectedProductId = value;
//                       provider.notifyListeners();
//                     },
//                   ),
//                 );
//               },
//             ),
//
//
//             const SizedBox(height: 20),
//
//             provider.isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton.icon(
//               onPressed: () async {
//                 await provider.createCustomer();
//                 if (context.mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text(provider.message),
//                     backgroundColor: Colors.blue,
//                   ));
//                 }
//                 provider.clearForm();
//               },
//               icon: const Icon(Icons.save),
//               label: const Text('Create Customer'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String label) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:infinity/compoents/AppTextfield.dart';
// import 'package:provider/provider.dart';
// import '../../Provider/customer/customer_provider.dart';
// import '../../Provider/product/product_provider.dart';
// import '../../Provider/staff/StaffProvider.dart';
//
// class AddCustomerScreen extends StatefulWidget {
//   const AddCustomerScreen({super.key});
//
//   @override
//   State<AddCustomerScreen> createState() => _AddCustomerScreenState();
// }
//
// class _AddCustomerScreenState extends State<AddCustomerScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isSubmitting = false;
//   String? _logoError;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       Provider.of<StaffProvider>(context, listen: false).fetchStaff();
//       Provider.of<ProductProvider>(context, listen: false).fetchProducts();
//     });
//   }
//
//   void _showImagePicker(BuildContext context) {
//     final provider = Provider.of<CompanyProvider>(context, listen: false);
//
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Text(
//               'Select Company Logo',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//             ),
//           ),
//           ListTile(
//             leading: Icon(
//               Icons.photo_library_rounded,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             title: const Text('Choose from Gallery'),
//             onTap: () async {
//               Navigator.pop(context);
//               await provider.pickImage();
//               if (mounted) {
//                 setState(() => _logoError = null);
//               }
//             },
//           ),
//           ListTile(
//             leading: Icon(
//               Icons.camera_alt_rounded,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             title: const Text('Take a Photo'),
//             onTap: () {
//               Navigator.pop(context);
//               // Add camera functionality if needed
//             },
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _submitForm(BuildContext context) async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//
//     final provider = Provider.of<CompanyProvider>(context, listen: false);
//
//     // Validate logo
//     if (provider.companyLogo == null) {
//       setState(() => _logoError = 'Please select a company logo');
//       return;
//     }
//
//     setState(() => _isSubmitting = true);
//
//     try {
//       final success = await provider.createCustomer();
//
//       if (mounted) {
//         _showSuccessDialog(context);
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isSubmitting = false);
//       }
//     }
//   }
//
//   void _showSuccessDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         icon: Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.green.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(
//             Icons.check_circle_rounded,
//             color: Colors.green,
//             size: 48,
//           ),
//         ),
//         title: const Text(
//           'Customer Added Successfully!',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         content: const Text(
//           'The new customer has been added to your system.',
//           textAlign: TextAlign.center,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close dialog
//               Navigator.pop(context); // Close screen
//             },
//             child: const Text('Back to List'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context); // Close dialog
//               Provider.of<CompanyProvider>(context, listen: false).clearForm();
//               _formKey.currentState?.reset();
//               setState(() => _logoError = null);
//             },
//             child: const Text('Add Another'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//     final provider = Provider.of<CompanyProvider>(context);
//     final staffProvider = Provider.of<StaffProvider>(context);
//     final productProvider = Provider.of<ProductProvider>(context);
//
//     String? Function(dynamic value) validator;
//     return Scaffold(
//       backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             pinned: true,
//             expandedHeight: 140,
//             elevation: 0,
//             backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
//             surfaceTintColor: isDarkMode ? Colors.grey[800] : Colors.white,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new_rounded),
//               onPressed: () => Navigator.pop(context),
//             ),
//             flexibleSpace: FlexibleSpaceBar(
//               centerTitle: true,
//               titlePadding: const EdgeInsets.only(bottom: 16),
//               title: Text(
//                 'Add New Customer',
//                 style: TextStyle(
//                   color: theme.colorScheme.primary,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 22,
//                 ),
//               ),
//               background: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       theme.colorScheme.primary.withOpacity(0.1),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.all(20),
//             sliver: SliverToBoxAdapter(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Company Logo Section
//                     Card(
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         side: BorderSide(
//                           color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
//                         ),
//                       ),
//                       color: isDarkMode ? Colors.grey[800] : Colors.white,
//                       child: Padding(
//                         padding: const EdgeInsets.all(24),
//                         child: Column(
//                           children: [
//                             GestureDetector(
//                               onTap: () => _showImagePicker(context),
//                               child: Container(
//                                 width: 120,
//                                 height: 120,
//                                 decoration: BoxDecoration(
//                                   color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(
//                                     color: (_logoError != null)
//                                         ? Colors.red.withOpacity(0.5)
//                                         : theme.colorScheme.primary.withOpacity(0.3),
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: provider.companyLogo != null
//                                     ? ClipRRect(
//                                   borderRadius: BorderRadius.circular(14),
//                                   child: Image.file(
//                                     provider.companyLogo!,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return Center(
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Icon(
//                                               Icons.error_outline_rounded,
//                                               size: 32,
//                                               color: Colors.grey[400],
//                                             ),
//                                             const SizedBox(height: 8),
//                                             Text(
//                                               'Invalid Image',
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 color: Colors.grey[500],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 )
//                                     : Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.add_photo_alternate_rounded,
//                                       size: 40,
//                                       color: theme.colorScheme.primary.withOpacity(0.5),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'Add Logo',
//                                       style: TextStyle(
//                                         color: theme.colorScheme.primary,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             if (_logoError != null) ...[
//                               const SizedBox(height: 8),
//                               Text(
//                                 _logoError!,
//                                 style: TextStyle(
//                                   color: Colors.red,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                             const SizedBox(height: 8),
//                             Text(
//                               'Tap to add company logo',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[500],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//
//                     // Company Information Card
//                     Card(
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         side: BorderSide(
//                           color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
//                         ),
//                       ),
//                       color: isDarkMode ? Colors.grey[800] : Colors.white,
//                       child: Padding(
//                         padding: const EdgeInsets.all(24),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Company Information',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: theme.colorScheme.primary,
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             AppTextField(controller:provider.companyNameController, label: 'Company Name', validator:(value) => value!.isEmpty),
//
//                             const SizedBox(height: 16),
//                             AppTextField(controller: provider.businessTypeController, label: 'Business Type', validator:(value) => value!.isEmpty),
//                             const SizedBox(height: 16),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: AppTextField(controller: provider.cityController, label: 'city', validator: validator)
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: _buildTextField(
//                                     controller: provider.phoneController,
//                                     label: 'Phone',
//                                     icon: Icons.phone_rounded,
//                                     keyboardType: TextInputType.phone,
//                                     isRequired: true,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//                             _buildTextField(
//                               controller: provider.addressController,
//                               label: 'Address',
//                               icon: Icons.location_on_rounded,
//                               maxLines: 2,
//                               isRequired: true,
//                             ),
//                             const SizedBox(height: 16),
//                             _buildTextField(
//                               controller: provider.emailController,
//                               label: 'Email Address',
//                               icon: Icons.email_rounded,
//                               keyboardType: TextInputType.emailAddress,
//                               isRequired: true,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//
//                     // Contact Persons Card
//                     Card(
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         side: BorderSide(
//                           color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
//                         ),
//                       ),
//                       color: isDarkMode ? Colors.grey[800] : Colors.white,
//                       child: Padding(
//                         padding: const EdgeInsets.all(24),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Contact Persons',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: theme.colorScheme.primary,
//                                   ),
//                                 ),
//                                 OutlinedButton.icon(
//                                   onPressed: provider.addPerson,
//                                   icon: const Icon(Icons.add_rounded, size: 16),
//                                   label: const Text('Add Person'),
//                                   style: OutlinedButton.styleFrom(
//                                     visualDensity: VisualDensity.compact,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 20),
//
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: provider.personsList.length,
//                               itemBuilder: (context, index) {
//                                 final person = provider.personsList[index];
//                                 return Container(
//                                   margin: const EdgeInsets.only(bottom: 16),
//                                   padding: const EdgeInsets.all(16),
//                                   decoration: BoxDecoration(
//                                     color: isDarkMode ? Colors.grey[700] : Colors.grey[50],
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             'Person ${index + 1}',
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               color: theme.colorScheme.primary,
//                                             ),
//                                           ),
//                                           if (provider.personsList.length > 1)
//                                             IconButton(
//                                               onPressed: () => provider.removePerson(index),
//                                               icon: Icon(
//                                                 Icons.delete_outline_rounded,
//                                                 color: Colors.red,
//                                                 size: 20,
//                                               ),
//                                               padding: EdgeInsets.zero,
//                                               constraints: const BoxConstraints(),
//                                             ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 12),
//                                       _buildPersonTextField(
//                                         controller: person['fullName']!,
//                                         label: 'Full Name',
//                                       ),
//                                       const SizedBox(height: 12),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: _buildPersonTextField(
//                                               controller: person['designation']!,
//                                               label: 'Designation',
//                                             ),
//                                           ),
//                                           const SizedBox(width: 12),
//                                           Expanded(
//                                             child: _buildPersonTextField(
//                                               controller: person['department']!,
//                                               label: 'Department',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 12),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: _buildPersonTextField(
//                                               controller: person['phoneNumber']!,
//                                               label: 'Phone',
//                                               keyboardType: TextInputType.phone,
//                                             ),
//                                           ),
//                                           const SizedBox(width: 12),
//                                           Expanded(
//                                             child: _buildPersonTextField(
//                                               controller: person['email']!,
//                                               label: 'Email',
//                                               keyboardType: TextInputType.emailAddress,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//
//                     // Assignments Card
//                     Card(
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         side: BorderSide(
//                           color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
//                         ),
//                       ),
//                       color: isDarkMode ? Colors.grey[800] : Colors.white,
//                       child: Padding(
//                         padding: const EdgeInsets.all(24),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Assignments',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: theme.colorScheme.primary,
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//
//                             // Assigned Staff
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Assigned Staff',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: isDarkMode ? Colors.white : Colors.grey[700],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 staffProvider.isLoading
//                                     ? Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 16),
//                                   child: Center(
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: theme.colorScheme.primary,
//                                     ),
//                                   ),
//                                 )
//                                     : staffProvider.staffs.isEmpty
//                                     ? Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 12),
//                                   decoration: BoxDecoration(
//                                     color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: const Center(
//                                     child: Text('No staff available'),
//                                   ),
//                                 )
//                                     : Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                                   decoration: BoxDecoration(
//                                     color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
//                                     borderRadius: BorderRadius.circular(12),
//                                     border: Border.all(
//                                       color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
//                                     ),
//                                   ),
//                                   child: DropdownButton<String>(
//                                     value: provider.selectedStaffName,
//                                     isExpanded: true,
//                                     underline: const SizedBox(),
//                                     hint: const Text('Select Staff'),
//                                     icon: Icon(
//                                       Icons.arrow_drop_down_rounded,
//                                       color: theme.colorScheme.primary,
//                                     ),
//                                     style: TextStyle(
//                                       color: isDarkMode ? Colors.white : Colors.grey[800],
//                                       fontSize: 14,
//                                     ),
//                                     onChanged: (value) {
//                                       provider.selectedStaffName = value;
//                                       provider.notifyListeners();
//                                     },
//                                     items: staffProvider.staffs.map((staff) {
//                                       return DropdownMenuItem<String>(
//                                         value: staff.username,
//                                         child: Text(staff.username ?? 'Unnamed Staff'),
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 16),
//
//                             // Assigned Product
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Assigned Product',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: isDarkMode ? Colors.white : Colors.grey[700],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 productProvider.isLoading
//                                     ? Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 16),
//                                   child: Center(
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: theme.colorScheme.primary,
//                                     ),
//                                   ),
//                                 )
//                                     : productProvider.products.isEmpty
//                                     ? Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 12),
//                                   decoration: BoxDecoration(
//                                     color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: const Center(
//                                     child: Text('No products available'),
//                                   ),
//                                 )
//                                     : Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                                   decoration: BoxDecoration(
//                                     color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
//                                     borderRadius: BorderRadius.circular(12),
//                                     border: Border.all(
//                                       color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
//                                     ),
//                                   ),
//                                   child: DropdownButton<String>(
//                                     value: provider.selectedProductId,
//                                     isExpanded: true,
//                                     underline: const SizedBox(),
//                                     hint: const Text('Select Product'),
//                                     icon: Icon(
//                                       Icons.arrow_drop_down_rounded,
//                                       color: theme.colorScheme.primary,
//                                     ),
//                                     style: TextStyle(
//                                       color: isDarkMode ? Colors.white : Colors.grey[800],
//                                       fontSize: 14,
//                                     ),
//                                     onChanged: (value) {
//                                       provider.selectedProductId = value;
//                                       provider.notifyListeners();
//                                     },
//                                     items: productProvider.products.map((product) {
//                                       return DropdownMenuItem<String>(
//                                         value: product.sId,
//                                         child: Text(product.name ?? 'Unnamed Product'),
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//
//                     // Submit Button
//                     _isSubmitting
//                         ? Center(
//                       child: Column(
//                         children: [
//                           CircularProgressIndicator(
//                             color: theme.colorScheme.primary,
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'Creating Customer...',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                         : Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton(
//                             onPressed: () => Navigator.pop(context),
//                             style: OutlinedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               side: BorderSide(
//                                 color: theme.colorScheme.primary,
//                               ),
//                             ),
//                             child: Text(
//                               'Cancel',
//                               style: TextStyle(
//                                 color: theme.colorScheme.primary,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () => _submitForm(context),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: theme.colorScheme.primary,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               elevation: 4,
//                             ),
//                             child: const Text(
//                               'Create Customer',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//       TextEditingController controller,
//       String label, {
//         IconData? icon,
//         TextInputType keyboardType = TextInputType.text,
//         int maxLines = 1,
//         bool isRequired = false,
//       }) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       style: TextStyle(
//         color: isDarkMode ? Colors.white : Colors.grey[800],
//       ),
//       decoration: InputDecoration(
//         labelText: '$label${isRequired ? ' *' : ''}',
//         labelStyle: TextStyle(
//           color: isDarkMode ? Colors.white70 : Colors.grey[600],
//         ),
//         prefixIcon: icon != null
//             ? Icon(
//           icon,
//           color: theme.colorScheme.primary,
//           size: 20,
//         )
//             : null,
//         filled: true,
//         fillColor: isDarkMode ? Colors.grey[700] : Colors.grey[100],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color: theme.colorScheme.primary,
//             width: 2,
//           ),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 14,
//         ),
//       ),
//       validator: (value) {
//         if (isRequired && (value == null || value.isEmpty)) {
//           return 'Please enter $label';
//         }
//         return null;
//       },
//     );
//   }
//
//   Widget _buildPersonTextField(
//       TextEditingController controller,
//       String label, {
//         TextInputType keyboardType = TextInputType.text,
//       }) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       style: TextStyle(
//         fontSize: 14,
//         color: isDarkMode ? Colors.white : Colors.grey[800],
//       ),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(
//           fontSize: 13,
//           color: isDarkMode ? Colors.white70 : Colors.grey[600],
//         ),
//         filled: true,
//         fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(
//             color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
//           ),
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 12,
//           vertical: 10,
//         ),
//         isDense: true,
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Required';
//         }
//         return null;
//       },
//     );
//   }
// }









import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../compoents/AppTextfield.dart';
import '../../Provider/customer/customer_provider.dart';
import '../../Provider/product/product_provider.dart';
import '../../Provider/staff/StaffProvider.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  String? _logoError;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<StaffProvider>(context, listen: false).fetchStaff();
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  void _showImagePicker(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Select Company Logo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.photo_library_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Choose from Gallery'),
            onTap: () async {
              Navigator.pop(context);
              await provider.pickImage();
              if (mounted) {
                setState(() => _logoError = null);
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.camera_alt_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Take a Photo'),
            onTap: () {
              Navigator.pop(context);
              // Add camera functionality if needed
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = Provider.of<CompanyProvider>(context, listen: false);

    // Validate logo
    if (provider.companyLogo == null) {
      setState(() => _logoError = 'Please select a company logo');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final success = await provider.createCustomer();

      if (mounted) {
        _showSuccessDialog(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 48,
          ),
        ),
        title: const Text(
          'Customer Added Successfully!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: const Text(
          'The new customer has been added to your system.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close screen
            },
            child: const Text('Back to List'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Provider.of<CompanyProvider>(context, listen: false).clearForm();
              _formKey.currentState?.reset();
              setState(() => _logoError = null);
            },
            child: const Text('Add Another'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final provider = Provider.of<CompanyProvider>(context);
    final staffProvider = Provider.of<StaffProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            elevation: 0,
            backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
            surfaceTintColor: isDarkMode ? Colors.grey[800] : Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Add New Customer',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            centerTitle: true,
            // flexibleSpace: FlexibleSpaceBar(
            //   centerTitle: true,
            //   titlePadding: const EdgeInsets.only(bottom: 16),
            //
            //   background: Container(
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: [
            //           theme.colorScheme.primary.withOpacity(0.1),
            //           Colors.transparent,
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Logo Section
                    Center(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                          ),
                        ),
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _showImagePicker(context),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: (_logoError != null)
                                          ? Colors.red.withOpacity(0.5)
                                          : theme.colorScheme.primary.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: provider.companyLogo != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.file(
                                      provider.companyLogo!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error_outline_rounded,
                                                size: 32,
                                                color: Colors.grey[400],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Invalid Image',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                      : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_rounded,
                                        size: 40,
                                        color: theme.colorScheme.primary.withOpacity(0.5),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Add Logo',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_logoError != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  _logoError!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                'Tap to add company logo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Company Information Card
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                        ),
                      ),
                      color: isDarkMode ? Colors.grey[800] : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Company Information',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Company Name
                            AppTextField(
                              controller: provider.companyNameController,
                              label: 'Company Name *',

                              validator: (value) => value!.isEmpty
                                  ? 'Please enter company name'
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            // Business Type
                            AppTextField(
                              controller: provider.businessTypeController,
                              label: 'Business Type *',

                              validator: (value) => value!.isEmpty
                                  ? 'Please enter business type'
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            // City and Phone in Row
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: provider.cityController,
                                    label: 'City *',

                                    validator: (value) => value!.isEmpty
                                        ? 'Please enter city'
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: AppTextField(
                                    controller: provider.phoneController,
                                    label: 'Phone Number *',

                                    keyboardType: TextInputType.phone,
                                    validator: (value) => value!.isEmpty
                                        ? 'Please enter phone number'
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Address
                            AppTextField(
                              controller: provider.addressController,
                              label: 'Address *',

                              validator: (value) => value!.isEmpty
                                  ? 'Please enter address'
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            // Email
                            AppTextField(
                              controller: provider.emailController,
                              label: 'Email Address *',

                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email address';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Contact Persons Card
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                        ),
                      ),
                      color: isDarkMode ? Colors.grey[800] : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Contact Persons',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: provider.addPerson,
                                  icon: const Icon(Icons.add_rounded, size: 16),
                                  label: const Text('Add Person'),
                                  style: OutlinedButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.personsList.length,
                              itemBuilder: (context, index) {
                                final person = provider.personsList[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? Colors.grey[700] : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Person ${index + 1}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                          if (provider.personsList.length > 1)
                                            IconButton(
                                              onPressed: () => provider.removePerson(index),
                                              icon: Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),

                                      // Full Name
                                      AppTextField(
                                        controller: person['fullName']!,
                                        label: 'Full Name *',

                                        validator: (value) => value!.isEmpty
                                            ? 'Please enter full name'
                                            : null,
                                      ),
                                      const SizedBox(height: 12),

                                      // Designation and Department in Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AppTextField(
                                              controller: person['designation']!,
                                              label: 'Designation *',

                                              validator: (value) => value!.isEmpty
                                                  ? 'Please enter designation'
                                                  : null,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: AppTextField(
                                              controller: person['department']!,
                                              label: 'Department *',

                                              validator: (value) => value!.isEmpty
                                                  ? 'Please enter department'
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),

                                      // Phone and Email in Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: AppTextField(
                                              controller: person['phoneNumber']!,
                                              label: 'Phone Number *',
                                              keyboardType: TextInputType.phone,
                                              validator: (value) => value!.isEmpty
                                                  ? 'Please enter phone number'
                                                  : null,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: AppTextField(
                                              controller: person['email']!,
                                              label: 'Email Address *',

                                              keyboardType: TextInputType.emailAddress,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter email';
                                                }
                                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                                  return 'Please enter valid email';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Assignments Card
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                        ),
                      ),
                      color: isDarkMode ? Colors.grey[800] : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assignments',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Assigned Staff
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assigned Staff *',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode ? Colors.white : Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                staffProvider.isLoading
                                    ? Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                )
                                    : staffProvider.staffs.isEmpty
                                    ? Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Text('No staff available'),
                                  ),
                                )
                                    : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                                    ),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: provider.selectedStaffName,
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    hint: const Text('Select Staff'),
                                    icon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: theme.colorScheme.primary,
                                    ),
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white : Colors.grey[800],
                                      fontSize: 14,
                                    ),
                                    validator: (value) => value == null || value.isEmpty
                                        ? 'Please select a staff member'
                                        : null,
                                    onChanged: (value) {
                                      provider.selectedStaffName = value;
                                      provider.notifyListeners();
                                    },
                                    items: staffProvider.staffs.map((staff) {
                                      return DropdownMenuItem<String>(
                                        value: staff.username,
                                        child: Text(staff.username ?? 'Unnamed Staff'),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Assigned Product
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assigned Product *',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode ? Colors.white : Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                productProvider.isLoading
                                    ? Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                )
                                    : productProvider.products.isEmpty
                                    ? Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Text('No products available'),
                                  ),
                                )
                                    : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                                    ),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: provider.selectedProductId,
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    hint: const Text('Select Product'),
                                    icon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: theme.colorScheme.primary,
                                    ),
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white : Colors.grey[800],
                                      fontSize: 14,
                                    ),
                                    validator: (value) => value == null || value.isEmpty
                                        ? 'Please select a product'
                                        : null,
                                    onChanged: (value) {
                                      provider.selectedProductId = value;
                                      provider.notifyListeners();
                                    },
                                    items: productProvider.products.map((product) {
                                      return DropdownMenuItem<String>(
                                        value: product.sId,
                                        child: Text(product.name ?? 'Unnamed Product'),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    _isSubmitting
                        ? Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Creating Customer...',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                        : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _submitForm(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              'Create Customer',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}