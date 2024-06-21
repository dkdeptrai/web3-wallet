import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/pages/authentication_control_wrapper/widgets/widgets.dart';
import 'package:web3_wallet/pages/pages.dart';
import 'package:web3_wallet/resources/resources.dart';
import 'package:web3_wallet/utils/password_util.dart';

class AuthControlWrapperPage extends StatefulWidget {
  const AuthControlWrapperPage({super.key});

  static const String routeName = "/auth-control-wrapper";

  @override
  State<AuthControlWrapperPage> createState() => _AuthControlWrapperPageState();
}

class _AuthControlWrapperPageState extends State<AuthControlWrapperPage> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasPassword = await PasswordUtil.hasPassword();
      if (!hasPassword) {
        if (!mounted) {
          return;
        }
        Navigator.pushNamed(context, CreatePasswordPage.routeName);
        return;
      }
      if (!mounted) {
        return;
      }
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return EnterPasswordDialog(
              passwordController: _passwordController,
            );
          });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushNamed(context, MainPage.routeName);
          }
        },
        builder: (context, state) {
          return Center(
            child: Image.asset(AppAssets.imgRobot3),
          );
        },
      ),
    );
  }
}
