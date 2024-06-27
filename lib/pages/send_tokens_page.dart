import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/constants/dimensions.dart';
import 'package:web3_wallet/pages/pages.dart';
import 'package:web3_wallet/resources/resources.dart';
import 'package:web3_wallet/services/services.dart';
import 'package:web3_wallet/utils/address_util.dart';
import 'package:web3_wallet/utils/date_time_format_util.dart';
import 'package:web3_wallet/utils/validator_util.dart';

class SendTokensPage extends StatefulWidget {
  const SendTokensPage({Key? key}) : super(key: key);

  static const String routeName = "/send-tokens";

  @override
  _SendTokensPageState createState() => _SendTokensPageState();
}

class _SendTokensPageState extends State<SendTokensPage> {
  final sepoliaTransactionService = GetIt.I<SepoliaTransactionService>();
  final _pendingTransactionsService = GetIt.I.get<PendingTransactionServiceImpl>();
  final TextEditingController _recipientController = TextEditingController();
  // final TextEditingController _amountController = TextEditingController();
  final _amountController = MaskedTextController(mask: '0.000.000-00');
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final String contractAddress;
  String tokenSymbol = "ETH";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      contractAddress = args['contractAddress'];
      tokenSymbol = args['tokenSymbol'];
    }
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Send Tokens'),
      ),
      body: BlocListener<SendTokensCubit, SendTokensState>(
        listener: (context, state) {
          if (state is SendingTokens) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const Center(
                  child: CustomLoadingWidget(),
                );
              },
            );
          }
          if (state is TokensSent) {
            // Navigator.pop(context);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text("Transaction sent successfully"),
            //   ),
            // );
          }
          if (state is SendTokensError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Sending transaction failed. Please try again later."),
              ),
            );
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(1.8, -1.5),
                child: Container(
                  height: size.height * 0.15,
                  width: size.height * 0.15,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEB6A98).withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0.6, -1.7),
                child: Container(
                  height: size.height * 0.15,
                  width: size.height * 0.15,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9E7DFC).withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0),
                    ),
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.defaultHorizontalPadding),
                child: Column(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              tokenSymbol,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.softPurple),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                // FilteringTextInputFormatter.digitsOnly,
                                // CurrencyInputFormatter(),
                              ],
                              decoration: InputDecoration(
                                hintText: "0.00",
                                hintStyle: Theme.of(context).textTheme.displayLarge?.copyWith(color: appColors.subTitle),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(AppDimensions.defaultTextFieldBorderRadius),
                                ),
                                contentPadding: const EdgeInsets.all(20),
                                fillColor: appColors.bgCard1,
                                filled: true,
                              ),
                              style: Theme.of(context).textTheme.displayLarge,
                              textAlign: TextAlign.center,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Amount is required";
                                }
                                if (double.tryParse(value.trim()) == null) {
                                  return "Invalid amount";
                                }
                                if (double.parse((value.trim()).replaceAll(',', '')) <= 0) {
                                  return "Amount must be greater than 0";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextFormField.primary(
                                    context: context,
                                    hintText: "Recipient Address",
                                    controller: _recipientController,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return "Recipient address is required";
                                      }
                                      if (!ValidatorUtil.isValidTokenAddress(value.trim())) {
                                        return "Invalid recipient address";
                                      }
                                      return null;
                                    },
                                    prefixIcon: CircleAvatar(
                                      backgroundColor: appColors.softOrange,
                                      child: CustomSvgImage(
                                        imagePath: AppAssets.icUser,
                                        color: appColors.orange,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await _navigateToQRScanner();
                                  },
                                  icon: CustomSvgImage(
                                    imagePath: AppAssets.icScan,
                                    color: appColors.softPurple,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                    CustomButton.primaryButton(
                      context: context,
                      text: "Send",
                      onTap: () async {
                        await _sendTransaction();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToQRScanner() async {
    var result = await Navigator.pushNamed(context, QRScannerPage.routeName);
    _recipientController.text = result.toString();
  }

  Future<void> _sendTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String? txhHash = await context.read<SendTokensCubit>().sendTokens(
          recipientWalletAddress: _recipientController.text.trim(),
          amount: double.parse(_amountController.text.trim()),
          contractAddress: contractAddress,
        );
    if (!mounted) return;
    Navigator.pop(context);
    final Size size = MediaQuery.of(context).size;
    final appColors = Theme.of(context).extension<AppColors>()!;
    if (txhHash != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: appColors.bgCard1,
            content: SizedBox(
              width: size.width - 2 * AppDimensions.defaultHorizontalPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppAssets.imgOther4, height: 150),
                  Text(
                    "Transaction",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(color: appColors.softPurple),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Recipient Address",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.softPurple),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AddressUtil.hideAddress(_recipientController.text),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: appColors.softPurple),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Time",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.softPurple),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateTimeFormatUtil.formatDateTime(DateTime.now()),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: appColors.softPurple),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Amount",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.softPurple),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _amountController.text,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: appColors.softPurple),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Status",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.softPurple),
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder(
                          stream: _pendingTransactionsService.getStream(txhHash)?.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data as Map<String, dynamic>;
                              final status = data['status'] != null ? (data['status']['status'] as String).toUpperCase() : "PENDING";
                              final statusColor = status == "PENDING" ? appColors.orange : appColors.green;
                              return Text(
                                status,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: statusColor),
                              );
                            }
                            return Text(
                              "PROCESSING",
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: appColors.orange),
                            );
                          }),
                      const SizedBox(height: 20),
                    ],
                  ),
                  CustomButton.secondaryButton(
                    context: context,
                    text: "OK",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final _formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove all non-digit characters for parsing, but keep the decimal point if present
    final newText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Parse the value as a double
    final parsedValue = double.tryParse(newText) ?? 0;

    // Divide by 100 to get the correct decimal value (e.g., 12300 -> 123.00)
    final formattedValue = _formatter.format(parsedValue);

    // Determine the cursor position based on the length of the formatted text
    final newCursorPosition = formattedValue.length;

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}
