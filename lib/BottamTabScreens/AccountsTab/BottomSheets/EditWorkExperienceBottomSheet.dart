import 'package:flutter/material.dart';

class Editworkexperiencebottomsheet extends StatefulWidget {
  final String? initialData;
  final String jobTitle;
  final String companyName;
  final String skills;
  final String fromDate;
  final String toDate;
  final String experienceInYear;
  final String experienceInMonths;
  final String annualSalary;
  final String jobDetail;
  final Function(Map<String, dynamic> data) onSave;

  const Editworkexperiencebottomsheet({
    super.key,
    this.initialData,
    required this.onSave,
    required this.jobTitle,
    required this.companyName,
    required this.skills,
    required this.fromDate,
    required this.toDate,
    required this.experienceInYear,
    required this.experienceInMonths,
    required this.annualSalary,
    required this.jobDetail,
  });

  @override
  State<Editworkexperiencebottomsheet> createState() =>
      _EditworkexperiencebottomsheetState();
}

class _EditworkexperiencebottomsheetState
    extends State<Editworkexperiencebottomsheet> {
  late TextEditingController _jobTitleController;
  late TextEditingController _companyNameController;
  late TextEditingController _skillsController;
  late TextEditingController _fromDateController;
  late TextEditingController _toDateController;
  late String experienceInYear;
  late String experienceInMonths;
  late TextEditingController _annualSalaryController;
  late TextEditingController _jobDetailController;

  @override
  void initState() {
    super.initState();
    _jobTitleController = TextEditingController(
      text: widget.initialData == null ? '' : widget.jobTitle,
    );
    _companyNameController = TextEditingController(
      text: widget.initialData == null ? '' : widget.companyName,
    );
    _skillsController = TextEditingController(
      text: widget.initialData == null ? '' : widget.skills,
    );
    _fromDateController = TextEditingController(
      text: widget.initialData == null ? '' : widget.fromDate,
    );
    _toDateController = TextEditingController(
      text: widget.initialData == null ? '' : widget.toDate,
    );
    experienceInYear = widget.initialData == null
        ? '0'
        : widget.experienceInYear;
    experienceInMonths = widget.initialData == null
        ? '0'
        : widget.experienceInMonths;
    _annualSalaryController = TextEditingController(
      text: widget.initialData == null ? '' : widget.annualSalary,
    );
    _jobDetailController = TextEditingController(
      text: widget.initialData == null ? '' : widget.jobDetail,
    );
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyNameController.dispose();
    _skillsController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    _annualSalaryController.dispose();
    _jobDetailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime initialDate = DateTime.now();
    if (controller.text.isNotEmpty) {
      initialDate = DateTime.parse(controller.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  String _formatWorkExpDetail() {
    return '''
${_jobTitleController.text}\nCompany name : ${_companyNameController.text}\nskills: ${_skillsController.text}\n fromDate: ${_fromDateController.text} - toDate: ${_toDateController.text}- Experience Year - $experienceInYear
Experience month - $experienceInMonths AnnuaL Salary - ${_annualSalaryController.text} Job detail - ${_jobDetailController.text}
''';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double sizeScale = widthScale.clamp(0.98, 1.02);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20 * sizeScale,
            vertical: 10 * sizeScale,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Work Experience',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003840),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF005E6A)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  children: [
                    _buildLabel("Job Title"),
                    _buildTextField("Enter Job name", _jobTitleController),
                    _buildLabel("Company Name"),
                    _buildTextField(
                      "Enter issuing organization",
                      _companyNameController,
                    ),
                    _buildLabel("Add Skills"),
                    _buildTextField("Enter skills", _skillsController),
                    _buildLabel("From Date"),
                    _buildTextField(
                      "Select date",
                      _fromDateController,
                      suffixIcon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(context, _fromDateController),
                    ),
                    _buildLabel("To Date"),
                    _buildTextField(
                      "Select  date",
                      _toDateController,
                      suffixIcon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(context, _toDateController),
                    ),
                    _buildLabel("Experience in years"),
                    _dropdownField(
                      value: experienceInYear,
                      items: const ["1", "2", "3", "4", "5", "6"],
                      onChanged: (val) =>
                          setState(() => experienceInYear = val!),
                    ),
                    _buildLabel("Experience in months"),
                    _dropdownField(
                      value: experienceInMonths,
                      items: const [
                        "1",
                        "2",
                        "3",
                        "4",
                        "5",
                        "6",
                        "7",
                        "8",
                        "9",
                        "10",
                        "11",
                        "12",
                      ],
                      onChanged: (val) =>
                          setState(() => experienceInMonths = val!),
                    ),
                    _buildLabel("Annual Salary "),
                    _buildTextField("in LPA", _annualSalaryController),
                    _buildLabel("Add Details "),
                    _buildTextField("Job details ", _jobDetailController),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005E6A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        final data = {
                          'WorkExp': _formatWorkExpDetail(),
                          'jobTitle': _jobTitleController.text,
                          'companyName': _companyNameController.text,
                          'skills': _skillsController.text,
                          'fromDate': _fromDateController.text,
                          'toDate': _toDateController.text,
                          'experienceInYear': experienceInYear,
                          'experienceInMonths': experienceInMonths,
                          'annualSalary': _annualSalaryController.text,
                          'jobDetail': _jobDetailController.text,
                        };
                        widget.onSave(data);
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xff003840),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty || !items.contains(value) ? items[0] : value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Please select',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hintText,
    TextEditingController controller, {
    IconData? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon != null
              ? IconButton(icon: Icon(suffixIcon), onPressed: onTap)
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
