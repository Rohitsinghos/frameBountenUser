import 'dart:convert';
import 'dart:io';

import 'package:bauntan/home/dash.dart';
import 'package:bauntan/home/earn.dart';
import 'package:bauntan/home/sipport.dart';
import 'package:bauntan/home/trans.dart';
import 'package:bauntan/model/model.dart' hide copyText;
import 'package:bauntan/other/compo.dart';
import 'package:bauntan/other/drawer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:video_player/video_player.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  bool process = true;
  var _cntr = [
    TextEditingController(
      text: "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['name']}",
    ),
    TextEditingController(text: ""),
    TextEditingController(
      text: "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['phone']}",
    ),
    TextEditingController(
      text: "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['email']}",
    ),
    TextEditingController(
      text:
          "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['location']}",
    ),
    TextEditingController(text: ""),
    TextEditingController(text: ""),
    TextEditingController(text: ""),
    TextEditingController(text: ""),
    TextEditingController(text: ""),
    TextEditingController(text: ""),
    TextEditingController(text: ""),
    TextEditingController(text: ""),
  ];

  File? _videoFile;
  bool _isUploading = false;

  int profileId = -1;

  Future<void> pickVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.video);

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        int sizeInMB = await file.length() ~/ (1024 * 1024);

        if (sizeInMB > 100) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("File too large! Max 100MB allowed.")),
          );
          return;
        }

        msg = "Video Uploading..";
        logi = true;
        process = true;
        if (!mounted) return;
        setState(() => _videoFile = file);
        uploadVideo();
      }
    } catch (e) {
      print(e);
      msg = "Importing error..";
      logi = false;
      process = false;
      if (!mounted) return;
      setState(() {});
    }
  }

  Future<void> uploadVideo() async {
    if (_videoFile == null) return;
    if (!mounted) return;
    setState(() => _isUploading = true);

    final uri = Uri.parse("${BASE_URL}/uploads");
    final request = http.MultipartRequest("POST", uri);
    if (!mounted) return;

    request.headers.addAll({
      'Authorization': 'Bearer $userToken', // Replace this with actual token
      'Accept': 'application/json',
    });
    if (!mounted) return;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // Replace with correct field name if needed
        _videoFile!.path,
        contentType: MediaType('video', 'mp4'), // adjust if needed
      ),
    );
    if (!mounted) return;

    try {
      if (!mounted) return;
      final response = await request.send();
      final resBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print(jsonDecode(resBody.body));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Upload successful!")));

        vide = jsonDecode(resBody.body)[0]['id'];
        msg = "Upload successful!";

        print(jsonDecode(resBody.body)[0]['id']);

        if (!mounted) return;

        setState(() {});

        if (!mounted) return;
        _videoFile = null;
        _getUpdate();
      } else {
        _videoFile = null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${resBody.statusCode}")),
        );
        msg = "Upload Failed!";
        if (!mounted) return;
        setState(() {});
      }
    } catch (e) {
      _videoFile = null;
      msg = "Network error!";
      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
    if (!mounted) return;
    setState(() => _isUploading = false);
  }

  Future<void> uploadImage(File file) async {
    // onprocess = true;
    // if (!mounted) return;
    // setState(() {});
    if (!mounted) return;
    final request =
        http.MultipartRequest('POST', Uri.parse('${BASE_URL}/uploads'))
          ..headers['Authorization'] = 'Bearer $userToken'
          ..files.add(
            await http.MultipartFile.fromPath(
              'file', // replace with your API's field name
              file.path,
            ),
          );
    if (!mounted) return;

    try {
      final response = await request.send();
      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // final resBody = await response.stream.bytesToString();
        final resBody = await response.stream.bytesToString();

        // 👇 Decode JSON string to List
        print(jsonDecode(resBody));
        profileId = jsonDecode(resBody)[0]["id"];
        // final int id = data[0]['id'];
        // print(jsonDecode(jsonDecode(source))));
        // avarId = id;

        print('✅ Image uploaded');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Image uploaded successfully!')),
        );
        // onprocess = false;
        _pickedImage = null;
        if (!mounted) return;
        profileId == -1;
        msg = "Profile uploaded, Updating profile..";
        if (!mounted) return;
        setState(() {});

        if (!mounted) return;
        _getUpdate();
      } else {
        // final error = await response.stream.bytesToString();
        print('❌ Upload failed:');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Upload failed!')));
        if (!mounted) return;
        logi = false;
        msg = "❌ Upload failed!";
        if (!mounted) return;
        setState(() {});
        // onprocess = false;

        // if (!mounted) return;
        // setState(() {});
      }
    } catch (e) {
      print('Network Error!');
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text('❗ Upload error: $e')));
      if (!mounted) return;
      logi = false;
      msg = "Upload Error!";
      setState(() {});
      // onprocess = false;

      // if (!mounted) return;
      // setState(() {});
    }
  }

  reset() {
    _pickedImage = null;
    _videoFile = null;
    process = false;
    _cntr = [
      TextEditingController(
        text:
            "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['name']}",
      ),
      TextEditingController(text: ''),
      TextEditingController(
        text:
            "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['phone']}",
      ),
      TextEditingController(
        text:
            "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['email']}",
      ),
      TextEditingController(
        text:
            "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['location']}",
      ),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
    ];
    vide = Afpro['profile']['VideoId'] ?? -1;
    profileId = -1;

    int cus = 0;
    Links = 0;

    for (int i = 0; i < Afpro['profile']['socialLinks'].length; i++) {
      if (Afpro['profile']['socialLinks'][i]["platform"] == "facebook") {
        _cntr[5].text = Afpro['profile']['socialLinks'][i]["url"];
      }
      if (Afpro['profile']['socialLinks'][i]["platform"] == "instagram") {
        _cntr[6].text = Afpro['profile']['socialLinks'][i]["url"];
      }
      if (Afpro['profile']['socialLinks'][i]["platform"] == "youtube") {
        _cntr[7].text = Afpro['profile']['socialLinks'][i]["url"];
      }

      if (Afpro['profile']['socialLinks'][i]["platform"] == "custom" &&
          cus < 5) {
        _cntr[8 + cus].text = Afpro['profile']['socialLinks'][i]["url"];
        cus++;
        Links++;
      }

      // for (int i = 0; i < 5; i++) {
      //   if (_cntr[8 + i].text != "") {
      //     xx.add({"platform": "custom", "url": "${_cntr[8 + i].text}"});
      //   }
      // }
    }
  }

  String msg = "";
  bool logi = false;
  int vide = -1;

  Future<void> _getUpdate() async {
    if (!mounted) return;
    List xx = [];

    if (_cntr[5].text.contains("https://") == true) {
      xx.add({"platform": "facebook", "url": "${_cntr[5].text}"});
    }
    if (_cntr[6].text.contains("https://") == true) {
      xx.add({"platform": "instagram", "url": "${_cntr[6].text}"});
    }

    if (_cntr[7].text.contains("https://") == true) {
      xx.add({"platform": "youtube", "url": "${_cntr[7].text}"});
    }

    for (int i = 0; i < 5; i++) {
      if (_cntr[8 + i].text.contains("https://") == true) {
        xx.add({"platform": "custom", "url": "${_cntr[8 + i].text}"});
      }
    }

    try {
      if (!mounted) return;
      final res = await http.put(
        Uri.parse(
          "${BASE_URL}/affiliate/profile/${Afpro["profile"]["affiliateId"]}",
        ),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${userToken}',
        },
        body: jsonEncode(<String, dynamic>{
          // "email": "${emailc.text}",
          // "password": "${passc.text}",
          // "expectedRole": "Affiliate",
          // "AvatarId":109,"VideoId":null}
          "name": "${_cntr[0].text}",
          "phone": "${_cntr[2].text}",
          "email": "${_cntr[3].text}",
          "address": "${_cntr[4].text}",
          "socialLinks": xx,
          // [
          //   {"platform": "facebook", "url": "https://facebook.com/xyz"},
          //   {"platform": "instagram", "url": "https://instagram.com/xyz"},
          //   {"platform": "custom", "url": "https://linkedin.com/xyz"},

          //   {"platform": "custom", "url": "https://linkedin.com/xyz"},
          // ],
          "AvatarId": (profileId != -1)
              ? profileId
              : Afpro['profile']['AvatarId'],
          "VideoId": (vide == -1) ? null : vide,
        }),
      );
      if (!mounted) return;
      // vide = Afpro['profile']['VideoId'] ?? 667;

      // https://bountenapi.socialseller.in/api/affiliate/transactions/37?pagination[page]=1&pagination[pageSize]=5

      if (res.statusCode == 200) {
        if (!mounted) return;
        print(jsonDecode(res.body));

        // Perfo = jsonDecode(res.body);

        g1 = true;
        if (!mounted) return;
        final res11 = await http.get(
          Uri.parse("${BASE_URL}/affiliate/profile"),

          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${userToken}',
          },
        );
        if (!mounted) return;

        // https://bountenapi.socialseller.in/api/affiliate/transactions/37?pagination[page]=1&pagination[pageSize]=5

        if (res11.statusCode == 200) {
          print(jsonDecode(res11.body));

          Afpro = jsonDecode(res11.body);

          g1 = true;
          reset();

          if (!mounted) return;
          _videoFile = null;

          msg = "";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile Updated successfully!')),
          );
          process = false;
          logi = true;
          String? videoUrl;

          try {
            if (!mounted) return;
            final profile = Afpro?['profile'];
            final url = profile?['videoUrl']?['url'];

            videoUrl = url;

            _controller = VideoPlayerController.network(videoUrl!);
            _controller
                .initialize()
                .then((_) {
                  videowo = true;
                  if (mounted) setState(() {});
                })
                .catchError((error) {
                  videowo = false;
                  print("Video init error: $error");
                  // Fallback or show error UI
                });
          } catch (e) {
            videowo = false;
            print("Exception during video load: $e");
            // Optionally use a fallback
          }

          if (!mounted) return;

          setState(() {});
        } else {
          print("nndnndndnnd");
          if (!mounted) return;
          logi = false;
          msg = "Fetching server Error!";
          if (!mounted) return;
          setState(() {});
        }

        // }
      } else {
        print("nndnndndnnd");
        if (!mounted) return;
        msg = "Fetching Server Error!";
        logi = false;
        if (!mounted) return;
        setState(() {});
      }
    } catch (e) {
      print(e);
      if (!mounted) return;
      logi = false;
      msg = "Network Error!";
      setState(() {});
    }
  }

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    reset();

    String? videoUrl;
    videowo = false;

    if (!mounted) {
      return;
    }
    setState(() {});

    try {
      final profile = Afpro?['profile'];
      final url = profile?['videoUrl']?['url'];
      // if (url != null && url is String && url.isNotEmpty) {
      videoUrl = url;
      // } else {
      //   videoUrl =
      //       'https://bounten-aws-bucket.s3.ap-south-1.amazonaws.com/samplevideo_1280x720_1mb-1752144184728.mp4';
      // }

      _controller = VideoPlayerController.network(videoUrl!);
      _controller
          .initialize()
          .then((_) {
            videowo = true;
            if (mounted) setState(() {});
          })
          .catchError((error) {
            videowo = false;
            print("Video init error: $error");
            // Fallback or show error UI
          });
    } catch (e) {
      videowo = false;
      print("Exception during video load: $e");
      // Optionally use a fallback
    }
  }

  bool videowo = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    await Future.delayed(Duration(milliseconds: 100));
    if (!mounted) return;
    reset();

    setState(() {});
  }
  // const PersonalInfoPage({super.key});

  File? _pickedImage;
  void _uploadPickedImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      File imageFile = File(picked.path);
      // _pickedImage = File(picked.path);
    }
  }

  Future<void> _showPickOptionsDialog() async {
    final isCamera = await showDialog<bool>(
      context: context,
      builder: (_) => GetPicPage(),
    );
    if (isCamera == null) return;
    _pickImage(isCamera ? ImageSource.camera : ImageSource.gallery);
  }

  final picker = ImagePicker();

  // final _pickedImage;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await picker.pickImage(source: source, maxWidth: 800);
    if (file == null) return;

    int sizeInMB = await file.length() ~/ (1 * 1024);

    if (sizeInMB > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File too large! Max 500KB allowed.")),
      );
      return;
    }

    _pickedImage = File(file.path);
    // _uploadPickedImage();

    if (!mounted) return; // prevents calling setState if widget is disposed

    setState(() {});
  }

  int Links = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Row(
          children: [
            Image.asset('assets/logo2.jpg', height: 40),
            SizedBox(width: 7),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                "${Afpro["profile"]["lead_stage"]}",
                style: TextStyle(fontSize: 11, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        // leading: Builder(
        //   builder: (context) => IconButton(
        //     icon: Icon(Icons.menu),
        //     onPressed: () => Scaffold.of(context).openDrawer(),
        //   ),
        // ),
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
                backgroundImage:
                    (Afpro != null &&
                        Afpro!['profile']?['media']?['url'] != null)
                    ? NetworkImage(Afpro!['profile']['media']['url'])
                          as ImageProvider
                    : AssetImage('assets/avatar.png'),
                radius: 15,
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),

      drawer: AppDrawer(page: 2),

      body: RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Colors.white,
        onRefresh: _refreshData,
        child: ListView(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        // cursorHeight: 100,
                        controller: ctl,
                        readOnly: true,
                        style: TextStyle(color: Colors.blue, fontSize: 16),

                        decoration: InputDecoration(
                          hintText:
                              (Stat == null || Stat["referralLink"] == null)
                              ? 'https://bounten.com/lakshit'
                              : "${Stat["referralLink"]}",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.qr_code, color: adth),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => QrPage(),
                              );
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
            SizedBox(height: 3),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      copyText(
                        (Stat == null || Stat["referralLink"] == null)
                            ? 'https://bounten.com/lakshit'
                            : "${Stat["referralLink"]}",
                      );
                    },
                    child: Card(
                      child: Container(
                        // height: 50,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: adth,
                        ),
                        // width: 160,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.copy, color: Colors.white, size: 20),
                              SizedBox(width: 5),
                              Text(
                                'Copy Link',
                                style: TextStyle(color: Colors.white),
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
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   margin: const EdgeInsets.only(
            //     top: 6.0,
            //     left: 12,
            //     right: 12,
            //     bottom: 8,
            //   ),
            //   // color: Colors.white,
            //   child:
            //   ),
            // ),
            // SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Container(
            //           decoration: BoxDecoration(
            //             // color: Colors.white,

            //             // borderRadius: BorderRadius.circular(15),
            //             // border: Border.all(color: Colors.blue),
            //           ),
            //           child: TextField(
            //             controller: ctl,
            //             readOnly: true,
            //             decoration: InputDecoration(
            //               hintText:
            //                   (Stat == null || Stat["referralLink"] == null)
            //                   ? 'https://bounten.com/lakshit'
            //                   : "${Stat["referralLink"]}",
            //               suffixIcon: IconButton(
            //                 icon: Icon(Icons.qr_code, color: Colors.blue),
            //                 onPressed: () {
            //                   showDialog(
            //                     context: context,
            //                     builder: (context) => QrPage(),
            //                   );
            //                 },
            //               ),
            //               border: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(12),
            //                 borderSide: BorderSide(color: Colors.blue),
            //               ),
            //               hintStyle: TextStyle(color: Colors.blue),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 15),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Card(
            //         child: Container(
            //           width: 160,
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.circular(12),
            //             child: MaterialButton(
            //               color: Colors.blue,
            //               onPressed: () {
            //                 copyText(
            //                   (Stat == null || Stat["referralLink"] == null)
            //                       ? 'https://bounten.com/lakshit'
            //                       : "${Stat["referralLink"]}",
            //                 );
            //               },
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Icon(Icons.copy, color: Colors.white),
            //                   Padding(
            //                     padding: const EdgeInsets.all(15.0),
            //                     child: Text(
            //                       'Copy Link',
            //                       style: TextStyle(color: Colors.white),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       Card(
            //         borderOnForeground: false,
            //         child: Container(
            //           width: 160,

            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(12),
            //             border: Border.all(color: adth),
            //           ),
            //           child: ClipRRect(
            //             borderRadius: BorderRadiusGeometry.circular(12),
            //             child: MaterialButton(
            //               color: Colors.white,
            //               onPressed: () {
            //                 shareImageAndText();
            //               },
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Icon(Icons.share_outlined, color: Colors.blue),
            //                   Padding(
            //                     padding: const EdgeInsets.all(15.0),
            //                     child: Text(
            //                       'Share',
            //                       style: TextStyle(color: Colors.blue),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 5),
            (Afpro == null)
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            (msg == "Loading") ? "" : msg,
                            style: TextStyle(
                              fontSize: 16,
                              color: (msg == "Loading")
                                  ? Colors.black
                                  : Colors.red,
                            ),
                          ),
                          // RefreshProgressIndicator(s),
                          IconButton(
                            onPressed: () {
                              msg = "Loading";
                              process = true;
                              setState(() {});
                              // _getUpdate();
                            },
                            icon: (process)
                                ? RefreshProgressIndicator(color: Colors.blue)
                                : Icon(
                                    Icons.refresh,
                                    size: 28,
                                    color: (msg == "Loading")
                                        ? Colors.black
                                        : Colors.red,
                                  ),
                          ),

                          // Text(
                          //   msg,
                          //   style: TextStyle(
                          //     color: (logi || msg == "Loading")
                          //         ? Colors.green
                          //         : Colors.red,
                          //   ),
                          // ),
                          // IconButton(
                          //   onPressed: () {
                          //     _gettran();
                          //   },
                          //   icon: Icon(
                          //     Icons.refresh,
                          //     color: (logi || msg == "Loading")
                          //         ? Colors.green
                          //         : Colors.red,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 0.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Personal information",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: blacki,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Profile Image",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 4,
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundImage: (_pickedImage != null)
                                      ? FileImage(_pickedImage!)
                                      // ignore: unnecessary_null_comparison
                                      : ((Afpro != null &&
                                                Afpro!['profile']?['media']?['url'] !=
                                                    null)
                                            ? NetworkImage(
                                                    Afpro!['profile']['media']['url'],
                                                  )
                                                  as ImageProvider
                                            : AssetImage('assets/avatar.png')),
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 1,
                              right: 1,
                              child: GestureDetector(
                                onTap: () {
                                  _showPickOptionsDialog();
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 20,
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        _buildInputField('First Name', _cntr[0]),
                        // _buildInputField('Last Name', _cntr[1]),
                        _buildInputField('Mobile Number', _cntr[2]),
                        _buildInputField('Email Address', _cntr[3]),
                        _buildInputField('Address', _cntr[4]),
                        SizedBox(height: 20),
                        Divider(
                          height: 1,
                          color: const Color.fromARGB(255, 211, 211, 211),
                        ),
                        SizedBox(height: 17),

                        Container(
                          child: Text(
                            "Social Media Links",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: blacki,
                            ),
                          ),
                        ),

                        // const SizedBox(height: 10),
                        _buildInputField('Facebook', _cntr[5]),
                        _buildInputField('Instagram', _cntr[6]),
                        _buildInputField('Youtube', _cntr[7]),

                        for (int i = 0; i < Links; i++)
                          _buildInputField2(
                            i + 1,
                            'Additional Link ${i + 1}',
                            _cntr[i + 8],
                          ),

                        Row(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (Links != 5)
                              GestureDetector(
                                onTap: () {
                                  if (Links < 5) {
                                    Links++;
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  child: Text(
                                    "Add More Links (${5 - Links}/5)",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: blacki),
                                  ),
                                ),
                              ),
                            SizedBox(width: 5),
                            // if (Links != 0)
                            //   GestureDetector(
                            //     onTap: () {

                            //     },
                            //     child: Container(
                            //       child: Text(
                            //         "x Delete Link",
                            //         textAlign: TextAlign.end,
                            //         style: TextStyle(color: Colors.red),
                            //       ),
                            //     ),
                            //   ),
                          ],
                        ),

                        SizedBox(height: 20),
                        Divider(
                          height: 1,
                          color: const Color.fromARGB(255, 211, 211, 211),
                        ),
                        SizedBox(height: 17),

                        Container(
                          child: Text(
                            "Upload Video",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: blacki,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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

                                      // height: 180,
                                      width: double.infinity,
                                      child:
                                          (Afpro != null &&
                                              Afpro['profile']['videoUrl'] !=
                                                  null &&
                                              Afpro['profile']['videoUrl']['url'] !=
                                                  null)
                                          ? Padding(
                                              padding: const EdgeInsets.all(
                                                3.0,
                                              ),
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      // setState(() {});
                                                      if (Afpro['profile']['VideoId'] !=
                                                          null)
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) => Dialog(
                                                            insetAnimationDuration:
                                                                Duration(
                                                                  seconds: 3,
                                                                ),
                                                            insetAnimationCurve:
                                                                Curves
                                                                    .easeInBack,
                                                            backgroundColor:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    25,
                                                                  ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                    20,
                                                                  ),
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Navigator.pop(
                                                                          context,
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.symmetric(
                                                                              horizontal: 5.0,
                                                                            ),
                                                                            child: Icon(
                                                                              Icons.cancel,
                                                                              size: 30,
                                                                              color: Colors.blue, // const Color.fromARGB(255, 111, 110, 110),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      "Are you sure, Delete Video??",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            19,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),

                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),

                                                                    // QrImageView(
                                                                    //   data: '${Stat["referralLink"]}',
                                                                    //   size: 200,
                                                                    //   version: QrVersions.auto,
                                                                    // ),

                                                                    // // Icon(Icons.image),
                                                                    // SizedBox(height: 25),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10.0,
                                                                      ),
                                                                      child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Card(
                                                                            child: Container(
                                                                              width: 220,
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  12,
                                                                                ),
                                                                                child: MaterialButton(
                                                                                  color: adth,
                                                                                  onPressed: () {
                                                                                    Navigator.pop(
                                                                                      context,
                                                                                    );
                                                                                  },
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(
                                                                                          15.0,
                                                                                        ),
                                                                                        child: Text(
                                                                                          'No',
                                                                                          style: TextStyle(
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Card(
                                                                            borderOnForeground:
                                                                                false,
                                                                            child: Container(
                                                                              width: 220,

                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  12,
                                                                                ),
                                                                                border: Border.all(
                                                                                  color: adth,
                                                                                ),
                                                                              ),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadiusGeometry.circular(
                                                                                  12,
                                                                                ),
                                                                                child: MaterialButton(
                                                                                  color: Colors.white,
                                                                                  onPressed: () {
                                                                                    // confirmdel = true;
                                                                                    // setS
                                                                                    msg = "Video Deleting..";
                                                                                    process = true;

                                                                                    if (!mounted) return;
                                                                                    setState(
                                                                                      () {},
                                                                                    );
                                                                                    vide = -1;
                                                                                    _getUpdate();
                                                                                    Navigator.pop(
                                                                                      context,
                                                                                    );
                                                                                  },
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(
                                                                                          15.0,
                                                                                        ),
                                                                                        child: Text(
                                                                                          'Yes',
                                                                                          style: TextStyle(
                                                                                            color: adth,
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
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );

                                                      // if (Afpro['profile']['VideoId'] ==
                                                      //     null) {
                                                      //   msg = "deleting";

                                                      //   if (!mounted) return;

                                                      //   _getUpdate();
                                                      // }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Text(
                                                        "❌ Delete Video",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  (Afpro?['profile']?['VideoId'] ==
                                                              null ||
                                                          videowo == false)
                                                      ? Container(
                                                          child: Icon(
                                                            Icons.video_library,

                                                            color: Colors.red,
                                                          ),
                                                        )
                                                      : Row(
                                                          children: [
                                                            // sitioned(
                                                            // bottom: 0,
                                                            // left: 0,
                                                            IconButton(
                                                              onPressed: () {
                                                                if (!mounted)
                                                                  return;
                                                                setState(() {
                                                                  _controller
                                                                          .value
                                                                          .isPlaying
                                                                      ? _controller
                                                                            .pause()
                                                                      : _controller
                                                                            .play();
                                                                });
                                                              },
                                                              icon: Icon(
                                                                _controller
                                                                        .value
                                                                        .isPlaying
                                                                    ? Icons
                                                                          .pause
                                                                    : Icons
                                                                          .play_arrow,
                                                              ),
                                                            ),
                                                            // ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  _controller
                                                                          .value
                                                                          .isPlaying
                                                                      ? _controller
                                                                            .pause()
                                                                      : _controller
                                                                            .play();
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 100,
                                                                width: 120,
                                                                color: Colors
                                                                    .black12,
                                                                child: Stack(
                                                                  // mainAxisAlignment:
                                                                  //     MainAxisAlignment
                                                                  //         .center,
                                                                  children: [
                                                                    // if (_controlsVisible)
                                                                    // Po
                                                                    Center(
                                                                      child:
                                                                          _controller
                                                                              .value
                                                                              .isInitialized
                                                                          ? AspectRatio(
                                                                              aspectRatio: _controller.value.aspectRatio,
                                                                              child: VideoPlayer(
                                                                                _controller,
                                                                              ),
                                                                            )
                                                                          : Icon(
                                                                              Icons.image,
                                                                            ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 20,
                                                          vertical: 10,
                                                        ),
                                                    child: VideoProgressIndicator(
                                                      _controller,
                                                      allowScrubbing: true,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          // videoUrl:,
                                          // )
                                          : GestureDetector(
                                              onTap: () {
                                                if (_videoFile != null) {
                                                  return;
                                                }

                                                pickVideo();
                                              },
                                              child: Container(
                                                color: bg,
                                                padding: EdgeInsets.all(15),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.video_library,
                                                        size: 25,
                                                        color:
                                                            (_videoFile == null)
                                                            ? Colors.grey
                                                            : Colors.blue,
                                                      ),
                                                      SizedBox(height: 8),
                                                      // VideoPlayer(
                                                      //   VideoPlayerController.file(
                                                      //     File(_videoFile!.path),
                                                      //   ),
                                                      // ),
                                                      Text(
                                                        (_videoFile == null)
                                                            ? "Upload Video"
                                                            : "Uploading Video...",
                                                        style: TextStyle(
                                                          color:
                                                              (_videoFile ==
                                                                  null)
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                child: Container(
                                  width: 135,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: MaterialButton(
                                      padding: EdgeInsets.all(0),
                                      color: Colors.blue,
                                      onPressed: () {
                                        logi = true;
                                        msg = "Updating Profile...";
                                        // process = true;
                                        setState(() {});

                                        if (_check()) return;

                                        logi = true;
                                        msg = "Updating Profile...";
                                        process = true;
                                        setState(() {});
                                        if (_pickedImage != null) {
                                          uploadImage(_pickedImage!);
                                        } else if (_videoFile != null) {
                                          uploadVideo();
                                        } else {
                                          _getUpdate();
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 15.0,
                                              horizontal: 5,
                                            ),
                                            child: Text(
                                              'Update Profile',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
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
                                  width: 135,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      12,
                                    ),
                                    border: Border.all(color: Colors.blue),
                                    color: Colors.white,
                                  ),
                                  child: ClipRRect(
                                    child: MaterialButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        // reset();
                                        // setState(() {});

                                        showDialog(
                                          context: context,
                                          builder: (context) => ChangePass(),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 15.0,
                                              horizontal: 5,
                                            ),
                                            child: Text(
                                              'Change Password',
                                              style: TextStyle(
                                                color: Colors.blue,
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

                        Center(
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              Text(
                                msg,
                                style: TextStyle(
                                  color: (!logi) ? Colors.red : Colors.green,
                                ),
                              ),
                              if (process)
                                LinearProgressIndicator(color: Colors.blue),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),
                      ],
                    ),
                  ),
            SizedBox(height: 26),
          ],
        ),
      ),
    );
  }

  _check() {
    bool ret = false;
    bool lk = false;
    if (_cntr[5].text.indexOf("https://") == -1 && _cntr[5].text != "") {
      _cntr[5].clear();
      lk = true;
      // ret = true;
    }
    if (_cntr[6].text.indexOf("https://") == -1 && _cntr[6].text != "") {
      _cntr[6].clear();
      lk = true;
      // ret = true;
    }

    if (_cntr[7].text.indexOf("https://") == -1 && _cntr[7].text != "") {
      _cntr[7].clear;
      lk = true;
      // ret = true;
    }

    for (int i = 0; i < 5; i++) {
      if (_cntr[8 + i].text.indexOf("http") == -1 && _cntr[8 + i].text != "") {
        _cntr[8 + i].clear();
        lk = true;
      }
    }

    if (_cntr[0].text.length < 3) {
      // _cntr[0].clear;
      ret = true;
    }
    if (!(_cntr[2].text.length == 10 &&
        (_cntr[2].text[0] == '6' || _cntr[2].text[0] == '9'))) {
      // _cntr[2].clear;
      ret = true;
    }

    if (_cntr[3].text.length < 5 || _cntr[3].text.indexOf("@") == -1) {
      // _cntr[3].clear;
      ret = true;
    }

    if (_cntr[4].text.length < 3) {
      // _cntr[4].clear;
      ret = true;
    }

    if (ret) {
      logi = false;
      msg =
          '${(_cntr[0].text.length < 3) ? "Name should be more than 3 Characters, " : ""}' +
          '${!(_cntr[2].text.length == 10 && (_cntr[2].text[0] == '6' || _cntr[2].text[0] == '9')) ? "Mobile no should have 10 digits & 6 or 9, " : ""} ' +
          '${(_cntr[3].text.length < 5 || _cntr[3].text.indexOf("@") == -1) ? "Email should be valid," : ""}' +
          '${(_cntr[4].text.length < 3) ? "Address more than 3 Characters, " : ""}' +
          '${(lk) ? "Links should be valid" : ""}' +
          "Try Again!";
      if (!mounted) return;
      setState(() {});
    }

    return ret;
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
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          // : label,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField2(
    int id,
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                if (Links > 0) {
                  if (Links == id) {
                    _cntr[Links - 1 + 8].clear();
                  } else {
                    for (int i = id; i < Links; i++)
                      _cntr[i - 1 + 8].text = _cntr[i + 8].text;
                    _cntr[Links - 1 + 8].clear();
                  }

                  Links--;
                  if (!mounted) return;
                  setState(() {});
                }
              },
              child: Icon(Icons.clear, color: Colors.red, size: 20),
            ),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,

          // hintText: label,
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

// import 'dart:convert';
// import 'dart:io';

// import 'package:bauntan/home/dash.dart';
// import 'package:bauntan/home/earn.dart';
// import 'package:bauntan/home/sipport.dart';
// import 'package:bauntan/home/trans.dart';
// import 'package:bauntan/model/model.dart' hide copyText;
// import 'package:bauntan/other/compo.dart';
// import 'package:bauntan/other/drawer.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as path;
// import 'package:http_parser/http_parser.dart';
// import 'package:video_player/video_player.dart';

// class PersonalInfoPage extends StatefulWidget {
//   const PersonalInfoPage({super.key});

//   @override
//   State<PersonalInfoPage> createState() => _PersonalInfoPageState();
// }

// class _PersonalInfoPageState extends State<PersonalInfoPage> {
//   var _cntr = [
//     TextEditingController(
//       text: "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['name']}",
//     ),
//     TextEditingController(
//       text: "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['name']}",
//     ),
//     TextEditingController(
//       text: "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['phone']}",
//     ),
//     TextEditingController(
//       text: "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['email']}",
//     ),
//     TextEditingController(
//       text:
//           "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['location']}",
//     ),
//   ];

//   File? _videoFile;
//   bool _isUploading = false;

//   Future<void> pickVideo() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.video);

//     if (result != null && result.files.single.path != null) {
//       File file = File(result.files.single.path!);
//       int sizeInMB = await file.length() ~/ (1024 * 1024);

//       if (sizeInMB > 10) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("File too large! Max 10MB allowed.")),
//         );
//         return;
//       }

//       msg = "uploading..";
//       setState(() => _videoFile = file);
//       uploadVideo();
//     }
//   }

//   Future<void> uploadVideo() async {
//     if (_videoFile == null) return;

//     setState(() => _isUploading = true);

//     final uri = Uri.parse("${BASE_URL}/uploads");
//     final request = http.MultipartRequest("POST", uri);

//     request.headers.addAll({
//       'Authorization': 'Bearer $userToken', // Replace this with actual token
//       'Accept': 'application/json',
//     });

//     request.files.add(
//       await http.MultipartFile.fromPath(
//         'file', // Replace with correct field name if needed
//         _videoFile!.path,
//         contentType: MediaType('video', 'mp4'), // adjust if needed
//       ),
//     );

//     try {
//       final response = await request.send();
//       final resBody = await http.Response.fromStream(response);

//       if (response.statusCode == 200) {
//         print(jsonDecode(resBody.body));
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text("Upload successful!")));

//         Afpro['profile']['VideoId'] = jsonDecode(resBody.body)[0]['id'];
//         msg = "Upload successful!";

//         print(jsonDecode(resBody.body)[0]['id']);

//         if (!mounted) return;

//         setState(() {});

//         if (!mounted) return;
//         _videoFile = null;
//         _getUpdate();
//       } else {
//         _videoFile = null;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Upload failed: ${resBody.statusCode}")),
//         );
//         msg = "Upload Failed!";
//         setState(() {});
//       }
//     } catch (e) {
//       _videoFile = null;
//       msg = "Network error!";
//       setState(() {});
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     }

//     setState(() => _isUploading = false);
//   }

//   reset() {
//     _cntr = [
//       TextEditingController(
//         text:
//             "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['name']}",
//       ),
//       TextEditingController(
//         text:
//             "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['name']}",
//       ),
//       TextEditingController(
//         text:
//             "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['phone']}",
//       ),
//       TextEditingController(
//         text:
//             "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['email']}",
//       ),
//       TextEditingController(
//         text:
//             "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['location']}",
//       ),
//     ];
//   }

//   String msg = "";
//   bool logi = false;
//   var vide = 738;

//   Future<void> _getUpdate() async {
//     try {
//       final res = await http.put(
//         Uri.parse("${BASE_URL}/affiliate/profile/37"),

//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer ${userToken}',
//         },
//         body: jsonEncode(<String, dynamic>{
//           // "email": "${emailc.text}",
//           // "password": "${passc.text}",
//           // "expectedRole": "Affiliate",
//           "name": "${_cntr[0].text}",
//           "phone": "${_cntr[2].text}",
//           "email": "${_cntr[3].text}",
//           "address": "${_cntr[4].text}",
//           "socialLinks": [],
//           "AvatarId": Afpro['profile']['AvatarId'],
//           "VideoId": (vide == -1) ? null : Afpro['profile']['VideoId'],
//         }),
//       );
//       vide = Afpro['profile']['VideoId'] ?? 667;

//       // https://bountenapi.socialseller.in/api/affiliate/transactions/37?pagination[page]=1&pagination[pageSize]=5

//       if (res.statusCode == 200) {
//         print(jsonDecode(res.body));

//         // Perfo = jsonDecode(res.body);

//         g1 = true;

//         final res11 = await http.get(
//           Uri.parse("${BASE_URL}/affiliate/profile"),

//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//             'Authorization': 'Bearer ${userToken}',
//           },
//         );

//         // https://bountenapi.socialseller.in/api/affiliate/transactions/37?pagination[page]=1&pagination[pageSize]=5

//         if (res11.statusCode == 200) {
//           print(jsonDecode(res11.body));

//           Afpro = jsonDecode(res11.body);

//           g1 = true;
//           reset();

//           if (!mounted) return;
//           _videoFile = null;

//           msg = "saved successfully!";
//           logi = true;
//           String? videoUrl;

//           try {
//             final profile = Afpro?['profile'];
//             final url = profile?['videoUrl']?['url'];

//             videoUrl = url;

//             _controller = VideoPlayerController.network(videoUrl!);
//             _controller
//                 .initialize()
//                 .then((_) {
//                   videowo = true;
//                   if (mounted) setState(() {});
//                 })
//                 .catchError((error) {
//                   videowo = false;
//                   print("Video init error: $error");
//                   // Fallback or show error UI
//                 });
//           } catch (e) {
//             videowo = false;
//             print("Exception during video load: $e");
//             // Optionally use a fallback
//           }

//           // if (!mounted) return;

//           // setState(() {});/
//         } else {
//           print("nndnndndnnd");
//           if (!mounted) return;
//           logi = false;
//           msg = "Fetching server Error!";
//           setState(() {});
//         }

//         // }
//       } else {
//         print("nndnndndnnd");
//         if (!mounted) return;
//         msg = "Fetching Server Error!";
//         logi = false;
//         setState(() {});
//       }
//     } catch (e) {
//       print(e);
//       if (!mounted) return;
//       logi = false;
//       msg = "Network Error!";
//       setState(() {});
//     }
//   }

//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     String? videoUrl;

//     try {
//       final profile = Afpro?['profile'];
//       final url = profile?['videoUrl']?['url'];
//       if (url != null && url is String && url.isNotEmpty) {
//         videoUrl = url;
//       } else {
//         videoUrl =
//             'https://bounten-aws-bucket.s3.ap-south-1.amazonaws.com/samplevideo_1280x720_1mb-1752144184728.mp4';
//       }

//       _controller = VideoPlayerController.network(videoUrl!);
//       _controller
//           .initialize()
//           .then((_) {
//             videowo = true;
//             if (mounted) setState(() {});
//           })
//           .catchError((error) {
//             videowo = false;
//             print("Video init error: $error");
//             // Fallback or show error UI
//           });
//     } catch (e) {
//       videowo = false;
//       print("Exception during video load: $e");
//       // Optionally use a fallback
//     }
//   }

//   bool videowo = false;

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _refreshData() async {
//     if (!mounted) return;
//     await Future.delayed(Duration(milliseconds: 100));
//     if (!mounted) return;
//     reset();

//     setState(() {});
//   }
//   // const PersonalInfoPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bg,
//       appBar: AppBar(
//         surfaceTintColor: Colors.white,
//         title: Image.asset('assets/logo2.jpg', height: 40),
//         backgroundColor: Colors.white,
//         // leading: Builder(
//         //   builder: (context) => IconButton(
//         //     icon: Icon(Icons.menu),
//         //     onPressed: () => Scaffold.of(context).openDrawer(),
//         //   ),
//         // ),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               showDialog(context: context, builder: (context) => LogoutPage());
//               // LogoutPage();
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: const Color.from(
//                     alpha: 1,
//                     red: 0.416,
//                     green: 0.624,
//                     blue: 0.988,
//                   ),
//                   width: 3,
//                 ),
//                 borderRadius: BorderRadius.circular(30),
//               ),

//               child: CircleAvatar(
//                 backgroundImage:
//                     (Afpro != null &&
//                         Afpro!['profile']?['media']?['url'] != null)
//                     ? NetworkImage(Afpro!['profile']['media']['url'])
//                           as ImageProvider
//                     : AssetImage('assets/avatar.png'),
//                 radius: 15,
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//         ],
//       ),

//       drawer: AppDrawer(page: 2),

//       body: RefreshIndicator(
//         onRefresh: _refreshData,
//         child: ListView(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               margin: const EdgeInsets.all(16.0),
//               // color: Colors.white,
//               child: ListTile(
//                 title: Text(
//                   "Personal information",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
//                 ),
//               ),
//             ),
//             // SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         // color: Colors.white,

//                         // borderRadius: BorderRadius.circular(15),
//                         // border: Border.all(color: Colors.blue),
//                       ),
//                       child: TextField(
//                         controller: ctl,
//                         readOnly: true,
//                         decoration: InputDecoration(
//                           hintText:
//                               (Stat == null || Stat["referralLink"] == null)
//                               ? 'https://bounten.com/lakshit'
//                               : "${Stat["referralLink"]}",
//                           suffixIcon: IconButton(
//                             icon: Icon(Icons.qr_code, color: Colors.blue),
//                             onPressed: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (context) => QrPage(),
//                               );
//                             },
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                           hintStyle: TextStyle(color: Colors.blue),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 15),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Card(
//                     child: Container(
//                       width: 160,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: MaterialButton(
//                           color: Colors.blue,
//                           onPressed: () {
//                             copyText(
//                               (Stat == null || Stat["referralLink"] == null)
//                                   ? 'https://bounten.com/lakshit'
//                                   : "${Stat["referralLink"]}",
//                             );
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.copy, color: Colors.white),
//                               Padding(
//                                 padding: const EdgeInsets.all(15.0),
//                                 child: Text(
//                                   'Copy Link',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Card(
//                     borderOnForeground: false,
//                     child: Container(
//                       width: 160,

//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: adth),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadiusGeometry.circular(12),
//                         child: MaterialButton(
//                           color: Colors.white,
//                           onPressed: () {
//                             shareImageAndText();
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.share_outlined, color: Colors.blue),
//                               Padding(
//                                 padding: const EdgeInsets.all(15.0),
//                                 child: Text(
//                                   'Share',
//                                   style: TextStyle(color: Colors.blue),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 5),
//             Container(
//               padding: EdgeInsets.all(20),
//               margin: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(18),
//                 color: Colors.white,
//                 border: Border.all(color: Colors.grey, width: 0.2),
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 0),

//                   _buildInputField('First Name', _cntr[0]),
//                   // _buildInputField('Last Name', _cntr[1]),
//                   _buildInputField('Mobile Number', _cntr[2]),
//                   _buildInputField('Email Address', _cntr[3]),
//                   _buildInputField('Address', _cntr[4]),
//                   SizedBox(height: 10),

//                   Container(
//                     padding: EdgeInsets.all(16),
//                     // margin: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.white,
//                       border: Border.all(color: Colors.black, width: 0.5),
//                     ),
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 10),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 10.0),
//                           child: Row(
//                             children: [
//                               Text(
//                                 textAlign: TextAlign.start,
//                                 "Upload Video",
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Container(
//                           margin: EdgeInsets.symmetric(horizontal: 20),
//                           padding: const EdgeInsets.all(18.0),
//                           child: GestureDetector(
//                             onTap: () {},
//                             child: DottedBorder(
//                               borderType: BorderType.RRect,
//                               radius: Radius.circular(12),
//                               color: Colors.blue,
//                               child: Container(
//                                 color: bg,

//                                 // height: 180,
//                                 width: double.infinity,
//                                 child:
//                                     (Afpro != null &&
//                                         Afpro['profile']['videoUrl'] != null &&
//                                         Afpro['profile']['videoUrl']['url'] !=
//                                             null)
//                                     ? Padding(
//                                         padding: const EdgeInsets.all(3.0),
//                                         child: Column(
//                                           children: [
//                                             GestureDetector(
//                                               onTap: () {
//                                                 // setState(() {});
//                                                 if (Afpro['profile']['VideoId'] !=
//                                                     null)
//                                                   showDialog(
//                                                     context: context,
//                                                     builder: (context) => Dialog(
//                                                       insetAnimationDuration:
//                                                           Duration(seconds: 3),
//                                                       insetAnimationCurve:
//                                                           Curves.easeInBack,
//                                                       backgroundColor:
//                                                           Colors.white,
//                                                       shape: RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                               25,
//                                                             ),
//                                                       ),
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets.all(
//                                                               20,
//                                                             ),
//                                                         child: SingleChildScrollView(
//                                                           child: Column(
//                                                             mainAxisSize:
//                                                                 MainAxisSize
//                                                                     .min,
//                                                             children: [
//                                                               GestureDetector(
//                                                                 onTap: () {
//                                                                   Navigator.pop(
//                                                                     context,
//                                                                   );
//                                                                 },
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .end,
//                                                                   children: [
//                                                                     Padding(
//                                                                       padding: const EdgeInsets.symmetric(
//                                                                         horizontal:
//                                                                             5.0,
//                                                                       ),
//                                                                       child: Icon(
//                                                                         Icons
//                                                                             .cancel,
//                                                                         size:
//                                                                             30,
//                                                                         color: Colors
//                                                                             .blue, // const Color.fromARGB(255, 111, 110, 110),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 10,
//                                                               ),
//                                                               Text(
//                                                                 "Are you sure, Delete Video??",
//                                                                 textAlign:
//                                                                     TextAlign
//                                                                         .left,
//                                                                 style: TextStyle(
//                                                                   fontSize: 19,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                 ),
//                                                               ),

//                                                               SizedBox(
//                                                                 height: 15,
//                                                               ),

//                                                               // QrImageView(
//                                                               //   data: '${Stat["referralLink"]}',
//                                                               //   size: 200,
//                                                               //   version: QrVersions.auto,
//                                                               // ),

//                                                               // // Icon(Icons.image),
//                                                               // SizedBox(height: 25),
//                                                               Padding(
//                                                                 padding:
//                                                                     const EdgeInsets.symmetric(
//                                                                       horizontal:
//                                                                           10.0,
//                                                                     ),
//                                                                 child: Column(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .spaceBetween,
//                                                                   children: [
//                                                                     Card(
//                                                                       child: Container(
//                                                                         width:
//                                                                             220,
//                                                                         child: ClipRRect(
//                                                                           borderRadius: BorderRadius.circular(
//                                                                             12,
//                                                                           ),
//                                                                           child: MaterialButton(
//                                                                             color:
//                                                                                 adth,
//                                                                             onPressed: () {
//                                                                               Navigator.pop(
//                                                                                 context,
//                                                                               );
//                                                                             },
//                                                                             child: Row(
//                                                                               mainAxisAlignment: MainAxisAlignment.center,
//                                                                               children: [
//                                                                                 Padding(
//                                                                                   padding: const EdgeInsets.all(
//                                                                                     15.0,
//                                                                                   ),
//                                                                                   child: Text(
//                                                                                     'No',
//                                                                                     style: TextStyle(
//                                                                                       color: Colors.white,
//                                                                                     ),
//                                                                                   ),
//                                                                                 ),
//                                                                               ],
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                     Card(
//                                                                       borderOnForeground:
//                                                                           false,
//                                                                       child: Container(
//                                                                         width:
//                                                                             220,

//                                                                         decoration: BoxDecoration(
//                                                                           borderRadius: BorderRadius.circular(
//                                                                             12,
//                                                                           ),
//                                                                           border: Border.all(
//                                                                             color:
//                                                                                 adth,
//                                                                           ),
//                                                                         ),
//                                                                         child: ClipRRect(
//                                                                           borderRadius: BorderRadiusGeometry.circular(
//                                                                             12,
//                                                                           ),
//                                                                           child: MaterialButton(
//                                                                             color:
//                                                                                 Colors.white,
//                                                                             onPressed: () {
//                                                                               // confirmdel = true;
//                                                                               // setS
//                                                                               msg = "deleting";

//                                                                               if (!mounted)
//                                                                                 return;
//                                                                               setState(
//                                                                                 () {},
//                                                                               );
//                                                                               vide = -1;
//                                                                               _getUpdate();
//                                                                               Navigator.pop(
//                                                                                 context,
//                                                                               );
//                                                                             },
//                                                                             child: Row(
//                                                                               mainAxisAlignment: MainAxisAlignment.center,
//                                                                               children: [
//                                                                                 Padding(
//                                                                                   padding: const EdgeInsets.all(
//                                                                                     15.0,
//                                                                                   ),
//                                                                                   child: Text(
//                                                                                     'Yes',
//                                                                                     style: TextStyle(
//                                                                                       color: adth,
//                                                                                     ),
//                                                                                   ),
//                                                                                 ),
//                                                                               ],
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   );

//                                                 // if (Afpro['profile']['VideoId'] ==
//                                                 //     null) {
//                                                 //   msg = "deleting";

//                                                 //   if (!mounted) return;

//                                                 //   _getUpdate();
//                                                 // }
//                                               },
//                                               child: Padding(
//                                                 padding: const EdgeInsets.all(
//                                                   8.0,
//                                                 ),
//                                                 child: Text(
//                                                   "X Delete Video",
//                                                   textAlign: TextAlign.start,
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             (Afpro?['profile']?['VideoId'] ==
//                                                         null ||
//                                                     videowo == false)
//                                                 ? Container(
//                                                     child: Text(
//                                                       "error loading video",
//                                                       style: TextStyle(
//                                                         color: Colors.red,
//                                                       ),
//                                                     ),
//                                                   )
//                                                 : Row(
//                                                     children: [
//                                                       // sitioned(
//                                                       // bottom: 0,
//                                                       // left: 0,
//                                                       IconButton(
//                                                         onPressed: () {
//                                                           setState(() {
//                                                             _controller
//                                                                     .value
//                                                                     .isPlaying
//                                                                 ? _controller
//                                                                       .pause()
//                                                                 : _controller
//                                                                       .play();
//                                                           });
//                                                         },
//                                                         icon: Icon(
//                                                           _controller
//                                                                   .value
//                                                                   .isPlaying
//                                                               ? Icons.pause
//                                                               : Icons
//                                                                     .play_arrow,
//                                                         ),
//                                                       ),
//                                                       // ),
//                                                       GestureDetector(
//                                                         onTap: () {
//                                                           setState(() {
//                                                             _controller
//                                                                     .value
//                                                                     .isPlaying
//                                                                 ? _controller
//                                                                       .pause()
//                                                                 : _controller
//                                                                       .play();
//                                                           });
//                                                         },
//                                                         child: Container(
//                                                           height: 100,
//                                                           width: 120,
//                                                           color: Colors.black12,
//                                                           child: Stack(
//                                                             // mainAxisAlignment:
//                                                             //     MainAxisAlignment
//                                                             //         .center,
//                                                             children: [
//                                                               // if (_controlsVisible)
//                                                               // Po
//                                                               Center(
//                                                                 child:
//                                                                     _controller
//                                                                         .value
//                                                                         .isInitialized
//                                                                     ? AspectRatio(
//                                                                         aspectRatio: _controller
//                                                                             .value
//                                                                             .aspectRatio,
//                                                                         child: VideoPlayer(
//                                                                           _controller,
//                                                                         ),
//                                                                       )
//                                                                     : Icon(
//                                                                         Icons
//                                                                             .image,
//                                                                       ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),

//                                             Container(
//                                               margin: EdgeInsets.symmetric(
//                                                 horizontal: 20,
//                                                 vertical: 10,
//                                               ),
//                                               child: VideoProgressIndicator(
//                                                 _controller,
//                                                 allowScrubbing: true,
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: 10,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     // videoUrl:,
//                                     // )
//                                     : GestureDetector(
//                                         onTap: () {
//                                           if (_videoFile != null) {
//                                             return;
//                                           }

//                                           pickVideo();
//                                         },
//                                         child: Container(
//                                           color: bg,
//                                           child: Center(
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Icon(
//                                                   Icons.video_library,
//                                                   size: 35,
//                                                   color: (_videoFile == null)
//                                                       ? Colors.grey
//                                                       : Colors.blue,
//                                                 ),
//                                                 SizedBox(height: 8),
//                                                 // VideoPlayer(
//                                                 //   VideoPlayerController.file(
//                                                 //     File(_videoFile!.path),
//                                                 //   ),
//                                                 // ),
//                                                 Text(
//                                                   (_videoFile == null)
//                                                       ? "Upload Video"
//                                                       : "Uploading Video...",
//                                                   style: TextStyle(
//                                                     color: (_videoFile == null)
//                                                         ? Colors.grey
//                                                         : Colors.blue,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                       ],
//                     ),
//                   ),

//                   SizedBox(height: 45),

//                   // const SizedBox(height: 20),
//                   const SizedBox(height: 0),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 0.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Card(
//                           borderOnForeground: false,
//                           child: Container(
//                             width: 135,

//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadiusGeometry.circular(12),
//                               border: Border.all(color: Colors.blue),
//                               color: Colors.white,
//                             ),
//                             child: ClipRRect(
//                               child: MaterialButton(
//                                 padding: EdgeInsets.all(0),
//                                 onPressed: () {
//                                   // reset();
//                                   // setState(() {});

//                                   showDialog(
//                                     context: context,
//                                     builder: (context) => ChangePass(),
//                                   );
//                                 },
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         vertical: 15.0,
//                                         horizontal: 5,
//                                       ),
//                                       child: Text(
//                                         'Change Password',
//                                         style: TextStyle(color: Colors.blue),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Card(
//                           child: Container(
//                             width: 135,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: MaterialButton(
//                                 padding: EdgeInsets.all(0),
//                                 color: Colors.blue,
//                                 onPressed: () {
//                                   logi = true;
//                                   msg = "saving";
//                                   setState(() {});
//                                   if (_videoFile != null) {
//                                     uploadVideo();
//                                   } else {
//                                     _getUpdate();
//                                   }
//                                 },
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         vertical: 15.0,
//                                         horizontal: 5,
//                                       ),
//                                       child: Text(
//                                         'Save Changes',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(
//                         msg,
//                         style: TextStyle(
//                           color: (!logi) ? Colors.red : Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField(
//     String label,
//     TextEditingController controller, {
//     int maxLines = 1,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
//         SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTextField(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 0.0),
//       child: Column(
//         children: [
//           SizedBox(height: 5),
//           Row(
//             children: [
//               Text(
//                 label,
//                 textAlign: TextAlign.left,
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           SizedBox(height: 5),
//           TextFormField(
//             initialValue: value,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(13),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
