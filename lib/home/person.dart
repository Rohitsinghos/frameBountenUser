import 'package:bauntan/home/dash.dart';
import 'package:bauntan/home/earn.dart';
import 'package:bauntan/home/sipport.dart';
import 'package:bauntan/home/trans.dart';
import 'package:bauntan/model/model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class PersonalInfoPage extends StatelessWidget {
  final _cntr = [
    TextEditingController(text: 'Story Kitadake'),
    TextEditingController(text: '1112'),
    TextEditingController(text: 'Story Kitadake'),
    TextEditingController(text: '1112'),
    TextEditingController(text: '1112'),
  ];
  // const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
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
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 216, 240, 249),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Row(
                    children: [
                      (true)
                          ? Icon(Icons.person_rounded, color: Colors.blue)
                          : Icon(Icons.person_outline_rounded),
                      SizedBox(width: 10),
                      Text(
                        'Profile',
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
              child: ListTile(
                title: Row(
                  children: [
                    (false)
                        ? Icon(Icons.traffic_rounded, color: Colors.blue)
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
                  MaterialPageRoute(builder: (context) => SupportTicketPage()),
                );
              },
              child: ListTile(
                title: Row(
                  children: [
                    (false)
                        ? Icon(Icons.support_agent_rounded, color: Colors.blue)
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
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16.0),
            // color: Colors.white,
            child: ListTile(
              title: Text(
                "Personal information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ),
          // SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                          copyText("https://bounten.com/lakshit");
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
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.2),
            ),
            child: Column(
              children: [
                const SizedBox(height: 0),

                _buildInputField('First Name', _cntr[0]),
                _buildInputField('Last Name', _cntr[1]),
                _buildInputField('Mobile Number', _cntr[2]),
                _buildInputField('Email Address', _cntr[3]),
                _buildInputField('Address', _cntr[4]),
                SizedBox(height: 10),

                Container(
                  padding: EdgeInsets.all(16),
                  // margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.5),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            Text(
                              textAlign: TextAlign.start,
                              "Upload Video",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(18.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(12),
                            color: Colors.blue,
                            child: Container(
                              color: bg,
                              height: 100,
                              width: double.infinity,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.video_library,
                                      size: 35,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      // (_videoFile == null) ?
                                      "Upload Video", // : "Video Selected",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),

                SizedBox(height: 45),

                // const SizedBox(height: 20),
                const SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        borderOnForeground: false,
                        child: Container(
                          width: 135,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadiusGeometry.circular(12),
                            border: Border.all(color: Colors.blue),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            child: MaterialButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 5,
                                    ),
                                    child: Text(
                                      'Discard Changes',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: Container(
                          width: 135,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: MaterialButton(
                              padding: EdgeInsets.all(0),
                              color: Colors.blue,
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 5,
                                    ),
                                    child: Text(
                                      'Save Changes',
                                      style: TextStyle(color: Colors.white),
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
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Column(
        children: [
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 5),
          TextFormField(
            initialValue: value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
