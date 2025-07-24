import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditCertificateBottomSheet.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditProjectBottomSheet.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/BottomSheets/EditWorkExperienceBottomSheet.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/Myaccount/MyAccountAppbar.dart';
import 'package:sk_loginscreen1/Model/CertificateDetails_Model.dart';
import 'package:sk_loginscreen1/Model/Internship_Projects_Model.dart';
import 'package:sk_loginscreen1/Model/Skiils_Model.dart';
import 'package:sk_loginscreen1/Model/WorkExperience_Model.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/Get/InternshipProject_Api.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/Get/WorkExperience_Api.dart';
import '../../../Model/EducationDetail_Model.dart';
import '../../../Model/Languages_Model.dart';
import '../../../Utilities/MyAccount_Get_Post/Get/CertificateDetails_APi.dart';
import '../../../Utilities/MyAccount_Get_Post/Get/EducationDetail_Api.dart';
import '../../../Utilities/MyAccount_Get_Post/Get/LanguagesGet_Api.dart';
import '../../../Utilities/MyAccount_Get_Post/Get/Skills_Api.dart';
import '../BottomSheets/EditEducationBottomSheet.dart';
import '../BottomSheets/EditLanguageBottomSheet.dart';
import '../BottomSheets/EditPersonalDetailSheet.dart';
import '../BottomSheets/EditSkillsBottomSheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  String fullname = "John";
  String dob = "16, May 2004";
  String phone = "9892552373";
  String whatsapp = "9892552373";
  String email = "akhilesh.skillsconnect@gmail.com";
  String state = "Maharashtra";
  String city = "Mumbai";
  String country = "India";

  EducationDetailModel? educationDetail;

  // String degreeType = "Undergrad";
  // String courseName = "Bsc IT";
  // String college = "Birla College kalyan";
  // String specilization = "Flutter";
  // String courseType = "Full-time";
  // String gradingSystem = "CGPa";
  // String percentage = "86.5";
  // String passingYear = "2025";

  List<SkillsModel> skillList = [];
  List<InternshipProjectModel> projects = [];
  List<CertificateModel> certificatesList = [];
  List<WorkExperienceModel> workExperiences = [];
  List<LanguagesModel> languageList = [];
  List<EducationDetailModel> educationDetails = [];
  bool isLoadingEducation = true;
  bool isLoadingProject = true;
  bool isLoadingWorkExperience = true;
  bool isLoadingCertificate = true;
  bool isLoadingSkills = true;
  bool isLoadingLanguages = true;
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
    // projects.add({
    //   'projectDetail': null,
    //   'projectName': 'Project A',
    //   'companyName': 'Tech Corp',
    //   'projectType': 'Project',
    //   'skills': 'HTML, CSS, Flutter',
    //   'startDate': '2025-06-01',
    //   'endDate': '2025-12-01',
    //   'projectDetailDesc': 'A sample project description',
    // });
    // certificates.add({
    //   'certificateDetail': null,
    //   'certificateName': 'Cert A',
    //   'issuedBy': 'Cert Authority',
    //   'credentialId': '12345',
    //   'issuedDate': '2025-01-01',
    //   'expiredDate': '2026-01-01',
    //   'description': 'Sample certificate description',
    // });
    // workExperiences.add({
    //   'WorkExp': null,
    //   'jobTitle': 'Developer',
    //   'companyName': 'Work Corp',
    //   'skills': 'Java, Python',
    //   'fromDate': '2024-06-01',
    //   'toDate': '2025-06-26',
    //   'experienceInYear': '1',
    //   'experienceInMonths': '6',
    //   'annualSalary': '10 LPA',
    //   'jobDetail': 'Sample work experience description',
    // });
    // languages.add({'Language': null, 'language': 'English'});
  }

  // Future<void> _loadSavedData() async {
  //   try {
  //     final data = await SharedPrefHelper.loadData();
  //     setState(() {
  //       fullname = data['fullname'] as String? ?? fullname;
  //       dob = data['dob'] as String? ?? dob;
  //       phone = data['phone'] as String? ?? phone;
  //       whatsapp = data['whatsapp'] as String? ?? whatsapp;
  //       email = data['email'] as String? ?? email;
  //       state = data['state'] as String? ?? state;
  //       city = data['city'] as String? ?? city;
  //       country = data['country'] as String? ?? country;
  //       educationDetail = data['educationDetail'] as String?;
  //       degreeType = data['degreeType'] as String? ?? degreeType;
  //       courseName = data['courseName'] as String? ?? courseName;
  //       college = data['college'] as String? ?? college;
  //       specilization = data['specilization'] as String? ?? specilization;
  //       courseType = data['courseType'] as String? ?? courseType;
  //       gradingSystem = data['gradingSystem'] as String? ?? gradingSystem;
  //       percentage = data['percentage'] as String? ?? percentage;
  //       passingYear = data['passingYear'] as String? ?? passingYear;
  //       skills = List<String>.from(data['skills'] as List<dynamic>? ?? []);
  //       projects = List<Map<String, dynamic>>.from(
  //         data['projects'] as List<dynamic>? ?? [],
  //       );
  //       certificates = List<Map<String, dynamic>>.from(
  //         data['certificates'] as List<dynamic>? ?? [],
  //       );
  //       workExperiences = List<Map<String, dynamic>>.from(
  //         data['workExperiences'] as List<dynamic>? ?? [],
  //       );
  //       languages = List<Map<String, dynamic>>.from(
  //         data['languages'] as List<dynamic>? ?? [],
  //       );
  //       _profileImage = data['profileImage'] as File?;
  //     });
  //   } catch (e) {
  //     print('Error loading data: $e');
  //   }
  // }

  // Future<void> _saveData() async {
  //   print('Attempting to save data in MyAccount');
  //   await SharedPrefHelper.saveData(
  //     fullname: fullname,
  //     dob: dob,
  //     phone: phone,
  //     whatsapp: whatsapp,
  //     email: email,
  //     state: state,
  //     city: city,
  //     country: country,
  //     educationDetail: educationDetail,
  //     degreeType: degreeType,
  //     courseName: courseName,
  //     college: college,
  //     specilization: specilization,
  //     courseType: courseType,
  //     gradingSystem: gradingSystem,
  //     percentage: percentage,
  //     passingYear: passingYear,
  //     skills: skills,
  //     projects: projects,
  //     certificates: certificates,
  //     workExperiences: workExperiences,
  //     languages: languages,
  //     profileImage: _profileImage,
  //   );
  //   print('Data save completed in MyAccount');
  // }

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
        setState(() {
          isLoadingSkills = false;
        });

      });
    } catch (e) {
      print(' Error fetching skills: $e');
    }
  }

  void fetchLanguageData() async {
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
      // await _saveData();
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
                  // _saveData();
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
    final double fontScale = widthScale.clamp(0.98, 1.02);
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
                _buildSectionHeader(
                  "Personal Details",
                  showEdit: true,
                  onEdit: () {
                    showModalBottomSheet(
                      context: innerContext,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => EditPersonalDetailsSheet(
                        fullname: fullname,
                        dob: dob,
                        phone: phone,
                        whatsapp: whatsapp,
                        email: email,
                        state: state,
                        city: city,
                        country: country,
                        onSave: (updatedData) {
                          setState(() {
                            fullname = updatedData['fullname'] ?? fullname;
                            dob = updatedData['dob'] ?? dob;
                            phone = updatedData['phone'] ?? phone;
                            whatsapp = updatedData['whatsapp'] ?? whatsapp;
                            email = updatedData['email'] ?? email;
                            state = updatedData['state'] ?? state;
                            city = updatedData['city'] ?? city;
                            country = updatedData['country'] ?? country;
                          });
                          // _saveData();
                          Navigator.pop(innerContext);
                        },
                      ),
                    );
                  },
                ),
                _buildCardBody(
                  children: [
                    _DetailRow(
                      icon: Icons.perm_identity_outlined,
                      text: fullname,
                    ),
                    _DetailRow(icon: Icons.cake_outlined, text: dob),
                    _DetailRow(icon: Icons.phone_outlined, text: phone),
                    _DetailRow(icon: Icons.message_outlined, text: whatsapp),
                    _DetailRow(
                      icon: Icons.location_on_outlined,
                      text: state.isEmpty ? 'Not provided' : '$state , $city',
                    ),
                    // _DetailRow(
                    //   icon: Icons.location_on_outlined,
                    //   text: city.isEmpty ? 'Not provided' : city,
                    // ),
                    _DetailRow(
                      icon: Icons.mark_email_read_outlined,
                      text: email,
                    ),
                  ],
                ),

                //education from here
                const SizedBox(height: 20),
                _buildSectionHeader(
                  "Education Details",
                  showAdd: true,
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
                ),
                if (isLoadingEducation)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (educationDetails.isNotEmpty)
                  ...educationDetails.map((edu) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14 * sizeScale),
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFBCD8DB)),
                        borderRadius: BorderRadius.circular(12 * sizeScale),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6 * sizeScale),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBF6F7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.school_outlined,
                              size: 24,
                              color: Color(0xFF005E6A),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  edu.degreeName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14 * fontScale,
                                    color: const Color(0xFF005E6A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${edu.courseName} | ${edu.specializationName} \nCGPA - ${edu.marks}',
                                  style: TextStyle(
                                    fontSize: 14 * fontScale,
                                    color: const Color(0xFF003840),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${edu.collegeMasterName}\n${edu.passingYear}',
                                  style: TextStyle(
                                    fontSize: 14 * fontScale,
                                    color: const Color(0xFF003840),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF005E6A)),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: innerContext,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    builder: (_) => EditEducationBottomSheet(
                                      initialData: edu,
                                      onSave: (data) {
                                        setState(() {
                                          final index = educationDetails.indexOf(edu);
                                          educationDetails[index] = data['educationDetail'];
                                        });
                                        Navigator.pop(innerContext);
                                      },
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    educationDetails.remove(edu);
                                  });
                                },
                              ),
                        ],
                      ),
                    );
                  }).toList()
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "No education details found.",
                      style: TextStyle(
                        fontSize: 14 * fontScale,
                        color: const Color(0xFF003840),
                      ),
                    ),
                  ),


                //education end
                //resume
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Resume",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005E6A),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16 * sizeScale,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30 * sizeScale),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14 * fontScale,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20 * sizeScale),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFBCD8DB)),
                    borderRadius: BorderRadius.circular(12 * sizeScale),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.upload,
                        size: 30 * sizeScale,
                        color: const Color(0xFF005E6A),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Upload Resume",
                        style: TextStyle(
                          color: const Color(0xFF005E6A),
                          fontSize: 14 * fontScale,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                //resume end
                // skills
                _buildSectionHeader(
                  "Skills",
                  showEdit: skillList.isNotEmpty,
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
                  showAdd: skillList.isEmpty,
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
                ),

                if (skillList.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(12 * sizeScale),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFBCD8DB)),
                      borderRadius: BorderRadius.circular(12 * sizeScale),
                    ),
                    child: Wrap(
                      spacing: 8 * sizeScale,
                      runSpacing: 8 * sizeScale,
                      children: skillList.expand((skill) {
                        return skill.skills
                            .split(',')
                            .map((s) => s.trim())
                            .where((s) => s.isNotEmpty)
                            .map((singleSkill) => Chip(
                          label: Text(
                            singleSkill,
                            style: TextStyle(fontSize: 14 * fontScale),
                          ),
                          onDeleted: () {
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
                          deleteIconColor: const Color(0xFF005E6A),
                          backgroundColor: const Color(0xFFEBF6F7),
                          labelStyle: const TextStyle(color: Color(0xFF003840)),
                        ));
                      }).toList(),
                    ),
                  ),


                const SizedBox(height: 20),

                //skills end
                // project
                _buildSectionHeader(
                  "Project/Internship Details",
                  showAdd: true,
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
                ),
                if (isLoadingProject)
                  const Center(child: CircularProgressIndicator())
                else if (projects.isEmpty)
                  const Center(
                    child: Text(
                      'No projects available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  Column(
                    children: List.generate(projects.length, (i) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14 * sizeScale),
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFBCD8DB)),
                          borderRadius: BorderRadius.circular(12 * sizeScale),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(6 * sizeScale),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBF6F7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.workspaces_filled,
                                size: 24,
                                color: Color(0xFF005E6A),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.lightGreen,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFFBCD8DB),
                                      ),
                                    ),
                                    child: Text(
                                      projects[i].type,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    projects[i].projectName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14 * fontScale,
                                      color: const Color(0xFF005E6A),
                                    ),
                                  ),
                                  Text(
                                    projects[i].companyName,
                                    style: TextStyle(
                                      fontSize: 14 * fontScale,
                                      color: const Color(0xFF003840),
                                    ),
                                  ),
                                  Text(
                                    '${projects[i].duration} - ${projects[i].durationPeriod}',
                                    style: TextStyle(
                                      fontSize: 14 * fontScale,
                                      color: const Color(0xFF003840),
                                    ),
                                  ),
                                  Text(
                                    projects[i].skills,
                                    style: TextStyle(
                                      fontSize: 13 * fontScale,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    projects[i].details,
                                    style: TextStyle(
                                      fontSize: 13 * fontScale,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w700,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Color(0xFF005E6A),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: innerContext,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  builder: (_) => EditProjectDetailsBottomSheet(
                                    initialData: projects[i],
                                    onSave: (data) {
                                      setState(() {
                                        projects[i] = data;
                                      });
                                      Navigator.pop(innerContext);
                                    },
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  projects.removeAt(i);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ),

                //project end
                //certificate
                const SizedBox(height: 20),
                _buildSectionHeader(
                  "Certificate Details",
                  showAdd: true,
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
                ),

                for (var i = 0; i < certificatesList.length; i++)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14 * sizeScale),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFBCD8DB)),
                      borderRadius: BorderRadius.circular(12 * sizeScale),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6 * sizeScale),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF6F7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.file_copy_outlined,
                            size: 24,
                            color: Color(0xFF005E6A),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                certificatesList[i].certificateName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14 * fontScale,
                                  color: const Color(0xFF005E6A),
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                certificatesList[i].issuedOrgName,
                                style: TextStyle(
                                  fontSize: 14 * fontScale,
                                  color: const Color(0xFF003840),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${certificatesList[i].issueDate} - ${certificatesList[i].expiryDate}',
                                style: TextStyle(
                                  fontSize: 14 * fontScale,
                                  color: const Color(0xFF003840),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                certificatesList[i].credId,
                                style: TextStyle(
                                  fontSize: 13 * fontScale,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                certificatesList[i].description,
                                style: TextStyle(
                                  fontSize: 13 * fontScale,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Color(0xFF005E6A),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: innerContext,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              builder: (_) => EditCertificateBottomSheet(
                                initialData: certificatesList[i],
                                onSave: (data) {
                                  setState(() {
                                    certificatesList[i] = data;
                                  });
                                  Navigator.pop(innerContext);
                                },
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              certificatesList.removeAt(i);
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                //certificated end
                //work experience here
                const SizedBox(height: 20),
                _buildSectionHeader(
                  "Work Experience",
                  showAdd: true,
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
                ),
                for (int i = 0; i < workExperiences.length; i++)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14 * sizeScale),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFBCD8DB)),
                      borderRadius: BorderRadius.circular(12 * sizeScale),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6 * sizeScale),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF6F7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.work_history_outlined,
                            size: 24,
                            color: Color(0xFF005E6A),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workExperiences[i].jobTitle,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14 * fontScale,
                                  color: const Color(0xFF005E6A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                workExperiences[i].organization,
                                style: TextStyle(
                                  fontSize: 14 * fontScale,
                                  color: const Color(0xFF003840),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${workExperiences[i].workFromDate} - ${workExperiences[i].workToDate}',
                                style: TextStyle(
                                  fontSize: 14 * fontScale,
                                  color: const Color(0xFF003840),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Skills: ${workExperiences[i].skills}',
                                style: TextStyle(
                                  fontSize: 13 * fontScale,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Exp: ${workExperiences[i].totalExperienceYears} yrs ${workExperiences[i].totalExperienceMonths} months \n'
                                'Salary: ${workExperiences[i].salaryInLakhs}.${workExperiences[i].salaryInThousands} LPA',
                                style: TextStyle(
                                  fontSize: 13 * fontScale,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                workExperiences[i].jobDescription,
                                style: TextStyle(
                                  fontSize: 13 * fontScale,
                                  color: Colors.grey[600],
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Color(0xFF005E6A),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: innerContext,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              builder: (_) => Editworkexperiencebottomsheet(
                                initialData: workExperiences[i],
                                onSave: (WorkExperienceModel updated) {
                                  setState(() {
                                    workExperiences[i] = updated;
                                  });
                                  Navigator.pop(innerContext);
                                },
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              workExperiences.removeAt(i);
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                //work experience ended
                //languages begin

                const SizedBox(height: 20),
                _buildSectionHeader(
                  "Languages",
                  showAdd: true,
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

                ),
                for (var i = 0; i < languageList.length; i++)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14 * sizeScale),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFBCD8DB)),
                      borderRadius: BorderRadius.circular(12 * sizeScale),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6 * sizeScale),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF6F7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.language,
                            size: 24,
                            color: Color(0xFF005E6A),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                languageList[i].languageName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14 * fontScale,
                                  color: const Color(0xFF005E6A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                languageList[i].proficiency,
                                style: TextStyle(
                                  fontSize: 12 * fontScale,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Color(0xFF005E6A),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: innerContext,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              builder: (_) => LanguageBottomSheet(
                                initialData: languageList[i],
                                onSave: (LanguagesModel data) {
                                  setState(() {
                                    languageList[i] = data;
                                  });
                                },
                              ),
                            );
                          },

                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              languageList.removeAt(i);
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),


                //Languages end here
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    VoidCallback? onEdit,
    VoidCallback? onAdd,
    bool showEdit = false,
    bool showAdd = false,
  }) {
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double fontScale = widthScale.clamp(0.98, 1.02);
    final double sizeScale = widthScale.clamp(0.98, 1.02);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18 * fontScale,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF003840),
          ),
        ),
        Row(
          children: [
            if (showEdit && onEdit != null)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: const Color(0xFF005E6A),
                  size: 20 * sizeScale,
                ),
                onPressed: onEdit,
              ),
            if (showAdd && onAdd != null)
              TextButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 20, color: Color(0xFF005E6A)),
                label: Text(
                  "Add",
                  style: TextStyle(
                    color: const Color(0xFF005E6A),
                    fontSize: 16 * fontScale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF005E6A), width: 1.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30 * sizeScale),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12 * sizeScale,
                    vertical: 6 * sizeScale,
                  ),
                  minimumSize: const Size(10, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardBody({required List<Widget> children}) {
    final size = MediaQuery.of(context).size;
    final double sizeScale = size.width / 360;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16 * sizeScale),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFBCD8DB)),
        borderRadius: BorderRadius.circular(12 * sizeScale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double fontScale = widthScale.clamp(0.98, 1.02);
    final double sizeScale = widthScale.clamp(0.98, 1.02);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6 * sizeScale),
      child: Row(
        children: [
          Icon(icon, size: 20 * sizeScale, color: const Color(0xFF005E6A)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14 * fontScale)),
          ),
        ],
      ),
    );
  }
}
