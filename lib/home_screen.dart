import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:paygate/paygate_secrets.dart';
import 'package:paygate/utils.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void payWithSSLCommerz({required double amount}) async {
    // Implement SSLCommerz payment logic here
    // unique uuid for each transaction
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
          total_amount: amount,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Handle payment logic here
                payWithSSLCommerz(amount: 100.0); // Example amount
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
          ],
        ),
      ),
    );
  }
}
