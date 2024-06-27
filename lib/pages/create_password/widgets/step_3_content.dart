import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/pages/pages.dart';
import 'package:web3_wallet/resources/resources.dart';
import 'package:web3_wallet/utils/mnemonic_util.dart';

class Step3Content extends StatefulWidget {
  const Step3Content({super.key});

  @override
  State<Step3Content> createState() => _Step3ContentState();
}

class _Step3ContentState extends State<Step3Content> {
  String? selectedWord;

  @override
  void initState() {
    context.read<CreatePasswordCubit>().resetSelectedWords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              BlocBuilder<CreatePasswordCubit, CreatePasswordState>(
                builder: (context, state) {
                  final numOfSelected = state.selectedWords.length;
                  if (numOfSelected == state.mnemonicWords.length) {
                    return Column(
                      children: List.generate(
                        state.mnemonicWords.length,
                        (index) => Text(
                          "${index + 1}. ${state.mnemonicWords[index]}",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                    );
                  }
                  final selections = MnemonicUtil.randomSixWords(
                    mnemonicWords: state.mnemonicWords,
                    correctWord: state.mnemonicWords[numOfSelected],
                  );

                  return Column(
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        "${numOfSelected + 1}.",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 50),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.5 / 1.0,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _onSelectWord(selections[index]),
                            child: Container(
                              decoration: BoxDecoration(
                                color: appColors.softPurple2,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  selections[index],
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: appColors.softPurple),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
        BlocBuilder<CreatePasswordCubit, CreatePasswordState>(
          builder: (context, state) {
            bool isCorrect = true;
            bool isAllSelected = state.selectedWords.length == state.mnemonicWords.length;
            if (isAllSelected) {
              for (String word in state.selectedWords) {
                if (state.mnemonicWords[state.selectedWords.indexOf(word)] != word) {
                  isCorrect = false;
                  break;
                }
              }
            }
            if (isCorrect && isAllSelected) {
              return CustomButton.primaryButton(
                context: context,
                text: "Next",
                onTap: () => _onNext(state.mnemonicWords),
              );
            } else {
              return Column(
                children: [
                  if (isAllSelected)
                    Text(
                      "Please select the correct words in order",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: appColors.red),
                    ),
                  const SizedBox(height: 10),
                  CustomButton.primaryButton(
                    context: context,
                    text: "Try Again",
                    onTap: _onTryAgain,
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  void _onSelectWord(String word) {
    context.read<CreatePasswordCubit>().onSelectMnemonicWord(word);
  }

  void _onTryAgain() {
    context.read<CreatePasswordCubit>().resetSelectedWords();
    // Navigator.pushNamed(context, CreatePasswordSuccess.routeName);
  }

  void _onNext(List<String> mnemonicWords) async {
    await context.read<WalletCubit>().saveWalletInfo(mnemonicWords);
    await context.read<AuthenticationCubit>().register();
    if (!mounted) return;
    Navigator.pushNamed(context, CreatePasswordSuccess.routeName);
  }
}
