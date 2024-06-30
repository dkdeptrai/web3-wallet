import 'package:flutter/material.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/resources/resources.dart';

class UpdateProfileDialog extends StatefulWidget {
  final String currentName;

  const UpdateProfileDialog({
    Key? key,
    required this.currentName,
  }) : super(key: key);

  @override
  _UpdateProfileDialogState createState() => _UpdateProfileDialogState();
}

class _UpdateProfileDialogState extends State<UpdateProfileDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final Size size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: appColors.bgCard1,
      content: SizedBox(
        width: size.width - 2 * AppDimensions.defaultHorizontalPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Update profile",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(color: appColors.softPurple),
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Name",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.softPurple),
                ),
                const SizedBox(height: 10),
                CustomTextFormField.primary(
                  controller: _nameController,
                  context: context,
                  hintText: "Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                )
              ],
            ),
            const SizedBox(height: 20),
            CustomButton.secondaryButton(
              context: context,
              text: "Update",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
