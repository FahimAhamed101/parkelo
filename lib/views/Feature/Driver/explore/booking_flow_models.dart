import 'package:intl/intl.dart';

class BookingDraft {
  final String? parkingId;
  final String parkingName;
  final String location;
  final String zoneLabel;
  final String description;
  final String rules;
  final String addressLine;
  final String contactPhone;
  final String instagram;
  final String hostName;
  final String parkingType;
  final double rating;
  final int reviews;
  final int pricePerHour;
  final int pricePerDay;
  final int pricePerWeek;
  final int totalSpaces;
  final int availableSpaces;
  final int floors;
  final List<String> services;
  final List<String> serviceCodes;
  final List<String> photos;
  final List<String> spaceIdentifiers;
  final List<PricingSectionDraft> pricingSections;
  final bool dynamicPricingEnabled;
  final int dynamicPricingThreshold;
  final int dynamicPricingIncrease;
  final double overtimeMultiplier;
  final int overtimeGraceMinutes;
  final double taxRate;
  final int serviceFee;
  final int insuranceFeeValue;
  final List<String> arrivalTimes;
  final List<int> durationOptions;
  final DateTime date;
  final String arrivalTime;
  final int durationHours;
  final bool bookForAnotherPerson;
  final bool insuranceEnabled;
  final String assignedSpace;
  final String vehiclePlate;

  const BookingDraft({
    this.parkingId,
    required this.parkingName,
    required this.location,
    required this.zoneLabel,
    required this.description,
    required this.rules,
    required this.addressLine,
    required this.contactPhone,
    required this.instagram,
    required this.hostName,
    required this.parkingType,
    required this.rating,
    required this.reviews,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.pricePerWeek,
    required this.totalSpaces,
    required this.availableSpaces,
    required this.floors,
    required this.services,
    required this.serviceCodes,
    required this.photos,
    required this.spaceIdentifiers,
    required this.pricingSections,
    required this.dynamicPricingEnabled,
    required this.dynamicPricingThreshold,
    required this.dynamicPricingIncrease,
    required this.overtimeMultiplier,
    required this.overtimeGraceMinutes,
    required this.taxRate,
    required this.serviceFee,
    required this.insuranceFeeValue,
    required this.arrivalTimes,
    required this.durationOptions,
    required this.date,
    required this.arrivalTime,
    required this.durationHours,
    required this.bookForAnotherPerson,
    required this.insuranceEnabled,
    required this.assignedSpace,
    required this.vehiclePlate,
  });

  factory BookingDraft.initial() {
    final now = DateTime.now();
    return BookingDraft(
      parkingId: 'parking-colonial-premium',
      parkingName: 'Parking Colonial Premium',
      location: 'Zone Colonial, SD',
      zoneLabel: 'Zone Colonial, SD - 0.2 km - 128 reviews',
      description:
          'Premium parking near the Colonial Zone with camera monitoring and covered spaces.',
      rules:
          'Do not leave valuable objects visible inside your vehicle. Follow staff instructions when entering and exiting.',
      addressLine: 'Calle El Conde 102, Colonial Zone, Santo Domingo',
      contactPhone: '+1 809 000 0000',
      instagram: '@parkingcolonial',
      hostName: 'Parkealo',
      parkingType: 'public',
      rating: 4.87,
      reviews: 128,
      pricePerHour: 150,
      pricePerDay: 800,
      pricePerWeek: 4500,
      totalSpaces: 10,
      availableSpaces: 8,
      floors: 2,
      services: const [
        'Covered',
        'EV charging',
        'Cameras',
        'Valet',
        '24/7',
        'Controlled access',
        'Staff',
        'Private',
        'Wi-Fi',
        'Accessible',
        'Motorcycles',
        'Bathrooms',
      ],
      serviceCodes: const [
        'covered',
        'ev_charging',
        'camera',
        'valet',
        'open_24_7',
        'controlled_access',
        'staff',
        'private',
        'wifi',
        'accessible',
        'motorcycles',
        'bathrooms',
      ],
      photos: const [],
      spaceIdentifiers: const [
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '10',
      ],
      pricingSections: const [
        PricingSectionDraft(
          name: 'Ground Floor',
          hourly: 150,
          daily: 800,
          weekly: 4500,
          spaces: ['1', '2', '3', '4', '5'],
        ),
        PricingSectionDraft(
          name: 'Level 1',
          hourly: 150,
          daily: 800,
          weekly: 4500,
          spaces: ['6', '7', '8', '9', '10'],
        ),
      ],
      dynamicPricingEnabled: true,
      dynamicPricingThreshold: 80,
      dynamicPricingIncrease: 20,
      overtimeMultiplier: 1.5,
      overtimeGraceMinutes: 0,
      taxRate: 0.18,
      serviceFee: 25,
      insuranceFeeValue: 25,
      arrivalTimes: const ['7:00 AM', '7:30 AM', '8:00 AM', '8:30 AM'],
      durationOptions: const [1, 2, 4, 6, 8, 24],
      date: DateTime(now.year, now.month, now.day),
      arrivalTime: '7:30 AM',
      durationHours: 2,
      bookForAnotherPerson: false,
      insuranceEnabled: true,
      assignedSpace: 'Assigned on arrival',
      vehiclePlate: 'A123456',
    );
  }

  factory BookingDraft.fromMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) {
      return BookingDraft.initial();
    }

    final base = BookingDraft.initial();

    return BookingDraft(
      parkingId:
          map['parkingId'] as String? ?? map['id'] as String? ?? base.parkingId,
      parkingName: map['parkingName'] as String? ?? base.parkingName,
      location: map['location'] as String? ?? base.location,
      zoneLabel: map['zoneLabel'] as String? ?? base.zoneLabel,
      description: map['description'] as String? ?? base.description,
      rules: map['rules'] as String? ?? base.rules,
      addressLine: map['addressLine'] as String? ?? base.addressLine,
      contactPhone: map['contactPhone'] as String? ?? base.contactPhone,
      instagram: map['instagram'] as String? ?? base.instagram,
      hostName: map['hostName'] as String? ?? base.hostName,
      parkingType: map['parkingType'] as String? ?? base.parkingType,
      rating: (map['rating'] as num?)?.toDouble() ?? base.rating,
      reviews: map['reviews'] as int? ?? base.reviews,
      pricePerHour: map['pricePerHour'] as int? ?? base.pricePerHour,
      pricePerDay: map['pricePerDay'] as int? ?? base.pricePerDay,
      pricePerWeek: map['pricePerWeek'] as int? ?? base.pricePerWeek,
      totalSpaces: map['totalSpaces'] as int? ?? base.totalSpaces,
      availableSpaces: map['availableSpaces'] as int? ?? base.availableSpaces,
      floors: map['floors'] as int? ?? base.floors,
      services: _stringList(map['services'], base.services),
      serviceCodes: _stringList(map['serviceCodes'], base.serviceCodes),
      photos: _stringList(map['photos'], base.photos),
      spaceIdentifiers: _stringList(
        map['spaceIdentifiers'],
        base.spaceIdentifiers,
      ),
      pricingSections: PricingSectionDraft.listFromMap(
        map['pricingSections'],
        base.pricingSections,
      ),
      dynamicPricingEnabled:
          map['dynamicPricingEnabled'] as bool? ?? base.dynamicPricingEnabled,
      dynamicPricingThreshold:
          map['dynamicPricingThreshold'] as int? ??
          base.dynamicPricingThreshold,
      dynamicPricingIncrease:
          map['dynamicPricingIncrease'] as int? ?? base.dynamicPricingIncrease,
      overtimeMultiplier:
          (map['overtimeMultiplier'] as num?)?.toDouble() ??
          base.overtimeMultiplier,
      overtimeGraceMinutes:
          map['overtimeGraceMinutes'] as int? ?? base.overtimeGraceMinutes,
      taxRate: (map['taxRate'] as num?)?.toDouble() ?? base.taxRate,
      serviceFee: map['serviceFee'] as int? ?? base.serviceFee,
      insuranceFeeValue:
          map['insuranceFee'] as int? ??
          map['insuranceFeeValue'] as int? ??
          base.insuranceFeeValue,
      arrivalTimes: _stringList(map['arrivalTimes'], base.arrivalTimes),
      durationOptions: _intList(map['durationOptions'], base.durationOptions),
      date:
          DateTime.tryParse(map['date'] as String? ?? '') ??
          DateTime(base.date.year, base.date.month, base.date.day),
      arrivalTime: map['arrivalTime'] as String? ?? base.arrivalTime,
      durationHours: map['durationHours'] as int? ?? base.durationHours,
      bookForAnotherPerson:
          map['bookForAnotherPerson'] as bool? ?? base.bookForAnotherPerson,
      insuranceEnabled:
          map['insuranceEnabled'] as bool? ?? base.insuranceEnabled,
      assignedSpace: map['assignedSpace'] as String? ?? base.assignedSpace,
      vehiclePlate: map['vehiclePlate'] as String? ?? base.vehiclePlate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parkingId': parkingId,
      'parkingName': parkingName,
      'location': location,
      'zoneLabel': zoneLabel,
      'description': description,
      'rules': rules,
      'addressLine': addressLine,
      'contactPhone': contactPhone,
      'instagram': instagram,
      'hostName': hostName,
      'parkingType': parkingType,
      'rating': rating,
      'reviews': reviews,
      'pricePerHour': pricePerHour,
      'pricePerDay': pricePerDay,
      'pricePerWeek': pricePerWeek,
      'totalSpaces': totalSpaces,
      'availableSpaces': availableSpaces,
      'floors': floors,
      'services': services,
      'serviceCodes': serviceCodes,
      'photos': photos,
      'spaceIdentifiers': spaceIdentifiers,
      'pricingSections': pricingSections
          .map((section) => section.toMap())
          .toList(),
      'dynamicPricingEnabled': dynamicPricingEnabled,
      'dynamicPricingThreshold': dynamicPricingThreshold,
      'dynamicPricingIncrease': dynamicPricingIncrease,
      'overtimeMultiplier': overtimeMultiplier,
      'overtimeGraceMinutes': overtimeGraceMinutes,
      'taxRate': taxRate,
      'serviceFee': serviceFee,
      'insuranceFee': insuranceFeeValue,
      'arrivalTimes': arrivalTimes,
      'durationOptions': durationOptions,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'arrivalTime': arrivalTime,
      'durationHours': durationHours,
      'bookForAnotherPerson': bookForAnotherPerson,
      'insuranceEnabled': insuranceEnabled,
      'assignedSpace': assignedSpace,
      'vehiclePlate': vehiclePlate,
    };
  }

  BookingDraft copyWith({
    DateTime? date,
    String? arrivalTime,
    int? durationHours,
    bool? bookForAnotherPerson,
    bool? insuranceEnabled,
    String? vehiclePlate,
  }) {
    return BookingDraft(
      parkingId: parkingId,
      parkingName: parkingName,
      location: location,
      zoneLabel: zoneLabel,
      description: description,
      rules: rules,
      addressLine: addressLine,
      contactPhone: contactPhone,
      instagram: instagram,
      hostName: hostName,
      parkingType: parkingType,
      rating: rating,
      reviews: reviews,
      pricePerHour: pricePerHour,
      pricePerDay: pricePerDay,
      pricePerWeek: pricePerWeek,
      totalSpaces: totalSpaces,
      availableSpaces: availableSpaces,
      floors: floors,
      services: services,
      serviceCodes: serviceCodes,
      photos: photos,
      spaceIdentifiers: spaceIdentifiers,
      pricingSections: pricingSections,
      dynamicPricingEnabled: dynamicPricingEnabled,
      dynamicPricingThreshold: dynamicPricingThreshold,
      dynamicPricingIncrease: dynamicPricingIncrease,
      overtimeMultiplier: overtimeMultiplier,
      overtimeGraceMinutes: overtimeGraceMinutes,
      taxRate: taxRate,
      serviceFee: serviceFee,
      insuranceFeeValue: insuranceFeeValue,
      arrivalTimes: arrivalTimes,
      durationOptions: durationOptions,
      date: date ?? this.date,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      durationHours: durationHours ?? this.durationHours,
      bookForAnotherPerson: bookForAnotherPerson ?? this.bookForAnotherPerson,
      insuranceEnabled: insuranceEnabled ?? this.insuranceEnabled,
      assignedSpace: assignedSpace,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
    );
  }

  int get subtotal => pricePerHour * durationHours;
  int get tax => (subtotal * taxRate).round();
  int get insuranceFee => insuranceEnabled ? insuranceFeeValue : 0;
  int get total => subtotal + tax + serviceFee + insuranceFee;

  String get dateLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);
    if (selected == today) {
      return 'Today';
    }
    return DateFormat('MMM d').format(selected);
  }

  String get fullDateLabel => DateFormat('MMM d, yyyy').format(date);

  String get timeRangeLabel => '$arrivalTime - $endTime';

  String get durationLabel => '$durationHours hours';

  String get endTime {
    final parsed = DateFormat('h:mm a').parse(arrivalTime);
    final end = parsed.add(Duration(hours: durationHours));
    return DateFormat('h:mm a').format(end);
  }

  static List<String> _stringList(Object? value, List<String> fallback) {
    if (value is List) {
      return value
          .map((item) => item.toString())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return fallback;
  }

  static List<int> _intList(Object? value, List<int> fallback) {
    if (value is List) {
      final values = value
          .map((item) => item is num ? item.round() : int.tryParse('$item'))
          .whereType<int>()
          .where((item) => item > 0)
          .toList();
      return values.isEmpty ? fallback : values;
    }
    return fallback;
  }

  static Map<String, dynamic> fromApiParking(Map<String, dynamic> parking) {
    final rate = parking['rate'] as Map<String, dynamic>? ?? const {};
    final rating = parking['rating'] as Map<String, dynamic>? ?? const {};
    final availability =
        parking['availability'] as Map<String, dynamic>? ?? const {};
    final host = parking['host'] as Map<String, dynamic>? ?? const {};
    final media = parking['media'] as Map<String, dynamic>? ?? const {};
    final address = parking['address'] as Map<String, dynamic>? ?? const {};
    final pricing = parking['pricing'] as Map<String, dynamic>? ?? const {};
    final dynamicPricing =
        pricing['dynamicPricing'] as Map<String, dynamic>? ?? const {};
    final overtime = pricing['overtime'] as Map<String, dynamic>? ?? const {};
    final insurance = parking['insurance'] as Map<String, dynamic>? ?? const {};
    final bookingOptions =
        parking['bookingOptions'] as Map<String, dynamic>? ?? const {};
    final services = (parking['services'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final serviceLabels = services
        .map((service) => service['label']?.toString() ?? '')
        .where((label) => label.isNotEmpty)
        .toList();
    final serviceCodes = services
        .map((service) => service['code']?.toString() ?? '')
        .where((code) => code.isNotEmpty)
        .toList();
    final sections = (pricing['sections'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map((section) {
          final sectionRate =
              section['rate'] as Map<String, dynamic>? ?? const {};
          return {
            'name': section['name']?.toString() ?? 'Section',
            'hourly': (sectionRate['hourly'] as num?)?.round() ?? 0,
            'daily': (sectionRate['daily'] as num?)?.round() ?? 0,
            'weekly': (sectionRate['weekly'] as num?)?.round() ?? 0,
            'spaces': section['spaces'] is List ? section['spaces'] : const [],
          };
        })
        .toList();
    final gallery = media['gallery'] is List
        ? media['gallery'] as List
        : const [];
    final reviewCount = (rating['reviewsCount'] as num?)?.round() ?? 0;
    final distance = (parking['distance'] as Map<String, dynamic>?)?['label']
        ?.toString();
    final zone = parking['zone']?.toString() ?? '';
    final subtitleParts = [
      zone,
      if (distance != null && distance.isNotEmpty) distance,
      '$reviewCount reviews',
    ].where((part) => part.isNotEmpty).toList();
    final addressParts = [
      address['line1'],
      parking['sector'],
      address['city'],
    ].whereType<String>().where((part) => part.isNotEmpty).toList();
    final durations =
        (bookingOptions['durations'] as List<dynamic>? ?? const [])
            .map((item) => item is Map<String, dynamic> ? item['hours'] : item)
            .toList();

    return {
      'parkingId': parking['id']?.toString(),
      'parkingName': parking['name']?.toString(),
      'location': zone,
      'zoneLabel': subtitleParts.join(' - '),
      'description': parking['description']?.toString() ?? '',
      'rules':
          (parking['rules'] as Map<String, dynamic>?)?['safetyNotice']
              ?.toString() ??
          '',
      'addressLine': addressParts.join(', '),
      'contactPhone': host['contactPhone']?.toString() ?? '',
      'instagram': host['instagram']?.toString() ?? '',
      'hostName': host['name']?.toString() ?? 'Parkealo',
      'parkingType': parking['accessType']?.toString() ?? 'public',
      'rating': (rating['average'] as num?)?.toDouble() ?? 0,
      'reviews': reviewCount,
      'pricePerHour': (rate['hourly'] as num?)?.round() ?? 0,
      'pricePerDay': (rate['daily'] as num?)?.round() ?? 0,
      'pricePerWeek': (rate['weekly'] as num?)?.round() ?? 0,
      'serviceFee': (rate['serviceFee'] as num?)?.round() ?? 25,
      'taxRate': (rate['taxRate'] as num?)?.toDouble() ?? 0.18,
      'insuranceFee': (insurance['fee'] as num?)?.round() ?? 25,
      'totalSpaces': (availability['totalSpaces'] as num?)?.round() ?? 0,
      'availableSpaces':
          (availability['availableSpaces'] as num?)?.round() ?? 0,
      'floors': (availability['floors'] as num?)?.round() ?? 1,
      'services': serviceLabels,
      'serviceCodes': serviceCodes,
      'photos': [
        if ((media['heroImageUrl']?.toString() ?? '').isNotEmpty)
          media['heroImageUrl'].toString(),
        ...gallery.map((item) => item.toString()),
      ],
      'spaceIdentifiers': parking['spaceIdentifiers'] is List
          ? parking['spaceIdentifiers']
          : const [],
      'pricingSections': sections,
      'dynamicPricingEnabled': dynamicPricing['enabled'] == true,
      'dynamicPricingThreshold':
          (dynamicPricing['occupancyThresholdPercent'] as num?)?.round() ?? 80,
      'dynamicPricingIncrease':
          (dynamicPricing['peakIncreasePercent'] as num?)?.round() ?? 20,
      'overtimeMultiplier': (overtime['multiplier'] as num?)?.toDouble() ?? 1.5,
      'overtimeGraceMinutes': (overtime['graceMinutes'] as num?)?.round() ?? 0,
      'arrivalTimes': _stringList(bookingOptions['arrivalTimes'], const [
        '7:00 AM',
        '7:30 AM',
        '8:00 AM',
        '8:30 AM',
      ]),
      'durationOptions': _intList(durations, const [1, 2, 4, 6, 8, 24]),
    };
  }
}

class PricingSectionDraft {
  final String name;
  final int hourly;
  final int daily;
  final int weekly;
  final List<String> spaces;

  const PricingSectionDraft({
    required this.name,
    required this.hourly,
    required this.daily,
    required this.weekly,
    required this.spaces,
  });

  factory PricingSectionDraft.fromMap(Map<String, dynamic> map) {
    return PricingSectionDraft(
      name: map['name'] as String? ?? 'Section',
      hourly: (map['hourly'] as num?)?.round() ?? 0,
      daily: (map['daily'] as num?)?.round() ?? 0,
      weekly: (map['weekly'] as num?)?.round() ?? 0,
      spaces: BookingDraft._stringList(map['spaces'], const []),
    );
  }

  static List<PricingSectionDraft> listFromMap(
    Object? value,
    List<PricingSectionDraft> fallback,
  ) {
    if (value is List) {
      return value
          .whereType<Map<String, dynamic>>()
          .map(PricingSectionDraft.fromMap)
          .toList();
    }
    return fallback;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'hourly': hourly,
      'daily': daily,
      'weekly': weekly,
      'spaces': spaces,
    };
  }
}
