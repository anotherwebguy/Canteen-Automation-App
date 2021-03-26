import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/Helpers/widgets.dart';
import 'package:canteen_app/Model/categoryModel.dart';
import 'package:flutter/material.dart';

class Collection extends StatelessWidget {

  DashboardCollections model;

  Collection(DashboardCollections model, int pos,) {
    this.model = model;
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
              MaterialPageRoute(builder: (context) => model.tags));
      },
      child: Container(
        margin: EdgeInsets.only(left: 16.0),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Image.asset(
                  model.image,
                  width: width * 0.5,
                  height: 250,
                  fit: BoxFit.fill),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  text1(model.name,
                      fontSize: 18.0,
                      fontFamily: 'Andina',
                      textColor: Colors.white),
                  SizedBox(height: 4.0),
                  text1(model.info,
                      fontSize: 14.0, textColor: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}