import 'package:bauntan/home/earn.dart';
import 'package:bauntan/home/person.dart';
import 'package:bauntan/home/sipport.dart';
import 'package:bauntan/home/trans.dart';
import 'package:bauntan/model/model.dart';

import 'package:bountenadmin/model/appdata.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart'
    show rootBundle; // Required for Clipboard

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bounten',
      theme: ThemeData(primarySwatch: adth),
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}

void copyText(String text) {
  Clipboard.setData(ClipboardData(text: text));
  print("✅ Text copied: $text");
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, String>> leads = List.generate(
    10,
    (index) => {
      'name': 'Samuel Peterson',
      'product': 'Gadget Pro 2023',
      'quality': [
        'Poor',
        'High',
        'Low',
        'Poor',
        'Poor',
        'Poor',
        'Poor',
        'High',
        'Low',
        'Poor',
      ][index],
    },
  );

  Future<void> _shareImageAndText() async {
    // 1. Load image from assets or network (here: from assets)
    // final byteData = await rootBundle.load('assets/logo.jpg');

    // // 2. Save it to a temporary file
    // final tempDir = await getTemporaryDirectory();
    // final file = File('${tempDir.path}/shared_image.jpg');
    // await file.writeAsBytes(byteData.buffer.asUint8List());

    // 3. Share the image and text
    await Share.share('Check out this image!');
  }

  final _pickImage = null;

  // void _uploadPickedImage() async {
  //   final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     File imageFile = File(picked.path);
  //     // _pickedImage = File(picked.path);
  //   }
  // }

  // Future<void> _showPickOptionsDialog() async {
  //   final isCamera = await showDialog<bool>(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text('Select image source'),
  //       actions: [
  //         TextButton(
  //           child: const Text('Camera'),
  //           onPressed: () => Navigator.pop(context, true),
  //         ),
  //         TextButton(
  //           child: const Text('Gallery'),
  //           onPressed: () => Navigator.pop(context, false),
  //         ),
  //       ],
  //     ),
  //   );
  //   if (isCamera == null) return;
  //   _pickImage(isCamera ? ImageSource.camera : ImageSource.gallery);
  // }

  List tabst = ['All leads', 'Poor Quality', 'Low Quality', 'High Quality'];

  String selectedValue = 'Poor Quality';

  int tabb = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the confirmation dialog
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App', style: TextStyle(color: adth)),
            content: Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        );
        // If the user confirmed, exit the app
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: bg,
        backgroundColor: const Color.fromARGB(255, 238, 248, 252),
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          title: Image.asset('assets/logo2.jpg', height: 40),
          backgroundColor: Colors.white,
          // leading: Builder(
          //   builder: (context) => IconButton(
          //     icon: Icon(Icons.menu),
          //     onPressed: () => Scaffold.of(context).openDrawer(),
          //   ),
          // ),
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => DashboardPage()),
                  // );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        (true)
                            ? Icon(Icons.dashboard, color: adth)
                            : Icon(Icons.dashboard_outlined),
                        SizedBox(width: 10),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: adth,
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
                child: ListTile(
                  title: Row(
                    children: [
                      (false)
                          ? Icon(Icons.person_rounded, color: adth)
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
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EarningPage()),
                  );
                },
                child: ListTile(
                  title: Row(
                    children: [
                      (false)
                          ? Icon(Icons.local_activity, color: adth)
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
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionHistoryPage(),
                    ),
                  );
                },
                child: ListTile(
                  title: Row(
                    children: [
                      (false)
                          ? Icon(Icons.traffic_rounded, color: adth)
                          : Icon(Icons.transform_outlined),
                      SizedBox(width: 10),
                      Text(
                        'Transaction History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 111, 110, 110),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SupportTicketPage(),
                    ),
                  );
                },
                child: ListTile(
                  title: Row(
                    children: [
                      (false)
                          ? Icon(Icons.support_agent_rounded, color: adth)
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
            ],
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 10),
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                _buildStatCard(
                  "Total Traffic",
                  "15,678",
                  Icon(Icons.traffic, color: adthAccent),
                ),
                _buildStatCard(
                  "Total Leads",
                  "15,678",
                  Icon(Icons.group, color: adthAccent),
                ),
                _buildStatCard(
                  "Total Earnings",
                  "₹12,345",
                  Icon(Icons.account_balance_wallet, color: adthAccent),
                ),
                _buildStatCard(
                  "Pending Leads",
                  "56",
                  Icon(Icons.pending, color: adthAccent),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.white,

                        // borderRadius: BorderRadius.circular(15),
                        // border: Border.all(color: adth),
                      ),
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'https://bounten.com/lakshit',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.qr_code, color: adth),
                            onPressed: () {
                              copyText("https://bounten.com/lakshit");
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),

                            borderSide: BorderSide(color: adth),
                          ),
                          hintStyle: TextStyle(color: adth),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    child: Container(
                      width: 160,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: MaterialButton(
                          color: adth,
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
                      width: 160,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: adth),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(12),
                        child: MaterialButton(
                          color: Colors.white,
                          onPressed: () {
                            _shareImageAndText();
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
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Leads Quality Analysis",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 114, 114, 114),
                      ),
                    ),
                  ),

                  Container(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (int index = 0; index < 4; index++)
                                      GestureDetector(
                                        onTap: () {
                                          tabb = index;
                                          setState(() {});
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(8),

                                          child: Container(
                                            color: (index == tabb)
                                                ? adth
                                                : const Color.fromARGB(
                                                    255,
                                                    238,
                                                    248,
                                                    252,
                                                  ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              child: Center(
                                                child: Text(
                                                  tabst[index],
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: (index != tabb)
                                                        ? adth
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Table(
                            border: TableBorder(
                              horizontalInside: BorderSide(
                                color: Colors.grey,
                                width: 0.2,
                              ),
                            ),
                            // defaultColumnWidth: ,
                            columnWidths: const {
                              0: FixedColumnWidth(110),
                              1: FixedColumnWidth(100),
                              2: FixedColumnWidth(100),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,

                            children: [
                              TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),

                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          'Name',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          'Product',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Lead Quality Analysis',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ...leads.map((lead) {
                                return TableRow(
                                  children: [
                                    Container(
                                      height: 50,
                                      color: Colors.white,
                                      padding: EdgeInsets.all(4),
                                      child: Center(
                                        child: Text(
                                          // overflow: TextOverflow.ellipsis,
                                          // maxLines: 3,
                                          textAlign: TextAlign.center,
                                          lead['name']!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        // overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        lead['product']!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),

                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                        // horizontal: 3,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(6),
                                        child: Container(
                                          color: const Color.fromARGB(
                                            255,
                                            238,
                                            248,
                                            252,
                                          ),
                                          child: Center(
                                            child: DropdownButton<String>(
                                              // padding: EdgeInsets.symmetric(
                                              //   horizontal: 5,
                                              // ),
                                              alignment: Alignment.center,

                                              value: selectedValue,
                                              icon: Icon(Icons.arrow_drop_down),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11,
                                              ),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedValue = newValue!;
                                                });
                                              },
                                              items:
                                                  <String>[
                                                    'High Quality',
                                                    'Low Quality',
                                                    'Poor Quality',
                                                    'Poori Quality',
                                                    // 'Mango',
                                                  ].map<
                                                    DropdownMenuItem<String>
                                                  >((String value) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),

                                              // DropdownButton(
                                              //   dropdownColor: const Color.fromARGB(
                                              //     255,
                                              //     238,
                                              //     248,
                                              //     252,
                                              //   ),
                                              //   iconEnabledColor: const Color.fromARGB(
                                              //     255,
                                              //     238,
                                              //     248,
                                              //     252,
                                              //   ),
                                              //   onChanged: (value) {
                                              //     // butt = value.toString();
                                              //   },
                                              //   // value: lead,
                                              //   items: [],
                                              // child: Container(
                                              //   color: const Color.fromARGB(
                                              //     255,
                                              //     238,
                                              //     248,
                                              //     252,
                                              //   ),
                                              //   padding: EdgeInsets.all(4),
                                              //   child: Row(
                                              //     children: [
                                              //       Text(
                                              //         // overflow: TextOverflow.ellipsis,
                                              //         textAlign: TextAlign.center,
                                              //         '${lead['quality']} Quality',
                                              //         style: TextStyle(
                                              //           fontSize: 11,
                                              //           color: Colors.black,
                                              //         ),
                                              //       ),
                                              //       Icon(Icons.arrow_drop_down),
                                              //     ],
                                              //   ),
                                              // ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Icon Ico) {
    return Container(
      padding: EdgeInsets.all(2),
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Container(
          width: 160,
          height: 90,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      color: adthAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 230, 230, 252),
                      borderRadius: BorderRadius.circular(7),
                    ),

                    padding: EdgeInsets.all(3),
                    child: Ico,
                  ),
                ],
              ),
              Text(
                title,
                style: TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
