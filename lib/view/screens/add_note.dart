import 'package:firebase_note_app/helpers/firestore_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  GlobalKey<FormState> addNoteKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? title;
  String? description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            if (addNoteKey.currentState!.validate()) {
              addNoteKey.currentState!.save();

              Map<String, dynamic> data = {
                "title": title,
                "description": description,
              };

              await FirestoreHelper.firestoreHelper.insertRecords(data: data);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Record Inserted Successfully..."),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );

              titleController.clear();
              descriptionController.clear();

              setState(() {
                title = null;
                description = null;
              });
            }
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff191654),
                Color(0xff43C6AC),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.teal,
        title: Text(
          "Add Note",
          style: GoogleFonts.ubuntu(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: addNoteKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: TextFormField(
                cursorHeight: 30,
                controller: titleController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter Your Title First...";
                  }
                  return null;
                },
                onSaved: (val) {
                  title = val;
                },
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle:
                      GoogleFonts.ubuntu(color: Colors.grey, fontSize: 30),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: TextFormField(
                cursorHeight: 25,
                controller: descriptionController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter Description First...";
                  }
                  return null;
                },
                onSaved: (val) {
                  description = val;
                },
                decoration: InputDecoration(
                  hintText: "Note",
                  hintStyle:
                      GoogleFonts.ubuntu(color: Colors.grey, fontSize: 20),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.teal.shade50,
    );
  }
}
