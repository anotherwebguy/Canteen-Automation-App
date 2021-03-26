import 'package:canteen_app/CommonScreens/all.dart';
import 'package:canteen_app/CommonScreens/categories.dart';
import 'package:canteen_app/Model/categoryModel.dart';
import 'package:flutter/material.dart';


List<CategoryModel> getFilterFavourites() {
  List<CategoryModel> categoryModelArrayList = List<CategoryModel>();

  CategoryModel item1 = CategoryModel();
  item1.img = "assets/db1_ic_pizza.svg";
  item1.name = "FastFood";
  item1.color = Color(0xFF5FACC9);
  item1.tags = Categories(category: "FastFood" ,);

  CategoryModel item2 = CategoryModel();
  item2.img = "assets/db1_ic_coffee.svg";
  item2.name = "Drinks";
  item2.color = Color(0xFFB88DDD);
  item2.tags = Categories(category: "Drinks" ,);

  CategoryModel item3 = CategoryModel();
  item3.img = "assets/db1_ic_cake.svg";
  item3.name = "Deserts";
  item3.color = Color(0xFFF5D270);
  item3.tags = Categories(category: "Desserts" ,);

  CategoryModel item4 = CategoryModel();
  item4.img = "assets/d5_ic_food.svg";
  item4.name = "All";
  item4.color = Color(0xFFFBC02D);
  item4.tags = AllCat();


  categoryModelArrayList.add(item1);
  categoryModelArrayList.add(item2);
  categoryModelArrayList.add(item3);
  categoryModelArrayList.add(item4);
  return categoryModelArrayList;
}

List<DashboardCollections> addCollectionData() {
  List<DashboardCollections> collectionData = List<DashboardCollections>();
  collectionData.add(DashboardCollections("Fast Food", "assets/home1.jpg", "Starts from @15",Categories(category: "FastFood" ,)));
  collectionData.add(DashboardCollections("Drinks", "assets/dash3.jpg", "Starts from @15",Categories(category: "Drinks" ,)));
  collectionData.add(DashboardCollections("Desserts", "assets/dash2.jpg", "Starts from @15",Categories(category: "Desserts" ,)));
  return collectionData;
}