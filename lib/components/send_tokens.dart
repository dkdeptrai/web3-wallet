import 'package:flutter/material.dart';
import 'package:web3_wallet/services/transaction_service.dart';

class SendTokensPage extends StatefulWidget {
  final String privateKey;

  const SendTokensPage({Key? key, required this.privateKey}) : super(key: key);

  @override
  _SendTokensPageState createState() => _SendTokensPageState();
}

class _SendTokensPageState extends State<SendTokensPage> {
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  late SepoliaTransactionService sepoliaTransactionService;
  late OtherTokenService testService;
  bool isLoading = false; // Add this line to track loading state

  @override
  void initState() {
    super.initState();
    sepoliaTransactionService = SepoliaTransactionService();
    testService =
        OtherTokenService("0xff1FA4a41703FC25e7216190eeF33abcB963ae67");
    _initializeService();
  }

  Future<void> _initializeService() async {
    await sepoliaTransactionService.init();
    await testService.init();
  }

  @override
  void dispose() {
    recipientController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> sendTransaction() async {
    String recipient = recipientController.text;
    String amount = amountController.text;
    if (recipient.isEmpty || amount.isEmpty) {
      return;
    }
    isLoading = true;
    final res = await sepoliaTransactionService.sendTransaction(
        amountToSend: amount.trim(),
        privateKey: widget.privateKey,
        recipientAddress: recipient.trim());

    // Uncomment these lines to test sending tokens
    // final res = await testService.sendTransaction(
    //     amountToSend: amount.trim(),
    //     privateKey: widget.privateKey,
    //     recipientAddress: recipient.trim());
    isLoading = false;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Tokens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: recipientController,
              decoration: const InputDecoration(
                labelText: 'Recipient Address',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16.0),
            FutureBuilder(
              future: sendTransaction(), // Use FutureBuilder here
              builder: (context, snapshot) {
                if (isLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return ElevatedButton(
                    onPressed: () => sendTransaction(),
                    child: const Text('Send'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
