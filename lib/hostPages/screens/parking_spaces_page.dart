import 'package:flutter/material.dart';

import '../services/host_api_client.dart';
import '../widgets/host_panel_chrome.dart';

const _primaryBlue = Color(0xFF1556B7);
const _ink = Color(0xFF071633);
const _muted = Color(0xFF8A96A8);
const _green = Color(0xFF009A52);
const _greenBorder = Color(0xFF83E0B0);
const _greenBg = Color(0xFFE7FFF3);
const _red = Color(0xFFE21B3C);
const _redBorder = Color(0xFFF6A8B5);
const _redBg = Color(0xFFFFEEF2);

class ParkingSpacesPage extends StatefulWidget {
  const ParkingSpacesPage({super.key, this.configureAll = false});

  final bool configureAll;

  @override
  State<ParkingSpacesPage> createState() => _ParkingSpacesPageState();
}

class _ParkingSpacesPageState extends State<ParkingSpacesPage> {
  _HostParkingData? _parking;
  String? _configSectionId;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final response = await HostApiClient.instance.fetchParkings();
      final parkings = response['parkings'];
      final first = parkings is List && parkings.isNotEmpty
          ? parkings.first
          : null;
      if (!mounted) return;
      setState(() {
        _parking = first is Map<String, dynamic>
            ? _HostParkingData.fromApi(first)
            : null;
        _configSectionId =
            widget.configureAll &&
                _parking != null &&
                _parking!.sections.isNotEmpty
            ? _parking!.sections.first.id
            : null;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    final parking = _parking;
    if (parking == null || parking.id.isEmpty) return;

    setState(() => _saving = true);
    try {
      final response = await HostApiClient.instance.saveParkingLayout(
        parking.id,
        parking.toLayoutPayload(),
      );
      final parkingJson = response['parking'];
      if (parkingJson is Map<String, dynamic> && mounted) {
        setState(() => _parking = _HostParkingData.fromApi(parkingJson));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _toggleSpace(String sectionId, String label) async {
    final parking = _parking;
    if (parking == null) return;

    setState(() {
      _parking = parking.toggleSpace(sectionId, label);
    });
    await _save();
  }

  Future<void> _configureSection(
    String sectionId, {
    String? prefix,
    int? count,
  }) async {
    final parking = _parking;
    if (parking == null) return;

    setState(() {
      _parking = parking.configureSection(
        sectionId,
        prefix: prefix,
        count: count,
      );
    });
    await _save();
  }

  Future<void> _addSection(_SectionDraft draft) async {
    final parking = _parking;
    if (parking == null) return;

    setState(() {
      _parking = parking.addSection(draft);
      _configSectionId = _parking!.sections.last.id;
    });
    await _save();
  }

  @override
  Widget build(BuildContext context) {
    return HostPanelScaffold(
      selectedTab: HostPanelTab.parking,
      child: Stack(
        children: [
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_parking == null)
            const _EmptyParkingPanel()
          else
            RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 18, 12, 92),
                children: [
                  for (var i = 0; i < _parking!.sections.length; i++) ...[
                    _ParkingSectionCard(
                      section: _parking!.sections[i],
                      showConfiguration:
                          _configSectionId == _parking!.sections[i].id,
                      onConfigTap: () {
                        setState(() {
                          final id = _parking!.sections[i].id;
                          _configSectionId = _configSectionId == id ? null : id;
                        });
                      },
                      onToggleSpace: (label) =>
                          _toggleSpace(_parking!.sections[i].id, label),
                      onConfigure: ({prefix, count}) => _configureSection(
                        _parking!.sections[i].id,
                        prefix: prefix,
                        count: count,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                  _AddSectionButton(
                    onTap: () async {
                      final draft = await showModalBottomSheet<_SectionDraft>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const _NewSectionSheet(),
                      );
                      if (draft != null) await _addSection(draft);
                    },
                  ),
                ],
              ),
            ),
          if (_saving)
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: LinearProgressIndicator(minHeight: 2),
            ),
        ],
      ),
    );
  }
}

class ParkingSpacesConfigPage extends StatelessWidget {
  const ParkingSpacesConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ParkingSpacesPage(configureAll: true);
  }
}

class _ParkingSectionCard extends StatelessWidget {
  const _ParkingSectionCard({
    required this.section,
    required this.showConfiguration,
    required this.onConfigTap,
    required this.onToggleSpace,
    required this.onConfigure,
  });

  final _ParkingSectionData section;
  final bool showConfiguration;
  final VoidCallback onConfigTap;
  final ValueChanged<String> onToggleSpace;
  final void Function({String? prefix, int? count}) onConfigure;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDCE7F3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0B2448),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  section.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _SectionActionButton(
                configured: showConfiguration,
                onTap: onConfigTap,
              ),
            ],
          ),
          const SizedBox(height: 5),
          _SectionStats(section: section),
          if (showConfiguration) ...[
            const SizedBox(height: 16),
            _ConfigurePanel(section: section, onConfigure: onConfigure),
          ],
          const SizedBox(height: 15),
          _SpacesWrap(spaces: section.spaces, onTap: onToggleSpace),
          const SizedBox(height: 13),
          const _SpaceLegend(),
        ],
      ),
    );
  }
}

class _SectionActionButton extends StatelessWidget {
  const _SectionActionButton({required this.configured, required this.onTap});

  final bool configured;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: configured ? 29 : 27,
        padding: EdgeInsets.symmetric(horizontal: configured ? 14 : 12),
        decoration: BoxDecoration(
          color: configured ? Colors.white : const Color(0xFFF0F4F9),
          borderRadius: BorderRadius.circular(999),
          border: configured ? Border.all(color: _primaryBlue) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              configured ? Icons.check_rounded : Icons.settings_outlined,
              color: configured ? _primaryBlue : const Color(0xFF4D6484),
              size: configured ? 14 : 12,
            ),
            const SizedBox(width: 4),
            Text(
              configured ? 'Listo' : 'Config',
              style: TextStyle(
                color: configured ? _primaryBlue : const Color(0xFF4D6484),
                fontSize: configured ? 11 : 10.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionStats extends StatelessWidget {
  const _SectionStats({required this.section});

  final _ParkingSectionData section;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800),
        children: [
          TextSpan(
            text: '${section.free} libres',
            style: const TextStyle(color: _green),
          ),
          const TextSpan(
            text: ' · ',
            style: TextStyle(color: _muted),
          ),
          TextSpan(
            text: '${section.occupied} ocupados',
            style: const TextStyle(color: _red),
          ),
          const TextSpan(
            text: ' · ',
            style: TextStyle(color: _muted),
          ),
          TextSpan(
            text: '${section.total} total',
            style: const TextStyle(color: _muted),
          ),
        ],
      ),
    );
  }
}

class _ConfigurePanel extends StatefulWidget {
  const _ConfigurePanel({required this.section, required this.onConfigure});

  final _ParkingSectionData section;
  final void Function({String? prefix, int? count}) onConfigure;

  @override
  State<_ConfigurePanel> createState() => _ConfigurePanelState();
}

class _ConfigurePanelState extends State<_ConfigurePanel> {
  late final TextEditingController _prefixController;
  late int _count;

  @override
  void initState() {
    super.initState();
    _prefixController = TextEditingController(text: widget.section.prefix);
    _count = widget.section.total;
  }

  @override
  void didUpdateWidget(covariant _ConfigurePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.section.id != widget.section.id) {
      _prefixController.text = widget.section.prefix;
      _count = widget.section.total;
    }
  }

  @override
  void dispose() {
    _prefixController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBED7FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'CONFIGURAR SECCIÓN',
            style: TextStyle(
              color: _primaryBlue,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _ConfigLabel('Prefijo de espacios'),
                    const SizedBox(height: 7),
                    TextField(
                      controller: _prefixController,
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(
                        color: _primaryBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 11,
                        ),
                        enabledBorder: _inputBorder(const Color(0xFFD7E4F4)),
                        focusedBorder: _inputBorder(_primaryBlue),
                      ),
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (value) {
                        final clean = value.trim().toUpperCase();
                        if (clean.isNotEmpty) {
                          widget.onConfigure(prefix: clean);
                        }
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '→ Los espacios serán ${_prefixController.text.trim().isEmpty ? widget.section.prefix : _prefixController.text.trim().toUpperCase()}1, ${_prefixController.text.trim().isEmpty ? widget.section.prefix : _prefixController.text.trim().toUpperCase()}2...',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 10,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 142,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ConfigLabel('Cantidad de espacios'),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        for (final value in const [5, 10, 15, 20, 25, 30])
                          _NumberChip(
                            label: '$value',
                            selected: _count == value,
                            onTap: () {
                              setState(() => _count = value);
                              widget.onConfigure(count: value);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFFE0A400),
                  size: 14,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Toca cualquier espacio en el mapa de abajo para cambiar su identificador o estado',
                    style: TextStyle(
                      color: Color(0xFF7390B9),
                      fontSize: 10.2,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }
}

class _ConfigLabel extends StatelessWidget {
  const _ConfigLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF58709A),
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _NumberChip extends StatelessWidget {
  const _NumberChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: onTap,
      child: Container(
        width: 38,
        height: 31,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF3FF) : Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: selected ? _primaryBlue : const Color(0xFFD7E4F4),
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _primaryBlue : _ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SpacesWrap extends StatelessWidget {
  const _SpacesWrap({required this.spaces, required this.onTap});

  final List<_ParkingSpaceData> spaces;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final itemWidth = ((constraints.maxWidth - spacing * 4) / 5)
            .clamp(48.0, 64.0)
            .toDouble();

        return Wrap(
          spacing: spacing,
          runSpacing: 8,
          children: [
            for (final space in spaces)
              SizedBox(
                width: itemWidth,
                height: space.compact ? 48 : 57,
                child: _SpaceTile(space: space, onTap: () => onTap(space.id)),
              ),
          ],
        );
      },
    );
  }
}

class _SpaceTile extends StatelessWidget {
  const _SpaceTile({required this.space, required this.onTap});

  final _ParkingSpaceData space;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = space.occupied ? _red : _green;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: space.occupied ? _redBg : _greenBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: space.occupied ? _redBorder : _greenBorder,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              space.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: space.compact ? 12 : 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            if (space.compact)
              Icon(
                space.occupied
                    ? Icons.directions_car_filled_rounded
                    : Icons.check_rounded,
                color: color,
                size: space.occupied ? 12 : 14,
              )
            else
              Text(
                space.occupied ? 'Occupied' : 'Libre',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 8.4,
                  fontWeight: FontWeight.w900,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SpaceLegend extends StatelessWidget {
  const _SpaceLegend();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _LegendItem(
          label: 'Libre',
          borderColor: _greenBorder,
          fillColor: Color(0xFFF4FFF9),
        ),
        const SizedBox(width: 12),
        const _LegendItem(
          label: 'Occupied',
          borderColor: _redBorder,
          fillColor: Color(0xFFFFF6F7),
        ),
        const Spacer(),
        Text(
          'Toca para cambiar estado',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _primaryBlue.withValues(alpha: 0.36),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.borderColor,
    required this.fillColor,
  });

  final String label;
  final Color borderColor;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: _primaryBlue,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AddSectionButton extends StatelessWidget {
  const _AddSectionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Container(
        height: 46,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFDDE7F3)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: _primaryBlue, size: 19),
            SizedBox(width: 8),
            Text(
              'Agregar sección de parqueo',
              style: TextStyle(
                color: _primaryBlue,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewSectionSheet extends StatefulWidget {
  const _NewSectionSheet();

  @override
  State<_NewSectionSheet> createState() => _NewSectionSheetState();
}

class _NewSectionSheetState extends State<_NewSectionSheet> {
  final _nameController = TextEditingController(text: 'Nueva sección');
  final _prefixController = TextEditingController(text: 'C');
  int _count = 10;

  @override
  void dispose() {
    _nameController.dispose();
    _prefixController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Nueva sección de parqueo',
                style: TextStyle(
                  color: _ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              _SheetInput(label: 'Nombre', controller: _nameController),
              const SizedBox(height: 10),
              _SheetInput(label: 'Prefijo', controller: _prefixController),
              const SizedBox(height: 12),
              const _ConfigLabel('Cantidad de espacios'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final value in const [5, 10, 15, 20])
                    _NumberChip(
                      label: '$value',
                      selected: _count == value,
                      onTap: () => setState(() => _count = value),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          _SectionDraft(
                            name: _nameController.text.trim().isEmpty
                                ? 'Nueva sección'
                                : _nameController.text.trim(),
                            prefix: _prefixController.text.trim().isEmpty
                                ? 'C'
                                : _prefixController.text.trim().toUpperCase(),
                            count: _count,
                          ),
                        );
                      },
                      child: const Text('Crear'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetInput extends StatelessWidget {
  const _SheetInput({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _EmptyParkingPanel extends StatelessWidget {
  const _EmptyParkingPanel();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
      children: const [
        Icon(Icons.local_parking_rounded, color: _primaryBlue, size: 46),
        SizedBox(height: 14),
        Text(
          'No parking published yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Publish your first parking to manage sections and spaces here.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 13),
        ),
      ],
    );
  }
}

class _HostParkingData {
  const _HostParkingData({
    required this.id,
    required this.name,
    required this.sections,
  });

  final String id;
  final String name;
  final List<_ParkingSectionData> sections;

  factory _HostParkingData.fromApi(Map<String, dynamic> json) {
    final layout = json['layout'] as Map<String, dynamic>? ?? const {};
    final layoutSections = layout['sections'];
    final pricing = json['pricing'] as Map<String, dynamic>? ?? const {};
    final pricingSections = pricing['sections'];
    final spaces = json['spaces'] as Map<String, dynamic>? ?? const {};
    final identifiers = spaces['identifiers'];
    final occupiedSpaces =
        (layout['occupiedSpaces'] as List<dynamic>? ?? const [])
            .map((item) => item.toString())
            .toSet();

    List<_ParkingSectionData> sections;
    if (layoutSections is List && layoutSections.isNotEmpty) {
      sections = layoutSections
          .whereType<Map<String, dynamic>>()
          .map(_ParkingSectionData.fromLayout)
          .toList();
    } else if (pricingSections is List && pricingSections.isNotEmpty) {
      sections = pricingSections
          .whereType<Map<String, dynamic>>()
          .map(
            (section) =>
                _ParkingSectionData.fromPricing(section, occupiedSpaces),
          )
          .toList();
    } else {
      final labels = identifiers is List
          ? identifiers.map((item) => item.toString()).toList()
          : List<String>.generate(
              (spaces['total'] as num?)?.round() ?? 10,
              (index) => 'A${index + 1}',
            );
      sections = [
        _ParkingSectionData.fromLabels(
          id: 'A',
          name: 'Planta Baja',
          prefix: 'A',
          labels: labels,
          occupiedSpaces: occupiedSpaces,
        ),
      ];
    }

    return _HostParkingData(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Parking',
      sections: sections,
    );
  }

  _HostParkingData toggleSpace(String sectionId, String label) {
    return _HostParkingData(
      id: id,
      name: name,
      sections: sections
          .map(
            (section) =>
                section.id == sectionId ? section.toggle(label) : section,
          )
          .toList(),
    );
  }

  _HostParkingData configureSection(
    String sectionId, {
    String? prefix,
    int? count,
  }) {
    return _HostParkingData(
      id: id,
      name: name,
      sections: sections
          .map(
            (section) => section.id == sectionId
                ? section.configure(prefix: prefix, count: count)
                : section,
          )
          .toList(),
    );
  }

  _HostParkingData addSection(_SectionDraft draft) {
    final section = _ParkingSectionData.fromLabels(
      id: '${draft.prefix}-${DateTime.now().millisecondsSinceEpoch}',
      name: draft.name,
      prefix: draft.prefix,
      labels: List<String>.generate(
        draft.count,
        (index) => '${draft.prefix}${index + 1}',
      ),
      occupiedSpaces: const {},
    );
    return _HostParkingData(
      id: id,
      name: name,
      sections: [...sections, section],
    );
  }

  Map<String, dynamic> toLayoutPayload() {
    return {
      'sections': sections.map((section) => section.toPayload()).toList(),
      'occupiedSpaces': [
        for (final section in sections)
          for (final space in section.spaces)
            if (space.occupied) space.label,
      ],
    };
  }
}

class _ParkingSectionData {
  const _ParkingSectionData({
    required this.id,
    required this.name,
    required this.prefix,
    required this.spaces,
  });

  final String id;
  final String name;
  final String prefix;
  final List<_ParkingSpaceData> spaces;

  int get total => spaces.length;
  int get occupied => spaces.where((space) => space.occupied).length;
  int get free => total - occupied;

  factory _ParkingSectionData.fromLayout(Map<String, dynamic> json) {
    final spaces = (json['spaces'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(_ParkingSpaceData.fromApi)
        .toList();
    final code = json['code']?.toString() ?? json['prefix']?.toString() ?? 'A';
    return _ParkingSectionData(
      id: json['id']?.toString() ?? code,
      name: json['name']?.toString() ?? 'Section',
      prefix: json['prefix']?.toString() ?? code,
      spaces: spaces,
    );
  }

  factory _ParkingSectionData.fromPricing(
    Map<String, dynamic> json,
    Set<String> occupiedSpaces,
  ) {
    final code = json['code']?.toString() ?? 'A';
    final labels = json['spaces'] is List
        ? (json['spaces'] as List).map((item) => item.toString()).toList()
        : const <String>[];
    return _ParkingSectionData.fromLabels(
      id: json['id']?.toString() ?? code,
      name: json['name']?.toString() ?? 'Section',
      prefix: code,
      labels: labels,
      occupiedSpaces: occupiedSpaces,
    );
  }

  factory _ParkingSectionData.fromLabels({
    required String id,
    required String name,
    required String prefix,
    required List<String> labels,
    required Set<String> occupiedSpaces,
  }) {
    return _ParkingSectionData(
      id: id,
      name: name,
      prefix: prefix,
      spaces: labels
          .map(
            (label) => _ParkingSpaceData(
              id: label,
              label: label,
              occupied: occupiedSpaces.contains(label),
              compact: false,
            ),
          )
          .toList(),
    );
  }

  _ParkingSectionData toggle(String label) {
    return _ParkingSectionData(
      id: id,
      name: name,
      prefix: prefix,
      spaces: spaces
          .map((space) => space.id == label ? space.toggle() : space)
          .toList(),
    );
  }

  _ParkingSectionData configure({String? prefix, int? count}) {
    final nextPrefix = prefix?.trim().toUpperCase();
    final cleanPrefix = nextPrefix == null || nextPrefix.isEmpty
        ? this.prefix
        : nextPrefix;
    final nextCount = count ?? total;
    final existingOccupied = {
      for (final space in spaces)
        if (space.occupied) space.label,
    };

    return _ParkingSectionData.fromLabels(
      id: id,
      name: name,
      prefix: cleanPrefix,
      labels: List<String>.generate(
        nextCount,
        (index) => '$cleanPrefix${index + 1}',
      ),
      occupiedSpaces: existingOccupied,
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      'id': id,
      'code': prefix,
      'prefix': prefix,
      'name': name,
      'spaces': spaces.map((space) => space.label).toList(),
      'count': spaces.length,
    };
  }
}

class _ParkingSpaceData {
  const _ParkingSpaceData({
    required this.id,
    required this.label,
    required this.occupied,
    this.compact = false,
  });

  final String id;
  final String label;
  final bool occupied;
  final bool compact;

  factory _ParkingSpaceData.fromApi(Map<String, dynamic> json) {
    return _ParkingSpaceData(
      id: json['id']?.toString() ?? json['label']?.toString() ?? '',
      label: json['label']?.toString() ?? json['id']?.toString() ?? '',
      occupied: json['occupied'] == true,
      compact: true,
    );
  }

  _ParkingSpaceData toggle() {
    return _ParkingSpaceData(
      id: id,
      label: label,
      occupied: !occupied,
      compact: compact,
    );
  }
}

class _SectionDraft {
  const _SectionDraft({
    required this.name,
    required this.prefix,
    required this.count,
  });

  final String name;
  final String prefix;
  final int count;
}
