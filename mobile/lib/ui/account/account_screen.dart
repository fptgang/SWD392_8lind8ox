import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/ui/account/widget/account_detail.dart';
import 'package:mobile/ui/core/theme/theme.dart';

import '../../blocs/register/register_bloc.dart';


class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => AccountScreen());
  }

  final AuthRepository authRepository = GetIt.instance<AuthRepository>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(authRepository: authRepository),
        child: Scaffold(
          backgroundColor: getColorSkin().backgroundColor,
          appBar: AppBar(
            backgroundColor: getColorSkin().accentColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: getColorSkin().black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AccountDetail(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



