import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/InternshipProject_Api.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/PersonalDetail_Api.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/WorkExperience_Api.dart';
import 'package:sk_loginscreen1/Model/EducationDetail_Model.dart';
import 'package:sk_loginscreen1/Model/Languages_Model.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/CertificateDetails_APi.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/EducationDetail_Api.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/LanguagesGet_Api.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/Skills_Api.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditEducationBottomSheet.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditLanguageBottomSheet.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditPersonalDetailSheet.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditSkillsBottomSheet.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../Model/Image_update_Model.dart';
import '../../../Model/Percentage_bar_Model.dart';
import '../../../Utilities/Language_Api.dart';
import '../../../Utilities/MyAccount_Get_Post/Image_Api.dart';
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
  bool _snackBarShown = false;


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
      final internshipProjectApi = await InternshipProjectApi
          .fetchInternshipProjects(
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.photo_library_outlined,
                color: const Color(0xFF005E6A),
                size: 22.w,
              ),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(
                    fontSize: 14.sp, color: const Color(0xFF003840)),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.camera_alt_outlined,
                color: const Color(0xFF005E6A),
                size: 22.w,
              ),
              title: Text(
                'Take a Photo',
                style: TextStyle(
                    fontSize: 14.sp, color: const Color(0xFF003840)),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_profileImage != null)
              ListTile(
                leading: Icon(
                    Icons.delete_outline, color: Colors.red, size: 22.w),
                title: Text(
                  'Remove Image',
                  style: TextStyle(fontSize: 14.sp, color: Colors.red),
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

  void _showSnackBarOnce(BuildContext context, String message,
      {int cooldownSeconds = 3}) {
    if (_snackBarShown) return;

    _snackBarShown = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontSize: 12.sp)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: cooldownSeconds),
      ),
    );

    Future.delayed(Duration(seconds: cooldownSeconds), () {
      _snackBarShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Scaffold(
      appBar: const AccountAppBar(),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (innerContext) =>
            SafeArea(
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
                      horizontal: 14.w, vertical: 17.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildProfileHeader(),
                      SizedBox(height: 22.h),
                      const ProfileCompletionBar(),
                      SizedBox(height: 22.h),
                      PersonalDetailsSection(
                        personalDetail: personalDetail,
                        isLoading: isLoadingPersonalDetail,
                        onEdit: () {
                          showModalBottomSheet(
                            context: innerContext,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            builder: (_) =>
                                EditPersonalDetailsSheet(
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
                      SizedBox(height: 17.h),
                      EducationSection(
                        educationDetails: educationDetails,
                        isLoading: isLoadingEducation,
                        onAdd: () {
                          showModalBottomSheet(
                            context: innerContext,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            builder: (_) =>
                                EditEducationBottomSheet(
                                  onSave: (data) {
                                    setState(() {
                                      educationDetails.add(
                                          data['educationDetail']);
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
                            builder: (_) =>
                                EditEducationBottomSheet(
                                  initialData: edu,
                                  onSave: (data) {
                                    setState(() {
                                      educationDetails[index] =
                                      data['educationDetail'];
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
                      SizedBox(height: 17.h),
                      const ResumeSection(),
                      SizedBox(height: 17.h),
                      SkillsSection(
                        skillList: skillList,
                        isLoading: isLoadingSkills,
                        onEdit: () {
                          showModalBottomSheet(
                            context: innerContext,
                            isScrollControlled: true,
                            builder: (_) =>
                                EditSkillsBottomSheet(
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
                            builder: (_) =>
                                EditSkillsBottomSheet(
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
                      SizedBox(height: 17.h),
                      ProjectsSection(
                        projects: projects,
                        isLoading: isLoadingProject,
                        onAdd: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final authToken = prefs.getString('authToken') ?? '';
                          final connectSid = prefs.getString('connectSid') ??
                              '';
                          if (authToken.isEmpty || connectSid.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Error: Please log in again.')),
                            );
                            return;
                          }
                          print("🆕 Opening Add Project BottomSheet");
                          bool isSaveComplete = false;
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(14.r)),
                            ),
                            builder: (context) =>
                                EditProjectDetailsBottomSheet(
                                  initialData: null,
                                  onSave: (newData) async {
                                    if (!isSaveComplete) {
                                      print(
                                          "✅ [onAdd -> onSave] Saved new project: ${newData
                                              .projectName} | Type: ${newData
                                              .type}");
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
                          final connectSid = prefs.getString('connectSid') ??
                              '';
                          if (authToken.isEmpty || connectSid.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Error: Please log in again.')),
                            );
                            return;
                          }

                          bool isSaveComplete = false;
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(14.r)),
                            ),
                            builder: (context) =>
                                EditProjectDetailsBottomSheet(
                                  initialData: project,
                                  onSave: (updatedData) async {
                                    if (!isSaveComplete) {
                                      print(
                                          "✅ [onEdit -> onSave] Updated project: ${updatedData
                                              .projectName} | Type: ${updatedData
                                              .type}");
                                      isSaveComplete = true;
                                      await fetchInternShipProjectDetails();
                                    }
                                  },
                                ),
                          );
                        },
                        onDelete: (int index) async {
                          final internshipId = int.tryParse(projects[index].internshipId ?? '');
                          if (internshipId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid internship ID')),
                            );
                            return;
                          }

                          final prefs = await SharedPreferences.getInstance();
                          final authToken = prefs.getString('authToken') ?? '';
                          final connectSid = prefs.getString('connectSid') ?? '';

                          final success = await InternshipProjectApi.deleteProjectInternship(
                            internshipId: internshipId,
                            authToken: authToken,
                            connectSid: connectSid,
                          );

                          if (success) {
                            setState(() {
                              projects.removeAt(index);
                            });
                            _showSnackBarOnce(
                                context, "Internship deleted successfully ");
                          } else {
                            _showSnackBarOnce(
                                context, "Failed to delete Internship");
                          }
                        },
                      ),
                      SizedBox(height: 17.h),
                      CertificatesSection(
                        certificatesList: certificatesList,
                        isLoading: isLoadingCertificate,
                        onAdd: () {
                          showModalBottomSheet(
                            context: innerContext,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            builder: (_) =>
                                EditCertificateBottomSheet(
                                  initialData: null,
                                  onSave: (certif) async {
                                    try {
                                      final prefs =
                                      await SharedPreferences.getInstance();
                                      final authToken =
                                          prefs.getString('authToken') ?? '';
                                      final connectSid =
                                          prefs.getString('connectSid') ?? '';

                                      if (authToken.isEmpty ||
                                          connectSid.isEmpty) {
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
                                    } catch (e) {
                                      print('❌ Failed to add certificate: $e');
                                      ScaffoldMessenger
                                          .of(innerContext)
                                          .showSnackBar(
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
                            builder: (_) =>
                                EditCertificateBottomSheet(
                                  initialData: certificate,
                                  onSave: (updatedCert) async {
                                    try {
                                      final prefs =
                                      await SharedPreferences.getInstance();
                                      final authToken =
                                          prefs.getString('authToken') ?? '';
                                      final connectSid =
                                          prefs.getString('connectSid') ?? '';

                                      if (authToken.isEmpty ||
                                          connectSid.isEmpty) {
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
                                    } catch (e) {
                                      print(
                                          '❌ Failed to update certificate: $e');
                                      ScaffoldMessenger
                                          .of(innerContext)
                                          .showSnackBar(
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
                        onDelete: (int index) async {
                          final certificationId = int.tryParse(certificatesList[index].certificationId ?? '');
                          if (certificationId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid certificate ID')),
                            );
                            return;
                          }

                          final prefs = await SharedPreferences.getInstance();
                          final authToken = prefs.getString('authToken') ?? '';
                          final connectSid = prefs.getString('connectSid') ?? '';

                          final success = await CertificateApi.deleteCertificate(
                            certificationId: certificationId,
                            authToken: authToken,
                            connectSid: connectSid,
                          );

                          if (success) {
                            setState(() {
                              certificatesList.removeAt(index);
                            });
                            _showSnackBarOnce(
                                context, "Certificate deleted successfully ");
                          } else {
                            _showSnackBarOnce(
                                context, "Failed to delete certificate");
                          }
                        },
                      ),
                      SizedBox(height: 17.h),
                      WorkExperienceSection(
                          workExperiences: workExperiences,
                          isLoading: isLoadingWorkExperience,
                          onAdd: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              builder: (_) =>
                                  EditWorkExperienceBottomSheet(
                                    initialData: null,
                                    onSave: (
                                        WorkExperienceModel newData) async {
                                      final prefs = await SharedPreferences
                                          .getInstance();
                                      final authToken = prefs.getString(
                                          'authToken') ?? '';
                                      final connectSid = prefs.getString(
                                          'connectSid') ?? '';
                                      final success = await WorkExperienceApi
                                          .saveWorkExperience(
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
                              builder: (_) =>
                                  EditWorkExperienceBottomSheet(
                                    initialData: workExperience,
                                    onSave: (
                                        WorkExperienceModel updated) async {
                                      final prefs = await SharedPreferences
                                          .getInstance();
                                      final authToken = prefs.getString(
                                          'authToken') ?? '';
                                      final connectSid = prefs.getString(
                                          'connectSid') ?? '';

                                      final success = await WorkExperienceApi
                                          .saveWorkExperience(
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
                        onDelete: (int index) async {
                          final workExperienceId = int.tryParse(workExperiences[index].workExperienceId ?? '');
                          final prefs = await SharedPreferences.getInstance();
                          final authToken = prefs.getString('authToken') ?? '';
                          final connectSid = prefs.getString('connectSid') ?? '';

                          final success = await WorkExperienceApi.deleteWorkExperience(
                            workExperienceId: workExperienceId,
                            authToken: authToken,
                            connectSid: connectSid,
                          );

                          if (success) {
                            setState(() {
                              workExperiences.removeAt(index);
                            });
                            _showSnackBarOnce(
                                context, "Work Experience deleted successfully ");
                          } else {
                            _showSnackBarOnce(
                                context, "Failed to delete Work Experience");
                          }
                        },
                      ),
                      SizedBox(height: 17.h),
                      LanguagesSection(
                        languageList: languageList,
                        isLoading: isLoadingLanguages,
                        onAdd: () {
                          showModalBottomSheet(
                            context: innerContext,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            builder: (_) =>
                                LanguageBottomSheet(
                                  initialData: null,
                                  onSave: (LanguagesModel data) {
                                    setState(() {
                                      languageList.add(data);
                                    });
                                  },
                                ),
                          );
                        },
                        onDelete: (int index) async {
                          final languageId = languageList[index].id;
                          final prefs = await SharedPreferences.getInstance();
                          final authToken = prefs.getString('authToken') ?? '';
                          final connectSid = prefs.getString('connectSid') ?? '';
                          final success = await LanguageDetailApi
                              .deleteLanguage(
                            id: languageId,
                            authToken: authToken,
                            connectSid: connectSid,
                          );
                          if (success) {
                            setState(() {
                              languageList.removeAt(index);
                            });
                            _showSnackBarOnce(
                                context, "Language deleted successfully ");
                          } else {
                            _showSnackBarOnce(context,
                                "Failed to delete language, try again");
                          }
                        },
                      ),
                      SizedBox(height: 17.h),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildProfileHeader() {
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
              width: 140.w,
              height: 140.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF005E6A),
                  width: 2.w,
                ),
              ),
              child: ClipOval(child: displayedImage),
            ),
            Positioned(
              bottom: 7.h,
              right: 7.w,
              child: GestureDetector(
                onTap: _showImagePickerOption,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16.r,
                  child: Icon(
                    Clarity.note_edit_line,
                    size: 22.w,
                    color: const Color(0xFF005E6A),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          '${_imageUpdateData?.firstName ?? ''} ${_imageUpdateData?.lastName ??
              ''}'
              .trim()
              .isNotEmpty
              ? '${_imageUpdateData?.firstName ?? ''} ${_imageUpdateData
              ?.lastName ?? ''}'
              .trim()
              : '',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF005E6A),
          ),
        ),
      ],
    );
  }
}