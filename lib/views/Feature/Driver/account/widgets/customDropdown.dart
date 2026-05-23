import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/AppColor/app_colors.dart';


// Custom Dropdown widget
class CustomDropdownProfile extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final Function(String?) onItemSelected;

  CustomDropdownProfile({
    required this.items,
    this.selectedItem,
    required this.onItemSelected,
  });

  @override
  _CustomDropdownProfileState createState() => _CustomDropdownProfileState();
}

class _CustomDropdownProfileState extends State<CustomDropdownProfile> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedItem;
  }

  @override
  void didUpdateWidget(covariant CustomDropdownProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem) {
      selectedOption = widget.selectedItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? currentDisplay = selectedOption ?? widget.selectedItem;
    return GestureDetector(
      onTap: () => _showDropdown(context),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
            color: AppColors.DarkBlue,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                currentDisplay ?? "Select one".tr,
                style: GoogleFonts.inter(
                  fontWeight: (currentDisplay == null) ? FontWeight.w400 : FontWeight.w500,
                  fontSize: (currentDisplay == null) ? 12 : 14,
                  color: AppColors.Black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 5.w),
            SvgPicture.asset(
              "assets/icons/bottomArrow.svg",
              width: 24.w,
              height: 24.h,
              color: AppColors.DarkGray,
            ),
          ],
        ),
      ),
    );
  }

  // Method to show the dropdown menu
  void _showDropdown(BuildContext context) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double verticalPosition = offset.dy + renderBox.size.height + 10.0;
    final String? newSelection = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, verticalPosition, 0, 0),
      items: widget.items.map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.DarkGray,
            ),
          ),
        );
      }).toList(),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.bgPrimary, width: 1),
      ),

    );

    if (newSelection != null) {
      setState(() {
        selectedOption = newSelection;
      });

      widget.onItemSelected(newSelection);
    }
  }
}