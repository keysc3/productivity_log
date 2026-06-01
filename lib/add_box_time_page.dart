import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productivity_log/my_app_bar.dart';

class AddBoxTimePage extends StatefulWidget {
  const AddBoxTimePage({super.key});

  @override
  State<AddBoxTimePage> createState() => _AddBoxTimePageState();
}

class _AddBoxTimePageState extends State<AddBoxTimePage> {
  
  final List<String> _items = ['Item 1', 'Item 2'];
  final _timeController = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _canSubmit = false;
  

  @override
  void dispose() {
    _timeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Submit all added entries.
  void _submitOnPress(){
    // TODO: Add entries to db.
    setState(() {
      _items.clear();
      _canSubmit = false;
    });
  }

  // Add box time to times to submit.
  void _addItem() {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _items.add('${_timeController.text} minutes on ${_dateController.text}');
        _canSubmit = true;
      });
      _timeController.clear();
    }
  }

  // Delete a box time from to be submitted list.
  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
      if(_items.isEmpty){
        _canSubmit = false;
      }
    });
  }

  // Date picker function.
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        // Only need the date.
        _dateController.text = picked.toString().split(' ')[0];
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Box Time',
      ),
      body: Align(
        alignment: AlignmentGeometry.topCenter,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Box time input. Only digits allowed.
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Please enter a number';
                      }
                      return null;
                    },
                    controller: _timeController,
                    decoration: InputDecoration(labelText: 'Time to complete (minutes)', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 16.0),
                  // Box date input.
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
                    onTap: () => _selectDate(),
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    children: [
                      Expanded(
                        // Submit all times button.
                        child: ElevatedButton(
                          onPressed: _canSubmit ? _submitOnPress : null,
                          style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50.0)),
                          child: Text('Submit'),
                        ),
                      ),
                      SizedBox(width: 12.0),
                      Expanded(
                        // Add a time button.
                        child: ElevatedButton(
                          onPressed: () => _addItem(),
                          style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50.0)),
                          child: Text('Add'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.0),
                  // Added box times list.
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_items[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteItem(index),
                        )
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}