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
  double amount = 0.0;

  //for converting patymentconfig into string
  //pass config for apay and gpay here
  String convertPaymentConfigToString(Map json) {
    return jsonEncode(json);
  }

  final Map gpayPaymentCofig = {
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
            "parameters": {"gateway": "example", "gatewayMerchantId": "gatewayMerchantId"}
          },
          "parameters": {
            "allowedCardNetworks": ["VISA", "MASTERCARD"],
            "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
            "billingAddressRequired": true,
            "billingAddressParameters": {"format": "FULL", "phoneNumberRequired": true}
          }
        }
      ],
      "merchantInfo": {"merchantId": "01234567890123456789", "merchantName": "Example Merchant Name"},
      "transactionInfo": {"countryCode": "US", "currencyCode": "USD"}
    }
  };

  final apayConfig = {
    "provider": "apple_pay",
    "data": {
      "merchantIdentifier": "merchant.com.sams.fish",
      "displayName": "Sam's Fish",
      "merchantCapabilities": ["3DS", "debit", "credit"],
      "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
      "countryCode": "US",
      "currencyCode": "USD",
      "requiredBillingContactFields": ["post"],
      "requiredShippingContactFields": ["post", "phone", "email", "name"],
      "shippingMethods": [
        {"amount": "0.00", "detail": "Available within an hour", "identifier": "in_store_pickup", "label": "In-Store Pickup"},
        {"amount": "4.99", "detail": "5-8 Business Days", "identifier": "flat_rate_shipping_id_2", "label": "UPS Ground"},
        {"amount": "29.99", "detail": "1-3 Business Days", "identifier": "flat_rate_shipping_id_1", "label": "FedEx Priority Mail"}
      ]
    }
  };

  void makePayment(PayProvider payProvider, Map paymentConfig) async {
    //add products here
    List<PaymentItem> paymentItems = [PaymentItem(amount: "500", status: PaymentItemStatus.final_price, label: "Product name")];
    Pay pay = Pay([PaymentConfiguration.fromJsonString(convertPaymentConfigToString(paymentConfig))]);
    try {
      final userCanPay = await pay.userCanPay(PayProvider.google_pay);
      if (userCanPay) {
        final paymentResult = await pay.showPaymentSelector(provider: PayProvider.google_pay, paymentItems: paymentItems);
        print(paymentResult);
      } else {
        //show can not make payment message
      }
    } catch (e) {
      //display error
    }
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
              //for gogole pay
              makePayment(PayProvider.google_pay, gpayPaymentCofig);
            },
          ),
        ));
  }
}

/*
 */

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
