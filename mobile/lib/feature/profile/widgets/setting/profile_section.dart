import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/profile/blocs/account/account_bloc.dart';
import 'package:mobile/feature/profile/blocs/account/account_state.dart';
import 'package:mobile/feature/profile/widgets/language_dropdown.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final displayName = _getDisplayName(state);
        final email = _getEmail(state);
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: getColorSkin().primaryRed650,
                child: Text(
                  _getInitials(displayName),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        );
      },
    );
  }
  
  String _getDisplayName(AccountState state) {
    if (state is AccountLoaded && state.account != null) {
      final firstName = state.account.firstName ?? '';
      final lastName = state.account.lastName ?? '';
      return '$firstName $lastName'.trim();
    }
    return 'Loading...';
  }
  
  String _getEmail(AccountState state) {
    if (state is AccountLoaded && state.account != null) {
      return state.account.email ?? 'No email available';
    }
    return 'Loading...';
  }
  
  String _getInitials(String displayName) {
    if (displayName == 'Loading...') return '?';
    
    final nameParts = displayName.split(' ');
    if (nameParts.isEmpty) return '?';
    
    if (nameParts.length == 1) {
      return nameParts[0].isNotEmpty ? nameParts[0][0].toUpperCase() : '?';
    }
    
    return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
  }
}
