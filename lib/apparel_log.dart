import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productivity_log/my_app_bar.dart';
import 'dart:math';

class AssociateShift {
  final String name;
  final TimeOfDay shiftStart;
  final TimeOfDay shiftEnd;
  
  AssociateShift({required this.name, required this.shiftStart, required this.shiftEnd});
}

class ApparelLogPage extends StatefulWidget {
  const ApparelLogPage({super.key});

  @override
  State<ApparelLogPage> createState() => _ApparelLogPageState();
}

class _ApparelLogPageState extends State<ApparelLogPage> {
  final List<AssociateShift> _shifts = [];
  final _formKey = GlobalKey<FormState>();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _procStartTimeController = TextEditingController(text: '7:00 AM');
  final _huddleController = TextEditingController(text: "0");
  final _associateController = TextEditingController();
  static const int boxTime = 33;
  static const int minHour = 6;
  static const int maxHour = 22;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  TimeOfDay procStartTime = TimeOfDay(hour: 7, minute: 0);
  int totalMinutes = 0;
  String totalFull = '00:00';
  int expectedBoxes = 0;

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    _procStartTimeController.dispose();
    _huddleController.dispose();
    _associateController.dispose();
    super.dispose();
  }


  // Huddle length value changed.
  void _huddleLengthChanged(){
    setState(() {
      _calculateTotalProcessingTime();
      totalFull = _formatTotalProcessingTime();
      expectedBoxes = totalMinutes ~/ boxTime;
    });
  }

  // Check if time picker input is valid.
  bool _isValidShiftTime(){
  if(startTime.hour >= minHour && (endTime.hour <= maxHour && endTime.hour > startTime.hour)){
    return true;
  }
    return false;
  }

  // Select a shift start time.
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 7, minute: 00),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) {
      setState(() {
        startTime = picked;
        _startTimeController.text = startTime.format(context);
      });
    }
  }

  // Select a shift end time.
  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 11, minute: 00),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) {
      setState(() {
        endTime = picked;
        _endTimeController.text = endTime.format(context);
      });
    }
  }

  // Select the time processing started.
  Future<void> _selectProcStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: procStartTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null && procStartTime != picked) {
      setState(() {
        procStartTime = picked;
        _procStartTimeController.text = procStartTime.format(context);
        _calculateTotalProcessingTime();
        totalFull = _formatTotalProcessingTime();
        expectedBoxes = totalMinutes ~/ boxTime;
      });
    }
  }

  // Get amount of processing hours in current shifts.
  void _calculateTotalProcessingTime(){
    int total = 0;
    for (var shift in _shifts){
      int startMinutes = shift.shiftStart.hour * 60 + shift.shiftStart.minute;
      int endMinutes = shift.shiftEnd.hour * 60 + shift.shiftEnd.minute;
      int procMinutes = procStartTime.hour * 60 + procStartTime.minute;

      int procStartDiff = max(0, procMinutes - startMinutes);

      // End minutes always larger than start minutes.
      int differenceInMinutes = endMinutes - startMinutes;
      int huddleTime = 0;
      if(shift.shiftStart .hour <= 9){
        huddleTime = int.tryParse(_huddleController.text) ?? 0;
      }
      total += differenceInMinutes - _calculateBreak(differenceInMinutes) - procStartDiff - huddleTime;
    }
    totalMinutes = total;
  }
  
  // Format total processing hours.
  String _formatTotalProcessingTime(){
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }

  // Add an associates shift to the shift list.
  void _addItem() {
    if(_isValidShiftTime()){
      setState(() {
        _shifts.add(AssociateShift(name: _associateController.text, shiftStart: startTime, shiftEnd: endTime));
        _calculateTotalProcessingTime();
        totalFull = _formatTotalProcessingTime();
        expectedBoxes = totalMinutes ~/ boxTime;
      });
      _associateController.clear();
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Invalid Time'),
          content: const Text('Please select a business hour between 9:00 AM and 5:00 PM.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Remove and associate shift from the shift list.
  void _removeItem(int index) {
    setState(() {
      _shifts.removeAt(index);
      _calculateTotalProcessingTime();
      totalFull = _formatTotalProcessingTime();
      expectedBoxes = totalMinutes ~/ 33;
    });
  }

  int _calculateBreak(int shiftMinutes){
    if(shiftMinutes < 300){
      return 15;
    }
    else if(shiftMinutes >= 300 && shiftMinutes < 420){
      return 40;
    }
    else{
      return 55;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Apparel Log'),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isMobile = constraints.maxWidth < 600.0;
          return Align(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: BoxConstraints(maxWidth: 800.0),
              color: Color(0xFF060606),
              padding: const EdgeInsets.all(8.0),
              child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInfoColumn(),
                    SizedBox(height: 24.0),
                    Expanded(child: _buildInputColumn()),
                  ],
                )
              : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Expanded(child:_buildInfoColumn()),
                    SizedBox(width: 40.0),
                    Expanded(child: _buildInputColumn()),
                  ],
                ),
            ),
          );
        },
      ),
    );
  }


  // Shift input column.
  Widget _buildInputColumn() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Associate name input field.
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _associateController,
              decoration: InputDecoration(labelText: 'Associate', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  // Associate shift start time input.
                  child: TextFormField(
                    readOnly: true,
                    controller: _startTimeController,
                    decoration: InputDecoration(labelText: 'Start', border: OutlineInputBorder()),
                    onTap: () => _selectStartTime(context),
                  ),
                ),
                SizedBox(width: 8.0),
                Text('-', style: TextStyle(fontSize: 32.0)),
                SizedBox(width: 8.0),
                Expanded(
                  // Associate shift end time input.
                  child: TextFormField(
                    readOnly: true,
                    controller: _endTimeController,
                    decoration: InputDecoration(labelText: 'End', border: OutlineInputBorder()),
                    onTap: () => _selectEndTime(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            // Add associate shift button.
            ElevatedButton(
              onPressed: () => _addItem(),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50.0)),
              child: Text('Add'),
            ),
            SizedBox(height: 24.0),
            // Added associate shifts list.
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _shifts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final item = _shifts[index];
                return Material (
                  color: Color(0xFF232323),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(' ${item.shiftStart.format(context)} - ${item.shiftEnd.format(context)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeItem(index),
                    )
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Info column and starting inputs.
  Widget _buildInfoColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 8.0)),
        // Processing start time input field.
        TextFormField(
          readOnly: true,
          controller: _procStartTimeController,
          decoration: InputDecoration(labelText: 'Processing Start Time', border: OutlineInputBorder()),
          onTap: () => _selectProcStartTime(context)
        ),
        SizedBox(height: 16.0),
        // Time huddle took input field. Only digits allowed.
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: _huddleController,
          decoration: InputDecoration(labelText: 'Huddle length (minutes)', border: OutlineInputBorder()),
          onChanged: (value) => _huddleLengthChanged(),
        ),
        SizedBox(height: 16.0),
        Text('Total associate processing hours: $totalFull'),
        SizedBox(height: 16.0),
        Text('Expected: $expectedBoxes')
      ],
    );
  }
}