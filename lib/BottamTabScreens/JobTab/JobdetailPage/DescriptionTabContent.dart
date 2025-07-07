import 'package:flutter/cupertino.dart';

class DescriptionTabContent extends StatelessWidget {
  const DescriptionTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      children: const [
        SectionTitle("Responsibilities of the Candidate:"),
        BulletPoint(
          "Initially students will be placed in various departments  - Warping, Weaving, TFO , Monofilament, Packing & Dispatch , Stitching , Processing , Non - Woven etc..of our factory , to understand the flow of production process..",
        ),
        BulletPoint("Post that their area of expertise will be finalised."),
        SizedBox(height: 10),
        SectionTitle("Terms and Condition :-"),
        BulletPoint(
          "Students shall be hired as GET (Graduate Engineer Trainee)  , for minimum one year.",
        ),
        BulletPoint(
          "Food to be arranged by students on their own. (Canteen Facility available at factory premises , which will be on actual cost).",
        ),
        BulletPoint(
          "There will be Retention Bonus for three years of Rs.1500 per month , the aforesaid amount shall be deducted every month and will be reimbursed on completion of three years with us.",
        ),
        BulletPoint("Detail GET joining Letter (Appointment Letter) will be provided at the time of joining."),
        SizedBox(height: 10),
        SectionTitle("Requirements:"),
        BulletPoint("Bachelors degree in Textile Engineering or related field"),
        BulletPoint("Strong understanding of textile manufacturing processes and materials"),
        BulletPoint("Ability to work well in a team environment"),
        BulletPoint("Strong communication and organizational skills"),
        BulletPoint("Willingness to learn and adapt to new technologies and processes"),
        BulletPoint("Basic computer skills including proficiency in Microsoft Office"),
        SizedBox(height: 10),
        SectionTitle("Nice to Have:"),
        BulletPoint("Internship or project experience in the textile industry"),
        BulletPoint("Understanding of sustainable textile production practices"),
        BulletPoint("Understanding of sustainable textile production practices"),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        color: Color(0xFF003840),
        fontSize: 16
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: TextStyle(fontSize: 15),)),
        ],
      ),
    );
  }
}
