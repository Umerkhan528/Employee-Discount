// add_discount.dart file in company folder which is in screen folder

import 'package:discount_portal_app/models/shop_data.dart';
import 'package:discount_portal_app/provider/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddDiscountScreen extends StatefulWidget {
  @override
  _AddDiscountScreenState createState() => _AddDiscountScreenState();
}

class _AddDiscountScreenState extends State<AddDiscountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _discountController = TextEditingController();
  String _selectedCategory = 'restaurant';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newShop = Shop(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        category: _selectedCategory,
        discount: _discountController.text.trim(),
      );

      Provider.of<ShopProvider>(
        context,
        listen: false,
      ).addShop(newShop.toMap());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Discount')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Shop Name'),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter a shop name' : null,
              ),
              TextFormField(
                controller: _discountController,
                decoration: InputDecoration(labelText: 'Discount (e.g. 20%)'),
                validator:
                    (value) => value!.isEmpty ? 'Please enter discount' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items:
                    ['restaurant', 'grocery', 'cafe']
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
                decoration: InputDecoration(labelText: 'Category'),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text('Add Discount')),
            ],
          ),
        ),
      ),
    );
  }
}
