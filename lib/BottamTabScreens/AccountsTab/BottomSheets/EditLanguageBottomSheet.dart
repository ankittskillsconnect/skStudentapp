import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utilities/LanguageApi.dart';

class LanguageBottomSheet extends StatefulWidget {
  final String? initialData;
  final String language;
  final Function(Map<String, dynamic> data) onSave;

  const LanguageBottomSheet({
    super.key,
    this.initialData,
    required this.onSave,
    required this.language,
  });

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet>
    with SingleTickerProviderStateMixin {
  late String selectedLanguage;
  late String selectedProficiency;
  bool isLoadingLanguages = true;
  List<String> languages = ['Loading languages...'];
  final List<String> _proficiencyLevels = ['Basic', 'Intermediate', 'Advanced'];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Clear cache to force fresh API call for debugging
    () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cached_languages');
    }();

    // Use initialData if provided, otherwise fallback to widget.language
    selectedLanguage = widget.initialData ?? widget.language;
    selectedProficiency = _proficiencyLevels[0];

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _fetchLanguageList();
  }

  Future<void> _fetchLanguageList() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedLanguages = prefs.getStringList('cached_languages');

    final authToken = prefs.getString('authToken') ?? '';
    String connectSid = prefs.getString('connectSid') ?? '';

    debugPrint("🟡 authToken from prefs: ${authToken.substring(0, 20)}...");
    debugPrint("🟡 connectSid from prefs: $connectSid");

    if (connectSid.isEmpty) {
      debugPrint(
        "🧨 WARNING: connectSid is empty, setting fallback value for debug!",
      );
      connectSid =
          's%3A90I8VK0ssLCW9DjFq4xSLrkDEI7xUgCG.JFNw9cZG8Txw07rqZ6gs7K8bGpm4pMApT7Yu9FqqjbY';
    }

    if (cachedLanguages != null && cachedLanguages.isNotEmpty) {
      debugPrint(
        "✅ Using cached languages (${cachedLanguages.length}) - $cachedLanguages",
      );
      setState(() {
        languages = cachedLanguages;
        if (!languages.contains(selectedLanguage) && languages.isNotEmpty) {
          selectedLanguage = languages[0];
        }
        isLoadingLanguages = false;
      });
      _animationController.forward();
      return;
    }

    try {
      final fetchedLanguages = await LanguageListApi.fetchLanguages(
        authToken: authToken,
        connectSid: connectSid,
      );

      debugPrint("✅ API returned ${fetchedLanguages.length} languages");

      if (!mounted) return;

      setState(() {
        languages = fetchedLanguages.isNotEmpty
            ? fetchedLanguages
            : ['No languages available'];
        if (!languages.contains(selectedLanguage) && languages.isNotEmpty) {
          selectedLanguage = languages[0];
        }
        isLoadingLanguages = false;
      });

      await prefs.setStringList('cached_languages', languages);
      _animationController.forward();
    } catch (e) {
      debugPrint("❌ Error fetching languages: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading languages: $e')));
        setState(() {
          languages = ['No languages available'];
          if (!languages.contains(selectedLanguage)) {
            selectedLanguage = languages[0];
          }
          isLoadingLanguages = false;
        });
        _animationController.forward();
      }
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
            child: isLoadingLanguages
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF005E6A),
                          ),
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
                  )
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
                            _buildDropdownField(
                              value: selectedLanguage,
                              items: languages,
                              onChanged: (val) => setState(
                                () => selectedLanguage = val ?? languages[0],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildLabel("Select proficiency*", required: true),
                            _buildDropdownField(
                              value: selectedProficiency,
                              items: _proficiencyLevels,
                              onChanged: (val) => setState(
                                () => selectedProficiency =
                                    val ?? _proficiencyLevels[0],
                              ),
                            ),
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

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    final displayValue = items.contains(value)
        ? value
        : (items.isNotEmpty ? items[0] : null);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: DropdownButtonFormField<String>(
        value: displayValue,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: isLoadingLanguages ? null : onChanged,
        decoration: InputDecoration(
          hintText: 'Please select',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: Colors.white,
        menuMaxHeight: 250,
        borderRadius: BorderRadius.circular(20),
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
          if (selectedLanguage.isEmpty ||
              selectedProficiency.isEmpty ||
              selectedLanguage == 'No languages available') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Please fill all required fields or check language data',
                ),
              ),
            );
            return;
          }
          final data = {
            'Language': widget.initialData,
            'language': selectedLanguage,
            'proficiency': selectedProficiency,
          };
          widget.onSave(data);
          Navigator.pop(context);
        },
        child: const Text("Submit", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
