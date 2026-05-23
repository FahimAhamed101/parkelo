import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _primaryBlue = Color(0xFF1556B7);
const _pageBg = Color(0xFFEFF7FF);
const _ink = Color(0xFF0F172A);
const _muted = Color(0xFF6B7280);
const _danger = Color(0xFFE11D48);
const _success = Color(0xFF16A34A);

class ManualRequestsPage extends StatelessWidget {
  const ManualRequestsPage({super.key});

  static const _requests = [
    _ManualRequest(
      message: 'A driver has requested to\nreserve a parking space.',
      time: '1 Minute ago',
      avatarColors: [Color(0xFFE2F1F7), Color(0xFFD7A38D)],
    ),
    _ManualRequest(
      message: 'A driver has requested to\nreserve a parking space.',
      time: '1 day ago',
    ),
    _ManualRequest(
      message: 'A driver has requested to\nreserve a parking space.',
      time: '1 day ago',
    ),
    _ManualRequest(
      message: 'A driver has requested to\nreserve a parking space.',
      time: '1 day ago',
      avatarColors: [Color(0xFF0F4C81), Color(0xFFF04D2A)],
    ),
  ];

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
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                itemCount: _requests.length,
                separatorBuilder: (context, index) => const SizedBox(height: 9),
                itemBuilder: (context, index) {
                  return _ManualRequestCard(request: _requests[index]);
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
                    'Manual',
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

  final _ManualRequest request;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 74),
      padding: const EdgeInsets.fromLTRB(8, 10, 7, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
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
          _AvatarSlot(colors: request.avatarColors),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 11,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  request.time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 9.5),
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
                onTap: () {},
              ),
              const SizedBox(width: 1),
              _ActionIcon(
                icon: Icons.check_rounded,
                color: _success,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarSlot extends StatelessWidget {
  const _AvatarSlot({required this.colors});

  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    if (colors == null) {
      return const SizedBox(width: 24, height: 24);
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors!,
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

class _ManualRequest {
  const _ManualRequest({
    required this.message,
    required this.time,
    this.avatarColors,
  });

  final String message;
  final String time;
  final List<Color>? avatarColors;
}
