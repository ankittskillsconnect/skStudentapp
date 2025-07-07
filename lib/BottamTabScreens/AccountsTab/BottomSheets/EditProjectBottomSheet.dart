import 'package:flutter/material.dart';

class EditProjectDetailsBottomSheet extends StatefulWidget {
  final String? initialData;
  final String projectName;
  final String companyName;
  final String projectType;
  final String skills;
  final String startDate;
  final String endDate;
  final String projectDetail;
  final Function(Map<String, dynamic> data) onSave;

  const EditProjectDetailsBottomSheet({
    super.key,
    this.initialData,
    required this.onSave,
    required this.projectName,
    required this.companyName,
    required this.projectType,
    required this.skills,
    required this.startDate,
    required this.endDate,
    required this.projectDetail,
  });

  @override
  State<EditProjectDetailsBottomSheet> createState() =>
      _EditProjectDetailsBottomSheetState();
}

class _EditProjectDetailsBottomSheetState
    extends State<EditProjectDetailsBottomSheet> {
  late TextEditingController _companyNameController;
  late TextEditingController _projectNameController;
  late TextEditingController _skillsController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _projectDetailController;
  late String projectType;

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController(
      text: widget.initialData == null ? '' : widget.companyName,
    );
    _projectNameController = TextEditingController(
      text: widget.initialData == null ? '' : widget.projectName,
    );
    _skillsController = TextEditingController(
      text: widget.initialData == null ? '' : widget.skills,
    );
    _startDateController = TextEditingController(
      text: widget.initialData == null ? '' : widget.startDate,
    );
    _endDateController = TextEditingController(
      text: widget.initialData == null ? '' : widget.endDate,
    );
    _projectDetailController = TextEditingController(
      text: widget.initialData == null ? '' : widget.projectDetail,
    );
    projectType = widget.initialData == null
        ? 'Internship'
        : widget.projectType;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _projectNameController.dispose();
    _skillsController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _projectDetailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  String _formatProjectDetail() {
    return '''
${_projectNameController.text}\nCompany: ${_companyNameController.text}\nType: $projectType\nDuration: ${_startDateController.text} - ${_endDateController.text}\nSkills: ${_skillsController.text}\n${_projectDetailController.text}
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
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
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
                      'Edit Project Details',
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
                Expanded(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildLabel("Project Type"),
                        _dropdownField(
                          value: projectType,
                          items: const ["Internship", "Project"],
                          onChanged: (val) =>
                              setState(() => projectType = val!),
                        ),
                        _buildLabel("Project Name"),
                        _buildTextField(
                          "Enter project name",
                          _projectNameController,
                        ),
                        _buildLabel("Company Name"),
                        _buildTextField(
                          "Enter company name",
                          _companyNameController,
                        ),
                        _buildLabel("Skills"),
                        _buildTextField("Enter skills", _skillsController),
                        _buildLabel("Start Date"),
                        _buildTextField(
                          "Select start date",
                          _startDateController,
                          SufficxIcon: Icons.calendar_month_rounded,
                          readOnly: true,
                          onTap: () =>
                              _selectDate(context, _startDateController),
                        ),
                        _buildLabel("End Date"),
                        _buildTextField(
                          "Select end date",
                          SufficxIcon: Icons.calendar_month_rounded,
                          _endDateController,
                          readOnly: true,
                          onTap: () => _selectDate(context, _endDateController),
                        ),
                        _buildLabel("Project Detail"),
                        _buildTextField(
                          "Enter project details",
                          _projectDetailController,
                        ),
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
                              'projectDetail': _formatProjectDetail(),
                              'projectName': _projectNameController.text,
                              'companyName': _companyNameController.text,
                              'projectType': projectType,
                              'skills': _skillsController.text,
                              'startDate': _startDateController.text,
                              'endDate': _endDateController.text,
                              'projectDetailDesc':
                                  _projectDetailController.text,
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
                ),
              ],
            ),
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
    return DropdownButtonFormField<String>(
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
    );
  }

  Widget _buildTextField(
    String hintText,
    TextEditingController controller, {
    IconData? SufficxIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    VoidCallback? SuffixIconPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: SufficxIcon != null
              ? IconButton(
                  icon: Icon(SufficxIcon),
                  onPressed: SuffixIconPressed,
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
