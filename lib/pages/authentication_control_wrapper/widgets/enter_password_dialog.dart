import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/constants/dimensions.dart';
import 'package:web3_wallet/resources/resources.dart';

class EnterPasswordDialog extends StatefulWidget {
  final TextEditingController passwordController;

  const EnterPasswordDialog({
    super.key,
    required this.passwordController,
  });

  @override
  State<EnterPasswordDialog> createState() => _EnterPasswordDialogState();
}

class _EnterPasswordDialogState extends State<EnterPasswordDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Form(
      key: _formKey,
      child: AlertDialog(
        backgroundColor: appColors.bgCard1,
        content: SizedBox(
          width: size.width - 2 * AppDimensions.defaultHorizontalPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.imgRobot3WithBg, height: 150),
              const SizedBox(height: 10),
              Text(
                "Enter password",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: appColors.softPurple),
              ),
              const SizedBox(height: 30),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  return CustomTextFormField.primary(
                    controller: widget.passwordController,
                    context: context,
                    hintText: "Password",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      if (state is WrongPassword) {
                        return "Wrong password";
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 30),
              CustomButton.secondaryButton(
                context: context,
                onTap: () => _authenticate(context),
                text: "Authenticate",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await context.read<AuthenticationCubit>().verifyPassword(password: widget.passwordController.text.trim());
    await context.read<AuthenticationCubit>().authenticate();
  }
}
