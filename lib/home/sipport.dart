import 'dart:io';
import 'package:bauntan/home/dash.dart';
import 'package:bauntan/home/earn.dart';
import 'package:bauntan/home/person.dart';
import 'package:bauntan/home/trans.dart';
import 'package:bauntan/model/model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// void main() => runApp(MaterialApp(home: SupportTicketPage()));

class SupportTicketPage extends StatefulWidget {
  @override
  _SupportTicketPageState createState() => _SupportTicketPageState();
}

class _SupportTicketPageState extends State<SupportTicketPage> {
  final _nameController = TextEditingController(text: 'Story Kitadake');
  final _emailController = TextEditingController(text: '1112');
  final _commentController = TextEditingController();
  File? _videoFile;

  // final ImagePicker _picker = ImagePicker();

  Future<void> _pickVideo() async {
    // final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   setState(() {
    //     _videoFile = File(pickedFile.path);
    //   });
    // }
  }

  void _submitTicket() {
    // Handle submission logic
    print('Name: ${_nameController.text}');
    print('Email: ${_emailController.text}');
    print('Comment: ${_commentController.text}');
    print('Video: ${_videoFile?.path}');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Ticket Submitted")));
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
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 216, 240, 249),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Row(
                    children: [
                      (true)
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
                          color: Colors.blue,
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
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(13),
              margin: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      "Support Ticket",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        // color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 0),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 0.2),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 0),
                  _buildInputField("Full Name", _nameController),

                  _buildInputField("Email Address", _emailController),

                  _buildInputField("Comment", _commentController, maxLines: 4),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          child: Container(
                            width: 165,
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
                                        vertical: 19.0,
                                        horizontal: 5,
                                      ),
                                      child: Text(
                                        'Submit ticket',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
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

            SizedBox(height: 30),
          ],
        ),
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
        SizedBox(height: 10),
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class DottedBorderBox extends StatelessWidget {
  final Widget child;

  const DottedBorderBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade100,
          style: BorderStyle.solid,
          width: 1.5,
        ),
      ),
      child: Center(child: child),
    );
  }
}
