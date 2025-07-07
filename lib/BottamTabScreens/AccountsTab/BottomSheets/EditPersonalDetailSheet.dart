import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utilities/CityListApi.dart';
import '../../../Utilities/StateListApi.dart';

class EditPersonalDetailsSheet extends StatefulWidget {
  final String fullname;
  final String dob;
  final String phone;
  final String whatsapp;
  final String email;
  final String state;
  final String city;
  final String country;
  final Function(Map<String, String>) onSave;

  const EditPersonalDetailsSheet({
    super.key,
    required this.fullname,
    required this.dob,
    required this.phone,
    required this.whatsapp,
    required this.email,
    required this.state,
    required this.city,
    required this.country,
    required this.onSave,
  });

  @override
  State<EditPersonalDetailsSheet> createState() =>
      _EditPersonalDetailsSheetState();
}

class _EditPersonalDetailsSheetState extends State<EditPersonalDetailsSheet> {
  late TextEditingController fullNameController;
  late TextEditingController dobController;
  late TextEditingController phoneController;
  late TextEditingController whatsappController;
  late TextEditingController emailController;

  List<String> states = [];
  List<String> cities = [];

  String? selectedState;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.fullname);
    dobController = TextEditingController(text: widget.dob);
    phoneController = TextEditingController(text: widget.phone);
    whatsappController = TextEditingController(text: widget.whatsapp);
    emailController = TextEditingController(text: widget.email);

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    print("🔐 Token loaded: \${token?.substring(0, 20)}...");

    if (token != null) {
      print("📡 Fetching states...");
      final fetchedStates = await StateListApi.fetchStates(
        countryId: 101,
        authToken: token,
      );
      print("✅ States fetched: \$fetchedStates");

      setState(() {
        states = List<String>.from(fetchedStates);
        selectedState = states.contains(widget.state) ? widget.state : null;
      });

      if (selectedState != null) {
        print("📡 Fetching cities for: \$selectedState");
        final fetchedCities = await CityListApi.fetchCities(
          selectedState!,
          token,
        );
        print("✅ Cities fetched: \$fetchedCities");

        setState(() {
          cities = fetchedCities;
          selectedCity = cities.contains(widget.city) ? widget.city : null;
        });
      }
    } else {
      print("⚠️ No token found in SharedPreferences.");
    }
  }

  Future<void> _selectDate() async {
    try {
      DateTime initialDate;
      try {
        initialDate = DateFormat('dd, MMM yyyy').parse(widget.dob);
      } catch (e) {
        initialDate = DateTime.now();
      }
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (pickedDate != null) {
        String formattedDate = DateFormat('dd, MMM yyyy').format(pickedDate);
        dobController.text = formattedDate;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error selecting date")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double sizeScale = widthScale.clamp(0.98, 1.02);

    return DraggableScrollableSheet(
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
                    'Edit Personal Details',
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
                    _buildLabel("Full Name"),
                    _buildTextField("Enter full name", fullNameController),
                    _buildLabel("Date of Birth"),
                    _buildTextField(
                      "Select DOB",
                      dobController,
                      suffixIcon: Icons.calendar_today,
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                    _buildLabel("Contact No"),
                    _buildTextField("Enter contact no", phoneController),
                    _buildLabel("WhatsApp No"),
                    _buildTextField("Enter WhatsApp no", whatsappController),
                    _buildLabel("Email"),
                    _buildTextField("Enter email", emailController),
                    _buildLabel("State"),
                    _buildDropdown(states, selectedState, (value) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? token = prefs.getString('authToken');
                      print("📍 State changed to: \$value");

                      setState(() {
                        selectedState = value;
                        selectedCity = null;
                        cities = [];
                      });

                      if (value != null && token != null) {
                        print("📡 Fetching cities for selected state: \$value");
                        final fetchedCities = await CityListApi.fetchCities(
                          value,
                          token,
                        );
                        print("✅ Cities fetched for \$value: \$fetchedCities");

                        setState(() {
                          cities = fetchedCities;
                        });
                      }
                    }),
                    _buildLabel("City"),
                    _buildDropdown(cities, selectedCity, (value) {
                      print("🏙️ City selected: \$value");
                      setState(() {
                        selectedCity = value;
                      });
                    }),
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
                        final dataToSave = {
                          'fullname': fullNameController.text,
                          'dob': dobController.text,
                          'phone': phoneController.text,
                          'whatsapp': whatsappController.text,
                          'email': emailController.text,
                          'state': selectedState ?? '',
                          'city': selectedCity ?? '',
                          'country': widget.country,
                        };

                        print("💾 Saving data: \$dataToSave");
                        widget.onSave(dataToSave);
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

  Widget _buildDropdown(
    List<String> items,
    String? selectedItem,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: items.contains(selectedItem) ? selectedItem : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        items: items
            .map(
              (item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
