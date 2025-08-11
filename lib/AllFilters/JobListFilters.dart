import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Joblistfilters extends StatefulWidget {
  final String jobType;
  final String jobTitle;
  final String workCulture;
  final String courses;
  final String cities;
  final String states;

  const Joblistfilters({
    super.key,
    required this.jobType,
    required this.jobTitle,
    required this.workCulture,
    required this.courses,
    required this.cities,
    required this.states,
  });

  @override
  State<Joblistfilters> createState() => _JoblistfiltersState();
}

class _JoblistfiltersState extends State<Joblistfilters>
    with SingleTickerProviderStateMixin {
  late String jobType;
  late TextEditingController jobTitleController;
  late String workCulture;
  late String courses;
  late String selectedCity;
  late String selectedState;

  @override
  Widget build(BuildContext context) {
    jobTitleController = TextEditingController(text: widget.jobTitle);
    jobType = widget.jobType;
    workCulture = widget.workCulture;
    courses = widget.courses;
    selectedCity = widget.cities;
    selectedState = widget.states;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF003840),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close,
                          color: const Color(0xFF005E6A), size: 22.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(thickness: 1.h),
                _buildLabel('Jobs Type'),
                _buildDropdownField(
                  value: jobType,
                  items: const ['Remote', 'In-office'],
                  onChanged: (val) => setState(() => jobType = val ?? ''),
                ),
                _buildLabel('Job Title'),
                _buildTextField('Enter Jobs title', jobTitleController),
                _buildLabel('Work culture'),
                _buildDropdownField(
                  value: workCulture,
                  items: const ['Hybrid', 'Flexible', 'Strict'],
                  onChanged: (val) => setState(() => workCulture = val ?? ''),
                ),
                _buildLabel('Jobs status'),
                _buildDropdownField(
                  value: '',
                  items: const ['Open', 'Closed'],
                  onChanged: (val) {},
                ),
                _buildLabel('Course'),
                _buildDropdownField(
                  value: courses,
                  items: const ['B.Tech', 'BBA', 'B.Sc', 'MBA'],
                  onChanged: (val) => setState(() => courses = val ?? ''),
                ),
                _buildLabel('State'),
                _buildDropdownField(
                  value: selectedState,
                  items: const ['Maharashtra', 'Karnataka', 'UP'],
                  onChanged: (val) => setState(() => selectedState = val ?? ''),
                ),
                _buildLabel('City'),
                _buildDropdownField(
                  value: selectedCity,
                  items: const ['Mumbai', 'Bangalore', 'New Delhi'],
                  onChanged: (val) => setState(() => selectedCity = val ?? ''),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'jobType': jobType,
                        'jobTitle': jobTitleController.text,
                        'workCulture': workCulture,
                        'courses': courses,
                        'cities': selectedCity,
                        'states': selectedState,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005E6A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 36.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: Text(
                      "Show Results",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
      padding: EdgeInsets.only(top: 8.h, bottom: 3.h),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
          color: const Color(0xFF003840),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hint,
      TextEditingController controller, {
        bool readOnly = false,
        IconData? suffixIcon,
        VoidCallback? onTap,
        Color? textColor,
      }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(color: textColor ?? Colors.black, fontSize: 13.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            color: textColor?.withOpacity(0.6) ?? Colors.grey, fontSize: 13.sp),
        suffixIcon:
        suffixIcon != null ? Icon(suffixIcon, size: 18.sp) : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r), borderSide: BorderSide()),
        contentPadding:
        EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    final List<String> updatedItems = [
      'Please select',
      ...items.where((e) => e != 'Please select'),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: updatedItems.contains(value) ? value : 'Please select',
        items: updatedItems.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: TextStyle(
                fontSize: 13.sp,
                color: e == 'Please select'
                    ? const Color(0xff005E6A)
                    : Colors.black,
                fontWeight:
                e == 'Please select' ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null && newValue != 'Please select') {
            onChanged(newValue);
          }
        },
        decoration: InputDecoration(
          hintText: 'Please select',
          hintStyle: TextStyle(fontSize: 13.sp),
          filled: true,
          fillColor: Colors.white,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(24.r)),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        ),
        dropdownColor: Colors.white,
        menuMaxHeight: 250.h,
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }
}
