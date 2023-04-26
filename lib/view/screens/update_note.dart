import 'package:firebase_note_app/helpers/firestore_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdatePage extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;
  const UpdatePage({Key? key, required this.id, required this.data})
      : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  GlobalKey<FormState> updateNoteKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    titleController.text = widget.data['title'];
    descriptionController.text = widget.data['description'];
  }

  String? title;
  String? description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            if (updateNoteKey.currentState!.validate()) {
              updateNoteKey.currentState!.save();

              Map<String, dynamic> data = {
                "title": title,
                "description": description,
              };

              await FirestoreHelper.firestoreHelper
                  .updateRecord(data: data, id: widget.id);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Record Updated Successfully..."),
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
          "Update Note",
          style: GoogleFonts.ubuntu(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text(
                      'This action will permanently delete this data'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirestoreHelper.firestoreHelper
                            .deleteRecords(id: widget.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Record Deleted Successfully..."),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.of(context).pushReplacementNamed('note_page');
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
            color: Colors.white,
          )
        ],
      ),
      body: Form(
        key: updateNoteKey,
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
