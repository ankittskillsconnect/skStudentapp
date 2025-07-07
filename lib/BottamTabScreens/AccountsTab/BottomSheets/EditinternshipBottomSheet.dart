import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Editinternshipbottomsheet extends StatefulWidget {
  final String initialData;
  final Function(String projectDetail) onSave;
  const Editinternshipbottomsheet({super.key, required this.initialData, required this.onSave});

  @override
  State<Editinternshipbottomsheet> createState() => _EditinternshipbottomsheetState();
}

class _EditinternshipbottomsheetState extends State<Editinternshipbottomsheet> {
late TextEditingController _internshipController;
  @override
  void initState() {
    super.initState();
    _internshipController = TextEditingController(text: widget.initialData ?? '');
  }

  @override
  void dispose() {
    _internshipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        builder: (context, ScrollController){
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: ScrollController,
          children: [
            const Text(
              'InternShip Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _internshipController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Your Internship Detail',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005E6A),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                widget.onSave(_internshipController.text.trim());
                Navigator.of(context).pop();
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      );
    });
  }
}
