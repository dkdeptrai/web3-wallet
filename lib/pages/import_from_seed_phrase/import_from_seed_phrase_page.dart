import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/common_widgets/custom_button_widget.dart';
import 'package:web3_wallet/common_widgets/custom_text_form_field.dart';
import 'package:web3_wallet/constants/dimensions.dart';
import 'package:web3_wallet/pages/pages.dart';
import 'package:web3_wallet/utils/validator_util.dart';

class ImportFromSeedPage extends StatefulWidget {
  const ImportFromSeedPage({super.key});

  static const String routeName = "/import-from-seed";

  @override
  State<ImportFromSeedPage> createState() => _ImportFromSeedPageState();
}

class _ImportFromSeedPageState extends State<ImportFromSeedPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _seedPhraseController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _seedPhraseController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Import from seed phrase"),
      ),
      body: BlocListener<ImportFromSeedCubit, ImportFromSeedState>(
        listener: (context, state) {
          if (state is ImportFromSeedLoading) {}
          if (state is ImportFromSeedFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.defaultHorizontalPadding),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CustomTextFormField.primary(
                        controller: _seedPhraseController,
                        context: context,
                        hintText: "Seed phrase *",
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Seed phrase is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField.primary(
                        controller: _passwordController,
                        context: context,
                        hintText: "Password *",
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
                      const SizedBox(height: 20),
                      CustomTextFormField.primary(
                        controller: _confirmPasswordController,
                        context: context,
                        hintText: "Confirm Password *",
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
                    ],
                  ),
                ),
              ),
              CustomButton.primaryButton(
                context: context,
                text: "Import",
                onTap: _onImport,
              ),
            ],
          ),
        )),
      ),
    );
  }

  Future<void> _onImport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await context.read<ImportFromSeedCubit>().importFromSeed(
          _seedPhraseController.text.trim(),
          _passwordController.text.trim(),
        );
    if (!mounted) return;
    Navigator.pushNamed(context, AuthControlWrapperPage.routeName);
  }
}
