import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/driver_booking_api_service.dart';

enum DriverBookingTab { active, requests, history }

class DriverBookingItem {
  const DriverBookingItem({
    required this.id,
    required this.status,
    required this.statusLabel,
    required this.approvalMode,
    required this.parkingName,
    required this.date,
    required this.timeRange,
    required this.vehiclePlate,
    required this.bookingPrice,
    required this.canCheckIn,
    required this.canCheckOut,
  });

  final String id;
  final String status;
  final String statusLabel;
  final String approvalMode;
  final String parkingName;
  final String date;
  final String timeRange;
  final String vehiclePlate;
  final String bookingPrice;
  final bool canCheckIn;
  final bool canCheckOut;

  bool get isAutomatic => approvalMode == 'automatic';
  bool get isInProgress => status == 'in_progress';
  bool get isPendingCheckIn => status == 'pending_checkin';

  String get dateTimeLabel {
    final dateLabel = _friendlyDate(date);
    return '$dateLabel - $timeRange';
  }

  factory DriverBookingItem.fromJson(Map<String, dynamic> json) {
    final parking = json['parking'] as Map<String, dynamic>? ?? const {};
    final reservation =
        json['reservation'] as Map<String, dynamic>? ?? const {};
    final pricing = json['pricing'] as Map<String, dynamic>? ?? const {};
    final actions = json['actions'] as Map<String, dynamic>? ?? const {};
    final hourlyRate = (pricing['hourlyRate'] as num?)?.round();
    final durationHours = (reservation['durationHours'] as num?)?.round();
    final displayTotal = pricing['displayTotal']?.toString();
    final compactPrice = hourlyRate != null && durationHours != null
        ? 'RD\$$hourlyRate x ${durationHours}h'
        : displayTotal ?? 'RD\$0';

    return DriverBookingItem(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusLabel: json['statusLabel']?.toString() ?? 'Booking',
      approvalMode: json['approvalMode']?.toString() ?? 'automatic',
      parkingName: parking['name']?.toString() ?? 'Parking',
      date: reservation['date']?.toString() ?? '',
      timeRange: reservation['timeRange']?.toString() ?? '',
      vehiclePlate: reservation['vehiclePlate']?.toString() ?? '',
      bookingPrice: compactPrice,
      canCheckIn: actions['canCheckIn'] == true,
      canCheckOut: actions['canCheckOut'] == true,
    );
  }

  static String _friendlyDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value.isEmpty ? 'Today' : value;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bookingDay = DateTime(parsed.year, parsed.month, parsed.day);
    if (bookingDay == today) return 'Today';
    if (bookingDay == today.add(const Duration(days: 1))) return 'Tomorrow';
    return DateFormat('MMM d').format(parsed);
  }
}

class DriverBookingsController extends GetxController {
  DriverBookingsController({DriverBookingApiService? api})
    : _api = api ?? DriverBookingApiService.instance;

  final DriverBookingApiService _api;

  final RxString selectedFilter = 'All'.obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final RxList<DriverBookingItem> activeBookings = <DriverBookingItem>[].obs;
  final RxList<DriverBookingItem> requestBookings = <DriverBookingItem>[].obs;
  final RxList<DriverBookingItem> historyBookings = <DriverBookingItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  Future<void> refreshAll() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await Future.wait([
        loadTab(DriverBookingTab.active, quiet: true),
        loadTab(DriverBookingTab.requests, quiet: true),
        loadTab(DriverBookingTab.history, quiet: true),
      ]);
    } catch (error) {
      errorMessage.value = _messageFrom(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTab(DriverBookingTab tab, {bool quiet = false}) async {
    if (!quiet) {
      isLoading.value = true;
      errorMessage.value = null;
    }
    try {
      final response = await _api.listBookings(tab: _tabCode(tab));
      final rawBookings = response['bookings'] as List<dynamic>? ?? const [];
      final bookings = rawBookings
          .whereType<Map<String, dynamic>>()
          .map(DriverBookingItem.fromJson)
          .where((booking) => booking.id.isNotEmpty)
          .toList();

      switch (tab) {
        case DriverBookingTab.active:
          activeBookings.assignAll(bookings);
          break;
        case DriverBookingTab.requests:
          requestBookings.assignAll(bookings);
          break;
        case DriverBookingTab.history:
          historyBookings.assignAll(bookings);
          break;
      }
    } catch (error) {
      errorMessage.value = _messageFrom(error);
    } finally {
      if (!quiet) isLoading.value = false;
    }
  }

  Future<bool> checkIn(DriverBookingItem booking, String qrPayload) async {
    try {
      await _api.checkIn(bookingId: booking.id, qrPayload: qrPayload);
      await refreshAll();
      Get.snackbar('Parkealo', 'Check-in successful');
      return true;
    } catch (error) {
      Get.snackbar('Parkealo', _messageFrom(error));
      return false;
    }
  }

  Future<void> checkOut(DriverBookingItem booking) async {
    try {
      await _api.checkOut(bookingId: booking.id);
      await refreshAll();
      Get.snackbar('Parkealo', 'Check-out successful');
    } catch (error) {
      Get.snackbar('Parkealo', _messageFrom(error));
    }
  }

  List<DriverBookingItem> filtered(List<DriverBookingItem> bookings) {
    switch (selectedFilter.value) {
      case 'Quick':
        return bookings.where((booking) => booking.isAutomatic).toList();
      case 'Pending':
        return bookings
            .where(
              (booking) =>
                  booking.status == 'pending_checkin' ||
                  booking.status == 'pending_host_approval',
            )
            .toList();
      default:
        return bookings;
    }
  }

  String _tabCode(DriverBookingTab tab) {
    switch (tab) {
      case DriverBookingTab.active:
        return 'active';
      case DriverBookingTab.requests:
        return 'requests';
      case DriverBookingTab.history:
        return 'history';
    }
  }

  String _messageFrom(Object error) {
    if (error is DriverBookingApiException) return error.message;
    return 'Could not load bookings';
  }
}
