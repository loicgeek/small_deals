import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProducts extends StatefulWidget {
  const UserProducts({Key? key}) : super(key: key);

  @override
  _UserProductsState createState() => _UserProductsState();
}

class _UserProductsState extends State<UserProducts>
    with AutomaticKeepAliveClientMixin {
  late CollectionReference _userProductsRef;
  late User user;
  late Stream<QuerySnapshot> userProductsStream;
  late List<QueryDocumentSnapshot> data;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    userProductsStream = FirebaseFirestore.instance
        .collection("products")
        .where("user_id", isEqualTo: user.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: userProductsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            data = snapshot.data!.docs;
            if (snapshot.data!.size == 0) {
              return Center(child: Text("No Products yet"));
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  var product = snapshot.data!.docs[index].data()!
                      as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 250,
                      color: Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product['images'] != null)
                            Image.network(
                              product['images'][0],
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                            ),
                          Text(
                            "${product['title']}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "XAF${product['price']}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "${product['description']}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.size,
              );
            }
          }

          return Container();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
