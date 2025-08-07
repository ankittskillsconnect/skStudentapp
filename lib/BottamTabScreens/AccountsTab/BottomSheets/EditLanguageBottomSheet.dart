import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model/LanguageMaster_Model.dart';
import '../../../Model/Languages_Model.dart';
import '../../../Utilities/Language_Api.dart';
import '../../../Utilities/MyAccount_Get_Post/Get/LanguagesGet_Api.dart';
import 'CustomDropDownLanguage.dart';

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
  bool isLoading = true;
  bool isSaving = false;
  List<LanguageMasterModel> masterLanguages = [];

  LanguageMasterModel? selectedLanguage;
  late String selectedProficiency;

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


    try {
      final languages = await LanguageListApi.fetchLanguages(
        authToken: authToken,
        connectSid: connectSid,
      );

      for (var lang in languages) {
        print("📝 Language item => id: ${lang.languageId}, name: ${lang.languageName}");
      }

      setState(() {
        masterLanguages = languages;

        if (widget.initialData != null) {
          selectedLanguage = masterLanguages.firstWhere(
                (lang) => lang.languageName == widget.initialData!.languageName,
            orElse: () {
              print("⚠️ No exact match found. Defaulting to first item.");
              return masterLanguages.first;
            },
          );
          print("✅ Selected from initialData: ${selectedLanguage?.languageName}");
        } else {
          selectedLanguage = masterLanguages.isNotEmpty ? masterLanguages.first : null;
        }

        isLoading = false;
      });

      _animationController.forward();
    } catch (e, stackTrace) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load languages: $e')),
      );
    }
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
                      bottom: MediaQuery.of(context).viewInsets.bottom +
                          10 * sizeScale,
                    ),
                    children: [
                      _buildLabel("Select language", required: true),
                      _buildLanguageDropdown(),
                      const SizedBox(height: 16),
                      _buildLabel("Select proficiency", required: true),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: CustomFieldLanguageDropdown<LanguageMasterModel>(
        masterLanguages.isNotEmpty ? masterLanguages : [LanguageMasterModel(languageId: 0, languageName: 'No languages available')],
        selectedLanguage,
            (val) => setState(() {
          selectedLanguage = val;
          print("Selected language updated to: ${val?.languageName}");
        }),
        hintText: 'Select language',
      ),
    );
  }

  Widget _buildProficiencyDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: CustomFieldLanguageDropdown<String>(
        _proficiencyLevels,
        selectedProficiency,
            (val) => setState(() {
          selectedProficiency = val ?? '';
          print("Selected proficiency updated to: $selectedProficiency");
        }),
        hintText: 'Select proficiency',
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
        onPressed: isSaving
            ? null
            : () async {
          if (selectedLanguage == null || selectedProficiency.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please fill all required fields')),
            );
            return;
          }

          setState(() => isSaving = true);

          final prefs = await SharedPreferences.getInstance();
          final authToken = prefs.getString('authToken') ?? '';
          final connectSid = prefs.getString('connectSid') ?? '';

          final languageToSave = LanguagesModel(
            languageId: selectedLanguage!.languageId,
            languageName: selectedLanguage!.languageName,
            proficiency: selectedProficiency,
          );

          final success = await LanguageDetailApi.updateLanguages(
            authToken: authToken,
            connectSid: connectSid,
            language: languageToSave,
          );

          setState(() => isSaving = false);

          if (success) {
            widget.onSave(languageToSave);
            Navigator.pop(context);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Language updated successfully!')),
            // );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update language. Please try again.')),
            );
          }
        },
        child: isSaving
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(color: Colors.white),
        )
            : const Text("Submit", style: TextStyle(color: Colors.white)),
      ),
    );
  }

}
