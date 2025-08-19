import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Model/CertificateDetails_Model.dart';
import 'CustomDropDowns/CustomDropDownCertificate.dart';

class EditCertificateBottomSheet extends StatefulWidget {
  final CertificateModel? initialData;
  final Function(CertificateModel) onSave;

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
    print('🔍 [EditCertificateBottomSheet] Initializing');
    final data = widget.initialData;
    _certificateNameController =
        TextEditingController(text: data?.certificateName ?? '');
    _issuedOrgController =
        TextEditingController(text: data?.issuedOrgName ?? '');
    _credIdController = TextEditingController(text: data?.credId ?? '');
    _urlController = TextEditingController(text: data?.url ?? '');
    _descriptionController =
        TextEditingController(text: data?.description ?? '');

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
      print(
          '🔍 [EditCertificateBottomSheet] Loaded initial data: ${data.certificateName ?? 'N/A'}');
    }
  }

  @override
  void dispose() {
    print('🔍 [EditCertificateBottomSheet] Disposing controllers');
    _certificateNameController.dispose();
    _issuedOrgController.dispose();
    _credIdController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      print('⚠️ [EditCertificateBottomSheet] Form validation failed');
      return;
    }

    print('🔍 [EditCertificateBottomSheet] Saving certificate');
    setState(() => isSaving = true);

    final certificate = CertificateModel(
      certificationId: widget.initialData?.certificationId,
      certificateName: _certificateNameController.text.trim(),
      issuedOrgName: _issuedOrgController.text.trim(),
      credId: _credIdController.text.trim(),
      issueDate: '$_issueYear-${CertificateModel.monthToNumber(_issueMonth)}',
      expiryDate:
          '$_expiryYear-${CertificateModel.monthToNumber(_expiryMonth)}',
      description: _descriptionController.text.trim(),
      url: _urlController.text.trim(),
      userId: widget.initialData?.userId,
    );
    widget.onSave(certificate);
    print(
        '✅ [EditCertificateBottomSheet] Certificate saved: ${certificate.certificateName}');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true);
    print('🔍 [EditCertificateBottomSheet] Rendering');

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.9,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: EdgeInsets.only(
              left: 14.4.w,
              right: 14.4.w,
              top: 9.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 9.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.1.r)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Certificate Details',
                        style: TextStyle(
                          fontSize: 16.2.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 17.7.w),
                        onPressed: () {
                          print(
                              '🔍 [EditCertificateBottomSheet] Closing bottom sheet');
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildLabel('Certificate Name'),
                        _buildTextField(_certificateNameController),
                        _buildLabel('Issued Organization'),
                        _buildTextField(_issuedOrgController),
                        _buildLabel('Credential ID'),
                        _buildTextField(_credIdController),
                        _buildLabel('Credential URL'),
                        _buildTextField(_urlController, required: false),
                        _buildLabel('Description'),
                        _buildTextField(_descriptionController),
                        _buildLabel('Issued Date'),
                        _buildDateRow(_issueMonth, _issueYear, (m) {
                          setState(() => _issueMonth = m);
                          print(
                              '🔍 [EditCertificateBottomSheet] Issue month changed to: $m');
                        }, (y) {
                          setState(() => _issueYear = y);
                          print(
                              '🔍 [EditCertificateBottomSheet] Issue year changed to: $y');
                        }),
                        _buildLabel('Expiry Date'),
                        _buildDateRow(_expiryMonth, _expiryYear, (m) {
                          setState(() => _expiryMonth = m);
                          print(
                              '🔍 [EditCertificateBottomSheet] Expiry month changed to: $m');
                        }, (y) {
                          setState(() => _expiryYear = y);
                          print(
                              '🔍 [EditCertificateBottomSheet] Expiry year changed to: $y');
                        }),
                        SizedBox(height: 27.1.h),
                        ElevatedButton(
                          onPressed: isSaving ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005E6A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27.1.r),
                            ),
                            minimumSize: Size.fromHeight(45.1.h),
                          ),
                          child: isSaving
                              ? SizedBox(
                                  height: 18.1.h,
                                  width: 18.1.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.8.w,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.7.sp),
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
        padding: EdgeInsets.only(top: 10.8.h, bottom: 5.4.h),
        child: Text(text,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.4.sp)),
      );

  Widget _buildTextField(TextEditingController controller,
      {bool required = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.8.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.8.r)),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 10.8.w, vertical: 7.2.h),
        ),
        style: TextStyle(fontSize: 12.4.sp),
        validator: (value) =>
            (required && (value == null || value.trim().isEmpty))
                ? 'Required'
                : null,
      ),
    );
  }

  Widget _buildDateRow(String month, String year,
      Function(String) onMonthChanged, Function(String) onYearChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.8.h),
      child: Row(
        children: [
          Expanded(
            child: CustomFieldCertificateDropdown(
              const [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec'
              ],
              month,
              (val) => onMonthChanged(val ?? 'Jan'),
              label: 'Month',
            ),
          ),
          SizedBox(width: 10.8.w),
          Expanded(
            child: CustomFieldCertificateDropdown(
              _yearItems()
                  .map((item) => item.value!)
                  .whereType<String>()
                  .toList(),
              year,
              (val) => onYearChanged(val ?? '2025'),
              label: 'Year',
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _yearItems() {
    final currentYear = DateTime.now().year;
    final selectedYears = {
      int.tryParse(_issueYear) ?? currentYear,
      int.tryParse(_expiryYear) ?? currentYear,
    };
    final startYear = currentYear - 35;
    final endYear = currentYear + 10;
    final allYears = {
      for (int year = startYear; year <= endYear; year++) year,
      ...selectedYears,
    }.toList()
      ..sort((a, b) => b.compareTo(a));

    return allYears.map((year) {
      final yearStr = year.toString();
      return DropdownMenuItem(
          value: yearStr,
          child: Text(yearStr, style: TextStyle(fontSize: 12.4.sp)));
    }).toList();
  }
}
