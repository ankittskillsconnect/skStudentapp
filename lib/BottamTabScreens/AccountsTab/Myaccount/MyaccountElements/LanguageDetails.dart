import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Model/Languages_Model.dart';
import '../../../../Utilities/MyAccount_Get_Post/LanguagesGet_Api.dart';
import '../../BottomSheets/EditLanguageBottomSheet.dart';
import 'SectionHeader.dart';

class LanguagesSection extends StatelessWidget {
  final List<LanguagesModel> languageList;
  final bool isLoading;
  final VoidCallback onAdd;
  final Function(int) onDelete;

  const LanguagesSection({
    super.key,
    required this.languageList,
    required this.isLoading,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844), minTextAdapt: true, splitScreenMode: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Languages",
          showAdd: true,
          onAdd: onAdd,
        ),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF005E6A)),
              strokeWidth: 3.w,
            ),
          )
        else if (languageList.isEmpty)
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Text(
              'No languages added',
              style: TextStyle(fontSize: 11.sp, color: Colors.grey),
            ),
          )
        else
          for (var i = 0; i < languageList.length; i++)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              margin: EdgeInsets.only(top: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFBCD8DB)),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF6F7),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.language,
                          size: 18.w,
                          color: const Color(0xFF005E6A),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          languageList[i].languageName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: const Color(0xFF005E6A),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        iconSize: 18.w,
                        onPressed: () => onDelete(i),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    languageList[i].proficiency,
                    style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  List<LanguagesModel> languageList = [];
  bool isLoadingLanguages = false;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    setState(() => isLoadingLanguages = true);
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    try {
      final languages = await LanguageDetailApi.fetchLanguages(
        authToken: authToken,
        connectSid: connectSid,
      );
      setState(() {
        languageList = languages;
        isLoadingLanguages = false;
        print('🔍 [MyAccount] Loaded languages: ${languageList.map((lang) => 'id: ${lang.id}, languageId: ${lang.languageId}, name: ${lang.languageName}').toList()}');
      });
    } catch (e) {
      setState(() => isLoadingLanguages = false);
      print('❌ [MyAccount] Failed to load languages: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load languages')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: LanguagesSection(
          languageList: languageList,
          isLoading: isLoadingLanguages,
          onAdd: () {
            print('🔍 [MyAccount] Opening LanguageBottomSheet for adding language');
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              builder: (_) => LanguageBottomSheet(
                initialData: null,
                onSave: (LanguagesModel data) {
                  setState(() {
                    languageList.add(data);
                    print('🔍 [MyAccount] Added language: id=${data.id}, languageId=${data.languageId}, name=${data.languageName}, proficiency=${data.proficiency}');
                  });
                  _loadLanguages(); // Sync ID
                },
              ),
            );
          },
          onDelete: (int index) async {
            print('🔍 [MyAccount] Starting deletion for index: $index');
            print('🔍 [MyAccount] languageList: ${languageList.map((lang) => 'id: ${lang.id}, languageId: ${lang.languageId}, name: ${lang.languageName}').toList()}');

            if (index < 0 || index >= languageList.length) {
              print('❌ [MyAccount] Invalid index: $index');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invalid language index')),
              );
              return;
            }

            final languageId = languageList[index].id;
            print('🔍 [MyAccount] Deleting language ID: $languageId, name: ${languageList[index].languageName}');

            if (languageId == null || languageId == 0) {
              print('❌ [MyAccount] Cannot delete language with invalid ID: $languageId');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cannot delete newly added language until synced')),
              );
              return;
            }

            final prefs = await SharedPreferences.getInstance();
            final authToken = prefs.getString('authToken') ?? '';
            final connectSid = prefs.getString('connectSid') ?? '';
            final success = await LanguageDetailApi.deleteLanguage(
              id: languageId,
              authToken: authToken,
              connectSid: connectSid,
            );

            if (success) {
              setState(() {
                languageList.removeAt(index);
                print('✅ [MyAccount] Removed language at index $index. New languageList: ${languageList.map((lang) => 'id: ${lang.id}, languageId: ${lang.languageId}, name: ${lang.languageName}').toList()}');
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language deleted successfully')),
              );
              await _loadLanguages(); // Sync with backend
            } else {
              print('❌ [MyAccount] Failed to delete language ID: $languageId');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to delete language, try again')),
              );
            }
          },
        ),
      ),
    );
  }
}