import 'package:flutter/material.dart';

class ShopProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _shopList = [];

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
