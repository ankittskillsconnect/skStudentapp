import 'package:flutter/material.dart';
import 'package:sk_loginscreen1/Model/Internship_Projects_Model.dart';

class EditProjectDetailsBottomSheet extends StatefulWidget {
  final InternshipProjectModel? initialData;
  final Function(InternshipProjectModel) onSave;

  const EditProjectDetailsBottomSheet({
    Key? key,
    this.initialData,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditProjectDetailsBottomSheet> createState() => _EditProjectDetailsBottomSheetState();
}

class _EditProjectDetailsBottomSheetState extends State<EditProjectDetailsBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController typeController;
  late TextEditingController projectNameController;
  late TextEditingController companyNameController;
  late TextEditingController skillsController;
  late TextEditingController durationController;
  late TextEditingController durationPeriodController;
  late TextEditingController detailsController;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    typeController = TextEditingController(text: d?.type ?? '');
    projectNameController = TextEditingController(text: d?.projectName ?? '');
    companyNameController = TextEditingController(text: d?.companyName ?? '');
    skillsController = TextEditingController(text: d?.skills ?? '');
    durationController = TextEditingController(text: d != null ? d.duration.toString() : '');
    durationPeriodController = TextEditingController(text: d?.durationPeriod ?? '');
    detailsController = TextEditingController(text: d?.details ?? '');
  }

  @override
  void dispose() {
    typeController.dispose();
    projectNameController.dispose();
    companyNameController.dispose();
    skillsController.dispose();
    durationController.dispose();
    durationPeriodController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final newData = InternshipProjectModel(
        type: typeController.text,
        projectName: projectNameController.text,
        companyName: companyNameController.text,
        skills: skillsController.text,
        duration: int.tryParse(durationController.text) ?? 0,
        durationPeriod: durationPeriodController.text,
        details: detailsController.text,
      );
      widget.onSave(newData);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.9,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                controller: scrollController,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Project Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003840),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF005E6A)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  _buildLabel("Project Type"),
                  _buildTextField("Please select", typeController),
                  _buildLabel("Project Name"),
                  _buildTextField("Please select", projectNameController),
                  _buildLabel("Company Name"),
                  _buildTextField("Please select", companyNameController),
                  _buildLabel("Skills"),
                  _buildTextField("Please select", skillsController),
                  _buildLabel("Duration (number only)"),
                  _buildTextField("Please select", durationController, keyboardType: TextInputType.number),
                  _buildLabel("Duration Period"),
                  _buildTextField("Please select", durationPeriodController),
                  _buildLabel("Project Details"),
                  _buildTextField("Please select", detailsController, maxLines: 4),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005E6A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: _handleSave,
                    child: const Text("Save", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
Widget _buildLabel(String text) => Padding(
  padding: const EdgeInsets.only(top: 12, bottom: 6),
  child: Text(
    text,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Color(0xff003840),
    ),
  ),
);

Widget _buildTextField(String label, TextEditingController controller,
    {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) =>
      (value == null || value.trim().isEmpty) ? 'Required' : null,
    ),
  );
}