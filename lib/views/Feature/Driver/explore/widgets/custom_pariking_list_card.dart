import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../helpers/route.dart';
import '../../../../../utils/appColor/app_colors.dart';

class CustomParkingListCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String rating;
  final String reviews;
  final String price;
  final List<String> tags;
  final bool showFavoriteIcon;
  final bool initialFavorited;

  const CustomParkingListCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.reviews,
    required this.price,
    this.tags = const [],
    this.showFavoriteIcon = true,
    this.initialFavorited = false,
  });

  @override
  State<CustomParkingListCard> createState() => _CustomParkingListCardState();
}

class _CustomParkingListCardState extends State<CustomParkingListCard> {
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.initialFavorited;
  }

  void _toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  void _openDetails() {
    Get.toNamed(
      AppRoutes.parkingDetailsScreen,
      arguments: {'fromFavorites': !widget.showFavoriteIcon},
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _openDetails,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.shadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 138,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.gradPublic,
                  ),
                  alignment: Alignment.center,
                  child: const _ParkingPinLogo(),
                ),
                if (widget.showFavoriteIcon)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _toggleFavorite();
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.20),
                        ),
                        child: Icon(
                          isFavorited
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 18,
                          color: isFavorited
                              ? AppColors.heartRed
                              : Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 12,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blueSky.withValues(alpha: 0.70),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '2 floors',
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 3,
              decoration: const BoxDecoration(gradient: AppColors.gradGreenBar),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 12, 13, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            height: 1.15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppColors.text,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            widget.rating,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSub,
                    ),
                  ),
                  if (widget.tags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.tags.map(_buildTransportTag).toList(),
                    ),
                  ],
                  const SizedBox(height: 11),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      text: widget.price,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        height: 1,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                      ),
                      children: [
                        TextSpan(
                          text: ' / hour',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSub,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.blueLt,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.blueMid),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.directions_walk_rounded,
            size: 12,
            color: AppColors.blue,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.nunito(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParkingPinLogo extends StatelessWidget {
  const _ParkingPinLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 66,
      height: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.location_on_rounded,
            size: 76,
            color: AppColors.blueSky.withValues(alpha: 0.96),
            shadows: [
              Shadow(
                color: AppColors.blueNav.withValues(alpha: 0.20),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          Positioned(
            top: 11,
            child: Text(
              'P',
              style: GoogleFonts.nunito(
                fontSize: 34,
                height: 1,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const Positioned(
            bottom: 22,
            child: Icon(
              Icons.directions_car_filled_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
