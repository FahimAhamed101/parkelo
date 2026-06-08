import 'package:flutter/material.dart';

import '../services/host_publish_flow_service.dart';
import '../widgets/publish_parking_flow.dart';
import 'publish_parking_submitted_page.dart';

class PublishParkingReviewPage extends StatefulWidget {
  const PublishParkingReviewPage({
    super.key,
    this.steps = PublishFlowHeader.defaultSteps,
    this.currentStep = 6,
  });

  final List<String> steps;
  final int currentStep;

  @override
  State<PublishParkingReviewPage> createState() =>
      _PublishParkingReviewPageState();
}

class _PublishParkingReviewPageState extends State<PublishParkingReviewPage> {
  late Future<Map<String, dynamic>> _reviewFuture;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _reviewFuture = HostPublishFlowService.instance.fetchReview();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _reviewFuture,
      builder: (context, snapshot) {
        final parking =
            snapshot.data?['parking'] as Map<String, dynamic>? ??
            HostPublishFlowService.instance.parking ??
            const {};
        final next =
            snapshot.data?['next'] as Map<String, dynamic>? ?? const {};
        final nextItems = (next['items'] as List<dynamic>? ?? const [])
            .cast<String>();

        return PublishFlowScaffold(
          currentStep: widget.currentStep,
          steps: widget.steps,
          stepTitle: widget.currentStep == widget.steps.length - 1
              ? 'Review'
              : widget.steps[widget.currentStep],
          showBackAction: true,
          continueLabel: 'Publish parking',
          continueColor: PublishFlowColors.green,
          onContinue: _submitting ? () {} : _submit,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ParkingSummaryCard(parking: parking),
                const SizedBox(height: 14),
                _NextStepsCard(
                  title: next['title'] as String? ?? 'What happens next?',
                  items: nextItems,
                ),
                if (_submitting) ...[
                  const SizedBox(height: 16),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await HostPublishFlowService.instance.submit();
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PublishParkingSubmittedPage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _ParkingSummaryCard extends StatelessWidget {
  const _ParkingSummaryCard({required this.parking});

  final Map<String, dynamic> parking;

  @override
  Widget build(BuildContext context) {
    final address = _fullAddress(parking);
    final spaces = parking['spaces'] as Map<String, dynamic>? ?? const {};
    final services = (parking['services'] as List<dynamic>? ?? const [])
        .map((item) => item is Map<String, dynamic> ? item['code'] : item)
        .whereType<String>()
        .toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EAF5)),
        boxShadow: [
          BoxShadow(
            color: PublishFlowColors.blue.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const ParkingPSquare(size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parking['name'] as String? ?? 'Parking draft',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: PublishFlowColors.ink,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: PublishFlowColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE2EAF5)),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'Type',
            value:
                ((parking['parkingType'] as String?) ?? 'public') == 'private'
                ? 'Private'
                : 'Public',
            leadingIcon: Icons.location_city_rounded,
          ),
          const _SummaryDivider(),
          _SummaryRow(
            label: 'Sector',
            value:
                parking['sector'] as String? ??
                parking['zone'] as String? ??
                '-',
          ),
          const _SummaryDivider(),
          _SummaryRow(
            label: 'Spaces',
            value:
                '${spaces['total'] ?? 0} spaces - ${spaces['floors'] ?? 1} level${(spaces['floors'] ?? 1) == 1 ? '' : 's'}',
          ),
          const _SummaryDivider(),
          _SummaryRow(
            label: 'Schedule',
            value: services.contains('open_24_7') ? '24 hours' : 'Specific',
          ),
          const _SummaryDivider(),
          _SummaryRow(
            label: 'Contact',
            value:
                (parking['host'] as Map<String, dynamic>?)?['contactPhone']
                    as String? ??
                '-',
          ),
          const _SummaryDivider(),
          _SummaryRow(label: 'Services', value: '${services.length} active'),
        ],
      ),
    );
  }

  String _fullAddress(Map<String, dynamic> parking) {
    final address = parking['address'] as Map<String, dynamic>? ?? const {};
    final parts = [
      address['line1'],
      parking['sector'],
      address['city'],
    ].whereType<String>().where((value) => value.isNotEmpty).toList();
    return parts.isEmpty ? 'Address pending' : parts.join(', ');
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.leadingIcon,
  });

  final String label;
  final String value;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: PublishFlowColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 16, color: PublishFlowColors.blue),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: PublishFlowColors.ink,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: Color(0xFFE8EEF8));
  }
}

class _NextStepsCard extends StatelessWidget {
  const _NextStepsCard({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC7D8F1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: PublishFlowColors.blue,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          for (final item
              in items.isEmpty
                  ? const [
                      'The Parkealo team will review your parking in up to 2 hours.',
                      'After approval, it will appear on the map and users can reserve it.',
                    ]
                  : items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6, right: 8),
                  child: Icon(
                    Icons.circle,
                    size: 6,
                    color: PublishFlowColors.blue,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: PublishFlowColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}
