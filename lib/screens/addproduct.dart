import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final list = ["FastFood","Drinks","Dinner","Desserts","All"];
  final quantity = TextEditingController();
  TextEditingController name;
  TextEditingController rating;
  TextEditingController description;
  TextEditingController price;
  String category;
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Product"),
        backgroundColor: Colors.purple[800],
      ),
      body: SingleChildScrollView(
              child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Enter Product name",
                  hintText: "Product Name"
                ),
              ),
              SizedBox(height: 5,),
              TextFormField(
                controller: price,
                decoration: InputDecoration(
                  labelText: "Enter Price",
                  hintText: "Price"
                ),
              ),
              SizedBox(height: 5,),
              TextFormField(
                controller: quantity,
                decoration: InputDecoration(
                  labelText: "Enter Quantity",
                  hintText: "Quantity",
                ),
              ),
              SizedBox(height: 5,),
              TextFormField(
                controller: rating,
                decoration: InputDecoration(
                  labelText: "Enter Rating",
                  hintText: "Rating"
                ),
              ),
              SizedBox(
                height: 5,
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: category,
                hint: Text("Category"),
                items: list.map((String value){
                  return new DropdownMenuItem(
                    value: value,
                    child: Text(value),
                    );
                }).toList(),
                onChanged: (value){
                  setState(() {
                    category=value;
                  });
                },
              ),
              SizedBox(height: 5,),
              TextField(
                controller: description,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Description"
                ),
              ),
              SizedBox(height: 5,),
              ButtonTheme(
                  minWidth: 100,
                  child: RaisedButton(
                  color: Colors.purple[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("Add Product", style: TextStyle(color: Colors.white),),
                  onPressed: (){
                  }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

