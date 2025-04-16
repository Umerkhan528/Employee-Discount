// edit_discount.dart file in company folder which is in screen folder

import 'package:discount_portal_app/models/shop_data.dart';
import 'package:discount_portal_app/provider/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDiscountScreen extends StatefulWidget {
  final Shop shop;
  final int index;
  const EditDiscountScreen({required this.shop, required this.index});

  @override
  _EditDiscountScreenState createState() => _EditDiscountScreenState();
}

class _EditDiscountScreenState extends State<EditDiscountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _discountController;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.shop.name);
    _discountController = TextEditingController(text: widget.shop.discount);
    _selectedCategory = widget.shop.category;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedShop = Shop(
        id: widget.shop.id,
        name: _nameController.text.trim(),
        category: _selectedCategory,
        discount: _discountController.text.trim(),
      );

      Provider.of<ShopProvider>(
        context,
        listen: false,
      ).updateShop(widget.index, updatedShop.toMap());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Discount')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Shop Name'),
                validator: (value) => value!.isEmpty ? 'Enter shop name' : null,
              ),
              TextFormField(
                controller: _discountController,
                decoration: InputDecoration(labelText: 'Discount (e.g. 10%)'),
                validator: (value) => value!.isEmpty ? 'Enter discount' : null,
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
              ElevatedButton(
                onPressed: _submit,
                child: Text('Update Discount'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
