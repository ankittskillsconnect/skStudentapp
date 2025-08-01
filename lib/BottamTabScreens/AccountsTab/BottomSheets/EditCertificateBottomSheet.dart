import 'package:flutter/material.dart';
import '../../../Model/CertificateDetails_Model.dart';

class EditCertificateBottomSheet extends StatefulWidget {
  final CertificateModel? initialData;
  final Function(CertificateModel) onSave;

  const EditCertificateBottomSheet({
    super.key,
    this.initialData,
    required this.onSave,
  });

  @override
  State<EditCertificateBottomSheet> createState() => _EditCertificateBottomSheetState();
}

class _EditCertificateBottomSheetState extends State<EditCertificateBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _certificateNameController;
  late TextEditingController _issuedOrgController;
  late TextEditingController _credIdController;
  late TextEditingController _urlController;
  late TextEditingController _descriptionController;

  String _issueMonth = 'Jan';
  String _issueYear = '2025';
  String _expiryMonth = 'Jan';
  String _expiryYear = '2025';

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    _certificateNameController = TextEditingController(text: data?.certificateName ?? '');
    _issuedOrgController = TextEditingController(text: data?.issuedOrgName ?? '');
    _credIdController = TextEditingController(text: data?.credId ?? '');
    _urlController = TextEditingController(text: data?.url ?? '');
    _descriptionController = TextEditingController(text: data?.description ?? '');

    if (data != null) {
      final issueParts = data.issueDate.split('-');
      final expiryParts = data.expiryDate.split('-');
      if (issueParts.length == 2) {
        _issueYear = issueParts[0];
        _issueMonth = CertificateModel.numberToMonth(issueParts[1]);
      }
      if (expiryParts.length == 2) {
        _expiryYear = expiryParts[0];
        _expiryMonth = CertificateModel.numberToMonth(expiryParts[1]);
      }
    }
  }

  @override
  void dispose() {
    _certificateNameController.dispose();
    _issuedOrgController.dispose();
    _credIdController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final certificate = CertificateModel(
      certificationId: widget.initialData?.certificationId,
      certificateName: _certificateNameController.text.trim(),
      issuedOrgName: _issuedOrgController.text.trim(),
      credId: _credIdController.text.trim(),
      issueDate: '$_issueYear-${CertificateModel.monthToNumber(_issueMonth)}',
      expiryDate: '$_expiryYear-${CertificateModel.monthToNumber(_expiryMonth)}',
      description: _descriptionController.text.trim(),
      url: _urlController.text.trim(),
      userId: widget.initialData?.userId,
    );
    widget.onSave(certificate);
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
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit Certificate Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildLabel('Certificate Name'),
                        _buildTextField(_certificateNameController, 'Enter certificate name'),
                        _buildLabel('Issued Organization'),
                        _buildTextField(_issuedOrgController, 'Enter organization name'),
                        _buildLabel('Credential ID'),
                        _buildTextField(_credIdController, 'Enter credential ID'),
                        _buildLabel('Credential URL'),
                        _buildTextField(_urlController, 'Enter URL', required: false),
                        _buildLabel('Description'),
                        _buildTextField(_descriptionController, 'Enter description'),
                        _buildLabel('Issued Date'),
                        _buildDateRow(_issueMonth, _issueYear,
                                (m) => setState(() => _issueMonth = m),
                                (y) => setState(() => _issueYear = y)),
                        _buildLabel('Expiry Date'),
                        _buildDateRow(_expiryMonth, _expiryYear,
                                (m) => setState(() => _expiryMonth = m),
                                (y) => setState(() => _expiryYear = y)),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: isSaving ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005E6A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: isSaving
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
  );

  Widget _buildTextField(TextEditingController controller, String label, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        validator: (value) => (required && (value == null || value.trim().isEmpty)) ? 'Required' : null,
      ),
    );
  }

  Widget _buildDateRow(String month, String year, Function(String) onMonthChanged, Function(String) onYearChanged) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Month',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            value: month,
            onChanged: (val) => onMonthChanged(val!),
            items: _monthItems(),
            isExpanded: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Year',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            value: year,
            onChanged: (val) => onYearChanged(val!),
            items: _yearItems(),
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _monthItems() {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList();
  }

  List<DropdownMenuItem<String>> _yearItems() {
    final currentYear = DateTime.now().year;
    return List.generate(20, (i) {
      final year = (currentYear - i).toString();
      return DropdownMenuItem(value: year, child: Text(year));
    });
  }
}