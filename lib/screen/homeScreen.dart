import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PaymentItem> _paymentItems = [];
  double amount = 0.0;

  @override
  void initState() {
    _paymentItems.add(PaymentItem(
      amount: "50.0",
      label: "Adidas Sandal",
      status: PaymentItemStatus.final_price,
    ));
    _paymentItems.forEach((element) {
      amount = amount + double.parse(element.amount);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Amount : $amount"),
          ),
          ApplePayButton(
            paymentConfigurationAsset: 'apay.json',
            paymentItems: _paymentItems,
            style: ApplePayButtonStyle.black,
            type: ApplePayButtonType.buy,
            height: 50,
            width: 150,
            margin: const EdgeInsets.only(top: 15.0),
            onError: (error) {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text("Failure"),
                    );
                  });
            },
            onPaymentResult: (result) {
              print(result);
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text("Success"),
                    );
                  });
            },
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Center(
            child: GooglePayButton(
              width: 150,
              height: 50,
              paymentConfigurationAsset: 'gpay.json',
              paymentItems: _paymentItems,
              style: GooglePayButtonStyle.white,
              type: GooglePayButtonType.pay,
              margin: const EdgeInsets.only(top: 15.0),
              onError: (error) {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Failure"),
                      );
                    });
              },
              onPaymentResult: (result) {
                print(result);
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Success"),
                      );
                    });
              },
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
