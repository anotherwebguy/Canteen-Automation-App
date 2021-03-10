import 'package:canteen_app/Model/categoryModel.dart';
import 'package:flutter/material.dart';


List<CategoryModel> getFilterFavourites() {
  List<CategoryModel> categoryModelArrayList = List<CategoryModel>();

  CategoryModel item1 = CategoryModel();
  item1.img = "assets/db1_ic_pizza.svg";
  item1.name = "FastFood";
  item1.color = Color(0xFF5FACC9);

  CategoryModel item2 = CategoryModel();
  item2.img = "assets/db1_ic_coffee.svg";
  item2.name = "Drinks";
  item2.color = Color(0xFFB88DDD);

  CategoryModel item3 = CategoryModel();
  item3.img = "assets/db1_ic_chicken.svg";
  item3.name = "Dinner";
  item3.color = Color(0xFFC2DB77);

  CategoryModel item4 = CategoryModel();
  item4.img = "assets/db1_ic_cake.svg";
  item4.name = "Deserts";
  item4.color = Color(0xFFF5D270);

  CategoryModel item5 = CategoryModel();
  item5.img = "assets/d5_ic_food.svg";
  item5.name = "All";
  item5.color = Color(0xFFFBC02D);


  categoryModelArrayList.add(item1);
  categoryModelArrayList.add(item2);
  categoryModelArrayList.add(item3);
  categoryModelArrayList.add(item4);
  categoryModelArrayList.add(item5);
  return categoryModelArrayList;
}