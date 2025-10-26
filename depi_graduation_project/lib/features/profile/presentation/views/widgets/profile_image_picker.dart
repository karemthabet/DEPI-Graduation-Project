import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  const ProfileImagePicker({super.key});

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? imageFile;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => imageFile = File(pickedFile.path));
    }
  }

  void showPickOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a Photo'),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Remove Photo'),
            onTap: () {
              Navigator.pop(context);
              setState(() => imageFile = null);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: imageFile == null
              ? const AssetImage('assets/images/profile.png')
              : FileImage(imageFile!) as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: InkWell(
            onTap: () => showPickOptions(context),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.camera_alt_outlined, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
