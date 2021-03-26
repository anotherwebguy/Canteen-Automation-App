import 'package:flutter/material.dart';

class CategoryModel {
  var name = "";
  var img = "";
  Color color;
  var tags;
}


class DashboardCollections {
  var name;
  var image;
  var info;
  var tags;

  DashboardCollections(this.name, this.image, this.info, this.tags);
}
