import 'package:discount_portal_app/provider/shop_provider.dart';
import 'package:discount_portal_app/models/shop_data.dart';
import 'package:discount_portal_app/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(
      context,
    ).popUntil((route) => route.isFirst); // Adjust this based on your routing
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Employee Dashboard'),
          actions: [
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Restaurants'),
              Tab(text: 'Grocery'),
              Tab(text: 'Cafes'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DiscountList(category: 'restaurant'),
            DiscountList(category: 'grocery'),
            DiscountList(category: 'cafe'),
          ],
        ),
      ),
    );
  }
}

class DiscountList extends StatelessWidget {
  final String category;
  const DiscountList({required this.category});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final filteredShops =
        shopProvider.shopList
            .map((shop) => Shop.fromMap(shop))
            .where((s) => s.category == category)
            .toList();

    return ListView.builder(
      itemCount: filteredShops.length,
      itemBuilder: (context, index) {
        final shop = filteredShops[index];
        return ListTile(
          title: Text(shop.name),
          subtitle: Text('${shop.discount} off'),
        );
      },
    );
  }
}
