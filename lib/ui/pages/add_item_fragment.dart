import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/image_compress.dart';

class AddItemFragment extends StatefulWidget {
  const AddItemFragment({super.key});

  @override
  State<AddItemFragment> createState() => _AddItemFragmentState();
}

class _AddItemFragmentState extends State<AddItemFragment> {
  File? _image;
  String imageUrlForProfile = "https://www.laneige.com/int/en/skincare/__icsFiles/afieldfile/2024/11/13/241107_final_INT_Gel_cleanser_Thumbnail_500x600_01.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child : GestureDetector(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                        if (file != null) {
                          // Compress the image
                          File? compressFile = await compressAndGetFile(File(file.path), file.path,96);

                          // Update the state with the compressed file
                          if (compressFile != null) {
                            setState(() {
                              _image = compressFile;
                            });
                          }
                        }
                      },
                      child: (_image == null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                imageUrlForProfile,
                                width: MediaQuery.of(context).size.width * 0.28,
                                height: MediaQuery.of(context).size.height * 0.13,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'lib/icons/add_photo.png',
                                    width: MediaQuery.of(context).size.width * 0.22,
                                    height: MediaQuery.of(context).size.height * 0.15,
                                    fit: BoxFit.contain,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  );
                                },
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return const Center(
                                    child: SizedBox(height: 90, child: CircularProgressIndicator()),
                                  );
                                },
                              )
                          )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                _image!,
                                width: MediaQuery.of(context).size.width * 0.28,
                                height: MediaQuery.of(context).size.height * 0.15,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                  return const Center(
                                      child: SizedBox(height: 90, width: 90, child: CircularProgressIndicator(color: Colors.blue))
                                  );
                                },
                              )
                          )
                  )
              ),
            ),
          ],
        ),
      )
    );
  }
}
