import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/appColor/app_colors.dart';
import '../../../base/AppText/appText.dart';
import '../../../base/CustomTextfield/CustomTextfield.dart';
import 'widgets/custom_pariking_list_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  final TextEditingController searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ["Private", "Camera", "Covered", "Person"];
  
  final List<Map<String, dynamic>> dummyParkingList = [
    {
      "imageUrl": "https://images.unsplash.com/photo-1590674899484-d5640e854abe?q=80&w=600&auto=format&fit=crop",
      "title": "Parking Colonial Premium",
      "subtitle": "Colonial Zone, SD · 0.2 km",
      "rating": "4.00",
      "reviews": "(120)",
      "price": "RD\$150",
      "tags": <String>[],
    },
    {
      "imageUrl": "https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?q=80&w=600&auto=format&fit=crop",
      "title": "VIP Piantini- Private House",
      "subtitle": "Colonial Zone, SD · 0.2 km",
      "rating": "4.00",
      "reviews": "(120)",
      "price": "RD\$150",
      "tags": ["Metro L1-200m", "OMSA-50m"],
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildCategories(),
                  const SizedBox(height: 20),
                  _buildMapSection(),
                  const SizedBox(height: 12),
                  _buildNearbyParkingHeader(),
                  _buildParkingList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF0F3377),
            Color(0xFF174FB5),
          ],
          stops: [-0.0157, 1.0118],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(
                    "https://as2.ftcdn.net/jpg/04/31/64/75/1000_F_431647519_usrbQ8Z983hTYe8zgA7t1XVc5fEtqcpa.webp"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      "Welcome Back",
                      fontSize: 12,
                      color: AppColors.bgPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      "Rokey Mahmud",
                      fontSize: 16,
                      color: AppColors.bgPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){},
                child: SvgPicture.asset(
                  "assets/icons/notification.svg",
                  width: 38,
                  height: 38,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          CustomTextField(
            hintText: 'Where to park?',
            controller: searchController,
            filColor: AppColors.bgPrimary,
            borderColor: AppColors.bgPrimary,
            borderRadius: 30,
            contentPaddingVertical: 12,
            prefixIcon: "assets/icons/searchIcon.svg",
            suffixIcon: "assets/icons/filterIcon.svg",
          ),

        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(_categories.length, (index) {
          return Padding(
            padding: EdgeInsets.only(right: index == _categories.length - 1 ? 0 : 14),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              child: _buildCategoryChip(_categories[index], _selectedCategoryIndex == index),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryChip(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.DarkBlue : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.DarkBlue, width: 0.5),
      ),
      child: AppText(
        text,
        color: isSelected ? AppColors.textColor : Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E9EC),
        borderRadius: BorderRadius.circular(16),
        // A dummy map background pattern can be used here if needed
      ),
      child: Stack(
        children: [
          // Background placeholder grid lines to make it look like a map
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
          ),
          // My car marker
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_car,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText("My car",
                          color: Colors.grey.shade400, fontSize: 10),
                      AppText("C67821",
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ],
                  )
                ],
              ),
            ),
          ),
          // Target icon
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.my_location,
                  size: 20, color: Colors.black87),
            ),
          ),
          // Red marker ($8)
          Positioned(
            top: 60,
            left: 150,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.directions_car,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      AppText("\$8",
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                ),
                // Arrow down triangle
                CustomPaint(
                  size: const Size(10, 8),
                  painter: TrianglePainter(color: Colors.red),
                ),
              ],
            ),
          ),
          // Dark Blue marker ($8)
          Positioned(
            bottom: 80,
            right: 80,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppText("\$8",
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                CustomPaint(
                  size: const Size(10, 8),
                  painter: TrianglePainter(color: const Color(0xFF0F172A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyParkingHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF0F3377),
            Color(0xFF174FB5),
          ],
          stops: [-0.0157, 1.0118],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            "Nearby Parking",
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          Row(
            children: [
              AppText("Sort", color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              const SizedBox(width: 4),
              const Icon(Icons.unfold_more, color: Colors.white, size: 16),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildParkingList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dummyParkingList.length,
      itemBuilder: (context, index) {
        final data = dummyParkingList[index];
        return CustomParkingListCard(
          imageUrl: data["imageUrl"],
          title: data["title"],
          subtitle: data["subtitle"],
          rating: data["rating"],
          reviews: data["reviews"],
          price: data["price"],
          tags: data["tags"],
        );
      },
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color;
    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
    
    // Draw some thicker "roads"
    var roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6;
      
    canvas.drawLine(Offset(0, 100), Offset(size.width, 100), roadPaint);
    canvas.drawLine(Offset(120, 0), Offset(120, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
