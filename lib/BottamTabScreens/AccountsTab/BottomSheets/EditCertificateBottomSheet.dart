import 'package:flutter/material.dart';
import '../../../Model/CertificateDetails_Model.dart';

class EditCertificateBottomSheet extends StatefulWidget {
  final CertificateModel? initialData;
  final Function(CertificateModel model) onSave;

  const EditCertificateBottomSheet({
    super.key,
    this.initialData,
    required this.onSave,
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
      text: widget.initialData?.certificateName ?? '',
    );
    _issuedByController = TextEditingController(
      text: widget.initialData?.issuedOrgName ?? '',
    );
    _credentialIdController = TextEditingController(
      text: widget.initialData?.credId ?? '',
    );
    _issuedDateController = TextEditingController(
      text: widget.initialData?.issueDate ?? '',
    );
    _expiredDateController = TextEditingController(
      text: widget.initialData?.expiryDate ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialData?.description ?? '',
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
      try {
        initialDate = DateTime.parse(controller.text);
      } catch (_) {}
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
                      onTap: () =>
                          _selectDate(context, _issuedDateController),
                    ),
                    _buildLabel("Expired Date"),
                    _buildTextField(
                      "Select expiration date",
                      _expiredDateController,
                      suffixIcon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () =>
                          _selectDate(context, _expiredDateController),
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
                        final model = CertificateModel(
                          certificateName: _certificateNameController.text,
                          issuedOrgName: _issuedByController.text,
                          credId: _credentialIdController.text,
                          issueDate: _issuedDateController.text,
                          expiryDate: _expiredDateController.text,
                          description: _descriptionController.text,
                        );
                        widget.onSave(model);
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
