import 'package:bauntan/home/dash.dart';
import 'package:bauntan/home/earn.dart';
import 'package:bauntan/home/person.dart';
import 'package:bauntan/home/sipport.dart';
import 'package:bauntan/model/model.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
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
      case 'Successful':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Future<void> shareImageAndText() async {
    // 1. Load image from assets or network (here: from assets)
    // final byteData = await rootBundle.load('assets/logo.jpg');

    // // 2. Save it to a temporary file
    // final tempDir = await getTemporaryDirectory();
    // final file = File('${tempDir.path}/shared_image.jpg');
    // await file.writeAsBytes(byteData.buffer.asUint8List());

    // 3. Share the image and text
    await Share.share('Check out this image!');
  }

  int cp = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Image.asset('assets/logo2.jpg', height: 40),
        backgroundColor: Colors.white,
        actions: [
          Container(
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
              backgroundImage: AssetImage('assets/avatar.png'),
              radius: 15,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 70),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Icon(
                      Icons.cancel,
                      size: 30,
                      color: const Color.fromARGB(255, 111, 110, 110),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            MaterialButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                  (context) => false,
                );
              },
              child: Container(
                child: ListTile(
                  title: Row(
                    children: [
                      (false)
                          ? Icon(Icons.dashboard, color: Colors.blue)
                          : Icon(Icons.dashboard_outlined),
                      SizedBox(width: 10),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 111, 110, 110),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalInfoPage()),
                );
              },
              child: Container(
                child: ListTile(
                  title: Row(
                    children: [
                      (false)
                          ? Icon(Icons.person_rounded, color: Colors.blue)
                          : Icon(Icons.person_outline_rounded),
                      SizedBox(width: 10),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 111, 110, 110),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EarningPage()),
                );
              },
              child: Container(
                child: ListTile(
                  title: Row(
                    children: [
                      (false)
                          ? Icon(Icons.local_activity, color: Colors.blue)
                          : Icon(Icons.local_activity_outlined),
                      SizedBox(width: 10),
                      Text(
                        'Performance',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 111, 110, 110),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionHistoryPage(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 216, 240, 249),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Row(
                    children: [
                      (true)
                          ? Icon(Icons.traffic_rounded, color: Colors.blue)
                          : Icon(Icons.transform_outlined),
                      SizedBox(width: 10),
                      Text(
                        'Transaction History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportTicketPage()),
                );
              },
              child: Container(
                child: ListTile(
                  title: Row(
                    children: [
                      (false)
                          ? Icon(
                              Icons.support_agent_rounded,
                              color: Colors.blue,
                            )
                          : Icon(Icons.support_agent_outlined),
                      SizedBox(width: 10),
                      Text(
                        'Support',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 111, 110, 110),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
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
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: .0),
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
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'https://bounten.com/lakshit',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.qr_code, color: Colors.blue),
                          onPressed: () {
                            copyText("https://bounten.com/lakshit");
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
                          copyText("https://bounten.com/lakshit");
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
                            Icon(Icons.share_outlined, color: Colors.blue),
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
          ...transactions.map((tx) {
            return Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    tx['name']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("Product\n${tx['product']}"),
                ),
                isThreeLine: true,
                trailing: Container(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Payout Status", style: TextStyle(fontSize: 12)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(tx['status']!),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tx['status']!,
                          style: TextStyle(
                            color: _getStatusTextColor(tx['status']!),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          SizedBox(height: 2),
          Card(
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
                  if (ind == 0 || ind == 6) {
                    return IconButton(
                      style: ButtonStyle(),
                      icon: Icon(
                        ind == 0 ? Icons.chevron_left : Icons.chevron_right,
                        // size: 10,
                      ),
                      onPressed: () {
                        if (cp == 1 && ind == 0) {
                          return;
                        }

                        ind == 0 ? cp-- : cp++;

                        setState(() {});
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
                        setState(() {});
                      },
                      child: Container(
                        width: 40,
                        decoration: (index == cp)
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  (index == -1) ? 12 : 0,
                                ),
                                border: Border.all(
                                  width: (index == 2) ? 0.5 : 0,
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
