import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../utils/appColor/app_colors.dart';
import '../../base/AppText/appText.dart';


class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String selectedValue;
  final Function(String) onSelected;
  final bool scrollable;
  final double popupHeight;
  final double height;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    this.scrollable = false,
    this.popupHeight = 300,
    this.height = 35,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      elevation: 4,
      color: Theme.of(context).brightness == Brightness.dark ? AppColors.DarkThemeSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) => onSelected(value),

      // ✅ Dynamic item builder
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: AppText(
            "Select one",
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: isDark ? AppColors.White: const Color(0xff71717A),
          ),
        ),

        if (scrollable)
          PopupMenuItem<String>(
            enabled: false,
            padding: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: popupHeight),
              child: SingleChildScrollView(
                child: Column(
                  children: items.map((item) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        onSelected(item);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        child: AppText(
                          item,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark ? AppColors.DarkThemeText : AppColors.Black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          )
        else
          ...items.map((item) => PopupMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: AppText(
                item,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.DarkThemeText : AppColors.Black,
              ),
            ),
          )),
      ],

      // ✅ Dropdown button design
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            width: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.DarkThemeDivider
                : AppColors.LightGray,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AppText(
                selectedValue.isEmpty ? "Select one" : selectedValue,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.White
                    : AppColors.DarkGray,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              "assets/icons/Icone=chevron-down.svg",
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.DarkThemeText
                  : AppColors.Black,
            ),
          ],
        ),
      ),
    );
  }
}