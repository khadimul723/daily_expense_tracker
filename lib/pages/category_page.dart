import 'package:daily_expense_tracker/providers/app_provider.dart';
import 'package:daily_expense_tracker/ultils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  static const String routeName = '/category';

  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  @override
  void didChangeDependencies() {
    Provider.of<AppProvider>(context, listen: false).getAllCategories();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Category'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSingleTextFieldDialog(
            context: context,
            title: 'Add Category',
            hint: 'Enter category name',
            onSave: (value) {
              Provider.of<AppProvider>(context, listen:  false)
                  .addCategory(value).then((id) {
                    showMsg(context, 'Category Added');
              }).catchError(showMsg(context, 'Could not save'));
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<AppProvider> (
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.categoryList.length,
          itemBuilder: (context, index) {
            final category = provider.categoryList[index];
            return ListTile(
              title: Text(category.name),
            );
          },
        ),
      ),
    );
  }
}
