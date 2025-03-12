
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_bloc.dart';
import 'package:mobile/blocs/blindbox_list/blindbox_list_state.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlindBoxesBloc, BlindBoxesState>(
      builder: (context, state) {
        if (state is LoadingState && state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DataState) {
          final blindBoxes = state.blindBoxes?.content;
          if (blindBoxes == null || blindBoxes.isEmpty) {
            return Center(
              // child: Text(AppLocalizations.of(context)?.noResults ?? 'No results found'),
              child: Text('No results found'),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: blindBoxes.length,
            itemBuilder: (context, index) {
              final box = blindBoxes[index];
              return ListTile(
                leading: box.images!.isNotEmpty
                    ? Image.network(box.images?.first.imageUrl ?? '')
                    : const Icon(Icons.image),
                title: Text(box.name ?? ''),
                subtitle: Text(box.description ?? ''),
                onTap: () => context.push('/blind-box-detail/${box.blindBoxId}'),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}