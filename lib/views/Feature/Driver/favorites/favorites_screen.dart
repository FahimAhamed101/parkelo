import 'package:flutter/material.dart';
import '../../../base/CustomAppbar/custom_appbar.dart';
import '../../../base/AppText/appText.dart';
import '../explore/widgets/custom_pariking_list_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Using a list to hold favorites. Change to an empty list [] to see the empty state.
  List<Map<String, dynamic>> favorites = [
    {
      "imageUrl": "https://images.unsplash.com/photo-1590674899484-d5640e854abe?q=80&w=600&auto=format&fit=crop",
      "title": "Parking Colonial Premium",
      "subtitle": "Colonial Zone, SD · 0.2 km",
      "rating": "4.00",
      "reviews": "(120)",
      "price": "RD\$150",
      "tags": ["Metro L1-200m", "OMSA-50m"],
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?q=80&w=600&auto=format&fit=crop",
      "title": "VIP Piantini- Private House",
      "subtitle": "Colonial Zone, SD · 0.2 km",
      "rating": "4.00",
      "reviews": "(120)",
      "price": "RD\$150",
      "tags": ["Metro L1-200m", "OMSA-50m"],
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      appBar: const CustomAppBar(
        title: "Favorites",
        showBackButton: true,
      ),
      body: favorites.isEmpty ? _buildEmptyState() : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, color: Color(0xFFE91E63), size: 48), // Pink heart
            const SizedBox(height: 24),
            AppText(
              "You don't have any favorites yet",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF002B5E), // Dark blue text matching the design
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            AppText(
              "Press the heart on any parking spot\nto save it here.",
              fontSize: 14,
              color: Colors.grey.shade500,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final item = favorites[index];
        return CustomParkingListCard(
          imageUrl: item['imageUrl'],
          title: item['title'],
          subtitle: item['subtitle'],
          rating: item['rating'],
          reviews: item['reviews'],
          price: item['price'],
          tags: List<String>.from(item['tags']),
          showFavoriteIcon: false,
        );
      },
    );
  }
}