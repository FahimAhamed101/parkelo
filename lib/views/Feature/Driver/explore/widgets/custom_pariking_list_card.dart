import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../helpers/route.dart';
import '../../../../base/AppText/appText.dart';

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

class _CustomParkingListCardState extends State<CustomParkingListCard>
    with SingleTickerProviderStateMixin {
  late bool _isFavorited;
  late AnimationController _heartController;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.initialFavorited;
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _heartController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() => _isFavorited = !_isFavorited);
    _heartController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  widget.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        "2 Floors",
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.showFavoriteIcon)
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: AnimatedBuilder(
                      animation: _heartScale,
                      builder: (context, child) => Transform.scale(
                        scale: _heartScale.value,
                        child: child,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _isFavorited
                              ? const Color(0xFFE91E63).withOpacity(0.12)
                              : Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) => ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                          child: Icon(
                            _isFavorited ? Icons.favorite : Icons.favorite_border,
                            key: ValueKey(_isFavorited),
                            size: 22,
                            color: _isFavorited
                                ? const Color(0xFFE91E63)
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  widget.title,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                const SizedBox(height: 4),
                AppText(
                  widget.subtitle,
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                if (widget.tags.isNotEmpty) const SizedBox(height: 12),
                if (widget.tags.isNotEmpty)
                  Row(
                    children: widget.tags.map((tag) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFF008CFA)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AppText(
                          tag,
                          fontSize: 10,
                          color: const Color(0xFF008CFA),
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 6),
                    AppText(
                      "${widget.rating} ",
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    AppText(
                      widget.reviews,
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        AppText(
                          widget.price,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        AppText(
                          " / hour",
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.parkingDetailsScreen,
                          arguments: {'fromFavorites': !widget.showFavoriteIcon},
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF008CFA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: AppText(
                          "View Details",
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

