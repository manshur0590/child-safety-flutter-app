import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  XFile? _parentImage;
  XFile? _childImage;
  final ImagePicker _picker = ImagePicker();
  late VideoPlayerController _bgController;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _parentPhoneController = TextEditingController();
  final TextEditingController _parentAddressController = TextEditingController();
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _childAgeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bgController = VideoPlayerController.asset('assets/videos/bg_ani.mp4')
      ..initialize().then((_) {
        _bgController.setLooping(true);
        _bgController.setVolume(0);
        _bgController.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isParent) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isParent) {
          _parentImage = pickedFile;
        } else {
          _childImage = pickedFile;
        }
      });
    }
  }

  void _submitProfile() {
    if (_formKey.currentState!.validate()) {
      // Save data logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile created successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          if (_bgController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _bgController.value.size.width,
                  height: _bgController.value.size.height,
                  child: VideoPlayer(_bgController),
                ),
              ),
            ),
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Card(
                color: Colors.white.withOpacity(0.10),
                margin: const EdgeInsets.all(200),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '👪 Create Kin Profile',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(true),
                            icon: const Icon(Icons.person),
                            label: const Text('Upload Parent Image'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(false),
                            icon: const Icon(Icons.child_care),
                            label: const Text('Upload Child Image'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(_parentNameController, 'Parent Name'),
                          const SizedBox(height: 10),
                          _buildTextField(_parentPhoneController, 'Parent Mobile Number',
                              keyboardType: TextInputType.phone),
                          const SizedBox(height: 10),
                          _buildTextField(_parentAddressController, 'Parent Address'),
                          const SizedBox(height: 10),
                          _buildTextField(_childNameController, 'Child Name'),
                          const SizedBox(height: 10),
                          _buildTextField(_childAgeController, 'Child Age',
                              keyboardType: TextInputType.number),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _submitProfile,
                            icon: const Icon(Icons.save),
                            label: const Text('Save Profile'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              textStyle: const TextStyle(fontSize: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? 'Enter $labelText' : null,
    );
  }
}