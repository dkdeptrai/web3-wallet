import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/utils/password_util.dart';
import 'package:web3_wallet/utils/validator_util.dart';

class Step1Content extends StatefulWidget {
  const Step1Content({super.key, required this.onNextStep});

  final Function onNextStep;

  @override
  State<Step1Content> createState() => _Step1ContentState();
}

class _Step1ContentState extends State<Step1Content> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  "This password will unlock your RoboWallet only on this device",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomTextFormField.primary(
                  context: context,
                  controller: _passwordController,
                  hintText: "Password",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (!ValidatorUtil.isPassword(value)) {
                      return "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextFormField.primary(
                  context: context,
                  controller: _confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (!ValidatorUtil.isPasswordMatch(_passwordController.text, _confirmPasswordController.text)) {
                      return "Password does not match";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sign in with FaceID?",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    CupertinoSwitch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                    ),
                    Expanded(
                      child: Text(
                        "I understand that RoboWallet cannot recover this password for you.",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          CustomButton.primaryButton(
            onTap: () => _onCreatePassword(context),
            context: context,
            text: "Create Password",
          )
        ],
      ),
    );
  }

  void _onCreatePassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await PasswordUtil.savePassword(_passwordController.text);
    widget.onNextStep();
  }
}
