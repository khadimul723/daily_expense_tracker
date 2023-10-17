import 'package:daily_expense_tracker/models/category_model.dart';
import 'package:daily_expense_tracker/models/expense_model.dart';
import 'package:daily_expense_tracker/providers/app_provider.dart';
import 'package:daily_expense_tracker/ultils/helper_function.dart';
import 'package:daily_expense_tracker/ultils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExpensePage extends StatefulWidget {
  static const String routeName = '/add_expense';

  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  CategoryModel? categoryModel;
  DateTime selectedDate = DateTime.now();
  ExpenseModel? expenseModel;

  @override
  void didChangeDependencies() {
    Provider.of<AppProvider>(context, listen: false).getAllCategories();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg != null) {
      expenseModel = arg as ExpenseModel;
      _nameController.text = expenseModel!.name;
      selectedDate =
          DateTime.fromMillisecondsSinceEpoch(expenseModel!.timestamp);
      _amountController.text = expenseModel!.amount.toString();

      _getCategory(expenseModel!.name);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title:
            Text(expenseModel == null ? 'Add New Expense' : 'Update Expense'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 6.0,
                ),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Expense name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide an expense name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 6.0,
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Expense amount',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide an amount';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 90.0,
                  vertical: 10.0,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<AppProvider>(
                      builder: (context, provider, child) =>
                          DropdownButtonFormField<CategoryModel>(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        value: categoryModel,
                        hint: const Text('Select Category'),
                        isExpanded: true,
                        items: provider.categoryList
                            .map(
                              (e) => DropdownMenuItem<CategoryModel>(
                                enabled: e.name == 'All' ? false : true,
                                value: e,
                                child: Text(
                                  e.name,
                                  style: TextStyle(
                                      color: e.name == 'All'
                                          ? Colors.grey
                                          : Colors.blueGrey),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(
                            () {
                              categoryModel = value;
                            },
                          );
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
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _showDatePickerDialog,
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Select Date'),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(getFormattedDate(selectedDate)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (expenseModel == null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 70.0, vertical: 30.0),
                  child: ElevatedButton(
                    onPressed: _saveExpense,
                    child: const Text('SAVE'),
                  ),
                ),
              if (expenseModel != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 70.0, vertical: 30.0),
                  child: ElevatedButton(
                    onPressed: _updateExpense,
                    child: const Text('UPDATE'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
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
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final expense = ExpenseModel(
        name: _nameController.text,
        categoryName: categoryModel!.name,
        amount: num.parse(_amountController.text),
        formattedDate: getFormattedDate(selectedDate),
        timestamp: selectedDate.millisecondsSinceEpoch,
        day: selectedDate.day,
        month: selectedDate.month,
        year: selectedDate.year,
      );
      Provider.of<AppProvider>(context, listen: false)
          .addExpense(expense)
          .then((value) {
        showMsg(context, 'Saved');
        Navigator.pop(context);
      }).catchError((error) {
        showMsg(context, 'Failed to save');
      });
    }
  }

  void _getCategory(String name) async {
    categoryModel = await Provider.of<AppProvider>(context, listen: false)
        .getCategoryByName(expenseModel!.categoryName);
    setState(() {});
  }

  void _updateExpense() async {
    if (_formKey.currentState!.validate()) {
      expenseModel!.name = _nameController.text;
      expenseModel!.categoryName = categoryModel!.name;
      expenseModel!.amount = num.parse(_amountController.text);
      expenseModel!.formattedDate = getFormattedDate(selectedDate);
      expenseModel!.timestamp = selectedDate.millisecondsSinceEpoch;
      expenseModel!.day = selectedDate.day;
      expenseModel!.month = selectedDate.month;
      expenseModel!.year = selectedDate.year;
      Provider.of<AppProvider>(context, listen: false)
          .updateExpense(expenseModel!)
          .then((value) {
        showMsg(context, 'Update');
        Navigator.pop(context);
      }).catchError((error) {
        showMsg(context, 'Failed to update');
      });
    }
  }
}
