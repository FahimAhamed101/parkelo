import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../../base/AppText/appText.dart';
import '../../../base/CustomAppbar/custom_appbar.dart';
import '../../../../helpers/route.dart';
import 'widgets/active_booking_card.dart';
import 'widgets/request_card.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  String selectedFilter = 'All';
  late TabController _tabController;
  bool _isCheckedIn = false;

  final List<RequestCardModel> _historyItems = const [
    RequestCardModel(
      title: "VIP Piantini · Private House",
      dateTime: "Yesterday · 09:00",
      licensePlate: "B789012",
      statusLabel: "COMPLETED",
      statusColor: Color(0xFF5C6BC0),
      statusBgColor: Color(0xFFEDE7F6),
      approvalLabel: "Approval",
      approvalColor: Color(0xFF5C6BC0),
      approvalBgColor: Color(0xFFEDE7F6),
      message: "Booking completed. Thank you for using Parkealo.",
      messageIcon: Icons.check_circle_outline,
    ),
    RequestCardModel(
      title: "Parking Bella Vista",
      dateTime: "Yesterday · 14:00",
      licensePlate: "B789012",
      statusLabel: "CONFIRMED",
      statusColor: Color(0xFF2E7D32),
      statusBgColor: Color(0xFFE8F5E9),
      approvalLabel: "Automatic",
      approvalColor: Color(0xFF2E7D32),
      approvalBgColor: Color(0xFFE8F5E9),
      message: "Booking confirmed. Check the access information or PIN in the chat.",
      messageIcon: Icons.check_box_outlined,
    ),
    RequestCardModel(
      title: "Parking Colonial Premium",
      dateTime: "May 20 · 10:30",
      licensePlate: "A123456",
      statusLabel: "PENDING",
      statusColor: Color(0xFFFF9800),
      statusBgColor: Color(0xFFFFF3E0),
      approvalLabel: "Approval",
      approvalColor: Color(0xFFFF9800),
      approvalBgColor: Color(0xFFFFF3E0),
      message: "Waiting for approval. You will receive the access information or PIN once confirmed.",
      messageIcon: Icons.access_time_outlined,
    ),
  ];

  final List<RequestCardModel> _requestItems = const [
    RequestCardModel(
      title: "VIP Piantini · Private House",
      dateTime: "Tomorrow · 09:00",
      licensePlate: "B789012",
      statusLabel: "PENDING",
      statusColor: Color(0xFFFF9800),
      statusBgColor: Color(0xFFFFF3E0),
      approvalLabel: "Approval",
      approvalColor: Color(0xFFFF9800),
      approvalBgColor: Color(0xFFFFF3E0),
      message: "Waiting for approval. You will receive the access information or PIN once confirmed.",
      messageIcon: Icons.access_time_outlined,
    ),
    RequestCardModel(
      title: "Parking Bella Vista",
      dateTime: "Tomorrow · 14:00",
      licensePlate: "B789012",
      statusLabel: "CONFIRMED",
      statusColor: Color(0xFF2E7D32),
      statusBgColor: Color(0xFFE8F5E9),
      approvalLabel: "Automatic",
      approvalColor: Color(0xFF2E7D32),
      approvalBgColor: Color(0xFFE8F5E9),
      message: "Booking confirmed. Check the access information or PIN in the chat.",
      messageIcon: Icons.check_box_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Bookings", showBackButton: true),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('Quick'),
                const SizedBox(width: 8),
                _buildFilterChip('Pending'),
              ],
            ),
          ),
          
          // Tabs
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.Primary,
            indicatorWeight: 2,
            labelColor: AppColors.Primary,
            unselectedLabelColor: Colors.grey.shade600,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            tabs: const [
              Tab(text: "Active"),
              Tab(text: "Requests"),
              Tab(text: "History"),
            ],
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveTab(),
                _buildRequestsTab(),
                _buildHistoryTab(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.Primary : Colors.white,
          border: Border.all(color: isSelected ? AppColors.Primary : Colors.grey.shade400, width: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: AppText(
          label,
          fontSize: 12,
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildActiveTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: Colors.green, size: 14),
                  const SizedBox(width: 4),
                  AppText("Automatic", fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.chat_bubble_outline, color: AppColors.Primary, size: 14),
                  const SizedBox(width: 4),
                  AppText("Chat", fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.Primary),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        if (_isCheckedIn)
          ActiveBookingCard(
            onExtend: () {},
            onCheckOut: () => setState(() => _isCheckedIn = false),
          )
        else
          _buildBookingCard(),
      ],
    );
  }

  Widget _buildBookingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // Blue Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF0052AD),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.location_on_outlined, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText("Parking Colonial\nPremium", fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      const SizedBox(height: 6),
                      AppText("Today · 10:30 – 12:30", fontSize: 11, color: Colors.white.withOpacity(0.9)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AppText("Pending check-in", fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Details Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText("License Plate", fontSize: 10, color: Colors.grey.shade500),
                        const SizedBox(height: 4),
                        AppText("A123456", fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppText("Booking", fontSize: 10, color: Colors.grey.shade500),
                        const SizedBox(height: 4),
                        AppText("RD\$150 × 2h", fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.Primary),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Parking Occupied Button
                GestureDetector(
                  onTap: () => _showOccupiedBottomSheet(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7E6),
                      border: Border.all(color: const Color(0xFFFFE4B5)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Color(0xFFB87800), size: 16),
                        const SizedBox(width: 8),
                        AppText("Parking occupied", fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFB87800)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Confirm Reservation Button
                GestureDetector(
                  onTap: () async {
                    final result = await Get.toNamed(AppRoutes.scanningScreen);
                    if (result == true) setState(() => _isCheckedIn = true);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF008CFA), // Using the brighter blue for CTA
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.qr_code_scanner, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        AppText("Scan QR - Check in", fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ],
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

  void _showOccupiedBottomSheet(BuildContext context) {
    int selectedOption = -1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F8F4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7E6),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFFFE4B5)),
                        ),
                        child: const Icon(Icons.access_time, color: Color(0xFFB87800), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText("Active booking in this space", fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            const SizedBox(height: 4),
                            AppText("There is a Parkealo user who arrived earlier", fontSize: 12, color: Colors.grey.shade600),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Time Info Card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7E6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText("Scheduled departure time", fontSize: 12, color: Colors.grey.shade700),
                            AppText("11:45 AM", fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText("Approx. remaining time", fontSize: 12, color: Colors.grey.shade700),
                            AppText("~25 min", fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  AppText("What do you want to do now?", fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                  const SizedBox(height: 16),

                  // Option 1: Wait
                  _buildOptionCard(
                    icon: Icons.access_time,
                    iconColor: const Color(0xFFB87800),
                    iconBgColor: const Color(0xFFFFF7E6),
                    title: "Wait for them to leave",
                    subtitle: "You will receive a notification when the space becomes free (~11:45 AM)",
                    isSelected: selectedOption == 0,
                    onTap: () => setSheetState(() => selectedOption = 0),
                  ),
                  const SizedBox(height: 12),

                  // Option 2: Reassign
                  _buildOptionCard(
                    icon: Icons.swap_horiz,
                    iconColor: AppColors.Primary,
                    iconBgColor: const Color(0xFFE8F4FD),
                    title: "Reassign to another space",
                    subtitle: "We will assign you another available space in this same parking lot",
                    isSelected: selectedOption == 1,
                    onTap: () => setSheetState(() => selectedOption = 1),
                  ),
                  const SizedBox(height: 24),

                  // Bottom Buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: AppText("Cancel", fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: selectedOption == -1
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  // Handle selection
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: selectedOption == -1
                                  ? Colors.grey.shade300
                                  : AppColors.Primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: AppText(
                              selectedOption == 1
                                  ? "Reassign now"
                                  : selectedOption == 0
                                      ? "Confirm — Wait"
                                      : "Select an option",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: selectedOption == -1 ? Colors.grey.shade500 : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRequestsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _requestItems.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: index < _requestItems.length - 1 ? 16 : 0),
        child: RequestCard(
          data: _requestItems[index],
          onMessageHost: () {
            // TODO: open chat with host
          },
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _historyItems.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: index < _historyItems.length - 1 ? 16 : 0),
        child: RequestCard(
          data: _historyItems[index],
          onMessageHost: () {},
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.Primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.Primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(title, fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  const SizedBox(height: 4),
                  AppText(subtitle, fontSize: 11, color: Colors.grey.shade600),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}