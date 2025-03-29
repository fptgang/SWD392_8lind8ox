import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/repositories/shipping_info_repository.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_bloc.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_event.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_state.dart';

class AddressSection extends StatefulWidget {
  const AddressSection({
    super.key,
    this.selectedAddressId,
    required this.onSelectAddress,
  });

  final int? selectedAddressId;
  final Function(int) onSelectAddress;

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  late final ShippingInfoBloc _shippingInfoBloc;
  bool _isLoading = true;
  List<ShippingInfoModel> _addresses = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _shippingInfoBloc = getIt<ShippingInfoBloc>();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    _shippingInfoBloc.add(GetShippingInfos());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShippingInfoBloc, ShippingInfoState>(
      bloc: _shippingInfoBloc,
      listener: (context, state) {
        if (state is ShippingInfoDataState) {
          setState(() {
            _addresses = state.shippingInfos;
            _isLoading = false;
          });
        } else if (state is ShippingInfoLoadingState && state.error != null) {
          setState(() {
            _error = state.error;
            _isLoading = false;
          });
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shipping Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    onPressed: () => _navigateToAddAddress(context),
                    icon: Icon(Icons.add, color: getColorSkin().black),
                    label:  Text('Add New', style: TextStyle(color: getColorSkin().black),),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading shipping addresses:\n$_error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[700]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAddresses,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_addresses.isEmpty) {
      return _buildEmptyAddresses(context);
    }

    return Column(
      children: _addresses
          .map((address) => _buildAddressItem(context, address))
          .toList(),
    );
  }

  Widget _buildEmptyAddresses(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No shipping addresses found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddAddress(context),
            icon: const Icon(Icons.add),
            label: const Text('Add New Address'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(BuildContext context, ShippingInfoModel address) {
    final isSelected = widget.selectedAddressId == address.shippingInfoId;

    return InkWell(
      onTap: () {
        if (address.shippingInfoId != null) {
          widget.onSelectAddress(address.shippingInfoId!);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? Colors.blue.withOpacity(0.05) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isSelected
                ? Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                  )
                : Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                  ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.name ?? 'No Name',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(address.phoneNumber ?? 'No Phone'),
                  const SizedBox(height: 4),
                  Text(
                    [
                      address.address,
                      address.ward,
                      address.district,
                      address.city,
                    ].where((s) => s != null && s.isNotEmpty).join(', '),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () =>
                  _navigateToEditAddress(context, address.shippingInfoId!),
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddAddress(BuildContext context) {
    context.push('/shipping-address/add').then((_) {
      // Refresh addresses after returning from the add screen
      _loadAddresses();
    });
  }

  void _navigateToEditAddress(BuildContext context, int addressId) {
    context.push('/shipping-address/edit/$addressId').then((_) {
      // Refresh addresses after returning from the edit screen
      _loadAddresses();
    });
  }
}
