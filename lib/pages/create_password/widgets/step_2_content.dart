// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/services/wallet_address_service.dart';

class Step2Content extends StatefulWidget {
  const Step2Content({
    Key? key,
    required this.onNextStep,
  }) : super(key: key);

  final Function onNextStep;

  @override
  State<Step2Content> createState() => _Step2ContentState();
}

class _Step2ContentState extends State<Step2Content> {
  final ethWalletService = ETHWalletService();
  late final String mnemonic;
  late final List<String> mnemonicWords;

  @override
  void initState() {
    mnemonic = ethWalletService.generateMnemonic();
    mnemonicWords = mnemonic.split(' ');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                "Write down you seed phrase",
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "This is your seed phrase. Write it down on a paper and keep it in a safe place. You'll be asked to re-enter this phrase (in order) on the next step.",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              GridView.builder(
                  padding: const EdgeInsets.only(left: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3.5 / 1.0,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: mnemonicWords.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '${index + 1}. ${mnemonicWords[index]}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    );
                  }),
            ],
          ),
        ),
        CustomButton.secondaryButton(
          context: context,
          text: "Copy to Clipboard",
          onTap: () => _onCopyToClipboard(context: context, mnemonic: mnemonic),
        ),
        const SizedBox(height: 20),
        CustomButton.primaryButton(
          onTap: () => _onNextStep(context),
          context: context,
          text: "Next",
        )
      ],
    );
  }

  void _onCopyToClipboard({required BuildContext context, required String mnemonic}) {
    Clipboard.setData(ClipboardData(text: mnemonic));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mnemonic Copied to Clipboard')),
    );
  }

  void _onNextStep(BuildContext context) {
    context.read<CreatePasswordCubit>().setMnemonicWords(mnemonicWords);
    widget.onNextStep();
  }
}
