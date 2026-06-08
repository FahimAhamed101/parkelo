import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/host_api_client.dart';

const _primaryBlue = Color(0xFF1556B7);
const _pageBg = Color(0xFFEFF7FF);
const _ink = Color(0xFF111827);
const _muted = Color(0xFF6B7280);
const _danger = Color(0xFFE11D48);
const _success = Color(0xFF16A34A);

class ManualRequestsPage extends StatefulWidget {
  const ManualRequestsPage({super.key});

  @override
  State<ManualRequestsPage> createState() => _ManualRequestsPageState();
}

class _ManualRequestsPageState extends State<ManualRequestsPage> {
  late Future<Map<String, dynamic>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = HostApiClient.instance.fetchManualRequests();
  }

  Future<void> _reloadRequests() async {
    setState(() {
      _requestsFuture = HostApiClient.instance.fetchManualRequests();
    });
    await _requestsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _primaryBlue,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: _pageBg,
      ),
      child: Scaffold(
        backgroundColor: _pageBg,
        body: Column(
          children: [
            _ManualHeader(onBack: () => Navigator.maybePop(context)),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _requestsFuture,
                builder: (context, snapshot) {
                  final requests =
                      (snapshot.data?['requests'] as List<dynamic>? ?? const [])
                          .map((item) => item as Map<String, dynamic>)
                          .toList();

                  if (snapshot.connectionState == ConnectionState.waiting &&
                      requests.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return RefreshIndicator(
                    onRefresh: _reloadRequests,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                      itemCount: requests.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 9),
                      itemBuilder: (context, index) {
                        return _ManualRequestCard(request: requests[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualHeader extends StatelessWidget {
  const _ManualHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 6, 2, 18),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 44,
                    height: 40,
                  ),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Manual requests',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ManualRequestCard extends StatelessWidget {
  const _ManualRequestCard({required this.request});

  final Map<String, dynamic> request;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 74),
      padding: const EdgeInsets.fromLTRB(8, 10, 7, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AvatarSlot(),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request['message'] as String? ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    color: _ink,
                    fontSize: 11.5,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  request['time'] as String? ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(color: _muted, fontSize: 9.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionIcon(
                icon: Icons.close_rounded,
                color: _danger,
                onTap: () => _handleAction(
                  context,
                  () => HostApiClient.instance.declineRequest(
                    request['bookingId'] as String? ?? request['id'] as String,
                  ),
                ),
              ),
              const SizedBox(width: 1),
              _ActionIcon(
                icon: Icons.check_rounded,
                color: _success,
                onTap: () => _handleAction(
                  context,
                  () => HostApiClient.instance.approveRequest(
                    request['bookingId'] as String? ?? request['id'] as String,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleAction(
    BuildContext context,
    Future<Map<String, dynamic>> Function() action,
  ) async {
    await action();
    if (!context.mounted) return;
    (context.findAncestorStateOfType<_ManualRequestsPageState>())
        ?._reloadRequests();
  }
}

class _AvatarSlot extends StatelessWidget {
  const _AvatarSlot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFE2F1F7), Color(0xFFD7A38D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: const Icon(Icons.person_rounded, color: Colors.white, size: 15),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 14,
      child: SizedBox(
        width: 17,
        height: 24,
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}
