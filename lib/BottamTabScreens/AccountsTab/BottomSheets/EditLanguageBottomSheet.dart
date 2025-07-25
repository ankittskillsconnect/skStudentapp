import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model/Languages_Model.dart';
import '../../../Utilities/Language_Api.dart';

class LanguageBottomSheet extends StatefulWidget {
  final LanguagesModel? initialData;
  final Function(LanguagesModel data) onSave;

  const LanguageBottomSheet({
    super.key,
    this.initialData,
    required this.onSave,
  });

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet>
    with SingleTickerProviderStateMixin {
  late String selectedLanguage;
  late String selectedProficiency;
  bool isLoading = true;
  List<String> allLanguages = [];

  final List<String> _proficiencyLevels = [
    'Basic',
    'Native/Bilingual',
    'Conversational'
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    selectedLanguage = widget.initialData?.languageName ?? '';
    selectedProficiency =
        widget.initialData?.proficiency ?? _proficiencyLevels[0];

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _loadLanguagesFromApi();
  }

  void _loadLanguagesFromApi() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';

    final languages = await LanguageListApi.fetchLanguages(
      authToken: authToken,
      connectSid: connectSid,
    );

    setState(() {
      allLanguages = languages;
      if (allLanguages.isNotEmpty) {
        final isInitialValid = allLanguages.contains(selectedLanguage);
        if (!isInitialValid) {
          selectedLanguage = allLanguages[0];
        }
      }
      isLoading = false;
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double sizeScale = size.width / 360;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.45,
      maxChildSize: 0.45,
      minChildSize: 0.45,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20 * sizeScale,
            vertical: 16 * sizeScale,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: isLoading
                ? _buildLoader(sizeScale)
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const Divider(thickness: 1.2),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.only(
                      bottom:
                      MediaQuery.of(context).viewInsets.bottom +
                          10 * sizeScale,
                    ),
                    children: [
                      _buildLabel("Select language*", required: true),
                      _buildLanguageDropdown(),
                      const SizedBox(height: 16),
                      _buildLabel("Select proficiency*", required: true),
                      _buildProficiencyDropdown(),
                      const SizedBox(height: 30),
                      _buildSubmitButton(),
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

  Widget _buildLoader(double sizeScale) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF005E6A)),
          ),
          SizedBox(height: 16 * sizeScale),
          Text(
            'Loading Languages...',
            style: TextStyle(
              fontSize: 16 * sizeScale,
              color: const Color(0xFF003840),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Add Language',
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
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF003840),
            ),
          ),
          if (required)
            const Text(' *', style: TextStyle(color: Colors.red, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return _buildDropdownField(
      value: selectedLanguage,
      items: allLanguages,
      onChanged: (val) => setState(() => selectedLanguage = val ?? ''),
    );
  }

  Widget _buildProficiencyDropdown() {
    return _buildDropdownField(
      value: selectedProficiency,
      items: _proficiencyLevels,
      onChanged: (val) => setState(() => selectedProficiency = val ?? ''),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        items: items.toSet().map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF005E6A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          if (selectedLanguage.isEmpty || selectedProficiency.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please fill all required fields')),
            );
            return;
          }

          final result = LanguagesModel(
            languageName: selectedLanguage,
            proficiency: selectedProficiency,
          );

          widget.onSave(result);
          Navigator.pop(context);
        },
        child: const Text("Submit", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
