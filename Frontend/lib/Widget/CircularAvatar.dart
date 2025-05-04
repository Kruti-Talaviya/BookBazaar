
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class UpdateAvatar extends StatefulWidget {
  final double radius;
  final bool enableImagePicking;
  final void Function(String? pickedImageUrl) onImagePicked;
  final String? initialImageUrl; // Add the initial image URL

  const UpdateAvatar({
    Key? key,
    required this.radius,
    required this.enableImagePicking,
    required this.onImagePicked,
    this.initialImageUrl, // Optional initial image URL
  }) : super(key: key);

  @override
  _UpdateAvatarState createState() => _UpdateAvatarState();
}

class _UpdateAvatarState extends State<UpdateAvatar> {
  File? _imageFile;

  // Pick Image from gallery or camera
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _cropImage(pickedFile.path);
    }
  }

  // Crop the selected image
  Future<void> _cropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.5), // Square aspect ratio
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Adjust Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'Adjust Image',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _imageFile = File(croppedFile.path);
        widget.onImagePicked(_imageFile!.path); // Call the callback to pass the image URL
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider backgroundImage;

    // Determine the background image
    if (_imageFile != null) {
      backgroundImage = FileImage(_imageFile!); // If an image is picked, use it
    } else if (widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty) {
      backgroundImage = NetworkImage(widget.initialImageUrl!); // Use the provided initial URL
    } else {
      backgroundImage = const AssetImage('assets/images/default.png'); // Fallback default image
    }

    return
       Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: widget.radius,
                backgroundImage: backgroundImage,
              ),
              // Display add photo icon only if no initial image and no image is picked
              if (widget.enableImagePicking && (_imageFile == null && (widget.initialImageUrl == null || widget.initialImageUrl!.isEmpty)))
                Positioned(
                  bottom: 0,
                  left: 80,
                  child: InkWell(
                    onTap: _pickImage, // Allow user to pick image when tapped
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],

    );
  }
}

