import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../Feature/Authentication/services/auth_api_service.dart';
import '../../../../utils/appColor/app_colors.dart';
import 'booking_flow_models.dart';
import 'widgets/custom_pariking_list_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController searchController = TextEditingController();
  final Set<String> selectedFilters = {};
  LatLng? _origin;
  String _sortCode = 'recommended';
  String _ratePeriod = 'hourly';
  late Future<_ExploreData> _exploreFuture;

  @override
  void initState() {
    super.initState();
    _exploreFuture = _loadInitialExploreData();
  }

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
              FutureBuilder<_ExploreData>(
                future: _exploreFuture,
                builder: (context, snapshot) {
                  final data = snapshot.data ?? _ExploreData.empty();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MapPreview(markers: data.markers, origin: _origin),
                      const SizedBox(height: 14),
                      _buildResultsRow(data.total),
                      const SizedBox(height: 12),
                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (data.parkings.isEmpty)
                        const _EmptyResults()
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Column(
                            children: data.parkings
                                .map(
                                  (parking) => CustomParkingListCard(
                                    imageUrl: parking.imageUrl,
                                    title: parking.title,
                                    subtitle: parking.subtitle,
                                    rating: parking.rating,
                                    reviews: parking.reviews,
                                    price: parking.price,
                                    tags: parking.tags,
                                    details: parking.details,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      if (data.hasError)
                        Padding(
                          padding: EdgeInsets.fromLTRB(14, 0, 14, 12),
                          child: _ExploreNotice(
                            text:
                                'Could not reach the live parking API. Check that the backend is running.',
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _reloadExplore() {
    setState(() {
      _exploreFuture = _fetchExploreData();
    });
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
              onSubmitted: (_) => _reloadExplore(),
            ),
          ),
          Container(height: 20, width: 1, color: AppColors.border),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _useCurrentLocation,
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.location_on_outlined,
                color: AppColors.green,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 13),
        ],
      ),
    );
  }

  Widget _buildRentalButton() {
    final options = const [
      ('hourly', 'Hourly'),
      ('daily', 'Daily'),
      ('monthly', 'Monthly'),
    ];

    return PopupMenuButton<String>(
      offset: const Offset(0, 42),
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      initialValue: _ratePeriod,
      onSelected: (value) {
        setState(() {
          _ratePeriod = value;
          _exploreFuture = _fetchExploreData();
        });
      },
      itemBuilder: (context) => [
        for (final option in options)
          PopupMenuItem<String>(
            value: option.$1,
            child: Text(
              option.$2,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
          ),
      ],
      child: Container(
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
              _periodLabel(_ratePeriod),
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
      ),
    );
  }

  String _periodLabel(String value) {
    return switch (value) {
      'daily' => 'Daily',
      'monthly' => 'Monthly',
      _ => 'Hourly',
    };
  }

  Future<_ExploreData> _loadInitialExploreData() async {
    final location = await _resolveCurrentLocation(
      requestPermission: true,
      showMessages: false,
    );
    if (location != null) {
      _origin = location;
      _sortCode = 'nearest';
    }
    return _fetchExploreData();
  }

  Future<LatLng?> _resolveCurrentLocation({
    required bool requestPermission,
    required bool showMessages,
  }) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (showMessages) _showSnack('Turn on location services to search nearby.');
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && requestPermission) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (showMessages) {
        _showSnack('Location permission is required for nearest parking.');
      }
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    return LatLng(position.latitude, position.longitude);
  }

  Widget _buildFilters() {
    final filters = const [
      (Icons.home_work_outlined, 'Private'),
      (Icons.videocam_outlined, 'Camera'),
      (Icons.roofing_outlined, 'Covered'),
      (Icons.person_rounded, 'Staff'),
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
              _reloadExplore();
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

  Widget _buildResultsRow(int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '$total ',
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
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _showSortSheet,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              child: Row(
                children: [
                  Text(
                    _sortLabel,
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
            ),
          ),
        ],
      ),
    );
  }

  Future<_ExploreData> _fetchExploreData() async {
    try {
      final query = <String, String>{'limit': '20', 'sort': _sortCode};
      final search = searchController.text.trim();
      if (search.isNotEmpty) query['search'] = search;
      if (_origin != null) {
        query['lat'] = _origin!.latitude.toString();
        query['lng'] = _origin!.longitude.toString();
      }
      final serviceCodes = selectedFilters
          .map(_filterToServiceCode)
          .whereType<String>()
          .toList();
      if (serviceCodes.isNotEmpty) query['services'] = serviceCodes.join(',');
      if (selectedFilters.contains('Private')) query['accessType'] = 'private';

      final response = await http.get(
        Uri.parse(
          '${AuthApiService.baseUrl}/api/parkings',
        ).replace(queryParameters: query),
      );
      if (response.statusCode >= 400) return _ExploreData.empty();
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return _ExploreData.empty();
      final parkings = decoded['parkings'];
      if (parkings is! List) return _ExploreData.empty();
      return _ExploreData(
        total: (decoded['total'] as num?)?.round() ?? parkings.length,
        parkings: parkings
            .whereType<Map<String, dynamic>>()
            .map((parking) => _ParkingData.fromApi(parking, _ratePeriod))
            .toList(),
        markers: parkings
            .whereType<Map<String, dynamic>>()
            .map((parking) => _MapMarkerData.fromParking(parking, _ratePeriod))
            .toList(),
      );
    } catch (error) {
      return _ExploreData.error();
    }
  }

  Future<void> _useCurrentLocation() async {
    try {
      final location = await _resolveCurrentLocation(
        requestPermission: true,
        showMessages: true,
      );
      if (location == null) return;
      setState(() {
        _origin = location;
        _sortCode = 'nearest';
        _exploreFuture = _fetchExploreData();
      });
    } catch (_) {
      _showSnack('Could not get your current location.');
    }
  }

  void _showSortSheet() {
    final options = const [
      ('recommended', 'Recommended'),
      ('nearest', 'Nearest'),
      ('price_low', 'Price low'),
      ('price_high', 'Price high'),
      ('available', 'Most available'),
      ('rating', 'Top rated'),
    ];

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderMd,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 14),
              for (final option in options)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option.$2,
                    style: GoogleFonts.nunito(
                      color: AppColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  trailing: _sortCode == option.$1
                      ? const Icon(Icons.check_rounded, color: AppColors.blue)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _sortCode = option.$1;
                      _exploreFuture = _fetchExploreData();
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  String get _sortLabel {
    return switch (_sortCode) {
      'nearest' => 'Nearest',
      'price_low' => 'Price low',
      'price_high' => 'Price high',
      'available' => 'Available',
      'rating' => 'Rating',
      _ => 'Sort',
    };
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String? _filterToServiceCode(String value) {
    return switch (value) {
      'Camera' => 'camera',
      'Covered' => 'covered',
      'Staff' => 'staff',
      _ => null,
    };
  }
}

class _ParkingData {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String rating;
  final String reviews;
  final String price;
  final List<String> tags;
  final Map<String, dynamic> details;

  const _ParkingData({
    this.imageUrl = '',
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.tags,
    required this.details,
  });

  factory _ParkingData.fromApi(Map<String, dynamic> parking, String period) {
    final rate = parking['rate'] as Map<String, dynamic>? ?? const {};
    final rating = parking['rating'] as Map<String, dynamic>? ?? const {};
    final media = parking['media'] as Map<String, dynamic>? ?? const {};
    final services = (parking['services'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final serviceLabels = services
        .map((service) => service['label']?.toString() ?? '')
        .where((label) => label.isNotEmpty)
        .toList();
    final reviewCount = (rating['reviewsCount'] as num?)?.round() ?? 0;
    final distance = (parking['distance'] as Map<String, dynamic>?)?['label']
        ?.toString();
    final zone = parking['zone']?.toString() ?? '';
    final subtitleParts = [
      zone,
      if (distance != null && distance.isNotEmpty) distance,
      '$reviewCount reviews',
    ].where((part) => part.isNotEmpty).toList();

    return _ParkingData(
      imageUrl: media['heroImageUrl']?.toString() ?? '',
      title: parking['name']?.toString() ?? 'Parking',
      subtitle: subtitleParts.join(' - '),
      rating: ((rating['average'] as num?)?.toDouble() ?? 0).toStringAsFixed(2),
      reviews: '$reviewCount reviews',
      price: _priceLabelFromRate(rate, period),
      tags: serviceLabels.take(3).toList(),
      details: BookingDraft.fromApiParking(parking),
    );
  }

  static String _priceLabelFromRate(Map<String, dynamic> rate, String period) {
    final symbol = rate['currencySymbol']?.toString() ?? 'RD\$';
    final hourly = (rate['hourly'] as num?)?.round() ?? 0;
    final daily = (rate['daily'] as num?)?.round() ?? hourly * 8;
    final weekly = (rate['weekly'] as num?)?.round() ?? daily * 7;

    return switch (period) {
      'daily' => '$symbol$daily',
      'monthly' => '$symbol${weekly * 4}',
      _ => '$symbol$hourly',
    };
  }
}

class _ExploreData {
  const _ExploreData({
    required this.total,
    required this.parkings,
    required this.markers,
    this.hasError = false,
  });

  final int total;
  final List<_ParkingData> parkings;
  final List<_MapMarkerData> markers;
  final bool hasError;

  static _ExploreData empty() {
    return const _ExploreData(total: 0, parkings: [], markers: []);
  }

  static _ExploreData error() {
    return const _ExploreData(
      total: 0,
      parkings: [],
      markers: [],
      hasError: true,
    );
  }
}

class _MapMarkerData {
  const _MapMarkerData({
    required this.id,
    required this.name,
    required this.priceLabel,
    required this.accessType,
    required this.availableSpaces,
    required this.point,
  });

  final String id;
  final String name;
  final String priceLabel;
  final String accessType;
  final int availableSpaces;
  final LatLng? point;

  factory _MapMarkerData.fromParking(
    Map<String, dynamic> parking,
    String period,
  ) {
    final coordinates = parking['coordinates'] as Map<String, dynamic>?;
    final latitude = (coordinates?['latitude'] as num?)?.toDouble();
    final longitude = (coordinates?['longitude'] as num?)?.toDouble();
    final rate = parking['rate'] as Map<String, dynamic>? ?? const {};
    final availability =
        parking['availability'] as Map<String, dynamic>? ?? const {};
    return _MapMarkerData(
      id: parking['id']?.toString() ?? '',
      name: parking['name']?.toString() ?? 'Parking',
      priceLabel: _ParkingData._priceLabelFromRate(rate, period),
      accessType: parking['accessType']?.toString() ?? 'public',
      availableSpaces: (availability['availableSpaces'] as num?)?.round() ?? 0,
      point: latitude == null || longitude == null
          ? null
          : LatLng(latitude, longitude),
    );
  }
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
  const _MapPreview({required this.markers, required this.origin});

  final List<_MapMarkerData> markers;
  final LatLng? origin;

  @override
  Widget build(BuildContext context) {
    final visibleMarkers = markers
        .where((marker) => marker.point != null)
        .take(40)
        .toList();
    final center = origin ??
        (visibleMarkers.isNotEmpty
            ? _averagePoint(visibleMarkers)
            : const LatLng(18.4861, -69.9312));

    return Container(
      height: 228,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8E4F2)),
        color: const Color(0xFFEFF5FB),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: visibleMarkers.length <= 1 ? 14.5 : 13,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.drag | InteractiveFlag.pinchZoom,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.parkealo',
                ),
                MarkerLayer(
                  markers: [
                    if (origin != null)
                      Marker(
                        point: origin!,
                        width: 34,
                        height: 34,
                        child: const _UserDot(),
                      ),
                    for (final marker in visibleMarkers)
                      Marker(
                        point: marker.point!,
                        width: 92,
                        height: 42,
                        child: _PriceBadge(
                          text: _compactPrice(marker.priceLabel),
                          color: marker.accessType == 'private'
                              ? AppColors.blueNav
                              : AppColors.green,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            left: 10,
            child: _MapLabel(
              text: visibleMarkers.isEmpty
                  ? 'No live parkings found'
                  : visibleMarkers.first.name,
              color: AppColors.bg,
              textColor: AppColors.textSub,
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Row(
              children: [
                const _MapLegend(label: 'Public', color: AppColors.green),
                const SizedBox(width: 6),
                const _MapLegend(label: 'Private', color: AppColors.blueNav),
                const SizedBox(width: 6),
                _MapLegend(
                  label:
                      '${visibleMarkers.fold<int>(0, (sum, marker) => sum + marker.availableSpaces)} free',
                  color: AppColors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _compactPrice(String value) {
    return value.replaceAll('/hour', '').replaceAll(' / hour', '').trim();
  }

  LatLng _averagePoint(List<_MapMarkerData> markers) {
    final points = markers.map((marker) => marker.point).whereType<LatLng>();
    var count = 0;
    var lat = 0.0;
    var lng = 0.0;
    for (final point in points) {
      count++;
      lat += point.latitude;
      lng += point.longitude;
    }
    if (count == 0) return const LatLng(18.4861, -69.9312);
    return LatLng(lat / count, lng / count);
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

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.local_parking_rounded,
            color: AppColors.blue,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            'No live parking spaces found',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: AppColors.text,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Publish and activate a parking from the Host panel, then refresh Explore.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: AppColors.textSub,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreNotice extends StatelessWidget {
  const _ExploreNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7DD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0D080)),
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          color: const Color(0xFF8A6200),
          fontSize: 11,
          fontWeight: FontWeight.w800,
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
