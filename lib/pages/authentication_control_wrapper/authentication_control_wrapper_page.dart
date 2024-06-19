import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
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
      final appColors = Theme.of(context).extension<AppColors>()!;
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
            return AlertDialog(
              backgroundColor: appColors.bgScreen,
              title: Text(
                "Enter password",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: appColors.softPurple),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField.primary(
                    controller: _passwordController,
                    context: context,
                    hintText: "Password",
                    obscureText: true,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: _authenticate,
                  child: const Text("Verify"),
                )
              ],
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
            Navigator.pushNamed(context, HomePage.routeName);
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

  Future<void> _authenticate() async {
    final cubit = context.read<AuthenticationCubit>();
    cubit.authenticate(password: _passwordController.text);
  }
}
