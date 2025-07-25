import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../ProfileLogic/ProfileEvent.dart';
import '../../../ProfileLogic/ProfileLogic.dart';
import '../../../Utilities/StateList_Api.dart';
import '../../../Utilities/CityList_Api.dart';
import '../../../Model/PersonalDetail_Model.dart';

class EditPersonalDetailsSheet extends StatefulWidget {
  final PersonalDetailModel? initialData;
  final Function(PersonalDetailModel) onSave;

  const EditPersonalDetailsSheet({
    super.key,
    required this.initialData,
    required this.onSave,
  });

  @override
  State<EditPersonalDetailsSheet> createState() =>
      _EditPersonalDetailsSheetState();
}

class _EditPersonalDetailsSheetState extends State<EditPersonalDetailsSheet>
    with SingleTickerProviderStateMixin {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController dobController;
  late TextEditingController phoneController;
  late TextEditingController whatsappController;
  late TextEditingController emailController;
  late String selectedState;
  late String selectedCity;

  bool isLoadingStates = true;
  bool isLoadingCities = false;

  List<String> states = [];
  List<String> cities = ['Select a state first'];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController(text: widget.initialData?.firstName);
    lastNameController = TextEditingController(text: widget.initialData?.lastName);
    dobController = TextEditingController(text: widget.initialData?.dateOfBirth);
    phoneController = TextEditingController(text: widget.initialData?.mobile);
    whatsappController = TextEditingController(text: widget.initialData?.whatsAppNumber);
    emailController = TextEditingController(text: widget.initialData?.email);

    selectedState = widget.initialData!.state;
    selectedCity = widget.initialData!.city;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _fetchStateList();
  }

  Future<void> _fetchStateList() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedStates = prefs.getStringList('cached_states');

    if (cachedStates != null && cachedStates.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        states = cachedStates;
        selectedState = states.contains(selectedState) ? selectedState : states.first;
        isLoadingStates = false;
      });
      _animationController.forward();
      await _fetchCityList();
      return;
    }

    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';

    try {
      final fetchedStates = await StateListApi.fetchStates(
        countryId: '101',
        authToken: authToken,
        connectSid: connectSid,
      );
      if (!mounted) return;
      setState(() {
        states = fetchedStates.isNotEmpty ? fetchedStates : ['No States Available'];
        selectedState = states.contains(selectedState) ? selectedState : states.first;
        isLoadingStates = false;
      });
      prefs.setStringList('cached_states', states);
      _animationController.forward();
      await _fetchCityList();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        states = ['No States Available'];
        selectedState = states.first;
        isLoadingStates = false;
      });
      _animationController.forward();
    }
  }

  Future<void> _fetchCityList() async {
    if (selectedState == 'No States Available' || selectedState.isEmpty) {
      setState(() {
        cities = ['Select a state first'];
        selectedCity = cities.first;
      });
      return;
    }

    setState(() => isLoadingCities = true);

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    final stateId = await _resolveStateId(selectedState);

    try {
      final fetchedCities = await CityListApi.fetchCities(
        cityName: '',
        stateId: stateId,
        authToken: authToken,
        connectSid: connectSid,
      );
      if (!mounted) return;
      setState(() {
        cities = fetchedCities.isNotEmpty ? fetchedCities : ['No Cities Available'];
        selectedCity = cities.contains(selectedCity) ? selectedCity : cities.first;
        isLoadingCities = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        cities = ['No Cities Available'];
        selectedCity = cities.first;
        isLoadingCities = false;
      });
    }
  }

  Future<String> _resolveStateId(String stateName) async {
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
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] is List && data['data'].isNotEmpty) {
          return data['data'][0]['id'].toString();
        }
      }
    } catch (_) {}
    return '';
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(widget.initialData!.dateOfBirth) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.9,
      builder: (_, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: isLoadingStates
              ? const Center(child: CircularProgressIndicator())
              : FadeTransition(
            opacity: _fadeAnimation,
            child: ListView(
              controller: scrollController,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edit Personal Details',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 10),
                _buildLabel("First Name"),
                _buildTextField("Enter first name", firstNameController),
                _buildLabel("Last Name"),
                _buildTextField("Enter last name", lastNameController),
                _buildLabel("Date of Birth"),
                _buildTextField("Select DOB", dobController, readOnly: true, suffixIcon: Icons.calendar_today, onTap: _selectDate),
                _buildLabel("Mobile"),
                _buildTextField("Enter mobile", phoneController),
                _buildLabel("WhatsApp"),
                _buildTextField("Enter WhatsApp", whatsappController),
                _buildLabel("Email"),
                _buildTextField("Enter Email", emailController),
                _buildLabel("State"),
                _buildDropdown(
                    states, selectedState, (val) async {
                  setState(() {
                    selectedState = val!;
                    selectedCity = '';
                    cities = ['Select a state first'];
                  });
                  await _fetchCityList();
                }),
                _buildLabel("City"),
                Stack(
                  children: [
                    _buildDropdown(cities, selectedCity, (val) => setState(() => selectedCity = val!)),
                    if (isLoadingCities)
                      const Positioned.fill(
                        child: IgnorePointer(
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (selectedState == 'No States Available' || selectedCity.contains('No')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please ensure all data is valid")),
                      );
                      return;
                    }
                    final updatedData = PersonalDetailModel(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      mobile: phoneController.text,
                      whatsAppNumber: whatsappController.text,
                      dateOfBirth: dobController.text,
                      email: emailController.text,
                      state: selectedState,
                      city: selectedCity,
                    );
                    widget.onSave(updatedData);
                    if (context.mounted) {
                      context.read<ProfileBloc>().add(LoadProfileData());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005E6A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Save", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
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
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildTextField(
      String hint,
      TextEditingController controller, {
        bool readOnly = false,
        IconData? suffixIcon,
        VoidCallback? onTap,
      }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 18) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: items.contains(value) ? value : items.first,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
