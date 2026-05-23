import 'package:flutter/material.dart';
import '../../../utils/appColor/app_colors.dart';
import '../AppText/appText.dart';

/// A textfield-style tap target that opens a bottom-sheet list picker.
class VehiclePickerField extends StatelessWidget {
  final String? value;
  final String hintText;
  final List<String> items;
  final ValueChanged<String> onSelected;

  const VehiclePickerField({
    super.key,
    required this.items,
    required this.onSelected,
    this.value,
    this.hintText = "Select",
  });

  void _open(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PickerSheet(
        items: items,
        selected: value,
        onSelected: (v) {
          Navigator.pop(context);
          onSelected(v);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppText(
                hasValue ? value! : hintText,
                fontSize: 14,
                color: hasValue ? AppColors.DarkBlue : const Color(0xFF5E5E5E),
                fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final List<String> items;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _PickerSheet({
    required this.items,
    required this.onSelected,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.65),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
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
          const SizedBox(height: 8),
          // Top border accent
          Container(height: 2, color: AppColors.Primary),
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == selected;
                return InkWell(
                  onTap: () => onSelected(item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          item,
                          fontSize: 15,
                          color: isSelected ? AppColors.Primary : const Color(0xFF5B8DB8),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                        ),
                        if (isSelected)
                          const Icon(Icons.check, color: AppColors.Primary, size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
