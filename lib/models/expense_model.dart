const String tblExpense = 'tbl_expense';
const String tblExpenseColId = 'id';
const String tblExpenseColName = 'name';
const String tblExpenseColCategory = 'category';
const String tblExpenseColAmount = 'amount';
const String tblExpenseColFormattedDate = 'date';
const String tblExpenseColTimestamp = 'timestamp';
const String tblExpenseColDay = 'day';
const String tblExpenseColMonth = 'month';
const String tblExpenseColYear = 'year';

class ExpenseModel {
  int? id;
  String name;
  String categoryName;
  num amount;
  String formattedDate;
  int timestamp;
  int day;
  int month;
  int year;

  ExpenseModel({
    this.id,
    required this.name,
    required this.categoryName,
    required this.amount,
    required this.formattedDate,
    required this.timestamp,
    required this.day,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      tblExpenseColName: name,
      tblExpenseColCategory: categoryName,
      tblExpenseColAmount: amount,
      tblExpenseColFormattedDate: formattedDate,
      tblExpenseColTimestamp: timestamp,
      tblExpenseColDay: day,
      tblExpenseColMonth: month,
      tblExpenseColYear: year,
    };
    if (id != null) {
      map[tblExpenseColId] = id;
    }
    return map;
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) => ExpenseModel(
        id: map[tblExpenseColId],
        name: map[tblExpenseColName],
        categoryName: map[tblExpenseColCategory],
        amount: map[tblExpenseColAmount],
        formattedDate: map[tblExpenseColFormattedDate],
        timestamp: map[tblExpenseColTimestamp],
        day: map[tblExpenseColDay],
        month: map[tblExpenseColMonth],
        year: map[tblExpenseColYear],
      );
}
