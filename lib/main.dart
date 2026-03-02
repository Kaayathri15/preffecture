import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:preffecture/prefecture_detail.dart';
import 'package:preffecture/sponsors_page.dart';
import 'package:preffecture/report_page.dart';
import 'package:preffecture/profile_page.dart';
import 'package:preffecture/PrefectureRegionPage.dart';
import 'package:preffecture/reward_page.dart';
import 'package:preffecture/auth_page.dart';
import 'dart:async';

void main() => runApp(const PrefectureApp());

class PrefectureApp extends StatelessWidget {
  const PrefectureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE50914),
          primary: const Color(0xFFE50914),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// --- 1. ANIMATED SPLASH SCREEN ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;
  late Animation<double> _rotate;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2).chain(CurveTween(curve: Curves.elasticOut)), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 2.5).chain(CurveTween(curve: Curves.easeInCirc)), weight: 20),
    ]).animate(_controller);

    _fade = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);

    _rotate = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.1), weight: 5),
      TweenSequenceItem(tween: Tween(begin: 0.1, end: -0.1), weight: 5),
      TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.0), weight: 5),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 45),
    ]).animate(_controller);

    _slide = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -30.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: -30.0, end: 0.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 20),
    ]).animate(_controller);

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthPage()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _slide.value),
          child: Transform.rotate(
            angle: _rotate.value,
            child: Transform.scale(
              scale: _scale.value,
              child: Opacity(
                opacity: _fade.value,
                child: Image.asset("assets/images/4727_Logo_copy.png", width: 220),
              ),
            ),
          ),
        ).centered(),
      ),
    );
  }
}

// --- 2. MAIN WRAPPER ---
class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  final Color gold = const Color(0xFFC5A059);
  final Color red = const Color(0xFFE50914);

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0: return "Experiences & Highlights";
      case 1: return "Prefectures";
      case 2: return "Partners";
      case 3: return "Journey Tracker";
      case 4: return "Rewards";
      case 5: return "Profile";
      default: return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const PrefectureHome(),
      PrefectureRegionPage(key: ValueKey('region_page_$_currentIndex')),
      const SponsorsPage(),
      const ReportPage(),
      const RewardsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        title: HStack([
          "47で27".text.color(red).bold.xl3.make(),
          20.widthBox,
          _getAppBarTitle().text.color(gold).semiBold.lg.make(),
        ]).pOnly(left: 4),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: gold.withOpacity(0.5), height: 1),
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: gold,
        unselectedItemColor: Colors.white24,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.handshake), label: "Sponsors"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Rewards"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// --- 3. HOME PAGE (FULL DETAIL SLIDER) ---
class PrefectureHome extends StatefulWidget {
  const PrefectureHome({super.key});

  @override
  State<PrefectureHome> createState() => _PrefectureHomeState();
}

class _PrefectureHomeState extends State<PrefectureHome> {
  final Color gold = const Color(0xFFC5A059);
  late PageController _pageController;
  Timer? _autoSlideTimer;

  // Actual Data
  final List<Map<String, dynamic>> _activePrefectures = [
    {"name": "Hokkaido", "region": "Hokkaido", "img": "https://images.pexels.com/photos/5195410/pexels-photo-5195410.jpeg", "jp": "北海道", "status": "active"},
    {"name": "Tokyo", "region": "Kantō", "img": "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf", "jp": "東京都", "status": "active"},
    {"name": "Chiba", "region": "Kantō", "img": "https://images.pexels.com/photos/31461527/pexels-photo-31461527.jpeg", "jp": "千葉県", "status": "active"},
    {"name": "Hokkaido", "region": "Hokkaido", "img": "https://images.pexels.com/photos/5195410/pexels-photo-5195410.jpeg", "jp": "北海道", "status": "soon"},

  ];

  // Infinite loop constant
  final int _infinitePageCount = 10000;

  @override
  void initState() {
    super.initState();
    // Start the controller in the middle of the large number so the user can swipe left immediately
    int initialPage = (_infinitePageCount ~/ 2) - ((_infinitePageCount ~/ 2) % _activePrefectures.length);
    _pageController = PageController(initialPage: initialPage);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutQuart, // Smooth book-like transition
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _infinitePageCount,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (_) {
              // Reset timer on manual swipe to prevent double-sliding
              _autoSlideTimer?.cancel();
              _startAutoSlide();
            },
            itemBuilder: (context, index) {
              // Calculate actual data index using modulo
              final actualIndex = index % _activePrefectures.length;
              return PrefectureDetail(
                data: _activePrefectures[actualIndex],
                isStandalone: true,
              );
            },
          ),
          
          // LEFT ARROW (Visible with background)
          Align(
            alignment: Alignment.centerLeft,
            child: _buildNavButton(
              icon: Icons.arrow_back_ios_new,
              onPressed: () => _pageController.previousPage(
                duration: 800.milliseconds,
                curve: Curves.easeInOutQuart,
              ),
            ),
          ),

          // RIGHT ARROW (Visible with background)
          Align(
            alignment: Alignment.centerRight,
            child: _buildNavButton(
              icon: Icons.arrow_forward_ios,
              onPressed: () => _pageController.nextPage(
                duration: 800.milliseconds,
                curve: Curves.easeInOutQuart,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // // Helper for visible navigation buttons
  // Widget _buildNavButton({required IconData icon, required VoidCallback onPressed}) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.black.withOpacity(0.4), // Dark background to make arrow visible
  //       shape: BoxShape.circle,
  //       border: Border.all(color: gold.withOpacity(0.5), width: 1),
  //     ),
  //     child: IconButton(
  //       icon: Icon(icon, color: Colors.white, size: 28),
  //       onPressed: onPressed,
  //     ),
  //   );
  // }

  Widget _buildNavButton({required IconData icon, required VoidCallback onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    // HitTestBehavior.opaque ensures the transparent area around the arrow is still clickable
    behavior: HitTestBehavior.opaque, 
    child: SizedBox(
      height: double.infinity, // Maintains a full-height vertical touch zone
      width: 80,               // Provides a generous horizontal touch area
      child: Icon(
        icon,
        color: Colors.white.withOpacity(0.9), // Bright white as seen in your screenshot
        size: 45,                             // Increased size for better visibility
      ).centered(),
    ),
  );
}
}