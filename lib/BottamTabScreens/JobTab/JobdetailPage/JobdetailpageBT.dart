import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JobDetailPage2 extends StatefulWidget {
  const JobDetailPage2({super.key});

  @override
  State<JobDetailPage2> createState() => _JobDetailPage2State();
}

class _JobDetailPage2State extends State<JobDetailPage2> {
  final List<String> responsibilities = [
    'Initially students will be placed in various departments – Warping, Weaving, TFO, Monofilament, Packing & Dispatch, Stitching, Processing, Non – Woven etc. of our factory, to understand the flow of production process.',
    'Post that their area of expertise will be finalised.',
  ];

  final List<String> termsAndConditions = [
    'Students shall be hired as GET (Graduate Engineer Trainee) , for minimum one year.',
    'Food to be arranged by students on their own. (Canteen Facility available at factory premises , which will be on actual cost).',
    'An Amount of Rs.1500/- per month shall be deducted towards Bachelor Accommodation (only applicable to students who are joining at Wada factory).',
    'There will be Retention Bonus for three years of Rs.1500 per month , the aforesaid amount shall be deducted every month and will be reimbursed on completion of three years with us.',
    'Non-Disclosure Affidavit cum Declaration will be there at the time of joining.',
    'Detail GET joining Letter (Appointment Letter) will be provided at the time of joining.',
  ];

  final List<String> requirements = [
    'Bachelors degree in Textile Engineering or related field',
    'Strong understanding of textile manufacturing processes and materials',
    'Ability to work well in a team environment',
    'Strong communication and organizational skills',
    'Willingness to learn and adapt to new technologies and processes',
    'Basic computer skills including proficiency in Microsoft Office',
  ];

  final List<String> niceToHave = [
    'Internship or project experience in the textile industry',
    'Understanding of sustainable textile production practices',
  ];

  final List<String> aboutCompany = [
    'Alphabet Pvt. Ltd. is a leading manufacturer of technical textiles and industrial filter fabrics, serving industries like pharma, mining, food processing, and wastewater treatment.',
    'With over 40 years of experience and state-of-the-art facilities in Maharashtra, Daman, and Surat, they offer fully integrated production—from fiber to finished products.',
    'The company exports to 120+ countries and is known for quality, innovation, and sustainability.',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double heightScale = size.height / 640;
    final double fontScale = (widthScale * 0.8).clamp(0.8, 1.2);
    final double sizeScale = (widthScale * 0.9).clamp(0.9, 1.3);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50 * heightScale),
          child: Padding(
            padding: EdgeInsets.all(1 * sizeScale),
            child: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              titleSpacing: 0,
              title: Text(
                "Job Detail",
                style: TextStyle(
                  fontSize: 25 * fontScale,
                  color: const Color(0xFF003840),
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: Padding(
                padding: EdgeInsets.only(left: 12 * sizeScale),
                child: Center(
                  child: Container(
                    width: 46 * sizeScale,
                    height: 46 * sizeScale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.all(12),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 22 * sizeScale,
                        color: const Color(0xFF003840),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 12 * sizeScale),
                  child: Center(
                    child: Container(
                      width: 46 * sizeScale,
                      height: 46 * sizeScale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.share,
                          size: 22 * sizeScale,
                          color: const Color(0xFF003840),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16 * sizeScale,
              vertical: 5 * sizeScale,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _jobHeader(size, widthScale, fontScale),
                _sectionTitle('Responsibilities of the Candidate:'),
                _bulletSection(responsibilities, sizeScale),
                _sectionTitle('Terms and Condition :-'),
                _bulletSection(termsAndConditions, sizeScale),
                _sectionTitle('Requirements:'),
                _bulletSection(requirements, sizeScale),
                _sectionTitle('Nice to Have:'),
                _bulletSection(niceToHave, sizeScale),
                _sectionTitle('About Company'),
                _bulletSection(aboutCompany, sizeScale),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(
            vertical: 12 * sizeScale,
            horizontal: 140 * sizeScale,
          ),
          color: const Color(0xFFEFF8F9),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005E6A),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16 * sizeScale),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30 * sizeScale),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Apply Now",
                    style: TextStyle(
                      fontSize: 16 * fontScale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jobHeader(Size size, double widthScale, double fontScale) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5 * widthScale,
        vertical: 10 * widthScale,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/google.png',
                height: 48 * widthScale,
                width: 48 * widthScale,
              ),
              SizedBox(width: 10 * widthScale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Software engineer",
                            style: TextStyle(
                              fontSize: 18 * fontScale,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF005E6A),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.bookmark_add_outlined,
                            size: 26 * widthScale,
                            color: const Color(0xFF005E6A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Google • Surat, India",
                      style: TextStyle(
                        fontSize: 14 * fontScale,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14 * widthScale),
          Padding(
            padding: EdgeInsets.only(left: 10 * widthScale),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 10 * widthScale,
                children: const [
                  _Tag(label: "Full-time"),
                  _Tag(label: "In-office"),
                  _Tag(label: "14 Openings"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF003840),
      ),
    ),
  );

  Widget _bulletSection(List<String> items, double scale) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFEBF6F7),
      borderRadius: BorderRadius.circular(12 * scale),
    ),
    padding: EdgeInsets.symmetric(vertical: 10 * scale, horizontal: 12 * scale),
    margin: EdgeInsets.only(bottom: 8 * scale),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((e) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4 * scale),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("\u2022 ", style: TextStyle(fontSize: 16 * scale)),
              Expanded(
                child: Text(e, style: TextStyle(fontSize: 14 * scale)),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthScale = size.width / 360;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * widthScale,
        vertical: 6 * widthScale,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F9),
        borderRadius: BorderRadius.circular(20 * widthScale),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: const Color(0xFF005E6A),
          fontSize: 14 * widthScale,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
