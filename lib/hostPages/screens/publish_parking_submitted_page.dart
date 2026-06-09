import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../services/host_publish_flow_service.dart';
import '../widgets/host_bottom_nav.dart';
import '../widgets/publish_parking_flow.dart';

class PublishParkingSubmittedPage extends StatelessWidget {
  const PublishParkingSubmittedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notice = HostPublishFlowService.instance.submitNotice ?? const {};
    final parking = HostPublishFlowService.instance.parking ?? const {};
    final reviewHours = notice['estimatedReviewHours'] ?? 2;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(30, 28, 30, 34),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _SuccessIcon(),
                      const SizedBox(height: 29),
                      Text(
                        notice['title'] as String? ?? 'Request submitted!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: PublishFlowColors.ink,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        notice['message'] as String? ??
                            '${parking['name'] ?? 'Your parking'} is being reviewed by the Parkealo team.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: PublishFlowColors.muted,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _ReviewNotice(reviewHours: reviewHours),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 49,
                        child: ElevatedButton(
                          onPressed: () => _goToHost(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PublishFlowColors.green,
                            foregroundColor: Colors.white,
                            elevation: 10,
                            shadowColor: PublishFlowColors.green.withValues(
                              alpha: 0.25,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          child: Text(
                            notice['actionLabel'] as String? ??
                                'Go to admin panel',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const _QrNotice(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: const PublishFlowBottomNav(),
      ),
    );
  }

  void _goToHost(BuildContext context) {
    HostPublishFlowService.instance.unlockPanel();
    Get.offAll(() => const HostBottomNavScreen(initialIndex: 0));
  }
}

class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: PublishFlowColors.greenSoft,
        shape: BoxShape.circle,
        border: Border.all(color: PublishFlowColors.green, width: 3),
      ),
      child: const Icon(
        Icons.check_rounded,
        color: PublishFlowColors.green,
        size: 43,
      ),
    );
  }
}

class _ReviewNotice extends StatelessWidget {
  const _ReviewNotice({required this.reviewHours});

  final Object reviewHours;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E6),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFF0D080)),
      ),
      child: Text(
        'Under review - It will be visible on the map in about $reviewHours hours',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF8A6200),
          fontSize: 12,
          fontWeight: FontWeight.w900,
          height: 1.3,
        ),
      ),
    );
  }
}

class _QrNotice extends StatelessWidget {
  const _QrNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: PublishFlowColors.greenSoft,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFA8DDBF)),
      ),
      child: const Text(
        'In the panel you will find the QR code for your parking to print',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: PublishFlowColors.green,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          height: 1.3,
        ),
      ),
    );
  }
}
