import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../Utilities/StateListApi.dart';
import '../../../Utilities/CityListApi.dart';

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
  State<EditPersonalDetailsSheet> createState() => _EditPersonalDetailsSheetState();
}

class _EditPersonalDetailsSheetState extends State<EditPersonalDetailsSheet> {
  late TextEditingController fullNameController;
  late TextEditingController dobController;
  late TextEditingController phoneController;
  late TextEditingController whatsappController;
  late TextEditingController emailController;
  late String selectedState;
  late String selectedCity;
  bool isLoading = true;

  List<String> states = [];
  List<String> cities = [];

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.fullname);
    dobController = TextEditingController(text: widget.dob);
    phoneController = TextEditingController(text: widget.phone);
    whatsappController = TextEditingController(text: widget.whatsapp);
    emailController = TextEditingController(text: widget.email);
    selectedState = widget.state;
    selectedCity = widget.city;

    _initData();
  }

  Future<void> _initData() async {
    try {
      await Future.wait([
        _fetchStateList(),
        _fetchCityList(),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _fetchStateList() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';

    print("Using authToken: $authToken, connectSid: $connectSid");
    final fetchedStates = await StateListApi.fetchStates(
      countryId: '101', // As per Postman
      authToken: authToken,
      connectSid: connectSid,
    );

    if (!mounted) return;
    setState(() {
      states = fetchedStates.isNotEmpty ? fetchedStates : ['No States Available'];
      if (!states.contains(widget.state)) {
        selectedState = states[0];
      } else {
        selectedState = widget.state;
      }
    });
  }

  Future<void> _fetchCityList() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';

    final stateId = await _resolveStateId(selectedState);
    print("Fetching cities for state ID: $stateId");
    final fetchedCities = await CityListApi.fetchCities(
      cityName: '', // Fetch all cities
      stateId: stateId,
      authToken: authToken,
      connectSid: connectSid,
    );

    if (!mounted) return;
    setState(() {
      cities = fetchedCities.isNotEmpty ? fetchedCities : ['No Cities Available'];
      if (!cities.contains(widget.city)) {
        selectedCity = cities[0];
      } else {
        selectedCity = widget.city;
      }
    });
  }

  Future<String> _resolveStateId(String stateName) async {
    if (stateName.isEmpty || stateName == 'No States Available') return '';
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';

    try {
      final response = await http.post(
        Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/master/state/list'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
        },
        body: jsonEncode({"country_id": 101, "state_name": stateName}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] is List && data['data'].isNotEmpty) {
          return data['data'][0]['id'].toString();
        }
      }
    } catch (e) {
      print("Error resolving state ID: $e");
    }
    return '';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error selecting date")),
      );
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    dobController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    emailController.dispose();
    super.dispose();
  }

  String _formatPersonalDetails() {
    return '${fullNameController.text}\n$selectedCity, $selectedState\n${phoneController.text}\n${emailController.text}';
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      onPressed: () {
                        try {
                          Navigator.of(context).pop();
                        } catch (e) {
                          print("Error closing bottom sheet: $e");
                        }
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 10),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildLabel("Full Name"),
                        _buildTextField(
                          "Enter full name",
                          fullNameController,
                          keyboardType: TextInputType.name,
                        ),
                        _buildLabel("Date of Birth"),
                        _buildTextField(
                          "Select DOB",
                          dobController,
                          suffixIcon: Icons.calendar_today,
                          readOnly: true,
                          onTap: _selectDate,
                        ),
                        _buildLabel("Contact No"),
                        _buildTextField(
                          "Enter contact no",
                          phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                        _buildLabel("WhatsApp No"),
                        _buildTextField(
                          "Enter WhatsApp no",
                          whatsappController,
                          keyboardType: TextInputType.phone,
                        ),
                        _buildLabel("Email"),
                        _buildTextField(
                          "Enter email",
                          emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildLabel("State"),
                        _buildDropdownField(
                          value: selectedState,
                          items: states,
                          onChanged: (val) async {
                            setState(() {
                              selectedState = val ?? '';
                              selectedCity = ''; // Reset city when state changes
                              cities = ['No Cities Available'];
                            });
                            await _fetchCityList(); // Refresh cities
                          },
                        ),
                        _buildLabel("City"),
                        _buildDropdownField(
                          value: selectedCity,
                          items: cities,
                          onChanged: (val) => setState(() => selectedCity = val ?? ''),
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
                            if (states[0] == 'No States Available' ||
                                cities[0] == 'No Cities Available') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please ensure all data is loaded')),
                              );
                              return;
                            }
                            final dataToSave = {
                              'personalDetails': _formatPersonalDetails(),
                              'fullname': fullNameController.text,
                              'dob': dobController.text,
                              'phone': phoneController.text,
                              'whatsapp': whatsappController.text,
                              'email': emailController.text,
                              'state': selectedState,
                              'city': selectedCity,
                              'country': widget.country,
                            };
                            print("Saving data: $dataToSave");
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xff003840),
      ),
    ),
  );

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    final displayValue = items.contains(value) ? value : (items.isNotEmpty ? items[0] : null);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: displayValue,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (newValue) {
          if (newValue != null && newValue != 'No States Available' && newValue != 'No Cities Available') {
            onChanged(newValue);
            FocusScope.of(context).unfocus();
          }
        },
        decoration: InputDecoration(
          hintText: 'Please select',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
        ),
        dropdownColor: Colors.white,
        menuMaxHeight: 250,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        IconData? suffixIcon,
        bool readOnly = false,
        VoidCallback? onTap,
        TextInputType keyboardType = TextInputType.text,
      }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: label,
            suffixIcon: suffixIcon != null
                ? IconButton(icon: Icon(suffixIcon), onPressed: onTap)
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
}