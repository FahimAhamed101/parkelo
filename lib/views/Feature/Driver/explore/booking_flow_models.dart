import 'package:intl/intl.dart';

class BookingDraft {
  final String parkingName;
  final String location;
  final String zoneLabel;
  final double rating;
  final int reviews;
  final int pricePerHour;
  final DateTime date;
  final String arrivalTime;
  final int durationHours;
  final bool bookForAnotherPerson;
  final bool insuranceEnabled;
  final String assignedSpace;
  final String vehiclePlate;

  const BookingDraft({
    required this.parkingName,
    required this.location,
    required this.zoneLabel,
    required this.rating,
    required this.reviews,
    required this.pricePerHour,
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
      parkingName: 'Parking Colonial Premium',
      location: 'Zone Colonial, SD',
      zoneLabel: 'Zone Colonial, SD - 0.2 km - 128 reviews',
      rating: 4.87,
      reviews: 128,
      pricePerHour: 150,
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
      parkingName: map['parkingName'] as String? ?? base.parkingName,
      location: map['location'] as String? ?? base.location,
      zoneLabel: map['zoneLabel'] as String? ?? base.zoneLabel,
      rating: (map['rating'] as num?)?.toDouble() ?? base.rating,
      reviews: map['reviews'] as int? ?? base.reviews,
      pricePerHour: map['pricePerHour'] as int? ?? base.pricePerHour,
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
      'parkingName': parkingName,
      'location': location,
      'zoneLabel': zoneLabel,
      'rating': rating,
      'reviews': reviews,
      'pricePerHour': pricePerHour,
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
      parkingName: parkingName,
      location: location,
      zoneLabel: zoneLabel,
      rating: rating,
      reviews: reviews,
      pricePerHour: pricePerHour,
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
  int get tax => (subtotal * 0.18).round();
  int get serviceFee => 25;
  int get insuranceFee => insuranceEnabled ? 25 : 0;
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
}
