import 'package:daily_expense_tracker/db/db_helper.dart';
import 'package:daily_expense_tracker/models/category_model.dart';
import 'package:daily_expense_tracker/models/expense_model.dart';
import 'package:flutter/foundation.dart';

class  AppProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  List<ExpenseModel> expenseList = [];


  final db = DbHelper();


  Future<int> addCategory (String value) async{
    final category = CategoryModel(value);
    final id = await db.insertCategory(category);
    await getAllCategories();
    return id;
  }


  Future<void> getAllCategories () async {
    categoryList = await db.getAllCategories();
    notifyListeners();
  }


  Future<int> addExpense(ExpenseModel expense) async {
    final id = await db.insertExpense(expense);
    await getALlExpenses();
    return id;
  }

  Future<void> getALlExpenses () async {
    expenseList = await db.getAllExpenses();
    notifyListeners();
  }

  Future<void> getAllExpenseByCategoryName (String name) async {
    expenseList = await db.getAllExpenseByCategoryName(name);
    notifyListeners();
  }

  Future<void> getAllExpensesByDateTime (DateTime dt ) async {
    expenseList = await db.getAllExpenseSByDateTime(dt);
    notifyListeners();
  }

  Future<CategoryModel> getCategoryByName(String name) async {
    return db.getCategoryByName(name);
  }


  Future<int> updateExpense(ExpenseModel expense) async{
    final id = await db.updateExpense(expense);
    await getALlExpenses();
    return id;
  }

  Future<int> deleteExpense(int id) async {
    final deletedRowId = await db.deleteExpenseById(id);
    await getALlExpenses();
    return deletedRowId;
  }

}