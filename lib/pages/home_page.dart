import 'package:daily_expense_tracker/custom_widgets/main_drawer.dart';
import 'package:daily_expense_tracker/pages/add_expense_page.dart';
import 'package:daily_expense_tracker/providers/app_provider.dart';
import 'package:daily_expense_tracker/ultils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';

class Homepage extends StatefulWidget {
  static const String routeName = '/';

  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  CategoryModel? categoryModel;
  DateTime? selectedDate;

  @override
  void didChangeDependencies() {
    Provider.of<AppProvider>(context, listen: false).getALlExpenses();
    Provider.of<AppProvider>(context, listen: false).getAllCategories();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('HOME'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: _showDatePickerDialog, icon: const Icon(Icons.calendar_month),),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AddExpensePage.routeName),
        child: const Icon(Icons.add),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<AppProvider>(
               builder: (context, provider, child) =>
                  DropdownButtonFormField<CategoryModel>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    value: categoryModel,
                    hint: const Text('Select Category'),
                    isExpanded: true,
                    items: provider.categoryList
                        .map(
                          (e) => DropdownMenuItem<CategoryModel>(
                        child: Text(e.name),
                        value: e,
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      setState(
                            () {
                          categoryModel = value;
                        },
                      );
                      if (categoryModel!.name == 'All') {
                        provider.getALlExpenses();
                      }else{
                      provider.getAllExpenseByCategoryName(categoryModel!.name);
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
            ),
          ),
            Expanded(
              child: ListView.builder(
                itemCount: provider.expenseList.length,
                itemBuilder: (context, index) {
                  final expense = provider.expenseList[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.only(
                        right: 20,
                      ),
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    confirmDismiss: (direction) {
                      return showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Expense'),
                            content: Text(
                                'Are you sure to delete item ${expense.name} ?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text('NO'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text('YES'),
                              ),
                            ],
                          ));
                    },
                    onDismissed: (direction) async {
                      final deleteId = await provider.deleteExpense(expense.id!);
                      showMsg(context, 'Deleted');
                    },
                    child: ListTile(
                      title: Text(
                        expense.name,
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(expense.formattedDate),
                      trailing: Text(
                        'BDT: ${expense.amount}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AddExpensePage.routeName, arguments: expense);
                        },
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePickerDialog() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
      Provider.of<AppProvider>(context, listen: false).getAllExpensesByDateTime(selectedDate!);
    }
  }

}
