import 'dart:io';

import 'package:canteen_app/CommonScreens/homeView.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Services/dbdata.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as Path;

class EditProduct extends StatefulWidget {
  final String name, description, price, type, category, image,inv,docid;
  EditProduct(
      {this.name,
      this.description,
      this.price,
      this.type,
      this.inv,
      this.category,
      this.image,
      this.docid});
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final list = ["FastFood", "Drinks", "Desserts", "All"];
  final quantity = TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController rating = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController price = new TextEditingController();
  String category;
  File img1;
  String path1 = "";
  bool isLoading = false;
  String type = null;
  String inv = null;
  List<String> listOfCategory = ["FastFood", "Drinks", "Desserts"];
  String selectedIndexCategory;

  @override
  void initState() {
    super.initState();
    // fetchData();
    name.text = widget.name;
    description.text=widget.description;
    price.text=widget.price;
    selectedIndexCategory = widget.category;
    type = widget.type;
    path1 = widget.image;
    inv = widget.inv;
  }

  Future<void> chooseFile() async {
    try {
      final imageFileTwo = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      setState(() {
        img1 = imageFileTwo;
      });
    } catch (e) {
      print(e);
    }
  }

  Future uploadFileImage() async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        'admins/${FirebaseAuth.instance.currentUser.uid}/fooditems/${Path.basename(img1.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(img1);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURLTwo) {
      setState(() {
        path1 = fileURLTwo;
        print(path1);
      });
    });
  }

  Future<void> loadDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          title: Text('Please wait while we Add the FoodItem'),
          actions: <Widget>[
            Center(
              child: Container(
                child: Theme(
                  data: ThemeData.light(),
                  child: CupertinoActivityIndicator(
                    animating: true,
                    radius: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List searchString = [];

  void search(String a) {
    List words = [];
    a += ' ';
    words = a.split(' ');
    for (int k = 0; k < words.length; k++) {
      for (int i = 1; i <= words[k].length; i++) {
        searchString.add(words[k].substring(0, i).trim().toLowerCase());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Edit Products"),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(16.0),
              decoration: boxDecoration1(
                  showShadow: true, bgColor: Color(0xfff1f4fb), radius: 8.0),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      chooseFile();
                    },
                    child: Card(
                      elevation: 10,
                      color: Colors.lightBlue[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        width: 145,
                        //padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: img1 != null
                                  ? Image.file(
                                      img1,
                                      width: 150,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(10),
                                      child: Image(
                                        width: 150,
                                        height: 100,
                                        image: NetworkImage(
                                          widget.image,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  text2(
                          '    Note:  ' +
                              'Please select images less than or equal\n to 100kb in size. \n Image is Mandatory. ',
                          fontSize: 14.0)
                      .paddingTop(2.0),
                  text2('equal to 100kb in size.             ', fontSize: 14.0)
                      .paddingTop(2.0),
                  text2('Image is mandatory                ', fontSize: 14.0)
                      .paddingTop(2.0),
                ],
              ).paddingAll(16.0),
            ),
            Container(
              width: double.infinity,
              decoration: boxDecoration(showShadow: true, radius: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  text2("Select Category", textColor: Color(0xFF1e253a))
                      .paddingTop(8.0),
                  Card(
                      elevation: 4,
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        value: selectedIndexCategory,
                        style: boldTextStyle(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        underline: 0.height,
                        onChanged: (newValue) {
                          setState(() {
                            selectedIndexCategory = newValue;
                          });
                        },
                        items: listOfCategory.map((category) {
                          return DropdownMenuItem(
                            child: Text(category, style: primaryTextStyle())
                                .paddingLeft(8),
                            value: category,
                          );
                        }).toList(),
                      )),
                  text2("Enter FoodItem Name", textColor: Color(0xFF1e253a)),
                  formField(context, "Item name",
                          prefixIcon: Icons.fastfood,
                          controller: name,
                          keyboardType: TextInputType.text)
                      .paddingTop(8.0),
                  text2("Description", textColor: Color(0xFF1e253a))
                      .paddingTop(8.0),
                  formField(context, "Description",
                          prefixIcon: Icons.description,
                          controller: description,
                          keyboardType: TextInputType.multiline)
                      .paddingTop(8.0),
                  text2("Type", textColor: Color(0xFF1e253a)).paddingTop(8.0),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    children: [
                      Theme(
                        data: Theme.of(context)
                            .copyWith(unselectedWidgetColor: Colors.black),
                        child: Radio(
                          value: 'veg',
                          groupValue: type,
                          onChanged: (value) {
                            setState(() {
                              type = value;
                              toast("$type Selected");
                            });
                          },
                        ),
                      ),
                      Text('Veg only', style: primaryTextStyle()),
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.black,
                        ),
                        child: Radio(
                          value: 'Non-Veg',
                          groupValue: type,
                          onChanged: (value) {
                            setState(() {
                              type = value;
                              toast("$type Selected");
                            });
                          },
                        ),
                      ),
                      Text('Non-Veg only', style: primaryTextStyle()),
                    ],
                  ),
                  text2("Quantity", textColor: Color(0xFF1e253a)).paddingTop(8.0),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    children: [
                      Theme(
                        data: Theme.of(context)
                            .copyWith(unselectedWidgetColor: Colors.black),
                        child: Radio(
                          value: 'instock',
                          groupValue: inv,
                          onChanged: (value) {
                            setState(() {
                              inv = value;
                              toast("$inv Selected");
                            });
                          },
                        ),
                      ),
                      Text('In Stock', style: primaryTextStyle()),
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.black,
                        ),
                        child: Radio(
                          value: 'outstock',
                          groupValue: inv,
                          onChanged: (value) {
                            setState(() {
                              inv = value;
                              toast("$inv Selected");
                            });
                          },
                        ),
                      ),
                      Text('Out Stock', style: primaryTextStyle()),
                    ],
                  ),
                  text2("Amount", textColor: Color(0xFF1e253a)).paddingTop(8.0),
                  formField(context, "Enter the amount",
                          prefixIcon: Icons.attach_money,
                          controller: price,
                          keyboardType: TextInputType.number)
                      .paddingTop(8.0),
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: text2("Edit FoodItem",
                          textColor: Colors.white, fontFamily: 'Medium'),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8.0)),
                      color: Color(0xFF3d87ff),
                      onPressed: () async {
                        if (path1 != "" &&
                            name.text != "" &&
                            description.text != null &&
                            price.text != null &&
                            type != null) {
                          setState(() {
                            isLoading = true;
                          });
                          if (isLoading) {
                            loadDialog();
                          }
                          if(img1!=null && img1!=""){
                            await uploadFileImage();
                          }
                          
                          search(name.text);
                          Future.delayed(const Duration(seconds: 5), () {
                            updateFoodItemAllSection(name.text, description.text, price.text, path1,inv,searchString,type, selectedIndexCategory,widget.docid);
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return HomeView();
                              },
                            ), (route) => false);
                          });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Incomplete Information'),
                                    content:
                                        Text('Please Fill all the information'),
                                    actions: [
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ));
                        }
                      },
                    ),
                  ).paddingTop(16.0)
                ],
              ).paddingAll(16.0),
            ).paddingAll(16.0)
          ],
        ),
      ),
    );
  }
}
