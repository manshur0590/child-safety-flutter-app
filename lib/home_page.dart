import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import 'create_profile.dart';
import 'check_kin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _bgController;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String _currentVideo = 'assets/videos/bg_ani_1.mp4';

  @override
  void initState() {
    super.initState();
    _initializeVideo(_currentVideo);
  }

  void _initializeVideo(String assetPath) async {
    _bgController = VideoPlayerController.asset(assetPath);
    await _bgController.initialize();
    _bgController.setLooping(true);
    _bgController.setVolume(0);
    _bgController.play();
    setState(() {});
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  void _logout() => FirebaseAuth.instance.signOut();

  void _showSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _createProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateProfilePage()),
    );
  }

  void _checkKinship() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CheckKinPage()),
    );
  }

  void _switchVideo(String assetPath) async {
    await _bgController.pause();
    await _bgController.dispose();
    _initializeVideo(assetPath);
    _showSnackBar("Switched video background.");
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Kin Recognition'),
          backgroundColor: Colors.deepPurple.shade700.withOpacity(0.8),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu),
              onSelected: (value) {
                if (value == 'logout') {
                  _logout();
                } else if (value == 'profile' || value == 'settings') {
                  _showSnackBar('$value clicked.');
                } else if (value == 'video1') {
                  _switchVideo('assets/videos/bg_ani_1.mp4');
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'profile', child: Text('👤 Profile')),
                const PopupMenuItem(value: 'settings', child: Text('⚙️ Settings')),
                const PopupMenuItem(value: 'logout', child: Text('🚪 Logout')),
                const PopupMenuDivider(),
              ],
            ),
          ],
        ),
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
              )
            else
              const Center(child: CircularProgressIndicator()),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      ' Welcome to\nKin Recognition System',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1.2,
                        shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: Colors.white.withOpacity(0.85),
                      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      elevation: 12,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Column(
                            children: [
                              const Text(
                                'Main Actions',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: _createProfile,
                                icon: const Icon(Icons.person_add),
                                label: const Text('Create Profile'),
                                style: _smallButtonStyle(),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: _checkKinship,
                                icon: const Icon(Icons.search),
                                label: const Text('Check Kinship'),
                                style: _smallButtonStyle(),
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
          ],
        ),
      ),
    );
  }

  ButtonStyle _smallButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      minimumSize: const Size(150, 40),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
