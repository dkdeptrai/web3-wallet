import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/resources/resources.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/utils/validator_util.dart';

class ImportTokenDialog extends StatefulWidget {
  const ImportTokenDialog({super.key});

  @override
  State<ImportTokenDialog> createState() => _ImportTokenDialogState();
}

class _ImportTokenDialogState extends State<ImportTokenDialog> {
  final TokenService tokenService = GetIt.I<TokenService>();
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
              Image.asset(AppAssets.imgOther4, height: 150),
              const SizedBox(height: 10),
              Text(
                "Enter Token Address",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: appColors.softPurple),
              ),
              const SizedBox(height: 30),
              CustomTextFormField.primary(
                controller: controller,
                context: context,
                hintText: "Token Address",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter address!";
                  }
                  if (!ValidatorUtil.isValidTokenAddress(value)) {
                    return "Please enter a valid address!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              CustomButton.secondaryButton(
                context: context,
                onTap: () => _onImportToken(controller.text),
                text: "Import",
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onImportToken(String address) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    address = controller.text.trim();
    tokenService.importToken(address: address);
    Navigator.of(context).pop();
  }
}
