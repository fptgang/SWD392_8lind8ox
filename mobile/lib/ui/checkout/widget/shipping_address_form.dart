// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:mobile/blocs/shipping_info/shipping_info_bloc.dart';
// import 'package:mobile/blocs/shipping_info/shipping_info_event.dart';
// import 'package:mobile/ui/checkout/checkout_screen.dart';
// import 'package:openapi/api.dart';
//
// class ShippingAddressForm {
//   static void show(BuildContext context, ShippingInfoBloc shippingInfoBloc) {
//     final nameController = TextEditingController();
//     final addressController = TextEditingController();
//     final wardController = TextEditingController();
//     final districtController = TextEditingController();
//     final cityController = TextEditingController();
//     final phoneNumberController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Add Shipping Address'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: nameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Full Name*',
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: addressController,
//                   decoration: const InputDecoration(
//                     labelText: 'Address*',
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: wardController,
//                   decoration: const InputDecoration(
//                     labelText: 'Ward*',
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: districtController,
//                   decoration: const InputDecoration(
//                     labelText: 'District*',
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: cityController,
//                   decoration: const InputDecoration(
//                     labelText: 'City*',
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: phoneNumberController,
//                   decoration: const InputDecoration(
//                     labelText: 'Phone Number*',
//                   ),
//                   keyboardType: TextInputType.phone,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () => _handleFormSubmit(
//                 context,
//                 shippingInfoBloc,
//                 nameController.text,
//                 addressController.text,
//                 wardController.text,
//                 districtController.text,
//                 cityController.text,
//                 phoneNumberController.text,
//               ),
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   static void _handleFormSubmit(
//       BuildContext context,
//       ShippingInfoBloc shippingInfoBloc,
//       String name,
//       String address,
//       String ward,
//       String district,
//       String city,
//       String phoneNumber,
//       ) {
//     // Validate all fields
//     if (name.isEmpty ||
//         address.isEmpty ||
//         ward.isEmpty ||
//         district.isEmpty ||
//         city.isEmpty ||
//         phoneNumber.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill in all required fields'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     // Show loading indicator
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Creating shipping address...'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//
//     Navigator.pop(context);
//
//     try {
//       final shippingInfoDto = ShippingInfoDto();
//
//       // Set fields using dynamic approach
//       final dto = shippingInfoDto as dynamic;
//       dto.name = name;
//       dto.address = address;
//       dto.ward = ward;
//       dto.district = district;
//       dto.city = city;
//       dto.phoneNumber = phoneNumber;
//       dto.isVisible = true;
//
//       // Ensure account ID is set
//       final authBox = Hive.box('authentication');
//       int accountId = AccountHelper.getAccountId();
//       if (authBox.get('accountId') == null) {
//         authBox.put('accountId', accountId);
//       }
//
//       // Create and dispatch event
//       final createShippingInfoEvent = CreateShippingInfo(shippingInfoDto);
//       shippingInfoBloc.add(createShippingInfoEvent);
//     } catch (e) {
//       debugPrint('Exception setting DTO fields: $e');
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error creating shipping address: ${e.toString()}'),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 4),
//         ),
//       );
//     }
//   }
// }