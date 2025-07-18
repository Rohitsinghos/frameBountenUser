import 'dart:convert';
import 'dart:io';
import 'package:bauntan/home/dash.dart';
import 'package:bauntan/home/earn.dart';
import 'package:bauntan/home/person.dart';
import 'package:bauntan/home/trans.dart';
import 'package:bauntan/other/upp.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:bauntan/model/model.dart';
import 'package:bauntan/other/compo.dart';
import 'package:bauntan/other/drawer.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// void main() => runApp(MaterialApp(home: SupportTicketPage()));

class SupportTicketPage extends StatefulWidget {
  @override
  _SupportTicketPageState createState() => _SupportTicketPageState();
}

class _SupportTicketPageState extends State<SupportTicketPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _commentController = TextEditingController();
  // File? _videoFile;

  Future<void> _getSupport() async {
    try {
      final res = await http.get(
        Uri.parse("${BASE_URL}/affiliate/performance"),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${userToken}',
        },
      );

      // https://bountenapi.socialseller.in/api/affiliate/transactions/37?pagination[page]=1&pagination[pageSize]=5

      if (res.statusCode == 200) {
        print(jsonDecode(res.body));

        // Perfo = jsonDecode(res.body);

        g1 = true;

        if (!mounted) return;
        msg = "Successful!";
        logi = true;

        // if (g1 && g2 && g3) {
        setState(() {});
        // }
      } else {
        msg = "Server Error!";
        logi = false;
        setState(() {});
        print("nndnndndnnd");
      }
    } catch (e) {
      print(e);
      msg = "Network Error!";
      logi = false;
      setState(() {});
    }
  }

  bool logi = true;

  // ignore: unused_field
  File? _videoFile;
  bool _isUploading = false;

  Future<void> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      int sizeInMB = await file.length() ~/ (1024 * 1024);

      if (sizeInMB > 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File too large! Max 10MB allowed.")),
        );
        return;
      }

      setState(() => _videoFile = file);
    }
  }

  String msg = "";

  Future<void> uploadVideo() async {
    if (_videoFile == null) return;

    setState(() => _isUploading = true);

    final uri = Uri.parse("https://bountenapi.socialseller.in/api/uploads");
    final request = http.MultipartRequest("POST", uri);

    request.headers.addAll({
      'Authorization': 'Bearer $userToken', // Replace this with actual token
      'Accept': 'application/json',
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // Replace with correct field name if needed
        _videoFile!.path,
        contentType: MediaType('video', 'mp4'), // adjust if needed
      ),
    );

    try {
      final response = await request.send();
      final resBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print(jsonDecode(resBody.body));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Upload successful!")));

        Afpro['profile']['VideoId'] = jsonDecode(resBody.body)[0]['id'];
        msg = "Upload successful!";

        print(jsonDecode(resBody.body)[0]['id']);

        if (!mounted) return;
        _videoFile = null;

        setState(() {});

        if (!mounted) return;
      } else {
        _videoFile = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${resBody.statusCode}")),
        );
        msg = "Upload Failed!";
        setState(() {});
      }
    } catch (e) {
      _videoFile = null;
      msg = "Network error!";
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _isUploading = false);
  }

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
      drawer: AppDrawer(page: 5),
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoUploadPage(),
                                ),
                              );
                            },
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
                                      GestureDetector(
                                        onTap: () {
                                          _videoFile = null;
                                          setState(() {});

                                          pickVideo();
                                        },
                                        child: Container(
                                          color: bg,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.video_library,
                                                  size: 35,
                                                  color: (_videoFile == null)
                                                      ? Colors.grey
                                                      : Colors.blue,
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  (_videoFile == null)
                                                      ? "Upload Video"
                                                      : "Video Selected",
                                                  style: TextStyle(
                                                    color: (_videoFile == null)
                                                        ? Colors.grey
                                                        : Colors.blue,
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
                                onPressed: () {
                                  logi = true;
                                  msg = "loading...";
                                  _getSupport();
                                },
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        msg,
                        style: TextStyle(
                          color: (!logi) ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
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
