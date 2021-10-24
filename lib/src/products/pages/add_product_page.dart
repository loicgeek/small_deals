import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:small_deals/src/products/product_service.dart';
import 'package:small_deals/src/utils/app_colors.dart';
import 'package:small_deals/src/utils/validators.dart';
import 'package:small_deals/src/widgets/app_button.dart';
import 'package:small_deals/src/widgets/app_input.dart';

class AdproductPage extends StatefulWidget {
  const AdproductPage({Key? key}) : super(key: key);

  @override
  _AdproductPageState createState() => _AdproductPageState();
}

class _AdproductPageState extends State<AdproductPage>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descController;
  GlobalKey<FormState> _formKey = GlobalKey();
  late ProductService _productService;
  late Stream<QuerySnapshot<Map<String, dynamic>>> categoriesStream;
  bool isLoading = false;
  String? error;
  List<File>? images;
  List<String> imagesUrl = [];
  Map<String, dynamic>? selectedCategory = Map();

  Future getData() async {
    Map<String, dynamic> data = Map();
    data['title'] = _titleController.text;
    data['description'] = _descController.text;
    data['price'] = int.parse(_priceController.text);
    data['user_id'] = FirebaseAuth.instance.currentUser!.uid;
    data["user"] = FirebaseAuth.instance.currentUser;

    data['category_id'] = selectedCategory!['id'];
    data['category'] = selectedCategory!;
    return data;
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _priceController = TextEditingController();
    _descController = TextEditingController();
    _productService = ProductService();
    categoriesStream =
        FirebaseFirestore.instance.collection("categories").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            AppInput(
              controller: _titleController,
              label: "Title",
              validator: (value) {
                return Validators.required("Title", value);
              },
            ),
            AppInput(
              controller: _descController,
              label: "Description",
              minLines: 3,
              maxLines: 6,
              validator: (value) {
                return Validators.required("Description", value);
              },
            ),
            AppInput(
              controller: _priceController,
              label: "Price",
              textInputType: TextInputType.numberWithOptions(),
              validator: (value) {
                return Validators.required("Price", value);
              },
            ),
            StreamBuilder(
              stream: categoriesStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot<Object?>> cats =
                      snapshot.data!.docs;
                  return DropdownButtonFormField<String>(
                    onChanged: (value) {
                      selectedCategory ??= Map();
                      selectedCategory!['id'] = value;
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please Select a category";
                      }
                      return null;
                    },
                    value: selectedCategory!['id'],
                    items: cats.map((d) {
                      var cat = d.data()! as Map<String, dynamic>;
                      cat['id'] = d.id;
                      return DropdownMenuItem<String>(
                        child: Text("${cat['title']}"),
                        value: cat['id'],
                      );
                    }).toList(),
                  );
                }

                return Container();
              },
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                final ImagePicker _picker = ImagePicker();
                // Pick an image
                final List<XFile>? results = await _picker.pickMultiImage();
                if (results != null) {
                  print(images);
                  setState(() {
                    images = results.map((e) => File(e.path)).toList();
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary.withOpacity(.3),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 40,
                  )),
                ),
              ),
            ),
            if (images != null)
              Container(
                height: 100,
                child: ListView.builder(
                    itemCount: images!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      File file = images![index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(file),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  images!.removeAt(index);
                                  if (images!.isEmpty) {
                                    images = null;
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            SizedBox(
              height: 35,
            ),
            if (isLoading)
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              )),
            if (error != null)
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${error}",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )),
            AppButton(
              text: "Save",
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    setState(() {
                      isLoading = true;
                      error = null;
                    });
                    var data = await getData();
                    var productRef = await _productService.saveProduct(data);

                    try {
                      if (images != null)
                        for (var i = 0; i < images!.length; i++) {
                          var url = await _productService
                              .uploadFileToFireStorage(images![i]);
                          imagesUrl.add(url);
                        }
                    } catch (e) {
                      print(e);
                    }

                    if (imagesUrl.isNotEmpty) {
                      await productRef.update({"images": imagesUrl});
                    }

                    setState(() {
                      if (images != null) {
                        images!.clear();
                      }
                      imagesUrl.clear();

                      isLoading = false;
                      _titleController.clear();
                      _descController.clear();
                      _priceController.clear();
                    });
                  } catch (e) {
                    print(e);

                    setState(() {
                      error = e.toString();
                      isLoading = false;
                    });
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
