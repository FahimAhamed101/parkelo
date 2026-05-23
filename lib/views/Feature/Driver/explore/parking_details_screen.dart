import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../../base/AppText/appText.dart';

class ParkingDetailsScreen extends StatefulWidget {
  const ParkingDetailsScreen({super.key});

  @override
  State<ParkingDetailsScreen> createState() => _ParkingDetailsScreenState();
}

class _ParkingDetailsScreenState extends State<ParkingDetailsScreen> {
  String selectedDuration = '2h';
  bool bookForAnother = true;
  bool insuranceActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      bottomNavigationBar: _buildBottomBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopImage(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 16),
                  _buildManagedByCard(),
                  const SizedBox(height: 16),
                  _buildAvailableService(),
                  const SizedBox(height: 24),
                  AppText("When are you arriving?", fontSize: 14, fontWeight: FontWeight.bold),
                  const SizedBox(height: 16),
                  _buildDateSelector(),
                  const SizedBox(height: 16),
                  AppText("ARRIVAL TIME", fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  const SizedBox(height: 8),
                  _buildTimeSelector(),
                  const SizedBox(height: 16),
                  AppText("DURATION", fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  const SizedBox(height: 8),
                  _buildDurationSelector(),
                  const SizedBox(height: 24),
                  _buildSwitches(),
                  const SizedBox(height: 16),
                  _buildProtectionBanner(),
                  const SizedBox(height: 24),
                  _buildPriceSummary(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopImage() {
    return Stack(
      children: [
        Image.network(
          "https://images.unsplash.com/photo-1590674899484-d5640e854abe?q=80&w=600&auto=format&fit=crop",
          width: double.infinity,
          height: 220,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 20,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 26),
          ),
        ),
        if (!(Get.arguments != null && Get.arguments['fromFavorites'] == true))
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: const Icon(Icons.favorite_border, color: Colors.white, size: 26,),
          )
      ],
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AppText(
                "Parking Colonial Premium",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1C1C),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                AppText("4.87", fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1C1C1C)),
              ],
            )
          ],
        ),
        const SizedBox(height: 4),
        AppText(
          "Colonial Zone, SD · 0.2 km · 128 reviews",
          fontSize: 12,
          color: Color(0xFF4C4C4C),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildTag("Public", Color(0xFFECFDF5), AppColors.LightGreen),
            const SizedBox(width: 8),
            _buildTag("24/7", const Color(0xFFEFF6FF), const Color(0xFF1D4ED8)),
          ],
        )
      ],
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: AppText(
        text,
        fontSize: 11,
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildManagedByCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              "https://images.unsplash.com/photo-1590674899484-d5640e854abe?q=80&w=100&auto=format&fit=crop",
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText("Managed by Parkealo", fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1C)),
                SizedBox(height: 8),
                AppText("128 reviews · Verified", fontSize: 11, color: Colors.grey.shade500),
              ],
            ),
          ),
          SizedBox(width: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.Green.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.Green, size: 14),
                const SizedBox(width: 4),
                AppText("Verified", fontSize: 11, color: AppColors.Green, fontWeight: FontWeight.w600),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvailableService() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText("Available Service", fontSize: 12, fontWeight: FontWeight.bold),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildServiceIcon(Icons.videocam_outlined, "CCTV"),
              _buildServiceIcon(Icons.electrical_services, "EV Charge"),
              _buildServiceIcon(Icons.house_outlined, "Covered"),
              _buildServiceIcon(Icons.access_time, "24/7 Open"),
              _buildServiceIcon(Icons.accessible, "Accessible"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildServiceIcon(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 6),
        AppText(text, fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText("DATE", fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9EFFC),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: AppText("TODAY", fontSize: 11, color: AppColors.Primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Expanded(child: AppText("Today", fontSize: 14, fontWeight: FontWeight.w500)),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildChip("7:00 AM", false, isWide: true),
        _buildChip("7:30 AM", false, isWide: true),
        _buildChip("8:00 AM", false, isWide: true),
        _buildChip("8:30 AM", false, isWide: true),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildChip("1h", selectedDuration == '1h'),
        _buildChip("2h", selectedDuration == '2h'),
        _buildChip("4h", selectedDuration == '4h'),
        _buildChip("6h", selectedDuration == '6h'),
        _buildChip("8h", selectedDuration == '8h'),
        _buildChip("All\nday", selectedDuration == 'All day', isTwoLines: true),
      ],
    );
  }

  Widget _buildChip(String text, bool isSelected, {bool isTwoLines = false, bool isWide = false}) {
    return GestureDetector(
      onTap: () {
        if(text == "1h" || text == "2h" || text == "4h" || text == "6h" || text == "8h" || text.startsWith("All")) {
           setState(() {
              selectedDuration = text.replaceAll('\n', ' ');
           });
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: isWide ? 10 : (isTwoLines ? 10 : 12), vertical: isTwoLines ? 4 : 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.Green : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: AppText(
          text,
          fontSize: 11,
          color: isSelected ? AppColors.Green : Colors.grey.shade800,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSwitches() {
    return Column(
      children: [
        _buildSwitchRow(
          "Book for another person",
          "Enter the license plate of the vehicle to park.",
          bookForAnother,
          (val) => setState(() => bookForAnother = val),
        ),
        const SizedBox(height: 16),
        _buildSwitchRow(
          "Insurance · RD\$25",
          "Protected with Insurances Bookingtions · Covers up to RD\$3,000 in damages to your vehicle during your reservation time.",
          insuranceActive,
          (val) => setState(() => insuranceActive = val),
        ),
      ],
    );
  }

  Widget _buildSwitchRow(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(title, fontSize: 13, fontWeight: FontWeight.bold),
              const SizedBox(height: 4),
              AppText(subtitle, fontSize: 11, color: Colors.grey.shade600),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: AppColors.Primary,
        ),
      ],
    );
  }

  Widget _buildProtectionBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.LightGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.Green, size: 16),
          const SizedBox(width: 8),
          AppText("Protection active during your 2h stay", fontSize: 11, color: AppColors.Green, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText("Price Summary", fontSize: 14, fontWeight: FontWeight.bold),
        const SizedBox(height: 12),
        _buildPriceRow("RD\$150 x 2 hours", "RD\$300"),
        const SizedBox(height: 8),
        _buildPriceRow("Insurance Bookingtions", "RD\$25"),
        const SizedBox(height: 8),
        _buildPriceRow("ITBIS (18%)", "RD\$54"),
        const SizedBox(height: 8),
        _buildPriceRow("Service fee", "RD\$25"),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(label, fontSize: 12, color: Colors.grey.shade600),
        AppText(amount, fontSize: 12, color: Colors.grey.shade800),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF3F8F4), // match bg
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText("RD\$150 / hour", fontSize: 18, fontWeight: FontWeight.bold),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.Primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppText(
                "Book",
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
