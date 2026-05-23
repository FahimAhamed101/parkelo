import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/AppColor/app_colors.dart';
import '../../../../base/AppText/appText.dart';
import '../../../../base/CustomAppbar/custom_appbar.dart';


class InviteFriendScreen extends StatelessWidget {
  const InviteFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Invite friend"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildEarnedCard(),
            const SizedBox(height: 16),
            _buildHowItWorksCard(),
            const SizedBox(height: 16),
            _buildReferralCodeCard(),
            const SizedBox(height: 16),
            _buildReferralsListCard(),
            const SizedBox(height: 16),
            _buildBalanceCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEarnedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0052AD), // Darker blue to match mockup
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text("💐", style: TextStyle(fontSize: 32)),
          const SizedBox(height: 12),
          AppText("RD\$100 earned", fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          const SizedBox(height: 4),
          AppText("For 2 referred friends", fontSize: 13, color: Colors.white.withOpacity(0.9)),
        ],
      ),
    );
  }

  Widget _buildHowItWorksCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText("How it works?", fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0052AD)),
          const SizedBox(height: 16),
          _buildStepRow("1", "Share your code with friends"),
          const SizedBox(height: 12),
          _buildStepRow("2", "Your friend registers with your code"),
          const SizedBox(height: 12),
          _buildStepRow("3", "Both earn RD\$50 upon making your first reservation"),
        ],
      ),
    );
  }

  Widget _buildStepRow(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF0052AD), width: 1.5),
          ),
          alignment: Alignment.center,
          child: AppText(number, fontSize: 12, color: const Color(0xFF0052AD), fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppText(text, fontSize: 13, color: Colors.black87),
        )
      ],
    );
  }

  Widget _buildReferralCodeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText("YOUR REFERRAL CODE", fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0052AD)),
          const SizedBox(height: 16),
          
          CustomPaint(
            painter: DashedRectPainter(color: const Color(0xFF0052AD), strokeWidth: 1.5, gap: 6, radius: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText("PARK-CM7X2", fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0052AD)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF174FB5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppText("Copy", fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(child: _buildSocialButton(Icons.chat, "WhatsApp", const Color(0xFF25D366))),
              const SizedBox(width: 8),
              Expanded(child: _buildSocialButton(Icons.facebook, "Facebook", const Color(0xFF1877F2))),
              const SizedBox(width: 8),
              Expanded(child: _buildSocialButton(Icons.share, "Share", const Color(0xFF5E5E5E))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          AppText(text, fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  Widget _buildReferralsListCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText("YOUR REFERRALS (3)", fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF0052AD)),
          const SizedBox(height: 20),
          
          _buildReferralRow("https://images.unsplash.com/photo-1590674899484-d5640e854abe?q=80&w=100&auto=format&fit=crop", "Roberto P.", "2 days ago", "RD\$50", "EARNED", AppColors.Green),
          const SizedBox(height: 16),
          _buildReferralRow("https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?q=80&w=100&auto=format&fit=crop", "Lucia M.", "5 days ago", "RD\$50", "EARNED", AppColors.Green),
          const SizedBox(height: 16),
          _buildReferralRow("https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=100&auto=format&fit=crop", "Diego F.", "Pending", "RD\$50", "PENDING", AppColors.Orange),
        ],
      ),
    );
  }

  Widget _buildReferralRow(String image, String name, String time, String amount, String status, Color statusColor) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(image),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(name, fontSize: 14, fontWeight: FontWeight.bold),
              AppText(time, fontSize: 11, color: Colors.grey.shade500),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText(amount, fontSize: 14, fontWeight: FontWeight.bold, color: statusColor),
            AppText(status, fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
          ],
        )
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.LightGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("💰", style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 11, color: Color(0xFF1C1C1C), height: 1.4),
                children: [
                  const TextSpan(text: "Available balance: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "RD\$100", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.Green)),
                  const TextSpan(text: " — Redeemable on your next reservation"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  DashedRectPainter({this.color = Colors.black, this.strokeWidth = 1.0, this.gap = 5.0, this.radius = 0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius)));

    Path dashPath = Path();
    for (ui.PathMetric measurePath in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < measurePath.length) {
        dashPath.addPath(measurePath.extractPath(distance, distance + gap), Offset.zero);
        distance += gap * 2;
      }
    }

    canvas.drawPath(dashPath, dashedPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
