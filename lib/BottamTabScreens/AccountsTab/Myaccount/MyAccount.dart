import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditCertificateBottomSheet.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditProjectBottomSheet.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditWorkExperienceBottomSheet.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/Myaccount/MyAccountAppbar.dart';
import 'package:sk_loginscreen1/Model/CertificateDetails_Model.dart';
import 'package:sk_loginscreen1/Model/Internship_Projects_Model.dart';
import 'package:sk_loginscreen1/Model/PersonalDetail_Model.dart';
import 'package:sk_loginscreen1/Model/Skiils_Model.dart';
import 'package:sk_loginscreen1/Model/WorkExperience_Model.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/Get/InternshipProject_Api.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/Get/PersonalDetail_Api.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/Get/WorkExperience_Api.dart';
import 'package:sk_loginscreen1/Model/EducationDetail_Model.dart';
import 'package:sk_loginscreen1/Model/Languages_Model.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/Get/CertificateDetails_APi.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/Get/EducationDetail_Api.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/Get/LanguagesGet_Api.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/Get/Skills_Api.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditEducationBottomSheet.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditLanguageBottomSheet.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditPersonalDetailSheet.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditSkillsBottomSheet.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../Model/Image_update_Model.dart';
import '../../../Model/LanguageMaster_Model.dart';
import '../../../Model/Percentage_bar_Model.dart';
import '../../../Utilities/MyAccount_Get_Post/Get/Image_Api.dart';
import '../../../Utilities/MyAccount_Get_Post/Post/Skills_Post_Api.dart';
import 'MyaccountElements/CertificateDetails.dart';
import 'MyaccountElements/EducationDetails.dart';
import 'MyaccountElements/LanguageDetails.dart';
import 'MyaccountElements/Personaldetails.dart';
import 'MyaccountElements/Profile_Completition_Bar.dart';
import 'MyaccountElements/ProjectDetails.dart';
import 'MyaccountElements/SkillsDetails.dart';
import 'MyaccountElements/WorkExperienceDetails.dart';
import 'MyaccountElements/resumeDetails.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  String fullname = "John";
  EducationDetailModel? educationDetail;
  PersonalDetailModel? personalDetail;
  List<SkillsModel> skillList = [];
  List<InternshipProjectModel> projects = [];
  List<CertificateModel> certificatesList = [];
  List<WorkExperienceModel> workExperiences = [];
  List<LanguagesModel> languageList = [];
  List<EducationDetailModel> educationDetails = [];
  List<PersonalDetailModel> personalDetails = [];
  ImageUpdateModel? _imageUpdateData;
  bool isLoadingImage = true;
  bool isLoadingEducation = true;
  bool isLoadingProject = true;
  bool isLoadingWorkExperience = true;
  bool isLoadingCertificate = true;
  bool isLoadingSkills = true;
  bool isLoadingLanguages = true;
  bool isLoadingPersonalDetail = true;
  File? _profileImage;
  ProfileCompletionModel? profileCompletion;
  bool isLoadingProfilePercentage = true;
  // List<Map<String, dynamic>> availableLanguages = [];
  // late List<LanguageMasterModel> parsedLanguageList = [];


  @override
  void initState() {
    super.initState();
    fetchEducationDetails();
    fetchInternShipProjectDetails();
    fetchWorkExperienceDetails();
    fetchCertificateDetails();
    fetchSkills();
    fetchLanguageData();
    _fetchPersonalDetails();
    _loadProfileImageFromApi();
  }

  Future<void> _loadProfileImageFromApi() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    final data = await LoadImageApi.fetchUserImage(
      authToken: authToken,
      connectSid: connectSid,
    );
    if (mounted && data != null) {
      setState(() {
        _imageUpdateData = data;
      });
    }
  }

  Future<void> fetchEducationDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    try {
      final educationDetailsFromApi =
          await EducationDetailApi.fetchEducationDetails(
            authToken: authToken,
            connectSid: connectSid,
          );
      setState(() {
        educationDetail = educationDetailsFromApi.isNotEmpty
            ? educationDetailsFromApi.first
            : null;
        educationDetails = educationDetailsFromApi;
        isLoadingEducation = false;
      });
    } catch (e) {
      print("❌ Error fetching education details: $e");
      setState(() {
        isLoadingEducation = false;
      });
    }
  }

  Future<void> fetchInternShipProjectDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    try {
      final internshipProjectApi = await InternshipProjectApi.fetchInternshipProjects(
        authToken: authToken,
        connectSid: connectSid,
      );
      if (mounted) {
        setState(() {
          projects = internshipProjectApi;
          isLoadingProject = false;
          print('Projects Fetched');
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingProject = false;
        });
        print("❌ Error fetching project details: $e");
      }
    }
  }

  Future<void> _fetchPersonalDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    try {
      final results = await PersonalDetailApi.fetchPersonalDetails(
        authToken: authToken,
        connectSid: connectSid,
      );
      setState(() {
        if (results.isNotEmpty) {
          personalDetail = results.first as PersonalDetailModel?;
        } else {
          personalDetail = null;
        }
        isLoadingPersonalDetail = false;
        print('✅ Fetched personal detail');
      });
    } catch (e) {
      print('❌ Personal details fetch error: $e');
      setState(() {
        isLoadingPersonalDetail = false;
      });
    }
  }

  Future<void> fetchWorkExperienceDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    setState(() {
      isLoadingWorkExperience = true;
    });
    try {
      final workExperienceApi = await WorkExperienceApi.fetchWorkExperienceApi(
        authToken: authToken,
        connectSid: connectSid,
      );
      setState(() {
        workExperiences = workExperienceApi;
        isLoadingWorkExperience = false;
        print(' Work experience fetched');
      });
    } catch (e) {
      print("❌ Error fetching work experience: $e");
      setState(() {
        isLoadingWorkExperience = false;
      });
    }
  }

  Future<void> fetchCertificateDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    setState(() {
      isLoadingCertificate = true;
    });
    try {
      final certificates = await CertificateApi.fetchCertificateApi(
        authToken: authToken,
        connectSid: connectSid,
      );
      setState(() {
        certificatesList = certificates;
        isLoadingCertificate = false;
        print(' Certificates fetched successfully');
      });
    } catch (e) {
      print('❌ Error fetching certificates: $e');
      setState(() {
        isLoadingCertificate = false;
      });
    }
  }

  Future<void> fetchSkills() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    setState(() {
      isLoadingSkills = true;
    });
    try {
      final result = await SkillsApi.fetchSkills(
        authToken: authToken,
        connectSid: connectSid,
      );
      setState(() {
        skillList = result;
        isLoadingSkills = false;
      });
    } catch (e) {
      print(' Error fetching skills: $e');
    }
  }
  // static Future<Map<String, dynamic>> fetchLanguagesRawResponse({
  //   required String authToken,
  //   required String connectSid,
  // }) async {
  //   final url = Uri.parse(
  //     'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/language-details',
  //   );
  //
  //   final headers = {
  //     'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
  //   };
  //
  //   print('📤 [fetchLanguagesRawResponse] Sending request to: $url');
  //   print('📤 [fetchLanguagesRawResponse] Headers: $headers');
  //
  //   try {
  //     final request = http.Request('GET', url)..headers.addAll(headers);
  //     final streamedResponse = await request.send();
  //     final responseBody = await streamedResponse.stream.bytesToString();
  //
  //     print('📥 [fetchLanguagesRawResponse] Status: ${streamedResponse.statusCode}');
  //     print('📥 [fetchLanguagesRawResponse] Body: $responseBody');
  //
  //     if (streamedResponse.statusCode == 200) {
  //       final decoded = json.decode(responseBody);
  //       return {
  //         'languages': decoded['languages'] ?? [],
  //       };
  //     }
  //
  //     print('❌ [fetchLanguagesRawResponse] Failed to fetch language list.');
  //     return {'languages': []};
  //   } catch (e) {
  //     print('❌ [fetchLanguagesRawResponse] Exception: $e');
  //     return {'languages': []};
  //   }
  // }
  Future<void> fetchLanguageData() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    final fetchedLanguages = await LanguageDetailApi.fetchLanguages(
      authToken: authToken,
      connectSid: connectSid,
    );
    setState(() {
      languageList = fetchedLanguages;
      isLoadingLanguages = false;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 85);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOption() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: Color(0xFF005E6A),
              ),
              title: const Text(
                'Choose from Gallery',
                style: TextStyle(fontSize: 16, color: Color(0xFF003840)),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_outlined,
                color: Color(0xFF005E6A),
              ),
              title: const Text(
                'Take a Photo',
                style: TextStyle(fontSize: 16, color: Color(0xFF003840)),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_profileImage != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Remove Image',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _profileImage = null);
                },
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double sizeScale = widthScale.clamp(0.98, 1.02);

    return Scaffold(
      appBar: AccountAppBar(),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (innerContext) => SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                isLoadingImage = true;
                isLoadingEducation = true;
                isLoadingProject = true;
                isLoadingWorkExperience = true;
                isLoadingCertificate = true;
                isLoadingSkills = true;
                isLoadingLanguages = true;
                isLoadingPersonalDetail = true;
              });
              await Future.wait([
                _loadProfileImageFromApi(),
                fetchEducationDetails(),
                fetchInternShipProjectDetails(),
                _fetchPersonalDetails(),
                fetchWorkExperienceDetails(),
                fetchCertificateDetails(),
                fetchSkills(),
                fetchLanguageData(),
              ]);
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 16 * sizeScale,
                vertical: 20 * sizeScale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 25),
                  ProfileCompletionBar(),
                  const SizedBox(height: 25),
                  PersonalDetailsSection(
                    personalDetail: personalDetail,
                    isLoading: isLoadingPersonalDetail,
                    onEdit: () {
                      showModalBottomSheet(
                        context: innerContext,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        builder: (_) => EditPersonalDetailsSheet(
                          initialData: personalDetail,
                          onSave: (updatedData) {
                            setState(() {
                              personalDetail = updatedData;
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  EducationSection(
                    educationDetails: educationDetails,
                    isLoading: isLoadingEducation,
                    onAdd: () {
                      showModalBottomSheet(
                        context: innerContext,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        builder: (_) => EditEducationBottomSheet(
                          onSave: (data) {
                            setState(() {
                              educationDetails.add(data['educationDetail']);
                            });
                            Navigator.pop(innerContext);
                          },
                        ),
                      );
                    },
                    onEdit: (edu, index) {
                      showModalBottomSheet(
                        context: innerContext,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        builder: (_) => EditEducationBottomSheet(
                          initialData: edu,
                          onSave: (data) {
                            setState(() {
                              educationDetails[index] = data['educationDetail'];
                            });
                            Navigator.pop(innerContext);
                          },
                        ),
                      );
                    },
                    onDelete: (index) {
                      setState(() {
                        educationDetails.removeAt(index);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ResumeSection(),
                  const SizedBox(height: 20),
                  SkillsSection(
                    skillList: skillList,
                    isLoading: isLoadingSkills,
                    onEdit: () {
                      showModalBottomSheet(
                        context: innerContext,
                        isScrollControlled: true,
                        builder: (_) => EditSkillsBottomSheet(
                          initialSkills: skillList,
                          onSave: (updatedSkills) {
                            setState(() => skillList = updatedSkills);
                          },
                        ),
                      );
                    },
                    onAdd: () {
                      showModalBottomSheet(
                        context: innerContext,
                        isScrollControlled: true,
                        builder: (_) => EditSkillsBottomSheet(
                          initialSkills: skillList,
                          onSave: (updatedSkills) {
                            setState(() => skillList = updatedSkills);
                          },
                        ),
                      );
                    },
                    onDeleteSkill: (skill, singleSkill) {
                      setState(() {
                        final parsedSkills = skill.skills
                            .split(RegExp(r',(?![^()]*\))'))
                            .map((s) => s.trim())
                            .where((s) => s.isNotEmpty)
                            .toList();
                        final updatedSkills = parsedSkills
                            .where((s) => s != singleSkill)
                            .toList();
                        if (updatedSkills.isEmpty) {
                          skillList.remove(skill);
                        } else {
                          skill.skills = updatedSkills.join(', ');
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ProjectsSection(
                    projects: projects,
                    isLoading: isLoadingProject,
                    onAdd: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final authToken = prefs.getString('authToken') ?? '';
                      final connectSid = prefs.getString('connectSid') ?? '';
                      if (authToken.isEmpty || connectSid.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: Please log in again.')),
                        );
                        return;
                      }
                      print("🆕 Opening Add Project BottomSheet");
                      bool isSaveComplete = false;
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (context) => EditProjectDetailsBottomSheet(
                          initialData: null,
                          onSave: (newData) async {
                            if (!isSaveComplete) {
                              print("✅ [onAdd -> onSave] Saved new project: ${newData.projectName} | Type: ${newData.type}");
                              isSaveComplete = true;
                              await fetchInternShipProjectDetails();
                            }
                          },
                        ),
                      );
                    },
                    onEdit: (project, index) async {
                      final prefs = await SharedPreferences.getInstance();
                      final authToken = prefs.getString('authToken') ?? '';
                      final connectSid = prefs.getString('connectSid') ?? '';
                      if (authToken.isEmpty || connectSid.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: Please log in again.')),
                        );
                        return;
                      }
                      print("🛠 Opening Edit BottomSheet");
                      print("📍 internshipId: ${project.internshipId}"); // Debug to confirm
                      print("📍 userId: ${project.userId}");
                      print("📍 type: ${project.type}");
                      bool isSaveComplete = false;
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (context) => EditProjectDetailsBottomSheet(
                          initialData: project, // Ensure project contains internshipId
                          onSave: (updatedData) async {
                            if (!isSaveComplete) {
                              print("✅ [onEdit -> onSave] Updated project: ${updatedData.projectName} | Type: ${updatedData.type}");
                              isSaveComplete = true;
                              await fetchInternShipProjectDetails();
                            }
                          },
                        ),
                      );
                    },
                    onDelete: (index) {
                      print("🗑 Deleting project at index: $index");
                      setState(() {
                        projects.removeAt(index);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CertificatesSection(
                    certificatesList: certificatesList,
                    isLoading: isLoadingCertificate,
                    onAdd: () {
                      showModalBottomSheet(
                        context: innerContext,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        builder: (_) => EditCertificateBottomSheet(
                          initialData: null,
                          onSave: (certif) async {
                            try {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final authToken =
                                  prefs.getString('authToken') ?? '';
                              final connectSid =
                                  prefs.getString('connectSid') ?? '';

                              if (authToken.isEmpty || connectSid.isEmpty) {
                                throw Exception(
                                  'Missing auth token or session ID',
                                );
                              }
                              await CertificateApi.saveCertificateApi(
                                model: certif,
                                authToken: authToken,
                                connectSid: connectSid,
                              );
                              await fetchCertificateDetails();
                              if (innerContext.mounted)
                                Navigator.pop(innerContext);
                              // ScaffoldMessenger.of(innerContext).showSnackBar(
                              //   const SnackBar(content: Text('Certificate added successfully')),
                              // );
                            } catch (e) {
                              print('❌ Failed to add certificate: $e');
                              ScaffoldMessenger.of(innerContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to add certificate: $e',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                    onEdit: (certificate, index) {
                      showModalBottomSheet(
                        context: innerContext,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        builder: (_) => EditCertificateBottomSheet(
                          initialData: certificate,
                          onSave: (updatedCert) async {
                            try {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final authToken =
                                  prefs.getString('authToken') ?? '';
                              final connectSid =
                                  prefs.getString('connectSid') ?? '';

                              if (authToken.isEmpty || connectSid.isEmpty) {
                                throw Exception(
                                  'Missing auth token or session ID',
                                );
                              }

                              await CertificateApi.saveCertificateApi(
                                model: updatedCert,
                                authToken: authToken,
                                connectSid: connectSid,
                              );

                              await fetchCertificateDetails();
                              if (innerContext.mounted)
                                Navigator.pop(innerContext);
                              // ScaffoldMessenger.of(innerContext).showSnackBar(
                              //   const SnackBar(content: Text('Certificate updated successfully')),
                              // );
                            } catch (e) {
                              print('❌ Failed to update certificate: $e');
                              ScaffoldMessenger.of(innerContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to update certificate: $e',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                    onDelete: (index) async {
                      try {
                        final cert = certificatesList[index];
                        final prefs = await SharedPreferences.getInstance();
                        final authToken = prefs.getString('authToken') ?? '';
                        final connectSid = prefs.getString('connectSid') ?? '';

                        if (authToken.isEmpty || connectSid.isEmpty) {
                          throw Exception('Missing auth token or session ID');
                        }

                        // await CertificateApi.deleteCertificateApi(
                        //   certificateId: cert.id, // replace with actual ID field name
                        //   authToken: authToken,
                        //   connectSid: connectSid,
                        // );

                        await fetchCertificateDetails();
                        // ScaffoldMessenger.of(innerContext).showSnackBar(
                        //   const SnackBar(content: Text('Certificate deleted successfully')),
                        // );
                      } catch (e) {
                        print('❌ Failed to delete certificate: $e');
                        ScaffoldMessenger.of(innerContext).showSnackBar(
                          SnackBar(content: Text('Failed to delete: $e')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  WorkExperienceSection(
                    workExperiences: workExperiences,
                    isLoading: isLoadingWorkExperience,
                    onAdd: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        builder: (_) => EditWorkExperienceBottomSheet(
                          initialData: null,
                          onSave: (WorkExperienceModel newData) async {
                            final prefs = await SharedPreferences.getInstance();
                            final authToken = prefs.getString('authToken') ?? '';
                            final connectSid = prefs.getString('connectSid') ?? '';
                            final success = await WorkExperienceApi.saveWorkExperience(
                              model: newData,
                              authToken: authToken,
                              connectSid: connectSid,
                            );
                            if (success) await fetchWorkExperienceDetails();
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    onEdit: (workExperience, index) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        builder: (_) => EditWorkExperienceBottomSheet(
                          initialData: workExperience,
                          onSave: (WorkExperienceModel updated) async {
                            final prefs = await SharedPreferences.getInstance();
                            final authToken = prefs.getString('authToken') ?? '';
                            final connectSid = prefs.getString('connectSid') ?? '';

                            final success = await WorkExperienceApi.saveWorkExperience(
                              model: updated,
                              authToken: authToken,
                              connectSid: connectSid,
                            );
                            if (success) await fetchWorkExperienceDetails();
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    onDelete: (index) {
                      setState(() {
                        workExperiences.removeAt(index);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  LanguagesSection(
                    languageList: languageList,
                    isLoading: isLoadingLanguages,
                    onAdd: () {
                      showModalBottomSheet(
                        context: innerContext,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        builder: (_) => LanguageBottomSheet(
                          initialData: null,
                          onSave: (LanguagesModel data) {
                            setState(() {
                              languageList.add(data);
                            });
                          },
                        ),
                      );
                    },
                    onDelete: (index) {
                      setState(() {
                        languageList.removeAt(index);
                      });
                    },
                    // // If you want to enable edit too:
                    // onEdit: (language, index) {
                    //   showModalBottomSheet(
                    //     context: innerContext,
                    //     isScrollControlled: true,
                    //     backgroundColor: Colors.white,
                    //     builder: (_) => LanguageBottomSheet(
                    //       initialData: language,
                    //       onSave: (LanguagesModel data) {
                    //         setState(() {
                    //           languageList[index] = data;
                    //         });
                    //       },
                    //     ),
                    //   );
                    // },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double sizeScale = widthScale.clamp(0.98, 1.02);

    Widget displayedImage;

    if (_profileImage != null) {
      displayedImage = Image.file(_profileImage!, fit: BoxFit.cover);
    } else if (_imageUpdateData?.userImage != null &&
        _imageUpdateData!.userImage!.isNotEmpty) {
      displayedImage = Image.network(
        _imageUpdateData!.userImage!,
        fit: BoxFit.cover,
      );
    } else {
      displayedImage = const Image(
        image: AssetImage('assets/placeholder.jpg'),
        fit: BoxFit.cover,
      );
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 160 * sizeScale,
              height: 160 * sizeScale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF005E6A),
                  width: 2.3 * sizeScale,
                ),
              ),
              child: ClipOval(child: displayedImage),
            ),
            Positioned(
              bottom: 8 * sizeScale,
              right: 8 * sizeScale,
              child: GestureDetector(
                onTap: _showImagePickerOption,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18 * sizeScale,
                  child: Icon(
                    Clarity.note_edit_line,
                    size: 25 * sizeScale,
                    color: const Color(0xFF005E6A),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '${_imageUpdateData?.firstName ?? ''} ${_imageUpdateData?.lastName ?? ''}'
                  .trim()
                  .isNotEmpty
              ? '${_imageUpdateData?.firstName ?? ''} ${_imageUpdateData?.lastName ?? ''}'
                    .trim()
              : '',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF005E6A),
          ),
        ),
      ],
    );
  }
}
