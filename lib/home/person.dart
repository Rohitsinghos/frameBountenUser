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
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:video_player/video_player.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  var _cntr = [
    TextEditingController(
      text: "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['name']}",
    ),
    TextEditingController(
      text: "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['name']}",
    ),
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
  ];

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

      msg = "uploading..";
      setState(() => _videoFile = file);
      uploadVideo();
    }
  }

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

  reset() {
    _cntr = [
      TextEditingController(
        text:
            "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['name']}",
      ),
      TextEditingController(
        text:
            "${(Afpro == null) ? 'Story Kitadake' : Afpro['profile']['name']}",
      ),
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
    ];
  }

  String msg = "";
  bool logi = false;
  var vide = 738;

  Future<void> _getUpdate() async {
    try {
      final res = await http.put(
        Uri.parse("${BASE_URL}/affiliate/profile/37"),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${userToken}',
        },
        body: jsonEncode(<String, dynamic>{
          // "email": "${emailc.text}",
          // "password": "${passc.text}",
          // "expectedRole": "Affiliate",
          "name": "${_cntr[0].text}",
          "phone": "${_cntr[2].text}",
          "email": "${_cntr[3].text}",
          "address": "${_cntr[4].text}",
          "socialLinks": [],
          "AvatarId": Afpro['profile']['AvatarId'],
          "VideoId": (vide == -1) ? null : Afpro['profile']['VideoId'],
        }),
      );
      vide = Afpro['profile']['VideoId'] ?? 667;

      // https://bountenapi.socialseller.in/api/affiliate/transactions/37?pagination[page]=1&pagination[pageSize]=5

      if (res.statusCode == 200) {
        print(jsonDecode(res.body));

        // Perfo = jsonDecode(res.body);

        g1 = true;

        final res11 = await http.get(
          Uri.parse("${BASE_URL}/affiliate/profile"),

          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${userToken}',
          },
        );

        // https://bountenapi.socialseller.in/api/affiliate/transactions/37?pagination[page]=1&pagination[pageSize]=5

        if (res11.statusCode == 200) {
          print(jsonDecode(res11.body));

          Afpro = jsonDecode(res11.body);

          g1 = true;
          reset();

          if (!mounted) return;
          _videoFile = null;

          msg = "saved successfully!";
          logi = true;
          String? videoUrl;

          try {
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

          // if (!mounted) return;

          // setState(() {});/
        } else {
          print("nndnndndnnd");
          if (!mounted) return;
          logi = false;
          msg = "Fetching server Error!";
          setState(() {});
        }

        // }
      } else {
        print("nndnndndnnd");
        if (!mounted) return;
        msg = "Fetching Server Error!";
        logi = false;
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
    String? videoUrl;

    try {
      final profile = Afpro?['profile'];
      final url = profile?['videoUrl']?['url'];
      if (url != null && url is String && url.isNotEmpty) {
        videoUrl = url;
      } else {
        videoUrl =
            'https://bounten-aws-bucket.s3.ap-south-1.amazonaws.com/samplevideo_1280x720_1mb-1752144184728.mp4';
      }

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
                      controller: ctl,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: (Stat == null || Stat["referralLink"] == null)
                            ? 'https://bounten.com/lakshit'
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
                // _buildInputField('Last Name', _cntr[1]),
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

                              // height: 180,
                              width: double.infinity,
                              child:
                                  (Afpro != null &&
                                      Afpro['profile']['videoUrl'] != null &&
                                      Afpro['profile']['videoUrl']['url'] !=
                                          null)
                                  ? Padding(
                                      padding: const EdgeInsets.all(3.0),
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
                                                        Duration(seconds: 3),
                                                    insetAnimationCurve:
                                                        Curves.easeInBack,
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
                                                              MainAxisSize.min,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          5.0,
                                                                    ),
                                                                    child: Icon(
                                                                      Icons
                                                                          .cancel,
                                                                      size: 30,
                                                                      color: Colors
                                                                          .blue, // const Color.fromARGB(255, 111, 110, 110),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              "Are you sure, Delete Video??",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                fontSize: 19,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),

                                                            SizedBox(
                                                              height: 15,
                                                            ),

                                                            // QrImageView(
                                                            //   data: '${Stat["referralLink"]}',
                                                            //   size: 200,
                                                            //   version: QrVersions.auto,
                                                            // ),

                                                            // // Icon(Icons.image),
                                                            // SizedBox(height: 25),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        10.0,
                                                                  ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Card(
                                                                    child: Container(
                                                                      width:
                                                                          220,
                                                                      child: ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              12,
                                                                            ),
                                                                        child: MaterialButton(
                                                                          color:
                                                                              adth,
                                                                          onPressed: () {
                                                                            Navigator.pop(
                                                                              context,
                                                                            );
                                                                          },
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                                                      width:
                                                                          220,

                                                                      decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              12,
                                                                            ),
                                                                        border: Border.all(
                                                                          color:
                                                                              adth,
                                                                        ),
                                                                      ),
                                                                      child: ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadiusGeometry.circular(
                                                                              12,
                                                                            ),
                                                                        child: MaterialButton(
                                                                          color:
                                                                              Colors.white,
                                                                          onPressed: () {
                                                                            // confirmdel = true;
                                                                            // setS
                                                                            msg =
                                                                                "deleting";

                                                                            if (!mounted)
                                                                              return;
                                                                            setState(
                                                                              () {},
                                                                            );
                                                                            vide =
                                                                                -1;
                                                                            _getUpdate();
                                                                            Navigator.pop(
                                                                              context,
                                                                            );
                                                                          },
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Text(
                                                "X Delete Video",
                                                textAlign: TextAlign.start,
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
                                                  child: Text(
                                                    "error loading video",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                )
                                              : Row(
                                                  children: [
                                                    // sitioned(
                                                    // bottom: 0,
                                                    // left: 0,
                                                    IconButton(
                                                      onPressed: () {
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
                                                            ? Icons.pause
                                                            : Icons.play_arrow,
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
                                                        color: Colors.black12,
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
                                                                      aspectRatio: _controller
                                                                          .value
                                                                          .aspectRatio,
                                                                      child: VideoPlayer(
                                                                        _controller,
                                                                      ),
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .image,
                                                                    ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            child: VideoProgressIndicator(
                                              _controller,
                                              allowScrubbing: true,
                                              padding: EdgeInsets.symmetric(
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
                              onPressed: () {
                                // reset();
                                // setState(() {});

                                showDialog(
                                  context: context,
                                  builder: (context) => ChangePass(),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 5,
                                    ),
                                    child: Text(
                                      'Change Password',
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
                              onPressed: () {
                                logi = true;
                                msg = "saving";
                                setState(() {});
                                if (_videoFile != null) {
                                  uploadVideo();
                                } else {
                                  _getUpdate();
                                }
                              },
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
