import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/detail/blocs/blindbox_detail_event.dart';

import '../blocs/blindbox_detail_bloc.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;

  const QuantitySelector({
    Key? key,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: getColorSkin().primaryRed200,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.remove,
              size: 20,
              color: getColorSkin().primaryRed800,
            ),
            onPressed: () {
              context.read<BlindBoxDetailBloc>().add(DecrementQuantity());
            },
          ),
          Text(
            quantity.toString(),
            style: const TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              size: 20,
              color: getColorSkin().primaryRed800,
            ),
            onPressed: () {
              context.read<BlindBoxDetailBloc>().add(IncrementQuantity());
            },
          ),
        ],
      ),
    );
  }
}
