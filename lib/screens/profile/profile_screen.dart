import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameController.text = user?.name ?? '';
    _emailController.text = user?.email ?? '';
  }

  Future<void> _showChangePasswordDialog() async {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keluar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords tidak cocok')),
                );
                return;
              }

              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              context.read<AuthProvider>()
                  .updatePassword(passwordController.text)
                  .then((success) {
                if (context.mounted) {
                  navigator.pop();
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Password berhasil diperbarui.')),
                  );
                }
              })
                  .catchError((e) {
                if (context.mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              });
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final authProvider = context.read<AuthProvider>();

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      authProvider
          .updatePhoto(File(image.path))
          .then((success) {
        if (context.mounted) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Photo profile berhasil diperbarui.')),
          );
        }
      })
          .catchError((e) {
        if (context.mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEFE),
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Photo
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  child: ClipOval(
                    child: Image.network(
                      context.watch<AuthProvider>().user?.photoUrl ?? 'https://via.placeholder.com/120',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 18,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    onPressed: () => _pickAndUploadImage(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Email Field
            TextFormField(
              controller: _emailController,
              enabled: !Provider.of<AuthProvider>(context).user!.isGoogleUser,
              decoration: InputDecoration(
                labelText: 'Email',
                border: const OutlineInputBorder(),
                helperText: Provider.of<AuthProvider>(context).user!.isGoogleUser
                    ? 'Email tidak dapat diubah untuk akun Google'
                    : null,
              ),
            ),
            const SizedBox(height: 24),

            // Update Profile Button
            ElevatedButton(
              onPressed: () {
                final scaffoldMessenger = ScaffoldMessenger.of(context);

                context.read<AuthProvider>()
                    .updateProfile(_nameController.text, _emailController.text)
                    .then((success) {
                  if (context.mounted) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Profile berhasil diperbarui')),
                    );
                  }
                })
                    .catchError((e) {
                  if (context.mounted) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                });
              },
              child: context.watch<AuthProvider>().isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Update Profile'),
            ),
            const SizedBox(height: 16),

            // Change Password Button
            OutlinedButton(
              onPressed: _showChangePasswordDialog,
              child: const Text('Change Password'),
            ),
            const SizedBox(height: 16),


            // Logout Button
            TextButton(
              onPressed: () {
                final navigator = Navigator.of(context);
                context.read<AuthProvider>().logout().then((_) {
                  if (context.mounted) {
                    navigator.pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginScreen())
                    );
                  }
                }).catchError((e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}