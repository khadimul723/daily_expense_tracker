import 'package:daily_expense_tracker/pages/add_expense_page.dart';
import 'package:daily_expense_tracker/pages/category_page.dart';
import 'package:daily_expense_tracker/pages/home_page.dart';
import 'package:daily_expense_tracker/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        splashColor: Colors.red,
        highlightColor: Colors.black.withOpacity(.5),
      ),
      initialRoute: Homepage.routeName,
      routes: {
        Homepage.routeName: (context) => const Homepage(),
        AddExpensePage.routeName: (context) => const AddExpensePage(),
        CategoryPage.routeName: (context) => const CategoryPage(),
      },
    );
  }
}
