import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../utils/appColor/app_colors.dart';

enum VehicleFormMode { add, edit }

class VehicleFormPage extends StatefulWidget {
  const VehicleFormPage({super.key, required this.mode});

  final VehicleFormMode mode;

  bool get isEditing => mode == VehicleFormMode.edit;

  @override
  State<VehicleFormPage> createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends State<VehicleFormPage> {
  String _selectedType = 'Sedan';
  String? _selectedMake;
  String? _selectedColor;

  late final TextEditingController _plateController;
  late final TextEditingController _modelController;
  late final TextEditingController _yearController;
  late final TextEditingController _notesController;

  static const List<String> _makes = [
    'Toyota',
    'Honda',
    'Hyundai',
    'Kia',
    'Nissan',
    'Chevrolet',
    'Ford',
    'Volkswagen',
    'BMW',
    'Mercedes-Benz',
    'Audi',
    'Jeep',
    'Mitsubishi',
    'Mazda',
    'Suzuki',
    'Other',
  ];

  static const List<String> _colors = [
    'White',
    'Black',
    'Silver',
    'Gray',
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Orange',
    'Brown',
    'Beige',
    'Other',
  ];

  static const List<_VehicleTypeData> _vehicleTypes = [
    _VehicleTypeData('Sedan', Icons.directions_car_rounded),
    _VehicleTypeData('SUV / 4x4', Icons.time_to_leave_rounded),
    _VehicleTypeData('Pickup', Icons.local_shipping_rounded),
    _VehicleTypeData('Coupe', Icons.directions_car_filled_rounded),
    _VehicleTypeData('Minivan / Van', Icons.airport_shuttle_rounded),
    _VehicleTypeData('Motorcycle', Icons.two_wheeler_rounded),
  ];

  @override
  void initState() {
    super.initState();

    _selectedMake = widget.isEditing ? 'Toyota' : null;
    _selectedColor = widget.isEditing ? 'White' : null;
    _plateController = TextEditingController(
      text: widget.isEditing ? 'A123456' : '',
    );
    _modelController = TextEditingController(
      text: widget.isEditing ? 'Corolla' : '',
    );
    _yearController = TextEditingController(
      text: widget.isEditing ? '2020' : '',
    );
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _plateController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.blueNav,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.bg,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: Column(
          children: [
            _VehicleFormHeader(
              title: widget.isEditing ? 'Edit vehicle' : 'Add vehicle',
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 118),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('VEHICLE TYPE *'),
                    const SizedBox(height: 12),
                    _VehicleTypeGrid(
                      selectedType: _selectedType,
                      types: _vehicleTypes,
                      onSelected: (type) => setState(() {
                        _selectedType = type;
                      }),
                    ),
                    const SizedBox(height: 18),
                    const _FieldLabel('LICENSE PLATE *'),
                    const SizedBox(height: 8),
                    _TextInput(
                      controller: _plateController,
                      hintText: 'Example: A123456',
                      icon: Icons.badge_outlined,
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 5),
                    const _HelperText('Dominican format: A123456 or AB1234'),
                    const SizedBox(height: 16),
                    const _FieldLabel('MAKE *'),
                    const SizedBox(height: 8),
                    _SelectInput(
                      value: _selectedMake,
                      hintText: 'Select make',
                      items: _makes,
                      onChanged: (value) => setState(() {
                        _selectedMake = value;
                      }),
                    ),
                    const SizedBox(height: 16),
                    const _FieldLabel('MODEL *'),
                    const SizedBox(height: 8),
                    _TextInput(
                      controller: _modelController,
                      hintText: 'Example: Corolla, Civic, Tucson',
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('YEAR *'),
                              const SizedBox(height: 8),
                              _TextInput(
                                controller: _yearController,
                                hintText: 'Example: 2022',
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        SizedBox(
                          width: 112,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('COLOR *'),
                              const SizedBox(height: 8),
                              _SelectInput(
                                value: _selectedColor,
                                hintText: 'Color',
                                items: _colors,
                                onChanged: (value) => setState(() {
                                  _selectedColor = value;
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const _FieldLabel('NOTES (OPTIONAL)'),
                    const SizedBox(height: 8),
                    _TextInput(
                      controller: _notesController,
                      hintText:
                          'Example: Has a windshield sticker, leather seats...',
                      minLines: 3,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 8),
                    const _HelperText(
                      'Special characteristics and notes for the host',
                    ),
                    const SizedBox(height: 16),
                    _VehiclePreviewCard(
                      make: _selectedMake ?? 'Vehicle make',
                      model: _modelController.text.trim().isEmpty
                          ? 'Model'
                          : _modelController.text.trim(),
                      year: _yearController.text.trim().isEmpty
                          ? 'Year'
                          : _yearController.text.trim(),
                      color: _selectedColor ?? 'Color',
                      plate: _plateController.text.trim().isEmpty
                          ? 'License plate'
                          : _plateController.text.trim().toUpperCase(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _StickyActionBar(
          label: widget.isEditing ? 'Save changes' : 'Add vehicle',
          onPressed: () => Get.back(),
        ),
      ),
    );
  }
}

class _VehicleFormHeader extends StatelessWidget {
  const _VehicleFormHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.gradHero),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 20, 15),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                constraints: const BoxConstraints.tightFor(
                  width: 42,
                  height: 42,
                ),
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.bg.withValues(alpha: 0.14),
                ),
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.bg,
                  size: 28,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: AppColors.bg,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Vehicle information',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: AppColors.blueMid,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VehicleTypeGrid extends StatelessWidget {
  const _VehicleTypeGrid({
    required this.selectedType,
    required this.types,
    required this.onSelected,
  });

  final String selectedType;
  final List<_VehicleTypeData> types;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final tileWidth = (constraints.maxWidth - gap * 2) / 3;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final type in types)
              SizedBox(
                width: tileWidth,
                height: 68,
                child: _VehicleTypeTile(
                  data: type,
                  isSelected: selectedType == type.name,
                  onTap: () => onSelected(type.name),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _VehicleTypeTile extends StatelessWidget {
  const _VehicleTypeTile({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  final _VehicleTypeData data;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blueLt : AppColors.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.borderMd,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: AppColors.shadowSm,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              data.icon,
              color: isSelected ? AppColors.blue : AppColors.textSub,
              size: 20,
            ),
            const SizedBox(height: 7),
            Text(
              data.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: isSelected ? AppColors.blue : AppColors.textSub,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput({
    required this.controller,
    required this.hintText,
    this.icon,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.minLines = 1,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int minLines;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      cursorColor: AppColors.blue,
      style: GoogleFonts.nunito(
        color: AppColors.text,
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: icon == null ? 0 : 2,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.nunito(
          color: AppColors.textFaint,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        prefixIcon: icon == null
            ? null
            : Icon(icon, color: AppColors.blue, size: 19),
        filled: true,
        fillColor: AppColors.bg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderMd),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
    );
  }
}

class _SelectInput extends StatelessWidget {
  const _SelectInput({
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
  });

  final String? value;
  final String hintText;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.blue,
      ),
      items: [
        for (final item in items)
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                color: AppColors.text,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.nunito(
          color: AppColors.textFaint,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        filled: true,
        fillColor: AppColors.bg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderMd),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.nunito(
        color: AppColors.textSub,
        fontSize: 11,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _HelperText extends StatelessWidget {
  const _HelperText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.nunito(
        color: AppColors.textFaint,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _VehiclePreviewCard extends StatelessWidget {
  const _VehiclePreviewCard({
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.plate,
  });

  final String make;
  final String model;
  final String year;
  final String color;
  final String plate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.blueNav, AppColors.blue],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.shadowMd,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bg.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              color: AppColors.bg,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$make $model',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: AppColors.bg,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$year - $color',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: AppColors.blueMid,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  plate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: AppColors.bg,
                    fontSize: 14,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyActionBar extends StatelessWidget {
  const _StickyActionBar({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        height: 54,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: AppColors.bg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _VehicleTypeData {
  const _VehicleTypeData(this.name, this.icon);

  final String name;
  final IconData icon;
}
