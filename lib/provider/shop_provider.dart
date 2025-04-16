// shop_provider.dart file in provider folder
import 'package:flutter/material.dart';

class ShopProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _shopList = [
    {
      "id": "1",
      "name": "Tasty Bites",
      "category": "restaurant",
      "discount": "15%",
    },
    {"id": "2", "name": "Daily Mart", "category": "grocery", "discount": "10%"},
    {"id": "3", "name": "Brew Cafe", "category": "cafe", "discount": "20%"},
    {
      "id": "4",
      "name": "Pizza Palace",
      "category": "restaurant",
      "discount": "12%",
    },
    {
      "id": "5",
      "name": "Fresh Market",
      "category": "grocery",
      "discount": "8%",
    },
    {"id": "6", "name": "Coffee Corner", "category": "cafe", "discount": "15%"},
  ];

  List<Map<String, dynamic>> get shopList => _shopList;
  void setShops(List<Map<String, dynamic>> shops) {
    _shopList = shops;
    notifyListeners();
  }

  void addShop(Map<String, dynamic> shop) {
    _shopList.add(shop);
    notifyListeners();
  }

  void deleteShop(int index) {
    _shopList.removeAt(index);
    notifyListeners();
  }

  void updateShop(int index, Map<String, dynamic> updatedShop) {
    _shopList[index] = updatedShop;
    notifyListeners();
  }
}
