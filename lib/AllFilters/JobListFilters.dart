import 'package:flutter/material.dart';

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
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double sizeScale = widthScale.clamp(0.98, 1.02);

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
            horizontal: 20 * sizeScale,
            vertical: 10 * sizeScale,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Job Filter',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003840),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF005E6A)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(thickness: 1),

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
                  items: const ['Open', 'Closed', 'Urgent'],
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

                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005E6A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      "Show Results",
                      style: TextStyle(
                        fontSize: 16,
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
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF003840))),
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
      style: TextStyle(color: textColor ?? Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textColor?.withOpacity(0.6) ?? Colors.grey),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 18) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
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
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: updatedItems.contains(value) ? value : 'Please select',
        items: updatedItems.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: TextStyle(
                color: e == 'Please select' ? Color(0xff005E6A) : Colors.black,
                fontWeight: e == 'Please select' ? FontWeight.w500 : FontWeight.normal,
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
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        dropdownColor: Colors.white,
        menuMaxHeight: 250,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

}
