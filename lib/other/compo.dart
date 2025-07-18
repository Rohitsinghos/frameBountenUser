import 'dart:convert';

import 'package:bauntan/main.dart';
import 'package:bauntan/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class QrPage extends StatelessWidget {
  const QrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationDuration: Duration(seconds: 3),
      insetAnimationCurve: Curves.easeInBack,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Icon(
                        Icons.cancel,
                        size: 30,
                        color: Colors
                            .blue, // const Color.fromARGB(255, 111, 110, 110),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Scan QrCode or Copy link",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 15),

              QrImageView(
                data: '${Stat["referralLink"]}',
                size: 200,
                version: QrVersions.auto,
              ),

              // Icon(Icons.image),
              SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      child: Container(
                        width: 220,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: MaterialButton(
                            color: adth,
                            onPressed: () {
                              copyText(
                                (Stat == null || Stat["referralLink"] == null)
                                    ? 'https://bounten.com/lakshit'
                                    : "${Stat["referralLink"]}",
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.copy, color: Colors.white),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'Copy Link',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      borderOnForeground: false,
                      child: Container(
                        width: 220,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: adth),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(12),
                          child: MaterialButton(
                            color: Colors.white,
                            onPressed: () {
                              shareImageAndText();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.share_outlined, color: adth),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'Share',
                                    style: TextStyle(color: adth),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationDuration: Duration(seconds: 3),
      insetAnimationCurve: Curves.easeInBack,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Icon(
                        Icons.cancel,
                        size: 30,
                        color: Colors
                            .blue, // const Color.fromARGB(255, 111, 110, 110),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Are you sure, log out??",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 15),

              // QrImageView(
              //   data: '${Stat["referralLink"]}',
              //   size: 200,
              //   version: QrVersions.auto,
              // ),

              // // Icon(Icons.image),
              // SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      child: Container(
                        width: 220,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: MaterialButton(
                            color: adth,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'No',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      borderOnForeground: false,
                      child: Container(
                        width: 220,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: adth),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(12),
                          child: MaterialButton(
                            color: Colors.white,
                            onPressed: () {
                              final storage = FlutterSecureStorage();

                              storage.delete(
                                key:
                                    'bota**@useryubountensaahsjkhnxloggedtoken',
                              );
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyApp(isLoggedIn: false),
                                ),
                                (context) => false,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(color: adth),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
}

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  //const ForgetPass({super.key});

  String msg = "";

  Future<void> _getuser() async {
    // print("111111111111111111111kdsjskjkskskks");
    try {
      final res = await http.put(
        Uri.parse("${BASE_URL}/users/forget-password"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": "${emailc.text}",
          "role": "Affiliate",
        }),
      );

      if (res.statusCode == 200) {
        print(jsonDecode(res.body)["message"]);

        print(jsonDecode(res.body));

        // loginData = jsonDecode(res.body)["data"];
        // userToken = loginData["jwt"];
        // final storage = FlutterSecureStorage();

        // await storage.write(
        //   key: 'bota**@useryubountensaahsjkhnxloggedtoken',
        //   value: userToken,
        // );

        // print(userToken);

        if (!mounted) {
          return;
        }

        logi = true;
        msg = jsonDecode(res.body)["message"];
        sentotp = true;
        setState(() {});
      } else {
        print(jsonDecode(res.body));
        print("user failedN NANJANJAJAJJA");
        emailc.clear();
        // msg = jsonDecode(res.body);
        // show = true;
        logi = false;
        if (!mounted) {
          return;
        }

        msg = jsonDecode(res.body)["message"];

        setState(() {});
      }
    } catch (e) {
      print(e);

      print("jkkjkjkjkkkskks");
      msg = "Network error!";
      logi = false;
      if (!mounted) {
        return;
      }

      setState(() {});
      // logi = false;
    }
  }

  Future<void> _getOtpVerify() async {
    print("111111111111111111111kdsjskjkskskks");
    try {
      final res = await http.put(
        Uri.parse("${BASE_URL}/users/otpVerify"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": "${emailc.text}",
          "otp": "${otpController.text}",
        }),
      );

      if (res.statusCode == 200) {
        print(jsonDecode(res.body)["message"]);
        Tokon = jsonDecode(res.body)["token"];

        print(jsonDecode(res.body));

        if (!mounted) {
          return;
        }

        logi = true;
        msg = "Otp varified!";
        otpvarify = true;

        setState(() {});
      } else {
        print("user failedN NANJANJAJAJJA");
        logi = false;
        msg = "Otp is wrong!";
        otpController.clear();
        if (!mounted) {
          return;
        }

        setState(() {});
      }
    } catch (e) {
      print(e);

      print("jkkjkjkjkkkskks");
      logi = false;
      msg = "User Network Error!";
      if (!mounted) {
        return;
      }

      setState(() {});
      // logi = false;
    }
  }

  Future<void> _getChangePass() async {
    print("111111111111111111111kdsjskjkskskks");
    try {
      final res = await http.put(
        Uri.parse("${BASE_URL}/users/reset-password"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Tokon}',
        },
        body: jsonEncode(<String, String>{"newPassword": "${newc.text}"}),
      );

      if (res.statusCode == 200) {
        print(jsonDecode(res.body)["message"]);

        print(jsonDecode(res.body));

        if (!mounted) {
          return;
        }

        logi = true;
        msg = jsonDecode(res.body)["message"];
        otpvarify = true;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));

        Tokon = "";
        emailc.dispose();
        newc.dispose();
        cofc.dispose();
        otpController.dispose();
        Navigator.pop(context);

        // setState(() {});
      } else {
        print("user failedN NANJANJAJAJJA");
        logi = false;
        msg = jsonDecode(res.body)["message"];
        otpController.clear();
        if (!mounted) {
          return;
        }

        setState(() {});
      }
    } catch (e) {
      print(e);

      print("jkkjkjkjkkkskks");
      logi = false;
      msg = "Network Error!";
      if (!mounted) {
        return;
      }

      setState(() {});
      // logi = false;
    }
  }

  final emailc = TextEditingController();
  final otpController = TextEditingController();

  final newc = TextEditingController();
  final cofc = TextEditingController();
  bool sentotp = false;
  bool otpvarify = false;
  String Tokon = "";
  bool show = false;
  bool logi = false;

  @override
  Widget build(BuildContext context) {
    return (sentotp)
        ? ((otpvarify)
              ? Dialog(
                  insetAnimationDuration: Duration(seconds: 3),
                  insetAnimationCurve: Curves.easeInBack,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "New Password",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),

                          SizedBox(height: 8),
                          //  SizedBox(height: 20),
                          TextField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: newc,
                            decoration: InputDecoration(
                              hintText: "New Password",
                              hintStyle: TextStyle(color: adth),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: adth),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: adth),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Confirm Password",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),

                          SizedBox(height: 8),
                          //  SizedBox(height: 20),
                          TextField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: cofc,
                            decoration: InputDecoration(
                              hintText: "Confirm New Password",
                              hintStyle: TextStyle(color: adth),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: adth),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: adth),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: Text(
                          //     (logi == false) ? msg : '',
                          //     style: TextStyle(color: Colors.red, fontSize: 12),
                          //   ),
                          // ),
                          SizedBox(height: 20),

                          MaterialButton(
                            height: 50,
                            // minWidth: 283,
                            color: adth,
                            onPressed: () {
                              if (newc.text != cofc.text) {
                                logi = false;
                                msg = "Password does not match!";
                                setState(() {});
                                return;
                              }
                              msg = "In process..";
                              logi = true;
                              setState(() {});
                              _getChangePass();
                            },
                            child: Center(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Change Password",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Icon(color: Colors.white, Icons.lock_open),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              msg,
                              style: TextStyle(
                                color: (logi == true)
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),

                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                )
              : Dialog(
                  insetAnimationDuration: Duration(seconds: 3),
                  insetAnimationCurve: Curves.easeInBack,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Enter OTP",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Enter OTP",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),

                          SizedBox(height: 8),
                          //  SizedBox(height: 20),
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            controller: otpController,
                            onChanged: (value) {},
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(8),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeColor: Colors.deepOrange,
                              selectedColor: Colors.orange,
                              inactiveColor: Colors.grey.shade300,
                            ),
                          ),
                          SizedBox(height: 16),
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: Text(
                          //     (logi == false) ? msg : '',
                          //     style: TextStyle(color: Colors.red, fontSize: 12),
                          //   ),
                          // ),
                          SizedBox(height: 20),

                          MaterialButton(
                            height: 50,
                            // minWidth: 283,
                            color: adth,
                            onPressed: () {
                              if (otpController.text.length < 6) {
                                logi = false;
                                msg = "Otp can not be less than 6 digits!";
                                setState(() {});
                                return;
                              }
                              msg = "Varifying..";
                              logi = true;
                              setState(() {});
                              _getOtpVerify();
                            },
                            child: Center(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Otp Verify",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Icon(color: Colors.white, Icons.lock_open),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              msg,
                              style: TextStyle(
                                color: (logi == true)
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),

                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ))
        : Dialog(
            insetAnimationDuration: Duration(seconds: 3),
            insetAnimationCurve: Curves.easeInBack,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Forget Password",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email Address",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                    SizedBox(height: 8),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailc,
                      decoration: InputDecoration(
                        hintText: "email address",
                        hintStyle: TextStyle(color: adth),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: adth),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: adth),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Text(
                    //     (logi == false) ? msg : '',
                    //     style: TextStyle(color: Colors.red, fontSize: 12),
                    //   ),
                    // ),
                    SizedBox(height: 20),

                    MaterialButton(
                      height: 50,
                      // minWidth: 283,
                      color: adth,
                      onPressed: () {
                        if (emailc.text.isEmpty) {
                          logi = false;
                          msg = "Email Adress can not be empty!";
                          setState(() {});
                          return;
                        }
                        msg = "Loading";
                        logi = true;
                        setState(() {});
                        _getuser();
                      },
                      child: Center(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "Send Reset Code",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Icon(color: Colors.white, Icons.lock_open),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        msg,
                        style: TextStyle(
                          color: (logi == true) ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          );
  }
}

class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  String msg = "";
  bool logi = false;
  final newc = TextEditingController();
  final cofc = TextEditingController();

  Future<void> _getChangePass() async {
    print("111111111111111111111kdsjskjkskskks");
    try {
      final res = await http.put(
        Uri.parse("${BASE_URL}/users/reset-password"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${userToken}',
        },
        body: jsonEncode(<String, String>{"newPassword": "${newc.text}"}),
      );

      if (res.statusCode == 200) {
        print(jsonDecode(res.body)["message"]);

        print(jsonDecode(res.body));

        if (!mounted) {
          return;
        }

        logi = true;
        msg = jsonDecode(res.body)["message"];

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));

        // newc.dispose();
        // cofc.dispose();
        Navigator.pop(context);

        // setState(() {});
      } else {
        print("user failedN NANJANJAJAJJA");
        logi = false;
        msg = jsonDecode(res.body)["message"];
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));

        // newc.dispose();
        // cofc.dispose();
        Navigator.pop(context);
        // otpController.clear();
        if (!mounted) {
          return;
        }

        setState(() {});
      }
    } catch (e) {
      print(e);

      print("jkkjkjkjkkkskks");
      logi = false;
      msg = "Network Error!";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

      // newc.dispose();
      // cofc.dispose();
      Navigator.pop(context);
      // if (!mounted) {
      //   return;
      // }

      // setState(() {});
      // // logi = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationDuration: Duration(seconds: 3),
      insetAnimationCurve: Curves.easeInBack,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Change Password",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "New Password",
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),
              ),

              SizedBox(height: 8),
              //  SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: newc,
                decoration: InputDecoration(
                  hintText: "New Password",
                  hintStyle: TextStyle(color: adth),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: adth),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: adth),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Confirm Password",
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),
              ),

              SizedBox(height: 8),
              //  SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: cofc,
                decoration: InputDecoration(
                  hintText: "Confirm New Password",
                  hintStyle: TextStyle(color: adth),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: adth),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: adth),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: Text(
              //     (logi == false) ? msg : '',
              //     style: TextStyle(color: Colors.red, fontSize: 12),
              //   ),
              // ),
              SizedBox(height: 20),

              MaterialButton(
                height: 50,
                // minWidth: 283,
                color: adth,
                onPressed: () {
                  if (newc.text != cofc.text || newc.text.length < 6) {
                    logi = false;
                    msg = "Password does not match/less than 6 characters!";
                    setState(() {});
                    return;
                  }
                  msg = "In process..";
                  logi = true;
                  setState(() {});
                  _getChangePass();
                  // Navigator.pop(context);
                },
                child: Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Change Password",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Icon(color: Colors.white, Icons.lock_open),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  msg,
                  style: TextStyle(
                    color: (logi == true) ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),

              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

// class DeleteVDPage extends StatelessWidget {
//   const DeleteVDPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
