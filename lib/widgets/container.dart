import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../riverpord/riverpord.dart';

class ContainerWidget extends ConsumerWidget {
  const ContainerWidget({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String title, description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userList = ref.watch(todoData);
    User currentUser = userList.firstWhere(
          (user) => user.title == title && user.description == description,
    );

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xffE5E5E5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 30),
          Row(
            children: [
              InkWell(
                onTap: () {
                  // Handle update button press
                  _showBottomSheetUpdate(context, ref, title, description);
                },
                child: CircleAvatar(child: Icon(Icons.edit_note_outlined,)),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  // Call the removeData method with the current user
                  ref.read(todoData.notifier).removeData(currentUser);
                },
                child: Card(
                  elevation: 10.0,
                    color: Colors.white,
                    child: Icon(Icons.delete,color: Colors.redAccent)),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void _showBottomSheetUpdate(BuildContext context, WidgetRef ref, String title, String description) {
    TextEditingController _contTitle = TextEditingController(text: title);
    TextEditingController _contDescription = TextEditingController(text: description);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 600.0, // Set your desired height here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Let's Update",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              textFormWidget(_contTitle, false, "Enter Title"),
              const SizedBox(height: 16.0),
              textFormWidget(_contDescription, true, "Enter Description"),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: () {
                  // Find the existing user based on title and description
                  var existingUser = ref.read(todoData).firstWhere(
                        (user) => user.title == title && user.description == description,
                    orElse: () => User(title: '', description: ''), // Default if not found
                  );

                  if (_contTitle.text.length > 0 && _contDescription.text.length > 0) {
                    if (existingUser != null) {
                      // Update existing user
                      User updatedUser = User(
                        title: _contTitle.text,
                        description: _contDescription.text,
                      );
                      ref.read(todoData.notifier).updateData(existingUser, updatedUser).whenComplete(() {
                        Navigator.of(context).pop();
                      });
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  child: const Center(
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

