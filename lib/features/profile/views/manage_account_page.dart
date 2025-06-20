import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../config/variables.dart';

class ManageAccountPage extends StatefulWidget {
  const ManageAccountPage({super.key});

  @override
  State<ManageAccountPage> createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<String?> getUserProfilePictureLink(String? userId) async {
    String? profilePicLink;
    try {
      DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userProfileSnapshot.exists) {
        profilePicLink = userProfileSnapshot.get('photoUrl') ?? defaultUserPhotoUrl;
      }
    } catch (e) {
      print('Error fetching user profile picture link: $e');
    }
    return profilePicLink;
  }

  Future<void> uploadProfilePicture() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'svg'
      ],
    );
    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      File pickedFile = File(file.path ?? '');

      Reference ref = FirebaseStorage.instance
          .ref()
          .child('user_profile_images')
          .child(user?.uid ?? 'default')
          .child('profile_pic.jpg');

      UploadTask uploadTask = ref.putFile(pickedFile);

      try {
        await uploadTask.whenComplete(() async {
          String imageURL = await ref.getDownloadURL();

          if (user?.uid != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .set({'photoUrl': imageURL});
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Profile picture updated successfully'),
            ),
          );
        });
      } catch (error) {
        print(error);
      }
    }
  }

  Future<void> uploadNetworkProfilePicture(String photoUrl) async {
    try {
      if (user?.uid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .update({'photoUrl': photoUrl});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Profile picture updated successfully from network'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to update profile picture from network: $error'),
        ),
      );
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Modify user crediantials",
        ).tr(),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: FutureBuilder<String?>(
                  future: getUserProfilePictureLink(user?.uid),
                  builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      String? imagePath = snapshot.data;
                      return CircleAvatar(
                        backgroundImage: NetworkImage(imagePath ?? defaultUserPhotoUrl),
                        radius: 50,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: uploadProfilePicture,
                      child: Text("Upload File".tr(), style: kanitStyle),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String networkPhotoUrl = '';
                            return AlertDialog(
                              backgroundColor: Theme.of(context).cardColor,
                              title: const Text('Enter Network Photo URL').tr(),
                              content: TextField(
                                onChanged: (value) {
                                  networkPhotoUrl = value;
                                },
                                decoration: InputDecoration(
                                    hintText: 'URL'
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel').tr(),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Upload').tr(),
                                  onPressed: () {
                                    uploadNetworkProfilePicture(networkPhotoUrl);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Upload Network URL".tr(), style: kanitStyle),
                    ),
                  ),
                ],
              ),


              const SizedBox(
                height: 10,
              ),

              // Email
              Text(
                'Change user email'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(color: Theme.of(context).textTheme.titleLarge!.color!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                      onTap: () {
                        emailController.selection = TextSelection.fromPosition(
                          TextPosition(offset: emailController.text.length),
                        );
                      },
                      onFieldSubmitted: (newEmail) async {
                        if (newEmail != user?.email) {
                          try {
                            await user
                                ?.verifyBeforeUpdateEmail(newEmail ?? '')
                                .onError((error, stackTrace) {
                              print(error);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Email updated successfully').tr(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Failed to update email').tr(),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('It is the same email').tr(),
                            ),
                          );
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Current : ${user?.email ?? "Anonymous".tr()}',
                        hintStyle: kanitStyle,
                        border: InputBorder.none,
                      ),
                      validator: (email) {
                        if (email != null && !EmailValidator.validate(email)) {
                          return "Enter valid email!".tr();
                        } else {
                          return null;
                        }
                      }),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              // Display Name
              Text(
                'Change user display name'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(color: Theme.of(context).textTheme.titleLarge!.color!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                    onFieldSubmitted: (newDisplayName) async {
                      if (newDisplayName != user?.displayName) {
                        try {
                          await user?.updateDisplayName(newDisplayName ?? '');
                          ScaffoldMessenger.of(context).clearSnackBars();

                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                              backgroundColor: Colors.green,
                              content:
                              Text('Display name updated successfully').tr(),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).clearSnackBars();

                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Failed to update display name').tr(),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('It is the same display name').tr(),
                          ),
                        );
                      }
                    },
                    keyboardType: TextInputType.name,
                    controller: fullNameController,
                    decoration: InputDecoration(
                      hintText:
                      'Current : ${user?.displayName ?? "Anonymous".tr()}',
                      hintStyle: kanitStyle,
                      border: InputBorder.none,
                    ),
                    validator: (fullName) {
                      final namePattern = RegExp(r'^[A-Z][a-z]+\s[A-Z][a-z]+$');
                      if (fullName == null || fullName.isEmpty) {
                        return 'Please enter your full name'.tr();
                      } else if (!namePattern.hasMatch(fullName.trim())) {
                        return 'Please enter a valid full name like "Toktar Sultan"'.tr();
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Password
              Text(
                'Change user password'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(color: Theme.of(context).textTheme.titleLarge!.color!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                    // Inside the TextFormField for changing password
                      onFieldSubmitted: (newPassword) async {
                        if (newPassword != null && newPassword.length >= 8) {
                          try {
                            await user?.updatePassword(newPassword);
                            ScaffoldMessenger.of(context).clearSnackBars();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Password updated successfully').tr(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).clearSnackBars();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Failed to update password'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).clearSnackBars();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  'Password must be at least 8 characters'),
                            ),
                          );
                        }
                      },
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'New Password'.tr(),
                        hintStyle: kanitStyle,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value != null && value.length < 8) {
                          return "Password must be 8 chars";
                        } else {
                          return null;
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
