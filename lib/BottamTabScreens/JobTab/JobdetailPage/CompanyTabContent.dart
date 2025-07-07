import 'package:flutter/cupertino.dart';

class Companytabcontent extends StatelessWidget {
  const Companytabcontent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      children: const [
        SectionTitle("About Company"),
        Subpoints(
          "Alphabet Pvt. Ltd. is a leading manufacturer of technical textiles and industrial filter fabrics, serving industries like pharma, mining, food processing, and wastewater treatment. ",
        ),
        SizedBox(height: 20),
        Subpoints(
          "tWith over 40 years of experience and state-of-the-art facilities in Maharashtra, Daman, and Surat, they offer fully integrated production—from fiber to finished product",
        ),
        SizedBox(height: 20),
        Subpoints(
          "The company exports to 120+ countries and is known for quality, innovation, and sustainability.",
        ),
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

class Subpoints extends StatelessWidget {
  final String text;

  const Subpoints(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(text, style: TextStyle(fontSize: 14),),
          ),
        ],
      ),
    );
  }
}
