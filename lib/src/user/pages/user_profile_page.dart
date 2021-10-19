import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:small_deals/src/utils/app_colors.dart';
import 'package:small_deals/src/utils/app_routes.dart';

import 'edit_user_profile_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late User user;
  late DocumentReference userRef;
  late Stream<DocumentSnapshot> userStream;
  String sex = "M";
  late Map<String, dynamic> data;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    userRef = FirebaseFirestore.instance.collection("users").doc(user.uid);
    userStream = userRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: userRef.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "${snapshot.error}",
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            data = snapshot.data!.data()! as Map<String, dynamic>;

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      image: DecorationImage(
                        image: NetworkImage("${data['photo_url']}"),
                        fit: BoxFit.fitHeight,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                ListTile(
                  tileColor: Colors.white,
                  title: Text("Username"),
                  subtitle: Text("${data['username']}"),
                ),
                const Divider(),
                ListTile(
                  tileColor: Colors.white,
                  title: Text("Email"),
                  subtitle: Text("${data['email']}"),
                ),
                const Divider(),
                ListTile(
                  tileColor: Colors.white,
                  title: Text("First name"),
                  subtitle: Text("${data['first_name'] ?? ''}"),
                ),
                const Divider(),
                ListTile(
                  tileColor: Colors.white,
                  title: Text("Last name"),
                  subtitle: Text("${data['last_name'] ?? ''}"),
                ),
                const Divider(),
                ListTile(
                  tileColor: Colors.white,
                  title: Text("Age"),
                  subtitle: Text("${data['age'] ?? ''}"),
                ),
                ListTile(
                  title: Text("Sex"),
                  subtitle: Text("${data['sex'] ?? ''}"),
                ),
              ],
            );
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateTo(
              context,
              EditUserProfilePage(
                data: data,
                id: user.uid,
              ));
        },
        child: Icon(
          Icons.edit,
        ),
      ),
    );
  }
}
