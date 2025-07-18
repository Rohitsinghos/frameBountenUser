import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

Color bg = const Color.fromARGB(255, 238, 248, 252); // Colors.blue.shade50;
Color adth = Colors.blue;
Color adthAccent = Colors.blueAccent;

String BASE_URL = "https://bountenapi.socialseller.in/api";

Map<String, dynamic> loginData = {};

String userToken = "";

// "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NDAsImlhdCI6MTc1MjY1ODI0MiwiZXhwIjoxNzUzMjYzMDQyfQ.DwCwjV4pWRV2OGY4h5XJ6csD-dqwNkwdjcYG6A30E2Q";

bool g1 = false, g2 = false, g3 = false, g4 = false;

Map<String, dynamic> Afpro = {};
Map<String, dynamic> Trans = {};

Map<String, dynamic> Afpro5 = {};

Map<String, dynamic> Stat = {};

Map<String, dynamic> Perfo = {};

final ctl = TextEditingController();

void copyText(String text) {
  Clipboard.setData(ClipboardData(text: text));
  print("✅ Text copied: $text");
}

Future<void> shareImageAndText() async {
  // 1. Load image from assets or network (here: from assets)
  // final byteData = await rootBundle.load('assets/logo.jpg');

  // // 2. Save it to a temporary file
  // final tempDir = await getTemporaryDirectory();
  // final file = File('${tempDir.path}/shared_image.jpg');
  // await file.writeAsBytes(byteData.buffer.asUint8List());

  // 3. Share the image and text
  await Share.share(
    '${(Stat == null || Stat["referralLink"] == null) ? "https://bounten.com/lakshit" : "${Stat["referralLink"]}"}',
  );
}
