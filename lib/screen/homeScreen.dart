import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:pay_platform_interface/core/payment_configuration.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PaymentItem> _paymentItems = [];
  double amount = 0.0;

  String convertGPaymentConfigToString() {
    return jsonEncode({
      "provider": "google_pay",
      "data": {
        "environment": "TEST",
        "apiVersion": 2,
        "apiVersionMinor": 0,
        "allowedPaymentMethods": [
          {
            "type": "CARD",
            "tokenizationSpecification": {
              "type": "PAYMENT_GATEWAY",
              "parameters": {
                "gateway": "example",
                "gatewayMerchantId": "gatewayMerchantId"
              }
            },
            "parameters": {
              "allowedCardNetworks": ["VISA", "MASTERCARD"],
              "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
              "billingAddressRequired": true,
              "billingAddressParameters": {
                "format": "FULL",
                "phoneNumberRequired": true
              }
            }
          }
        ],
        "merchantInfo": {
          "merchantId": "01234567890123456789",
          "merchantName": "Example Merchant Name"
        },
        "transactionInfo": {"countryCode": "US", "currencyCode": "USD"}
      }
    });
  }

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
        appBar: AppBar(
          title: Text("$amount"),
        ),
        body: Center(
          child: MaterialButton(
            child: Text("Pay kar"),
            onPressed: () async {
              Pay pay = Pay([
                PaymentConfiguration.fromJsonString(jsonEncode({
                  "provider": "google_pay",
                  "data": {
                    "environment": "TEST",
                    "apiVersion": 2,
                    "apiVersionMinor": 0,
                    "allowedPaymentMethods": [
                      {
                        "type": "CARD",
                        "tokenizationSpecification": {
                          "type": "PAYMENT_GATEWAY",
                          "parameters": {
                            "gateway": "example",
                            "gatewayMerchantId": "gatewayMerchantId"
                          }
                        },
                        "parameters": {
                          "allowedCardNetworks": ["VISA", "MASTERCARD"],
                          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
                          "billingAddressRequired": true,
                          "billingAddressParameters": {
                            "format": "FULL",
                            "phoneNumberRequired": true
                          }
                        }
                      }
                    ],
                    "merchantInfo": {
                      "merchantId": "01234567890123456789",
                      "merchantName": "Example Merchant Name"
                    },
                    "transactionInfo": {
                      "countryCode": "US",
                      "currencyCode": "USD"
                    }
                  }
                }))
              ]);
              try {
                final userCanPay = await pay.userCanPay(PayProvider.google_pay);
                if (userCanPay) {
                  final paymentResult = await pay.showPaymentSelector(
                      provider: PayProvider.google_pay,
                      paymentItems: _paymentItems);
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            content: Text(paymentResult.toString()),
                          ));
                }
              } catch (e) {
                //
              }
            },
          ),
        ));
  }
}

/*
Column(
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

 */