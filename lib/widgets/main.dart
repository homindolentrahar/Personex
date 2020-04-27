import 'package:flutter/material.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/transaction_chart.dart';
import 'package:personal_expenses/widgets/transaction_list.dart';
import 'package:personal_expenses/widgets/transaction_new.dart';

void main() => runApp(PersonalExpenses());

class PersonalExpenses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expenses",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.redAccent,
        appBarTheme: AppBarTheme(
          color: Colors.black12,
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _transactions = [];

  List<Transaction> get _recentTransactions {
    return _transactions.where((item) {
      return item.dateTime.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTx(String title, double amount, DateTime dateTime) {
    final tx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        dateTime: dateTime);

    setState(() {
      _transactions.add(tx);
    });
  }

  void _deleteTx(String id) {
    setState(() {
      _transactions.removeWhere((value) {
        return value.id == id;
      });
    });
  }

  void _showModalAddNewTx() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (_) {
        return TransactionNew(
          addNewTx: _addNewTx,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.account_balance_wallet,
        ),
        title: Text(
          "Personal Expenses",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showModalAddNewTx,
          ),
        ],
      ),
      body: _transactions.isEmpty
          ? Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(16),
                  child: Text(
                    "No Transactions",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  width: double.infinity,
                  height: 300,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            )
          : Column(
              children: <Widget>[
                TransactionChart(
                  recentTransactions: _recentTransactions,
                ),
                TransactionList(
                  transactions: _transactions,
                  deleteTx: _deleteTx,
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showModalAddNewTx,
      ),
    );
  }
}
