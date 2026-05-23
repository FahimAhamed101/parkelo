import 'package:flutter/material.dart';
import '../../../../../utils/appColor/app_colors.dart';
import '../../../../base/AppText/appText.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  double _maxPrice = 8;
  String _selectedDistance = '1 mi';
  final List<String> _distances = ['0.5 mi', '1 mi', '3 mi', '5+ mi'];
  final List<String> _amenities = ['Covered', 'EV Charger', '24/7', 'Valet', 'Security', 'Disabled'];
  final Set<String> _selectedAmenities = {'Covered', 'EV Charger', 'Security'};
  int _minRating = 4;

  void _reset() {
    setState(() {
      _maxPrice = 8;
      _selectedDistance = '1 mi';
      _selectedAmenities.clear();
      _minRating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText("Filters", fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              GestureDetector(
                onTap: _reset,
                child: AppText("Reset", fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.Primary),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Price per hour
          AppText("Price per hour", fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText("\$0", fontSize: 12, color: Colors.grey.shade600),
              AppText("\$${_maxPrice.toInt()} max", fontSize: 12, color: Colors.grey.shade600),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.DarkBlue,
              inactiveTrackColor: Colors.grey.shade300,
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
              trackHeight: 3,
            ),
            child: Slider(
              value: _maxPrice,
              min: 0,
              max: 20,
              onChanged: (v) => setState(() => _maxPrice = v),
            ),
          ),
          const SizedBox(height: 16),

          // Distance
          AppText("Distance", fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: _distances.map((d) {
              final selected = _selectedDistance == d;
              return GestureDetector(
                onTap: () => setState(() => _selectedDistance = d),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.DarkBlue : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: AppText(
                    d,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    color: selected ? Colors.white : Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Amenities
          AppText("Amenities", fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _amenities.map((a) {
              final selected = _selectedAmenities.contains(a);
              return GestureDetector(
                onTap: () => setState(() {
                  selected ? _selectedAmenities.remove(a) : _selectedAmenities.add(a);
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.DarkBlue : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: AppText(
                    a,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    color: selected ? Colors.white : Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Rating
          AppText("Rating", fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
          const SizedBox(height: 10),
          Row(
            children: [
              ...List.generate(5, (i) {
                final filled = i < _minRating;
                return GestureDetector(
                  onTap: () => setState(() => _minRating = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: const Color(0xFFFFC107),
                      size: 32,
                    ),
                  ),
                );
              }),
              const SizedBox(width: 8),
              if (_minRating > 0)
                AppText("$_minRating+ stars", fontSize: 13, color: Colors.grey.shade600),
            ],
          ),
          const SizedBox(height: 24),

          // Show results button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.Primary,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: AppText(
                "Show 23 results",
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
