import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_note_app/helpers/firebaseauth_helpers.dart';
import 'package:firebase_note_app/helpers/firestore_helpers.dart';
import 'package:firebase_note_app/view/screens/update_note.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
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
          "Note Page",
          style: GoogleFonts.ubuntu(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuthHelper.firebaseAuthHelper.logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('login_page', (route) => false);
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirestoreHelper.firestoreHelper.fetchRecords(),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text("Error : ${snapShot.data}"),
            );
          } else if (snapShot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = snapShot.data;

            if (data == null) {
              return const Center(
                child: Text("No Data Here..."),
              );
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> allNotes =
                  data.docs;

              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                children: List.generate(
                  allNotes.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        Map<String, dynamic> updateData = {
                          "title": allNotes[index].data()['title'],
                          "description": allNotes[index].data()['description'],
                        };
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpdatePage(
                                id: allNotes[index].id, data: updateData)));
                      },
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${allNotes[index].data()['title']}",
                              style: GoogleFonts.ubuntu(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${allNotes[index].data()['description']}",
                              style: GoogleFonts.ubuntu(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).toList(),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      backgroundColor: Colors.teal,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('add_note_page');
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
