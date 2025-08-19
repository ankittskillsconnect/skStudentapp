import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Model/WorkExperience_Model.dart';
import 'CustomDropDowns/CustomDropdownEducation.dart';

class EditWorkExperienceBottomSheet extends StatefulWidget {
  final WorkExperienceModel? initialData;
  final Function(WorkExperienceModel) onSave;

  const EditWorkExperienceBottomSheet({
    super.key,
    required this.initialData,
    required this.onSave,
  });

  @override
  State<EditWorkExperienceBottomSheet> createState() =>
      _EditWorkExperienceBottomSheetState();
}

class _EditWorkExperienceBottomSheetState
    extends State<EditWorkExperienceBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _jobTitleController;
  late TextEditingController _organizationController;
  late TextEditingController _skillsController;
  late TextEditingController _jobDescriptionController;

  late String _fromMonth;
  late String _fromYear;
  late String _toMonth;
  late String _toYear;

  late String experienceInYear;
  late String experienceInMonths;
  late String salaryInLakhs;
  late String salaryInThousands;

  bool saving = false;

  @override
  void initState() {
    super.initState();
    print('🔍 [EditWorkExperienceBottomSheet] Initializing');

    const validMonths = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final currentYear = DateTime.now().year;
    final validYears = List<String>.generate(30, (i) => (currentYear - i).toString());

    _jobTitleController = TextEditingController(
      text: widget.initialData?.jobTitle ?? '',
    );
    _organizationController = TextEditingController(
      text: widget.initialData?.organization ?? '',
    );
    _skillsController = TextEditingController(
      text: widget.initialData?.skills ?? '',
    );
    _jobDescriptionController = TextEditingController(
      text: widget.initialData?.jobDescription ?? '',
    );

    _fromMonth = validMonths.contains(widget.initialData?.exStartMonth)
        ? widget.initialData!.exStartMonth
        : 'Jan';

    _fromYear = validYears.contains(widget.initialData?.exStartYear)
        ? widget.initialData!.exStartYear
        : currentYear.toString();

    _toMonth = validMonths.contains(widget.initialData?.exEndMonth)
        ? widget.initialData!.exEndMonth
        : 'Jan';

    _toYear = validYears.contains(widget.initialData?.exEndYear)
        ? widget.initialData!.exEndYear
        : currentYear.toString();

    experienceInYear = widget.initialData?.totalExperienceYears ?? '0';
    experienceInMonths = widget.initialData?.totalExperienceMonths ?? '0';
    salaryInLakhs = widget.initialData?.salaryInLakhs ?? '0';
    salaryInThousands = widget.initialData?.salaryInThousands ?? '0';

    print('🔍 [EditWorkExperienceBottomSheet] Loaded initial data: ${widget.initialData?.jobTitle ?? 'N/A'}');
  }

  @override
  void dispose() {
    print('🔍 [EditWorkExperienceBottomSheet] Disposing controllers');
    _jobTitleController.dispose();
    _organizationController.dispose();
    _skillsController.dispose();
    _jobDescriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      print('⚠️ [EditWorkExperienceBottomSheet] Form validation failed');
      return;
    }
    print('🔍 [EditWorkExperienceBottomSheet] Saving work experience');
    setState(() => saving = true);
    final workExperience = WorkExperienceModel(
      workExperienceId: widget.initialData?.workExperienceId,
      jobTitle: _jobTitleController.text.trim(),
      organization: _organizationController.text.trim(),
      skills: _skillsController.text.trim(),
      workFromDate: '$_fromMonth-$_fromYear',
      workToDate: '$_toMonth-$_toYear',
      totalExperienceYears: experienceInYear,
      totalExperienceMonths: experienceInMonths,
      salaryInLakhs: salaryInLakhs,
      salaryInThousands: salaryInThousands,
      jobDescription: _jobDescriptionController.text.trim(),
      exStartMonth: _fromMonth,
      exStartYear: _fromYear,
      exEndMonth: _toMonth,
      exEndYear: _toYear,
    );
    widget.onSave(workExperience);
    print('✅ [EditWorkExperienceBottomSheet] Work experience saved: ${workExperience.jobTitle}');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844), minTextAdapt: true, splitScreenMode: true);
    print('🔍 [EditWorkExperienceBottomSheet] Rendering');

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 18.1.w,
            vertical: 9.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.1.r)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Work Experience',
                      style: TextStyle(
                        fontSize: 16.2.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF003840),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: const Color(0xFF005E6A), size: 17.7.w),
                      onPressed: () {
                        print('🔍 [EditWorkExperienceBottomSheet] Closing bottom sheet');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 18.1.h,
                      top: 9.h,
                    ),
                    children: [
                      _buildLabel("Job Title"),
                      _buildTextField("Enter Job name", _jobTitleController),
                      _buildLabel("Company Name"),
                      _buildTextField("Enter issuing organization", _organizationController),
                      _buildLabel("Add Skills"),
                      _buildTextField("Enter skills", _skillsController),
                      _buildLabel("From Date"),
                      _buildDateRow(
                        _fromMonth,
                        _fromYear,
                            (val) {
                          setState(() => _fromMonth = val);
                          print('🔍 [EditWorkExperienceBottomSheet] From month changed to: $val');
                        },
                            (val) {
                          setState(() => _fromYear = val);
                          print('🔍 [EditWorkExperienceBottomSheet] From year changed to: $val');
                        },
                      ),
                      _buildLabel("To Date"),
                      _buildDateRow(
                        _toMonth,
                        _toYear,
                            (val) {
                          setState(() => _toMonth = val);
                          print('🔍 [EditWorkExperienceBottomSheet] To month changed to: $val');
                        },
                            (val) {
                          setState(() => _toYear = val);
                          print('🔍 [EditWorkExperienceBottomSheet] To year changed to: $val');
                        },
                      ),
                      _buildLabel("Experience"),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Years"),
                                _dropdownField(
                                  value: experienceInYear,
                                  items: List.generate(31, (i) => "$i"),
                                  onChanged: (val) {
                                    setState(() => experienceInYear = val!);
                                    print('🔍 [EditWorkExperienceBottomSheet] Experience years changed to: $val');
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 14.4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Months"),
                                _dropdownField(
                                  value: experienceInMonths,
                                  items: List.generate(12, (i) => "${i + 1}"),
                                  onChanged: (val) {
                                    setState(() => experienceInMonths = val!);
                                    print('🔍 [EditWorkExperienceBottomSheet] Experience months changed to: $val');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _buildLabel("Current Salary"),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Lakhs"),
                                _dropdownField(
                                  value: salaryInLakhs,
                                  items: List.generate(31, (i) => "$i"),
                                  onChanged: (val) {
                                    setState(() => salaryInLakhs = val!);
                                    print('🔍 [EditWorkExperienceBottomSheet] Salary lakhs changed to: $val');
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 14.4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Thousands"),
                                _dropdownField(
                                  value: salaryInThousands,
                                  items: ["0", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60", "65", "70", "75", "80", "85", "90", "95"],
                                  onChanged: (val) {
                                    setState(() => salaryInThousands = val!);
                                    print('🔍 [EditWorkExperienceBottomSheet] Salary thousands changed to: $val');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _buildLabel("Add Details"),
                      _buildTextField("Job details ", _jobDescriptionController),
                      SizedBox(height: 27.1.h),
                      ElevatedButton(
                        onPressed: saving ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005E6A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27.1.r),
                          ),
                          minimumSize: Size.fromHeight(45.1.h),
                        ),
                        child: saving
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
                          style: TextStyle(color: Colors.white, fontSize: 13.7.sp),
                        ),
                      ),
                      SizedBox(height: 9.h),
                    ],
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
      padding: EdgeInsets.only(top: 14.4.h, bottom: 5.4.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.4.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xff003840),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    final focusNode = FocusNode();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.4.h),
      child: EnsureVisibleWhenFocused(
        focusNode: focusNode,
        child: SearchableDropdownField(
          value: value.isNotEmpty && items.contains(value) ? value : items.first,
          items: items,
          onChanged: onChanged,
          label: 'Please select',
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
    final focusNode = FocusNode();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.4.h),
      child: EnsureVisibleWhenFocused(
        focusNode: focusNode,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 12.4.sp),
            suffixIcon: suffixIcon != null
                ? IconButton(icon: Icon(suffixIcon, size: 17.7.w), onPressed: onTap)
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.8.r)),
          ),
          style: TextStyle(fontSize: 12.4.sp),
        ),
      ),
    );
  }

  Widget _buildDateRow(
      String month,
      String year,
      Function(String) onMonthChanged,
      Function(String) onYearChanged,
      ) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final years = List.generate(30, (index) => (2000 + index).toString());
    return Row(
      children: [
        Expanded(
          child: _dropdownField(
            value: month,
            items: months,
            onChanged: (val) => onMonthChanged(val!),
          ),
        ),
        SizedBox(width: 14.4.w),
        Expanded(
          child: _dropdownField(
            value: year,
            items: years,
            onChanged: (val) => onYearChanged(val!),
          ),
        ),
      ],
    );
  }
}

class EnsureVisibleWhenFocused extends StatefulWidget {
  final FocusNode focusNode;
  final Widget child;

  const EnsureVisibleWhenFocused({
    super.key,
    required this.focusNode,
    required this.child,
  });

  @override
  State<EnsureVisibleWhenFocused> createState() => _EnsureVisibleWhenFocusedState();
}

class _EnsureVisibleWhenFocusedState extends State<EnsureVisibleWhenFocused> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_ensureVisible);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_ensureVisible);
    super.dispose();
  }

  void _ensureVisible() {
    if (widget.focusNode.hasFocus) {
      final RenderObject? object = context.findRenderObject();
      if (object is RenderBox) {
        final ScrollableState? scrollable = Scrollable.of(context);
        if (scrollable != null) {
          final position = scrollable.position;
          final offset = object.localToGlobal(Offset.zero, ancestor: scrollable.context.findRenderObject());
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          final targetOffset = offset.dy - keyboardHeight - 18.1.h;
          position.ensureVisible(
            object,
            alignment: 0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
          final maxScrollExtent = position.maxScrollExtent;
          if (targetOffset > maxScrollExtent) {
            position.jumpTo(maxScrollExtent);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}