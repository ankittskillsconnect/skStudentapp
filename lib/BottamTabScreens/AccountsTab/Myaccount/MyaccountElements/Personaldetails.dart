import 'package:flutter/material.dart';
import 'package:sk_loginscreen1/Model/PersonalDetail_Model.dart';
import 'DetailRow.dart';
import 'SectionHeader.dart';
import 'ShimmerWidgets.dart';
import 'package:icons_plus/icons_plus.dart';

class PersonalDetailsSection extends StatelessWidget {
  final PersonalDetailModel? personalDetail;
  final bool isLoading;
  final VoidCallback onEdit;

  const PersonalDetailsSection({
    super.key,
    required this.personalDetail,
    required this.isLoading,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double fontScale = widthScale.clamp(0.98, 1.02);
    final double sizeScale = widthScale.clamp(0.98, 1.02);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Personal Details",
          showEdit: personalDetail != null,
          onEdit: onEdit,
        ),
        isLoading
            ? PersonalDetailsShimmer(sizeScale: sizeScale, fontScale: fontScale)
            : personalDetail == null
            ? const Text('No personal details available.')
            : _buildCardBody(
          children: [
            DetailRow(
              icon: Icons.perm_identity_outlined,
              text: '${personalDetail!.firstName} ${personalDetail!.lastName}',
            ),
            DetailRow(icon: Icons.cake_outlined, text: personalDetail!.dateOfBirth),
            DetailRow(icon: Icons.phone_outlined, text: personalDetail!.mobile),
            DetailRowIconplus(icon: Bootstrap.whatsapp, text: personalDetail!.whatsAppNumber),
            DetailRow(
              icon: Icons.location_on_outlined,
              text: personalDetail!.state.isEmpty
                  ? 'Not provided'
                  : '${personalDetail!.state}, ${personalDetail!.city}',
            ),
            DetailRow(
              icon: Icons.mark_email_read_outlined,
              text: personalDetail!.email,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardBody({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFBCD8DB)),
        borderRadius: BorderRadius.circular(12 ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class DetailRowIconplus extends StatelessWidget {
  final IconData icon;
  final String text;

  const DetailRowIconplus({super.key, required this.icon, required this.text});

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
          Icon(icon, size: 17 * sizeScale, color: const Color(0xFF005E6A)),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14 * fontScale),
            ),
          ),
        ],
      ),
    );
  }
}