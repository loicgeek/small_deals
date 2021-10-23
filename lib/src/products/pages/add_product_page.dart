import 'package:firebase_auth/firebase_auth.dart';
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

class _AdproductPageState extends State<AdproductPage> {
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descController;
  GlobalKey<FormState> _formKey = GlobalKey();
  late ProductService _productService;
  bool isLoading = false;
  String? error;

  Future getData() async {
    Map<String, dynamic> data = Map();

    data['title'] = _titleController.text;
    data['description'] = _descController.text;
    data['price'] = int.parse(_priceController.text);
    data['user_id'] = FirebaseAuth.instance.currentUser!.uid;

    return data;
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _priceController = TextEditingController();
    _descController = TextEditingController();

    _productService = ProductService();
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
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                final ImagePicker _picker = ImagePicker();
                // Pick an image
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    //  currentImage = image;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
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
                    await _productService.saveProduct(data);
                    setState(() {
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
}
