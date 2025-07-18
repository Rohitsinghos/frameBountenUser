import 'dart:io';
import 'package:bauntan/model/model.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class VideoUploadPage extends StatefulWidget {
  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  File? _videoFile;
  bool _isUploading = false;

  Future<void> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      int sizeInMB = await file.length() ~/ (1024 * 1024);

      if (sizeInMB > 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File too large! Max 50MB allowed.")),
        );
        return;
      }

      setState(() => _videoFile = file);
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Upload successful!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${resBody.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Video")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (_videoFile != null)
              Text("Selected: ${path.basename(_videoFile!.path)}"),
            ElevatedButton(onPressed: pickVideo, child: Text("Pick Video")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : uploadVideo,
              child: _isUploading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Upload Video"),
            ),
          ],
        ),
      ),
    );
  }
}
