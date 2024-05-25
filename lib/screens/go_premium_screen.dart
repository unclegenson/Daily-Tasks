import 'package:daily_tasks/screens/add_task_screen.dart';
import 'package:daily_tasks/screens/settings_screen.dart';
import 'package:daily_tasks/widgets/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarinpal/zarinpal.dart';

class GoPremmium extends StatefulWidget {
  const GoPremmium({super.key});

  @override
  State<GoPremmium> createState() => _GoPremmiumState();
}

List premiumOptions = [
  'Notifications',
  'Birthday messages',
  'Attach image for each task'
];

class _GoPremmiumState extends State<GoPremmium> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[800],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      'assets/back2.svg',
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcATop),
                    ),
                  ),
                ),
              ),
            );
          }),
          backgroundColor: Colors.black87,
          title: const MyAppBarTitle(
            title: 'Premium Version',
            fontSize: 42,
          ),
          titleSpacing: 10,
          elevation: 0,
          toolbarHeight: 70,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: size.height * 8.2 / 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: SettingsCategoryWidget(
                        color: Colors.white, text: 'Premium Options :'),
                  ),
                  SizedBox(
                    height: size.height * 6 / 10,
                    child: ListView.builder(
                      itemCount: premiumOptions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.only(left: 8),
                          title: Text(
                            premiumOptions[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          leading: const Icon(Icons.circle),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SettingsCategoryWidget(
                                color: Colors.white,
                                text: 'Premium version price :'),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'for each month',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '47.000',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  ' تومان',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              '68.000',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.white,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: size.width - 40,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        PaymentRequest _paymentRequest = PaymentRequest();

                        _paymentRequest.setIsSandBox(true);
                        _paymentRequest.setMerchantID("Zarinpal MerchantID");
                        _paymentRequest.setAmount(1000); //integar Amount
                        _paymentRequest.setCallbackURL("return://myZarinPal");
                        _paymentRequest.setDescription("Payment Description");

                        String? _paymentUrl;

                        ZarinPal().startPayment(_paymentRequest,
                            (int? status, String? paymentGatewayUri) async {
                          print(paymentGatewayUri);
                          if (status == 100) {
                            if (!await launchUrl(
                                Uri.parse(paymentGatewayUri!))) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('error while routing to zarin pal'),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('some error in application happend'),
                              ),
                            );
                          }
                        });

                        ZarinPal().verificationPayment(
                            "Status", "Authority Call back", _paymentRequest,
                            (isPaymentSuccess, refID, paymentRequest) {
                          if (isPaymentSuccess) {
                            // Payment Is Success
                            print("Success");
                          } else {
                            // Error Print Status
                            print("Error");
                          }
                        });
                        //todo: setbool pref with purchase key
                        ZarinPal().startPayment(_paymentRequest,
                            (int? status, String? paymentGatewayUri) {
                          if (status == 100)
                            _paymentUrl =
                                paymentGatewayUri; // launch URL in browser
                        });
                      },
                      child: const Text(
                        'Purchase',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
