// company_home.dart file in company folder which is in screen folder

import 'package:discount_portal_app/provider/shop_provider.dart';
import 'package:discount_portal_app/screens/auth/login_screen.dart';
import 'package:discount_portal_app/screens/company/add_discount.dart';
import 'package:discount_portal_app/screens/company/edit_discount.dart';
import 'package:discount_portal_app/models/shop_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanyHomeScreen extends StatelessWidget {
  const CompanyHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Company Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddDiscountScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body:
          shopProvider.shopList.isEmpty
              ? Center(child: Text('No discounts added yet.'))
              : ListView.builder(
                itemCount: shopProvider.shopList.length,
                itemBuilder: (context, index) {
                  final shopMap = shopProvider.shopList[index];
                  final shop = Shop.fromMap(shopMap);
                  return Card(
                    child: ListTile(
                      title: Text(shop.name),
                      subtitle: Text('${shop.category} - ${shop.discount} off'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => EditDiscountScreen(
                                        shop: shop,
                                        index: index,
                                      ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              shopProvider.deleteShop(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
