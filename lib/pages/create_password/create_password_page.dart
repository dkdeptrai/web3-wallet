import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/pages/create_password/widgets/widgets.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  static const String routeName = "/create-password";

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Password"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.defaultHorizontalPadding),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<CreatePasswordCubit, CreatePasswordState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Text(
                          "Step ${state.step} of 3",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (value) => context.read<CreatePasswordCubit>().nextStep(),
                            itemBuilder: (context, index) {
                              return _buildStepContent(context: context, step: index + 1);
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent({required BuildContext context, required int step}) {
    switch (step) {
      case 1:
        return Step1Content(
          onNextStep: () {
            _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
          },
        );
      case 2:
        return Step2Content(
          onNextStep: () {
            _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
          },
        );
      case 3:
        return const Step3Content();
      default:
        return Container();
    }
  }
}
