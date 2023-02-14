import 'package:flutter/material.dart';

class SimpleExpenditure extends StatefulWidget {
  const SimpleExpenditure({super.key});

  @override
  State<SimpleExpenditure> createState() => _SimpleExpenditureState();
}

class _SimpleExpenditureState extends State<SimpleExpenditure> {
  double? _netSalary;
  double? _expenses;
  String message = ' ';

  final _form = GlobalKey<FormState>();

  final _netSalaryFocusNode = FocusNode();
  final _expensesFocusNode = FocusNode();

  @override
  void dispose() {
    _netSalaryFocusNode.dispose();
    _expensesFocusNode.dispose();
    super.dispose();
  }

  //calculates profit or loss
  double calculations() {
    return _netSalary! - _expenses!;
  }

  //It's called when the form is submitted using a button or through keyboard's "done" softkey
  void _saveForm() {
    _form.currentState?.validate();
    _form.currentState?.save();

    setState(() {
      message = ' ';
      if (_netSalary != null && _expenses != null) {
        if (_netSalary! > _expenses!) {
          message = 'You have gained ${calculations()} this month';
        } else if (_netSalary! < _expenses!) {
          message = 'You have lost ${calculations()} this month';
        } else {
          message = 'Your balance hasn\'t changed';
        }

        calculations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Expenditure'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              Center(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(right: 5.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Net Salary',
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _netSalaryFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_expensesFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the value';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value!.isNotEmpty) {
                              _netSalary = double.parse(value);
                            } else {
                              _netSalary = null;
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(left: 5.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Expenses',
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          focusNode: _expensesFocusNode,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the value';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value!.isNotEmpty) {
                              _expenses = double.parse(value);
                            } else {
                              _expenses = null;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    _saveForm();
                  },
                  child: const Text('Calculate'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
