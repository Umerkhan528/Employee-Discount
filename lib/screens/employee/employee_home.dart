// employee_home.dart file in employee folder
import 'package:discount_portal_app/widgets/permission_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:discount_portal_app/provider/shop_provider.dart';
import 'package:discount_portal_app/models/shop_data.dart';
import 'package:discount_portal_app/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({Key? key}) : super(key: key);

  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  PermissionStatus _locationPermissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    setState(() {
      _locationPermissionStatus = status;
    });

    if (!status.isGranted) {
      await _requestLocationPermission();
    }
  }

  Future<void> _requestLocationPermission() async {
    print('Starting permission request...');
    final currentStatus = await Permission.locationWhenInUse.status;
    print('Current permission status: $currentStatus');

    try {
      final granted = await requestLocationPermission(context);
      print('Permission request completed. Granted: $granted');

      final newStatus = await Permission.locationWhenInUse.status;
      print('New permission status: $newStatus');

      setState(() {
        _locationPermissionStatus = newStatus;
      });

      if (!granted && newStatus.isDenied) {
        print('Showing denied snackbar');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission is required to view discounts'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Permission request error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error requesting permission: ${e.toString()}'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Employee Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
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
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    switch (_locationPermissionStatus) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return const TabBarView(
          children: [
            DiscountList(category: 'restaurant'),
            DiscountList(category: 'grocery'),
            DiscountList(category: 'cafe'),
          ],
        );
      case PermissionStatus.denied:
        return _buildPermissionRequestView(
          'We need location permission to show nearby discounts....',
          'Allow Location Access',
          _requestLocationPermission,
        );
      case PermissionStatus.permanentlyDenied:
        return _buildPermissionRequestView(
          'Location permission is permanently denied. Please enable it in app settings',
          'Open Settings',
          () => openAppSettings(),
        );
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildPermissionRequestView(
    String message,
    String buttonText,
    VoidCallback onPressed,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: onPressed, child: Text(buttonText)),
        ],
      ),
    );
  }
}

class DiscountList extends StatelessWidget {
  final String category;
  const DiscountList({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final filteredShops =
        shopProvider.shopList
            .map((shop) => Shop.fromMap(shop))
            .where((s) => s.category == category)
            .toList();

    return filteredShops.isEmpty
        ? const Center(child: Text('No discounts available in this category'))
        : ListView.builder(
          itemCount: filteredShops.length,
          itemBuilder: (context, index) {
            final shop = filteredShops[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(shop.name),
                subtitle: Text('${shop.discount} off'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            );
          },
        );
  }
}
