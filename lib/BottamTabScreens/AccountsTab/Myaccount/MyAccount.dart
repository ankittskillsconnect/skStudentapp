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

import 'MyaccountElements/CertificateDetails.dart';
import 'MyaccountElements/EducationDetails.dart';
import 'MyaccountElements/LanguageDetails.dart';
import 'MyaccountElements/Personaldetails.dart';
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
  bool isLoadingEducation = true;
  bool isLoadingProject = true;
  bool isLoadingWorkExperience = true;
  bool isLoadingCertificate = true;
  bool isLoadingSkills = true;
  bool isLoadingLanguages = true;
  bool isLoadingPersonalDetail = true;
  File? _profileImage;

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
      final internshipProjectApi =
          await InternshipProjectApi.fetchInternshipProjects(
            authToken: authToken,
            connectSid: connectSid,
          );
      setState(() {
        projects = internshipProjectApi;
        isLoadingProject = false;
        print('Projects Fetched');
      });
    } catch (e) {
      print("❌ Error fetching project details: $e");
      setState(() {
        isLoadingProject = false;
      });
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
                          Navigator.pop(innerContext);
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
                          Navigator.pop(innerContext);
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
                          Navigator.pop(innerContext);
                        },
                      ),
                    );
                  },
                  onDeleteSkill: (skill, singleSkill) {
                    setState(() {
                      final updatedSkills = skill.skills
                          .split(',')
                          .map((s) => s.trim())
                          .where((s) => s != singleSkill)
                          .toList();
                      if (updatedSkills.isEmpty) {
                        skillList.remove(skill);
                      } else {
                        skill.skills = updatedSkills.join(',');
                      }
                    });
                  },
                ),
                const SizedBox(height: 20),
                ProjectsSection(
                  projects: projects,
                  isLoading: isLoadingProject,
                  onAdd: () {
                    showModalBottomSheet(
                      context: innerContext,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      builder: (_) => EditProjectDetailsBottomSheet(
                        initialData: null,
                        onSave: (data) {
                          setState(() {
                            projects.add(data);
                          });
                          Navigator.pop(innerContext);
                        },
                      ),
                    );
                  },
                  onEdit: (project, index) {
                    showModalBottomSheet(
                      context: innerContext,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      builder: (_) => EditProjectDetailsBottomSheet(
                        initialData: project,
                        onSave: (data) {
                          setState(() {
                            projects[index] = data;
                          });
                          Navigator.pop(innerContext);
                        },
                      ),
                    );
                  },
                  onDelete: (index) {
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
                        onSave: (data) {
                          setState(() {
                            certificatesList.add(data);
                          });
                          Navigator.pop(innerContext);
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
                        onSave: (data) {
                          setState(() {
                            certificatesList[index] = data;
                          });
                          Navigator.pop(innerContext);
                        },
                      ),
                    );
                  },
                  onDelete: (index) {
                    setState(() {
                      certificatesList.removeAt(index);
                    });
                  },
                ),
                const SizedBox(height: 20),
                WorkExperienceSection(
                  workExperiences: workExperiences,
                  isLoading: isLoadingWorkExperience,
                  onAdd: () {
                    showModalBottomSheet(
                      context: innerContext,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      builder: (_) => Editworkexperiencebottomsheet(
                        initialData: null,
                        onSave: (WorkExperienceModel newData) {
                          setState(() {
                            workExperiences.add(newData);
                          });
                          Navigator.pop(innerContext);
                        },
                      ),
                    );
                  },
                  onEdit: (workExperience, index) {
                    showModalBottomSheet(
                      context: innerContext,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      builder: (_) => Editworkexperiencebottomsheet(
                        initialData: workExperience,
                        onSave: (WorkExperienceModel updated) {
                          setState(() {
                            workExperiences[index] = updated;
                          });
                          Navigator.pop(innerContext);
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
                  onEdit: (language, index) {
                    showModalBottomSheet(
                      context: innerContext,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      builder: (_) => LanguageBottomSheet(
                        initialData: language,
                        onSave: (LanguagesModel data) {
                          setState(() {
                            languageList[index] = data;
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
                ),
                const SizedBox(height: 20),
              ],
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
              child: ClipOval(
                child: _profileImage != null
                    ? Image.file(_profileImage!, fit: BoxFit.cover)
                    : const Image(
                        image: AssetImage('assets/placeholder.jpg'),
                        fit: BoxFit.cover,
                      ),
              ),
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
          fullname,
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
