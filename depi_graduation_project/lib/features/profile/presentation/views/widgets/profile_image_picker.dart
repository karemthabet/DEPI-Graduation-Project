import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef ImagePickedCallback = void Function(File? imageFile);

class ProfileImagePicker extends StatefulWidget {
  final ImagePickedCallback onImagePicked;
  final String? initialAvatarUrl;

  const ProfileImagePicker({
    super.key,
    required this.onImagePicked,
    this.initialAvatarUrl,
  });

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
      widget.onImagePicked(imageFile);
    }
  }

  void removeImage() {
    setState(() => imageFile = null);
    widget.onImagePicked(null);
    Navigator.pop(context);
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
            onTap: removeImage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (imageFile != null) {
      imageProvider = FileImage(imageFile!);
    } else if (widget.initialAvatarUrl != null &&
        widget.initialAvatarUrl!.isNotEmpty) {
      imageProvider = NetworkImage(widget.initialAvatarUrl!);
    } else {
      imageProvider = const AssetImage('assets/images/profile.png');
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(radius: 60, backgroundImage: imageProvider),
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
