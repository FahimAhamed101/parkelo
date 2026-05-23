import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../../base/AppText/appText.dart';
import '../../../base/CustomAppbar/custom_appbar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<_NotifItem> _items = [
    _NotifItem(
      imageUrl: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&auto=format&fit=crop",
      title: "New message from Tamim",
      body: "Hey, I loved your recent works about The Serves ..",
      time: "1 day ago",
    ),
    _NotifItem(
      imageUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&auto=format&fit=crop",
      title: "New message from Sarah Chen",
      body: "Hey, I loved your recent works about The Serves ..",
      time: "2 day ago",
    ),
    _NotifItem(
      imageUrl: "https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=100&auto=format&fit=crop",
      title: "New message from Sarah Chen",
      body: "Hey, I loved your recent works about The Serves ..",
      time: "3 day ago",
    ),
    _NotifItem(
      imageUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&auto=format&fit=crop",
      title: "New message from Sarah Chen",
      body: "Hey, I loved your recent works about The Serves ..",
      time: "4 day ago",
    ),
  ];

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset("assets/icons/deleteIcon.svg", width: 28, height: 28),
              const SizedBox(height: 12),
              AppText(
                "Delete Notification",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF202020),
              ),
              const SizedBox(height: 8),
              AppText(
                "Are you sure to delete this notification?",
                fontSize: 12,
                color: const Color(0xFF494949),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey, width: 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: AppText("Cancel", fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.Primary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() => _items.removeAt(index));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: AppText("Delete", fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(title: "Notification", showBackButton: true),
      body: _items.isEmpty
          ? Center(
              child: AppText("No notifications", fontSize: 14, color: Colors.grey.shade500),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _items[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(item.imageUrl),
                      ),
                      const SizedBox(width: 12),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(item.title, fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                            const SizedBox(height: 4),
                            AppText(item.body, fontSize: 12, color: Colors.grey.shade600),
                            const SizedBox(height: 6),
                            AppText(item.time, fontSize: 11, color: Colors.grey.shade400),
                          ],
                        ),
                      ),

                      // Three-dot menu
                      GestureDetector(
                        onTap: () => _showDeleteDialog(context, index),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.more_vert, color: Colors.grey, size: 20),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _NotifItem {
  final String imageUrl;
  final String title;
  final String body;
  final String time;

  const _NotifItem({
    required this.imageUrl,
    required this.title,
    required this.body,
    required this.time,
  });
}
