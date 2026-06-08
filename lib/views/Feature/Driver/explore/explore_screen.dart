import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/appColor/app_colors.dart';
import 'widgets/custom_pariking_list_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController searchController = TextEditingController();
  final Set<String> selectedFilters = {'Private'};

  final List<_ParkingData> parkingList = const [
    _ParkingData(
      title: 'Parking Colonial Premium',
      subtitle: 'Colonial Zone, SD - 0.2 km - 128 reviews',
      rating: '4.87',
      reviews: '128 reviews',
      price: 'RD\$150',
      tags: ['Metro L1 - 200m', 'OMSA - 50m'],
    ),
    _ParkingData(
      title: 'VIP Piantini Private House',
      subtitle: 'Piantini, SD - 0.8 km - 94 reviews',
      rating: '4.72',
      reviews: '94 reviews',
      price: 'RD\$200',
      tags: ['Private', 'Covered'],
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              const _MapPreview(),
              const SizedBox(height: 14),
              _buildResultsRow(),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: parkingList
                      .map(
                        (parking) => CustomParkingListCard(
                          imageUrl: '',
                          title: parking.title,
                          subtitle: parking.subtitle,
                          rating: parking.rating,
                          reviews: parking.reviews,
                          price: parking.price,
                          tags: parking.tags,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: const BoxDecoration(gradient: AppColors.gradGreenBar),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 16, 15, 0),
            child: Row(
              children: [
                const _SmallBrandPin(),
                const SizedBox(width: 8),
                Text(
                  'Parkealo',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(child: _buildSearchField()),
                const SizedBox(width: 8),
                _buildRentalButton(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _buildFilters(),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.border),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.borderMd),
        boxShadow: AppColors.shadowSm,
      ),
      child: Row(
        children: [
          const SizedBox(width: 13),
          SvgPicture.asset(
            'assets/icons/locationIcon.svg',
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              AppColors.textFaint,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchController,
              cursorColor: AppColors.blue,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
              decoration: InputDecoration(
                hintText: 'Where are you going?',
                hintStyle: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textFaint,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Container(height: 20, width: 1, color: AppColors.border),
          const SizedBox(width: 10),
          const Icon(
            Icons.location_on_outlined,
            color: AppColors.green,
            size: 18,
          ),
          const SizedBox(width: 13),
        ],
      ),
    );
  }

  Widget _buildRentalButton() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.blue, width: 1.5),
      ),
      child: Row(
        children: [
          Text(
            'Hourly',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 17,
            color: AppColors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = const [
      (Icons.home_work_outlined, 'Private'),
      (Icons.videocam_outlined, 'Camera'),
      (Icons.roofing_outlined, 'Covered'),
      (Icons.person_rounded, 'Person'),
    ];

    return SizedBox(
      height: 32,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilters.contains(filter.$2);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedFilters.remove(filter.$2);
                } else {
                  selectedFilters.add(filter.$2);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.blueLt : AppColors.bg,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isSelected ? AppColors.blueMid : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    filter.$1,
                    size: 14,
                    color: isSelected ? AppColors.blue : AppColors.textSub,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    filter.$2,
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? AppColors.blue : AppColors.textSub,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: filters.length,
      ),
    );
  }

  Widget _buildResultsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '3 ',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
                children: [
                  TextSpan(
                    text: 'parking spaces found',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSub,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            'Sort',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(width: 3),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.blue,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _ParkingData {
  final String title;
  final String subtitle;
  final String rating;
  final String reviews;
  final String price;
  final List<String> tags;

  const _ParkingData({
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.tags,
  });
}

class _SmallBrandPin extends StatelessWidget {
  const _SmallBrandPin();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 23,
      height: 27,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.location_on_rounded,
            size: 27,
            color: AppColors.blue,
          ),
          Positioned(
            top: 3,
            child: Text(
              'P',
              style: GoogleFonts.nunito(
                fontSize: 11,
                height: 1,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const Positioned(
            bottom: 7,
            child: Icon(
              Icons.directions_car_filled_rounded,
              size: 8,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 228,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDDE8F5), Color(0xFFC5D8EC)],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _MapGridPainter())),
          Positioned(
            top: 12,
            left: 10,
            child: _MapLabel(
              text: 'Colonial Zone - Santo Domingo',
              color: AppColors.bg,
              textColor: AppColors.textSub,
            ),
          ),
          const Positioned(
            top: 35,
            left: 28,
            child: _PriceBadge(text: 'RD\$150', color: AppColors.green),
          ),
          const Positioned(
            top: 17,
            right: 66,
            child: _PriceBadge(text: 'RD\$200', color: AppColors.blueNav),
          ),
          const Positioned(
            top: 130,
            right: 118,
            child: _PriceBadge(text: 'RD\$80', color: AppColors.green),
          ),
          const Positioned(left: 126, top: 94, child: _UserDot()),
          Positioned(
            left: 10,
            bottom: 10,
            child: Row(
              children: const [
                _MapLegend(label: 'Public', color: AppColors.green),
                SizedBox(width: 6),
                _MapLegend(label: 'Private', color: AppColors.blueNav),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapLabel extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _MapLabel({
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.shadowSm,
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _PriceBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _UserDot extends StatelessWidget {
  const _UserDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blue.withValues(alpha: 0.13),
      ),
      child: Container(
        width: 13,
        height: 13,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.blue,
          border: Border.all(color: Colors.white, width: 2.5),
        ),
      ),
    );
  }
}

class _MapLegend extends StatelessWidget {
  final String label;
  final Color color;

  const _MapLegend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..strokeWidth = 1;
    final minorPaint = Paint()
      ..color = AppColors.blueMid.withValues(alpha: 0.36)
      ..strokeWidth = 1;
    final roadPaint = Paint()
      ..color = AppColors.blueMid.withValues(alpha: 0.72)
      ..strokeWidth = 4;

    for (double x = 0; x <= size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    for (double x = 16; x <= size.width; x += 64) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), minorPaint);
    }
    for (double y = 16; y <= size.height; y += 64) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minorPaint);
    }

    canvas.drawLine(
      Offset(0, size.height * 0.47),
      Offset(size.width, size.height * 0.47),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.31, 0),
      Offset(size.width * 0.31, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.65, 0),
      Offset(size.width * 0.65, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
