import 'package:daily_expense_tracker/pages/category_page.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 150,
            color: Theme.of(context).dialogBackgroundColor.withGreen(50),
          ),
          ListTile(

            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, CategoryPage.routeName);
            },
            leading: const Icon(Icons.category),
            title: const Text('Category'),
          ),
        ],
      ),
    );
  }
}
