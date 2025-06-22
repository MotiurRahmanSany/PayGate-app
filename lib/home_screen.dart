import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:paygate/constants.dart';
import 'package:paygate/paygate_secrets.dart';
import 'package:paygate/utils.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int payableAmount = 0;
  final amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void payWithSSLCommerz({required int amount}) async {
    final uid = Uuid().v4();

    try {
      debugPrint('sslstoreid: ${PaygateSecret.sslStoreID}');
      debugPrint('sslstorepassword: ${PaygateSecret.sslStorePassword}');

      final sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          //   ipn_url: "www.ipnurl.com",
          multi_card_name: "visa,master,bkash",
          currency: SSLCurrencyType.BDT,
          product_category: "Food",
          sdkType: SSLCSdkType.TESTBOX,
          store_id: PaygateSecret.sslStoreID,
          store_passwd: PaygateSecret.sslStorePassword,
          total_amount: amount.toDouble(),
          tran_id: "TEST-TRX-$uid",
        ),
      );

      final payStatus = await sslcommerz.payNow();

      if (payStatus.status == 'VALID') {
        // Handle successful payment
        showDynamicSnackBar(
          context: context,
          message: 'Payment Successful!',

          type: SnackBarType.success,
        );
        debugPrint("Payment Successful: ${payStatus.tranId}");
      } else if (payStatus.status == 'CANCELLED') {
        // Handle payment cancellation
        debugPrint("Payment Cancelled");
        showDynamicSnackBar(
          context: context,
          message: 'Payment Cancelled',
          type: SnackBarType.warning,
        );
      } else if (payStatus.status == 'FAILED') {
        // Handle payment failure
        debugPrint("Payment Failed");
        showDynamicSnackBar(
          context: context,
          message: 'Payment Failed',
          type: SnackBarType.error,
        );
      } else {
        // Handle other statuses
        debugPrint("Payment Status: ${payStatus.status}");
        showDynamicSnackBar(
          context: context,
          message: 'Payment Status: ${payStatus.status}',
          type: SnackBarType.info,
        );
      }
    } catch (err) {
      // Handle any errors that occur during the payment process
      debugPrint("Error occurred: $err");
    }
  }

  Future<String?> makeStripePayment(int amount) async {
    debugPrint("Stripe Payment Initiated");
    // Implement Stripe payment logic here
    final dio = Dio();
    try {
      var data = {
        "amount": (amount * 100).round().toString(),
        "currency": "usd",
        "description": "Payment for Order",
        "payment_method_types[]": "card",
      };
      debugPrint("Stripe Payment Data: $data");
      debugPrint("Stripe Secret Key: ${PaygateSecret.stripeSecretKey}");
      final response = await dio.post(
        Constants.stripePaymentIntentsUrl,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization':
                'Bearer ${PaygateSecret.stripeSecretKey}', // Use your Stripe secret key
          },
        ),
      );

      if (response.data != null) {
        debugPrint("Stripe Payment Response: ${response.data}");
        showDynamicSnackBar(
          context: context,
          message: 'Initiating Stripe Payment...',
          type: SnackBarType.info,
        );
        return response.data['client_secret'];
      } else {
        debugPrint("Stripe Payment Failed");
        showDynamicSnackBar(
          context: context,
          message: 'Stripe Payment Failed',
          type: SnackBarType.error,
        );
      }

      return null;
    } catch (e) {
      debugPrint("Error occurred: $e");
      showDynamicSnackBar(
        context: context,
        message: 'Error occurred during Stripe payment',
        type: SnackBarType.error,
      );
    }
    return null;
  }

  Future<void> payWithStipe({required int amount}) async {
    try {
      final clientSecret = await makeStripePayment(amount);
      if (clientSecret == null) {
        showDynamicSnackBar(
          context: context,
          message: 'Failed to create payment intent',
          type: SnackBarType.error,
        );
        return;
      }
      debugPrint("Stripe Client Secret: $clientSecret");
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'PayGate Merchant',
        ),
      );

      debugPrint("Stripe Payment Sheet Initialized");
      debugPrint("opening payment sheet");
      await Stripe.instance.presentPaymentSheet(
        options: PaymentSheetPresentOptions(timeout: 10),
      );
      await Stripe.instance.confirmPaymentSheetPayment();
      showDynamicSnackBar(
        context: context,
        message: 'Payment Successful!',
        type: SnackBarType.success,
      );
    } catch (e) {
      debugPrint("Error occurred: $e");
      if (e is StripeException) {
        showDynamicSnackBar(
          context: context,
          message: 'Stripe Error: ${e.error.localizedMessage}',
          type: SnackBarType.error,
        );
      } else {
        debugPrint("Payment Sheet Error: $e");
        showDynamicSnackBar(
          context: context,
          message: 'Payment Failed',
          type: SnackBarType.error,
        );
      }
    } finally {
      debugPrint("Payment Sheet Closed");
      // Optionally, you can reset the payment sheet here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'PayGate',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Your one-stop payment solution'),
              const SizedBox(height: 20),

              // enter amount
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Payment Amount',
                    hintText: 'Enter payment amount',
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      color: Color(0xFF635BFF),
                    ),
                    suffixText: 'USD',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF635BFF),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Validate the form and get the amount
                    payWithSSLCommerz(amount: int.parse(amountController.text));
                  }
                },
                icon: const Icon(Icons.payment, color: Colors.white),
                label: const Text(
                  'Pay with SSLCommerz',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0DB14B), // SSLCommerz green
                  padding: const EdgeInsets.symmetric(
                    horizontal: 44,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Validate the form and get the amount
                    await payWithStipe(
                      amount: int.parse(amountController.text),
                    );
                  }
                },
                icon: const Icon(Icons.credit_card, color: Colors.white),
                label: const Text(
                  'Pay with Stripe',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF635BFF), // Stripe purple
                  padding: const EdgeInsets.symmetric(
                    horizontal: 44,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // More rounded
                  ),
                  elevation: 8,
                  shadowColor: Colors.purpleAccent.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
