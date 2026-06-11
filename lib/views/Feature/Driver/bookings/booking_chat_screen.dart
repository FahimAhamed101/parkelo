import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/appColor/app_colors.dart';
import '../../../../utils/appIcons/app_icons.dart';
import '../bottom_nav/bottom_nav.dart';

class BookingChatScreen extends StatefulWidget {
  const BookingChatScreen({super.key});

  @override
  State<BookingChatScreen> createState() => _BookingChatScreenState();
}

class _BookingChatScreenState extends State<BookingChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late final String _parkingName;
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          '¡Hola! Tu reserva está confirmada. El acceso es por la entrada lateral en la Street Las Damas.',
      time: '10:05 AM',
      fromHost: true,
    ),
    const _ChatMessage(
      text: 'Gracias, ¿el parqueo tiene techo?',
      time: '10:07 AM',
      fromHost: false,
    ),
    const _ChatMessage(
      text: 'Sí, toda la planta baja está cubierta. Tu espacio es el A3.',
      time: '10:08 AM',
      fromHost: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    final parkingName = args is Map<String, dynamic>
        ? args['parkingName']?.toString()
        : null;
    _parkingName = parkingName?.isNotEmpty == true
        ? parkingName!
        : 'Parking Colonial Premium';
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF3F6FA),
      body: Column(
        children: [
          _ChatHeader(parkingName: _parkingName),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
              children: [
                Center(
                  child: Text(
                    'Hoy',
                    style: GoogleFonts.nunito(
                      color: AppColors.textFaint,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                for (final message in _messages) _MessageBubble(message: message),
              ],
            ),
          ),
          _Composer(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
      bottomNavigationBar: const _ChatBottomNav(),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        _ChatMessage(text: text, time: _timeNow(), fromHost: false),
      );
      _messageController.clear();
    });
  }

  String _timeNow() {
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');
    final suffix = now.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $suffix';
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.parkingName});

  final String parkingName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1F59C8),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              const SizedBox(width: 17),
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Get.back(),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              const _ChatHostLogo(),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Host · $parkingName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF23D66B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'En línea',
                          style: GoogleFonts.nunito(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isHost = message.fromHost;
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 4,
        left: isHost ? 0 : 54,
        right: isHost ? 56 : 0,
      ),
      child: Column(
        crossAxisAlignment:
            isHost ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                isHost ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (isHost) ...[
                const _SmallHostPin(),
                const SizedBox(width: 9),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  decoration: BoxDecoration(
                    color: isHost ? Colors.white : AppColors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isHost ? 4 : 16),
                      bottomRight: Radius.circular(isHost ? 16 : 4),
                    ),
                    boxShadow: isHost
                        ? [
                            BoxShadow(
                              color: const Color(0xFF19365E)
                                  .withValues(alpha: 0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    message.text,
                    style: GoogleFonts.nunito(
                      color: isHost ? AppColors.text : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.32,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: isHost ? 38 : 0,
              top: 5,
              right: isHost ? 0 : 2,
            ),
            child: Text(
              message.time,
              style: GoogleFonts.nunito(
                color: AppColors.textFaint,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 11, 13, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE1E8F2))),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  style: GoogleFonts.nunito(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    hintStyle: GoogleFonts.nunito(
                      color: AppColors.textSub,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFD),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(23),
                      borderSide: const BorderSide(color: Color(0xFFD5DFEC)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(23),
                      borderSide: const BorderSide(color: Color(0xFFD5DFEC)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(23),
                      borderSide: const BorderSide(color: AppColors.blue),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: onSend,
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF3F9),
                  shape: BoxShape.circle,
                ),
                child: Transform.rotate(
                  angle: -0.65,
                  child: const Icon(
                    Icons.send_rounded,
                    color: Color(0xFF91A5C2),
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBottomNav extends StatelessWidget {
  const _ChatBottomNav();

  @override
  Widget build(BuildContext context) {
    final items = [
      (AppIcons.explore, 'Explore', 0),
      (AppIcons.bookings, 'Bookingtions', 1),
      (AppIcons.favorites, 'Favorites', 2),
      (AppIcons.home, 'Host', 3),
      (AppIcons.account, 'Account', 4),
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: 66,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            for (final item in items)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.offAll(() => BottomNavScreen(initialIndex: item.$3)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: item.$3 == 1
                              ? AppColors.blue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          item.$1,
                          width: 18,
                          height: 18,
                          colorFilter: ColorFilter.mode(
                            item.$3 == 1 ? Colors.white : AppColors.blue,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          color: item.$3 == 1
                              ? AppColors.blue
                              : AppColors.textFaint,
                          fontSize: 8,
                          fontWeight:
                              item.$3 == 1 ? FontWeight.w900 : FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: item.$3 == 1 ? 18 : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient:
                              item.$3 == 1 ? AppColors.gradGreenBar : null,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Get.offAll(() => const BottomNavScreen(initialIndex: 5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.settings_outlined,
                      color: AppColors.blue,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Admin',
                      style: GoogleFonts.nunito(
                        color: AppColors.textFaint,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatHostLogo extends StatelessWidget {
  const _ChatHostLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        shape: BoxShape.circle,
      ),
      child: const _SmallHostPin(size: 30),
    );
  }
}

class _SmallHostPin extends StatelessWidget {
  const _SmallHostPin({this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.location_on_rounded,
            color: AppColors.blueSky,
            size: size,
          ),
          Positioned(
            top: size * 0.18,
            child: Text(
              'P',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: size * 0.38,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.time,
    required this.fromHost,
  });

  final String text;
  final String time;
  final bool fromHost;
}
