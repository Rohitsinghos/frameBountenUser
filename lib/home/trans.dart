import 'dart:convert';

import 'package:bauntan/home/dash.dart';
import 'package:bauntan/home/earn.dart';
import 'package:bauntan/home/person.dart';
import 'package:bauntan/home/sipport.dart';
import 'package:bauntan/model/model.dart' hide copyText;
import 'package:bauntan/other/compo.dart';
import 'package:bauntan/other/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  int mx = 0;

  final List<Map<String, String>> transactions = [
    {
      'name': 'Aurelia Nightshade',
      'product': 'Gadget Pro 2023',
      'status': 'Successful',
    },
    {
      'name': 'Aurelia Nightshade',
      'product': 'Gadget Pro 2023',
      'status': 'Successful',
    },
    {
      'name': 'Aurelia Nightshade',
      'product': 'Gadget Pro 2023',
      'status': 'Pending',
    },
    {
      'name': 'Aurelia Nightshade',
      'product': 'Gadget Pro 2023',
      'status': 'Pending',
    },
    {
      'name': 'Aurelia Nightshade',
      'product': 'Gadget Pro 2023',
      'status': 'Failed',
    },
    {
      'name': 'Aurelia Nightshade',
      'product': 'Gadget Pro 2023',
      'status': 'Failed',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Successful':
        return Colors.green.shade100;
      case 'Pending':
        return Colors.orange.shade100;
      case 'Failed':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Sold':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Unpaid':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  int cp = 1;

  String msg = "Loading";

  Future<void> _gettran() async {
    try {
      final res4 = await http.get(
        Uri.parse(
          "${BASE_URL}/affiliate/transactions/${Afpro['profile']['affiliateId'] ?? 37}?pagination[page]=$cp&pagination[pageSize]=5",
        ),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${userToken}',
        },
      );

      // https://bountenapi.socialseller.in/api

      if (res4.statusCode == 200) {
        g4 = true;
        print(jsonDecode(res4.body));

        Trans = jsonDecode(res4.body);

        if (!mounted) return;

        msg = "got it";

        setState(() {});
      } else {
        g4 = false;
        if (!mounted) return;

        msg = "Server error!";

        setState(() {});

        print("nndnndndnnd");
      }
    } catch (e) {
      print(e);
      if (!mounted) return;

      msg = "Network error!";

      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mx = Trans["meta"]["pagination"]["pageCount"];
    Trans = {};
    _gettran();

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Image.asset('assets/logo2.jpg', height: 40),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(context: context, builder: (context) => LogoutPage());
              // LogoutPage();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.from(
                    alpha: 1,
                    red: 0.416,
                    green: 0.624,
                    blue: 0.988,
                  ),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(30),
              ),

              child: CircleAvatar(
                backgroundImage: (Afpro != null)
                    ? NetworkImage(Afpro['profile']['media']['url'])
                    : AssetImage('assets/avatar.png'),
                radius: 15,
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      drawer: AppDrawer(page: 4),

      body: (Trans == null || Trans["data"] == null)
          ? SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Text(
                      msg,
                      style: TextStyle(
                        fontSize: 16,
                        color: (msg == "Loading") ? Colors.green : Colors.red,
                      ),
                    ),
                    Icon(Icons.refresh, color: Colors.blue),
                  ],
                ),
              ),
            )
          : ListView(
              padding: EdgeInsets.all(16),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          "Transaction History",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Colors.white,

                            // borderRadius: BorderRadius.circular(15),
                            // border: Border.all(color: Colors.blue),
                          ),
                          child: TextField(
                            controller: ctl,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText:
                                  (Stat == null || Stat["referralLink"] == null)
                                  ? "https://bounten.com/lakshit"
                                  : "${Stat["referralLink"]}",
                              suffixIcon: IconButton(
                                icon: Icon(Icons.qr_code, color: Colors.blue),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => QrPage(),
                                  );
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              hintStyle: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        child: Container(
                          width: 155,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: MaterialButton(
                              color: Colors.blue,
                              onPressed: () {
                                copyText(
                                  (Stat == null || Stat["referralLink"] == null)
                                      ? "https://bounten.com/lakshit"
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
                          width: 155,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: adth),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(12),
                            child: MaterialButton(
                              // color: Colors.white,
                              color: bg,
                              onPressed: () {
                                shareImageAndText();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.share_outlined,
                                    color: Colors.blue,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      'Share',
                                      style: TextStyle(color: Colors.blue),
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

                // SizedBox(height: 15),
                // SizedBox(height: 5),
                (Trans == null ||
                        Trans["data"] == null ||
                        Trans["data"].length == 0)
                    ? Container(
                        padding: EdgeInsets.all(15),
                        child: Center(child: Text("No transaction found!")),
                      )
                    : Column(
                        children: [
                          for (
                            int index = 0;
                            index < (Trans["data"].length ?? 0);
                            index++
                          )
                            Card(
                              color: Colors.white,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                margin: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 140,
                                      width: 180,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              // vertical: 15.0,
                                              // horizontal: 15,
                                            ),
                                            child: Text(
                                              Trans["data"][index]["lead"]["name"]!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      // horizontal: 10.0,
                                                    ),
                                                child: Text("Address"),
                                              ),
                                              Text(
                                                "${Trans["data"][index]["lead"]["location"]}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Commision",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),

                                                  Text(
                                                    "₹ ${Trans["data"][index]["lead"]['amount']}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      height: 120,

                                      // margin: EdgeInsets.all(15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Payout Status",
                                                style: TextStyle(fontSize: 12),
                                              ),

                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(
                                                    Trans["data"][index]["lead"]['status']!,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  Trans["data"][index]["lead"]['status']!,
                                                  style: TextStyle(
                                                    color: _getStatusTextColor(
                                                      Trans["data"][index]["lead"]['status']!,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Payment Status",
                                                style: TextStyle(fontSize: 12),
                                              ),

                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(
                                                    Trans["data"][index]['status']!,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  Trans["data"][index]['status']!,
                                                  style: TextStyle(
                                                    color: _getStatusTextColor(
                                                      Trans["data"][index]['status']!,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          //         ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),

                SizedBox(height: 2),
                ((mx ?? 1) <= 1)
                    ? Container()
                    : Card(
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(12),
                        //   color: Colors.white,
                        // ),
                        color: Colors.white,
                        child: Center(
                          child: Row(
                            spacing: 8,
                            children: List.generate(7, (ind) {
                              int index = cp - 2 + ind;
                              int mxpg = mx;
                              if (ind == 0 || ind == 6) {
                                return IconButton(
                                  style: ButtonStyle(),
                                  icon: Icon(
                                    ind == 0
                                        ? Icons.chevron_left
                                        : Icons.chevron_right,
                                    // size: 10,
                                  ),
                                  onPressed: () {
                                    if (cp == 1 || ind == 0 || cp >= mxpg) {
                                      return;
                                    }

                                    Trans = {};

                                    ind == 0 ? cp-- : cp++;

                                    setState(() {
                                      g4 = false;
                                    });
                                    _gettran();
                                  },
                                );
                              } else if (ind == 5) {
                                return Text("...");
                              } else if (index < 1) {
                                return SizedBox(width: 40);
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    cp = cp + ind - 2;
                                    setState(() {
                                      g4 = false;
                                    });
                                    _gettran();
                                    if (!mounted) {
                                    } else {
                                      setState(() {});
                                    }
                                  },
                                  child: (mxpg < index)
                                      ? SizedBox(width: 40)
                                      : Container(
                                          width: 40,
                                          decoration: (index == cp)
                                              ? BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        (index == -1) ? 12 : 0,
                                                      ),
                                                  border: Border.all(
                                                    width: (index == 2)
                                                        ? 0.5
                                                        : 0,
                                                  ),
                                                )
                                              : BoxDecoration(),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                              // horizontal: 15,
                                            ),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              "${index}",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ),
                                );
                              }
                            }),
                          ),
                        ),
                      ),
              ],
            ),
    );
  }
}
