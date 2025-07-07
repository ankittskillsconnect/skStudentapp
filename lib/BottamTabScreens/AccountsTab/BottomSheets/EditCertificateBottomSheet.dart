import 'package:flutter/material.dart';

class EditCertificateBottomSheet extends StatefulWidget {
  final String? initialData;
  final String certificateName;
  final String issuedBy;
  final String credentialId;
  final String issuedDate;
  final String expiredDate;
  final String description;
  final Function(Map<String, dynamic> data) onSave;

  const EditCertificateBottomSheet({
    super.key,
    this.initialData,
    required this.onSave,
    required this.certificateName,
    required this.issuedBy,
    required this.credentialId,
    required this.issuedDate,
    required this.expiredDate,
    required this.description,
  });

  @override
  State<EditCertificateBottomSheet> createState() =>
      _EditCertificateBottomSheetState();
}

class _EditCertificateBottomSheetState
    extends State<EditCertificateBottomSheet> {
  late TextEditingController _certificateNameController;
  late TextEditingController _issuedByController;
  late TextEditingController _credentialIdController;
  late TextEditingController _issuedDateController;
  late TextEditingController _expiredDateController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _certificateNameController = TextEditingController(
      text: widget.initialData == null ? '' : widget.certificateName,
    );
    _issuedByController = TextEditingController(
      text: widget.initialData == null ? '' : widget.issuedBy,
    );
    _credentialIdController = TextEditingController(
      text: widget.initialData == null ? '' : widget.credentialId,
    );
    _issuedDateController = TextEditingController(
      text: widget.initialData == null ? '' : widget.issuedDate,
    );
    _expiredDateController = TextEditingController(
      text: widget.initialData == null ? '' : widget.expiredDate,
    );
    _descriptionController = TextEditingController(
      text: widget.initialData == null ? '' : widget.description,
    );
  }

  @override
  void dispose() {
    _certificateNameController.dispose();
    _issuedByController.dispose();
    _credentialIdController.dispose();
    _issuedDateController.dispose();
    _expiredDateController.dispose();
    _descriptionController.dispose();
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

  String _formatCertificateDetail() {
    return '''
${_certificateNameController.text}\nIssued By: ${_issuedByController.text}\nCredential ID: ${_credentialIdController.text}\nIssued: ${_issuedDateController.text} - Expires: ${_expiredDateController.text}\n${_descriptionController.text}
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
                    'Edit Certificate',
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
                    _buildLabel("Certificate Name"),
                    _buildTextField(
                      "Enter certificate name",
                      _certificateNameController,
                    ),
                    _buildLabel("Issued By"),
                    _buildTextField(
                      "Enter issuing organization",
                      _issuedByController,
                    ),
                    _buildLabel("Credential ID"),
                    _buildTextField(
                      "Enter credential ID",
                      _credentialIdController,
                    ),
                    _buildLabel("Issued Date"),
                    _buildTextField(
                      "Select issued date",
                      _issuedDateController,
                      suffixIcon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(context, _issuedDateController),
                    ),
                    _buildLabel("Expired Date"),
                    _buildTextField(
                      "Select expiration date",
                      _expiredDateController,
                      suffixIcon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(context, _expiredDateController),
                    ),
                    _buildLabel("Description"),
                    _buildTextField(
                      "Enter description",
                      _descriptionController,
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
                          'certificateDetail': _formatCertificateDetail(),
                          'certificateName': _certificateNameController.text,
                          'issuedBy': _issuedByController.text,
                          'credentialId': _credentialIdController.text,
                          'issuedDate': _issuedDateController.text,
                          'expiredDate': _expiredDateController.text,
                          'description': _descriptionController.text,
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
  //
  // Widget _dropdownField({
  //   required String value,
  //   required List<String> items,
  //   required void Function(String?) onChanged,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6),
  //     child: DropdownButtonFormField<String>(
  //       value: value.isEmpty || !items.contains(value) ? items[0] : value,
  //       items: items
  //           .map((e) => DropdownMenuItem(value: e, child: Text(e)))
  //           .toList(),
  //       onChanged: onChanged,
  //       decoration: InputDecoration(
  //         hintText: 'Please select',
  //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //         contentPadding: const EdgeInsets.symmetric(
  //           horizontal: 12,
  //           vertical: 14,
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
