import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/chart.dart';

class TransactionChart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  TransactionChart({this.recentTransactions});

  List<Map<String, Object>> get grouppedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      recentTransactions.forEach((item) {
        if (item.dateTime.day == weekDay.day &&
            item.dateTime.month == weekDay.month &&
            item.dateTime.year == weekDay.year) {
          totalSum += item.amount;
        }
      });

      return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
    }).reversed.toList();
  }

  double get totalSpending {
    return grouppedTransactions.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: grouppedTransactions.map((item) {
            return Flexible(
              fit: FlexFit.tight,
              child: Chart(
                label: item['day'],
                spending: item['amount'],
                spendingPercentage: totalSpending == 0.0
                    ? 0.0
                    : (item['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
