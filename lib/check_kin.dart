import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CheckKinPage extends StatefulWidget {
  const CheckKinPage({super.key});

  @override
  State<CheckKinPage> createState() => _CheckKinPageState();
}

class _CheckKinPageState extends State<CheckKinPage> {
  File? _image;
  String result = 'Result will appear here';

  final ImagePicker _picker = ImagePicker();

  // 📸 Scan via camera
  Future<void> _scanCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        result = '🔍 Running kin recognition...';
      });

      // Simulate processing
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        result = '✅ Match Found! This image is of the child.';
      });

      // TODO: Replace this with ViTMa face recognition logic
    }
  }

  // 📂 Upload from gallery
  Future<void> _uploadFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        result = '🔍 Running kin recognition...';
      });

      // Simulate processing
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        result = '✅ Match Found! This is the parent.';
      });

      // TODO: Replace this with ViTMa face recognition logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Kinship'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Upload or Scan a photo to check kinship:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // 📂 Upload Button
                ElevatedButton.icon(
                  onPressed: _uploadFromGallery,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload from Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(180, 40),
                  ),
                ),
                const SizedBox(height: 10),

                // 📸 Scan Button
                ElevatedButton.icon(
                  onPressed: _scanCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Scan with Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(180, 40),
                  ),
                ),

                const SizedBox(height: 30),

                // 👁️ Show image preview
                if (_image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _image!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 30),
                const Divider(color: Colors.white70),
                const SizedBox(height: 10),

                const Text(
                  'Kinship Result:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    result,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
