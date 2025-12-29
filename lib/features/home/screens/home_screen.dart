import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/components/navigation/floating_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<NavItem> _navItems = const [
    NavItem(icon: LucideIcons.home, label: 'Home'),
    NavItem(icon: LucideIcons.search, label: 'Explore'),
    NavItem(icon: LucideIcons.shoppingBag, label: 'Shop'),
    NavItem(icon: LucideIcons.heart, label: 'Saved'),
    NavItem(icon: LucideIcons.user, label: 'Profile'),
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildHomeContent(),
              _buildExploreContent(),
              _buildShopContent(),
              _buildSavedContent(),
              _buildProfileContent(),
            ],
          ),

          FloatingNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavTap,
            items: _navItems,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          floating: true,
          title: Text(
            "DripLord",
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              fontSize: 24,
              letterSpacing: 2,
            ),
          ),
          actions: [
            IconButton(icon: const Icon(LucideIcons.bell), onPressed: () {}),
            IconButton(icon: const Icon(LucideIcons.search), onPressed: () {}),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  "Shop by brand category",
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildBrandTab("ZARA", true),
                      _buildBrandTab("VOGUE", false),
                      _buildBrandTab("CHANEL", false),
                      _buildBrandTab("RALPH LAUREN", false),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // VOGUE Hero style from Image 2
                Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    image: const DecorationImage(
                      image: NetworkImage("https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=1000&auto=format&fit=crop"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 30,
                        right: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "VOGUE",
                              style: GoogleFonts.outfit(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 4,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(LucideIcons.star, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text("4.8 (57K+ reviews)", style: GoogleFonts.outfit(color: Colors.white70)),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  child: const Text("Visit store"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().scale(),
                
                const SizedBox(height: 32),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Our products", style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("See all", style: GoogleFonts.outfit(color: Colors.white54)),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return _buildProductCard(
                      ["Women's bagged pant", "Women's sweater", "Women's sweat shirt", "Women's baggy pant"][index],
                      "€ 790.00",
                    );
                  },
                ),
                
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandTab(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          color: isSelected ? Colors.white : Colors.white38,
        ),
      ),
    );
  }

  Widget _buildProductCard(String title, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.luxuryGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              image: const DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1434389677669-e08b4cac3105?q=80&w=500&auto=format&fit=crop"),
                fit: BoxFit.cover,
              ),
            ),
            child: const Stack(
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 16,
                    child: Icon(LucideIcons.heart, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          price,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildExploreContent() => const Center(child: Text("Explore Content Updated to Luxury Vibe"));
  Widget _buildShopContent() => const Center(child: Text("Shop Content Updated to Luxury Vibe"));
  Widget _buildSavedContent() => const Center(child: Text("Saved Content Updated to Luxury Vibe"));
  
  Widget _buildProfileContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white10,
              child: Icon(LucideIcons.user, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text("Kobby", style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold)),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                if (mounted) Navigator.pushReplacementNamed(context, '/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: 0.1), 
                foregroundColor: Colors.red
              ),
              child: const Text("Sign Out"),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
