import 'package:flutter/material.dart';
import 'package:myapp/screens/loginPage.dart';
import 'package:myapp/screens/transactionTile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, dynamic>> _transactions = [];

  double _totalBalance = 0.0;

  double get totalCredit {
    return _transactions
        .where((tx) => tx["color"] == "green")
        .fold(0.0, (sum, tx) => sum + tx["amount"]);
  }

  double get totalDebit {
    return _transactions
        .where((tx) => tx["color"] == "red")
        .fold(0.0, (sum, tx) => sum + tx["amount"]);
  }

  @override
  void initState() {
    super.initState();
  }

  void _addExpense() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: AddExpenseScreen(
          onAdd: (transaction) {
            setState(() {
              _transactions.add(transaction);
              _totalBalance += transaction["color"] == "green"
                  ? transaction["amount"]
                  : -transaction["amount"];
              transaction["balance"] = _totalBalance;
            });
          },
        ),
      ),
    );
  }

  void _viewAllTransactions() {
    final convertedTransactions = _transactions.map((tx) {
      return {
        "icon": tx["icon"].toString(),
        "title": tx["title"].toString(),
        "amount": tx["amount"].toString(),
        "balance": tx["balance"].toString(),
        "color": tx["color"].toString(),
      };
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ViewAllScreen(transactions: convertedTransactions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xff272643),
          title: const Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Color.fromARGB(255, 109, 7, 172),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Hey, Milan!',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xff272643),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Color.fromARGB(255, 109, 7, 172),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Welcome, MILAN!',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addExpense,
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3.5,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color(0xff272643),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                    left: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatCard(
                              title: 'Total Balance',
                              value: _totalBalance,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 10),
                            _buildStatCard(
                              title: 'Total Credit',
                              value: totalCredit,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 10),
                            _buildStatCard(
                              title: 'Total Debit',
                              value: totalDebit,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Transactions',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: _viewAllTransactions,
                          child: const Text(
                            'View all',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    for (var tx in _transactions.reversed.take(3))
                      TransactionTile(
                        icon: _getIconFromName(tx["icon"]),
                        title: tx["title"],
                        amount: 'CAD \$${tx["amount"].toStringAsFixed(2)}',
                        balance:
                            'Balance: CAD \$${tx["balance"].toStringAsFixed(2)}',
                        iconColor:
                            tx["color"] == "green" ? Colors.green : Colors.red,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildStatCard({
    required String title,
    required double value,
    required Color color,
  }) {
    return SizedBox(
      width: 120,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                'CAD \$${value.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case "money":
        return Icons.currency_bitcoin;

      default:
        return Icons.currency_bitcoin;
    }
  }
}

// Add Expense Screen
class AddExpenseScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const AddExpenseScreen({super.key, required this.onAdd});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _transactionType = 'Credit';

  void _submit() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (title.isNotEmpty && amount > 0) {
      final transaction = {
        "icon": _transactionType == "Credit" ? "attach_money" : "money",
        "title": title,
        "amount": amount,
        "balance": 0.0, // Will be updated in the parent widget
        "color": _transactionType == "Credit" ? "green" : "red",
      };

      widget.onAdd(transaction);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Transaction Title'),
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount (CAD)'),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: _transactionType,
            items: const [
              DropdownMenuItem(value: 'Credit', child: Text('Credit')),
              DropdownMenuItem(value: 'Debit', child: Text('Debit')),
            ],
            onChanged: (value) {
              setState(() {
                _transactionType = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Add Transaction'),
          ),
        ],
      ),
    );
  }
}

// View All Transactions Screen
class ViewAllScreen extends StatelessWidget {
  final List<Map<String, String>> transactions;

  const ViewAllScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('All Transactions'),
        ),
        body: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return TransactionTile(
              icon: Icons.currency_bitcoin,
              title: tx["title"]!,
              amount:
                  "Amount CAD \$ : ${tx["amount"]!}", // Adding text to amount
              balance:
                  "Balance CAD \$ : ${tx["balance"]!}", // Adding text to balance
              iconColor: tx["color"] == "green" ? Colors.green : Colors.red,
            );
          },
        ));
  }
}
