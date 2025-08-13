import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model/LanguageMaster_Model.dart';
import '../../../Model/Languages_Model.dart';
import '../../../Utilities/Language_Api.dart';
import '../../../Utilities/MyAccount_Get_Post/LanguagesGet_Api.dart';
import 'CustomDropDowns/CustomDropDownLanguage.dart';

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
    selectedProficiency = widget.initialData?.proficiency ?? _proficiencyLevels[0];
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
      print('🧹 [LanguageBottomSheet] Clearing cache before fetching languages');
      await LanguageListApi.clearCachedLanguages();
      final languages = await LanguageListApi.fetchLanguages(
        authToken: authToken,
        connectSid: connectSid,
      );

      for (var lang in languages) {
        print('📝 [LanguageBottomSheet] Language item => id: ${lang.languageId}, name: ${lang.languageName}');
      }

      if (languages.isEmpty) {
        print('⚠️ [LanguageBottomSheet] No languages fetched from API.');
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No languages available')),
        );
        return;
      }

      setState(() {
        masterLanguages = languages;
        if (widget.initialData != null) {
          selectedLanguage = masterLanguages.firstWhere(
                (lang) => lang.languageName == widget.initialData!.languageName,
            orElse: () {
              print('⚠️ [LanguageBottomSheet] No match for initialData: ${widget.initialData!.languageName}. Defaulting to first.');
              return masterLanguages.first;
            },
          );
          print('✅ [LanguageBottomSheet] Selected from initialData: ${selectedLanguage?.languageName}, ID: ${selectedLanguage?.languageId}');
        } else {
          selectedLanguage = masterLanguages.first;
          print('✅ [LanguageBottomSheet] Default selected: ${selectedLanguage?.languageName}, ID: ${selectedLanguage?.languageId}');
        }
        isLoading = false;
      });

      _animationController.forward();
    } catch (e, stackTrace) {
      setState(() => isLoading = false);
      print('🚨 [LanguageBottomSheet] Exception in _loadLanguagesFromApi: $e');
      print('🚨 [LanguageBottomSheet] Stack trace: $stackTrace');
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
    ScreenUtil.init(context, designSize: const Size(390, 844), minTextAdapt: true, splitScreenMode: true);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      maxChildSize: 0.4,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: isLoading
                ? _buildLoader()
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Divider(thickness: 1.w),
                SizedBox(height: 8.h),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 8.h),
                    children: [
                      _buildLabel('Select language', required: true),
                      _buildLanguageDropdown(),
                      SizedBox(height: 12.h),
                      _buildLabel('Select proficiency', required: true),
                      _buildProficiencyDropdown(),
                      SizedBox(height: 18.h),
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

  Widget _buildLoader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF005E6A)),
            strokeWidth: 3.w,
          ),
          SizedBox(height: 12.h),
          Text(
            'Loading Languages...',
            style: TextStyle(fontSize: 11.sp, color: const Color(0xFF003840), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Add Language',
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: const Color(0xFF003840)),
        ),
        IconButton(
          icon: Icon(Icons.close, color: const Color(0xFF005E6A), size: 18.w),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h, bottom: 4.h),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: const Color(0xFF003840)),
          ),
          if (required) Text(' *', style: TextStyle(color: Colors.red, fontSize: 11.sp)),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: CustomFieldLanguageDropdown<LanguageMasterModel>(
        masterLanguages.isNotEmpty
            ? masterLanguages
            : [LanguageMasterModel(languageId: 0, languageName: 'No languages available')],
        selectedLanguage,
            (val) {
          if (val != null && val.languageId == 0) {
            print('⚠️ [LanguageBottomSheet] Selected language has invalid ID: 0');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid language selected')),
            );
            return;
          }
          setState(() {
            selectedLanguage = val;
            print('✅ [LanguageBottomSheet] Selected language updated to: ${val?.languageName}, ID: ${val?.languageId}');
          });
        },
        hintText: 'Select language',
      ),
    );
  }

  Widget _buildProficiencyDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: CustomFieldLanguageDropdown<String>(
        _proficiencyLevels,
        selectedProficiency,
            (val) => setState(() {
          selectedProficiency = val ?? '';
          print('✅ [LanguageBottomSheet] Selected proficiency updated to: $selectedProficiency');
        }),
        hintText: 'Select proficiency',
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 40.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF005E6A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        onPressed: isSaving
            ? null
            : () async {
          if (selectedLanguage == null || selectedProficiency.isEmpty) {
            print('❌ [LanguageBottomSheet] Missing required fields: language=$selectedLanguage, proficiency=$selectedProficiency');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please fill all required fields')),
            );
            return;
          }

          if (selectedLanguage!.languageId == 0) {
            print('❌ [LanguageBottomSheet] Invalid language_id: 0 for ${selectedLanguage!.languageName}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid language selected')),
            );
            return;
          }

          setState(() => isSaving = true);
          final prefs = await SharedPreferences.getInstance();
          final authToken = prefs.getString('authToken') ?? '';
          final connectSid = prefs.getString('connectSid') ?? '';
          print('🔍 [LanguageBottomSheet] authToken: $authToken');
          print('🔍 [LanguageBottomSheet] connectSid: $connectSid');

          final languageToSave = LanguagesModel(
            id: widget.initialData?.id,
            languageId: selectedLanguage!.languageId,
            languageName: selectedLanguage!.languageName,
            proficiency: selectedProficiency,
          );
          print('🔍 [LanguageBottomSheet] Saving language: id=${languageToSave.id}, languageId=${languageToSave.languageId}, name=${languageToSave.languageName}, proficiency=${languageToSave.proficiency}');

          final result = await LanguageDetailApi.updateLanguages(
            authToken: authToken,
            connectSid: connectSid,
            language: languageToSave,
          );

          setState(() => isSaving = false);

          if (result['success']) {
            final responseData = result['data'];
            int? newId = responseData['id'] as int?;
            LanguagesModel updatedLanguage = responseData['language'] as LanguagesModel;
            print('✅ [LanguageBottomSheet] Using language from response: id=${updatedLanguage.id}');

            widget.onSave(updatedLanguage);
            print('✅ [LanguageBottomSheet] Called onSave with: id=${updatedLanguage.id}, languageId=${updatedLanguage.languageId}, name=${updatedLanguage.languageName}, proficiency=${updatedLanguage.proficiency}');
            Navigator.pop(context);
          } else {
            print('❌ [LanguageBottomSheet] Failed to update language: ${result['data']}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update language. Please try again.')),
            );
          }
        },
        child: isSaving
            ? SizedBox(
          height: 18.h,
          width: 18.w,
          child: const CircularProgressIndicator(color: Colors.white),
        )
            : Text(
          'Submit',
          style: TextStyle(color: Colors.white, fontSize: 11.sp),
        ),
      ),
    );
  }
}