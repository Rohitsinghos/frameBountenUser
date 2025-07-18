import 'dart:convert';

import 'package:bauntan/home/dash.dart';
import 'package:bauntan/model/model.dart';
import 'package:bauntan/other/compo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// st

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailc = TextEditingController();
  final passc = TextEditingController();

  String msg = "";

  Future<void> _getuser() async {
    print("111111111111111111111kdsjskjkskskks");
    try {
      final res = await http.post(
        Uri.parse("${BASE_URL}/users/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": "${emailc.text}",
          "password": "${passc.text}",
          "expectedRole": "Affiliate",
        }),
      );

      if (res.statusCode == 200) {
        print(jsonDecode(res.body)["message"]);

        print(jsonDecode(res.body));

        loginData = jsonDecode(res.body)["data"];
        userToken = loginData["jwt"];
        final storage = FlutterSecureStorage();

        await storage.write(
          key: 'bota**@useryubountensaahsjkhnxloggedtoken',
          value: userToken,
        );

        print(userToken);

        if (!mounted) {
          return;
        }

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => DashboardPage()),
        // );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
          (context) => false,
        );

        logi = true;
        msg = "User Found!";
      } else {
        print("user failedN NANJANJAJAJJA");
        logi = false;
        msg = "User Not Found!";
        emailc.clear();
        passc.clear();
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

  bool logi = false;

  bool found = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: adth,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Image.network(
                //   "https://bounten-aws-bucket.s3.ap-south-1.amazonaws.com/bottle-7595561_1280-%281%29-1747118331724-1751025304098.jpg",
                //   height: 100,
                // ),
                Row(
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Welcome !",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Phone Number Input Row
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailc,
                  decoration: InputDecoration(
                    hintText: "Email",
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

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passc,
                  decoration: InputDecoration(
                    hintText: "Password",
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
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ForgetPass(),
                    );
                  },
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            // alignment: Alignment.centerRight,
                            child: Text(
                              "forget password",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Login Button
                MaterialButton(
                  height: 50,
                  minWidth: 283,
                  color: (logi == false) ? adth : bg,
                  onPressed: () {
                    if (emailc.text.isEmpty) {
                      msg = "Email Address can not be empty!";
                      logi = false;
                      setState(() {});
                      return;
                    }

                    if (passc.text.isEmpty) {
                      msg = "Password can not be empty!";
                      logi = false;
                      setState(() {});
                      return;
                    }

                    msg = "fetching user...";
                    logi = true;
                    if (mounted) {
                      setState(() {});
                    }
                    _getuser();

                    // if (controller1.text.length == 10) {

                    // } else {
                    // call = Colors.red;
                    // if (!mounted) return; // prevents calling setState if widget is disposed

                    //   setState(() {});
                    // } else {
                    //   controller1.clear();
                    // }
                  },
                  child: Center(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Login",
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

                Text(
                  msg,
                  style: TextStyle(
                    fontSize: 12,
                    color: (logi == true || msg != "")
                        ? Colors.red
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
