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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart'; // New Import
import 'dart:io';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class HttpClientFactory {
    static http.Client createClient() {
        if (kDebugMode) {
            final HttpClient ioc = HttpClient();
            // Ignore certificate errors for self-signed development certificates
            ioc.badCertificateCallback = 
                (X509Certificate cert, String host, int port) => true;
            return IOClient(ioc);
        }
        return http.Client();
    }
}
// Updated main function
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
 
 
  
  runApp(const PrefectureApp());
}
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

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
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
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 20,
      ),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 30),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 2.5,
        ).chain(CurveTween(curve: Curves.easeInCirc)),
        weight: 20,
      ),
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
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
                child: Image.asset(
                  "assets/images/4727_Logo_copy.png",
                  width: 220,
                ),
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
      case 0:
        return "   Experiences & Highlights";
      case 1:
        return "   Prefectures";
      case 2:
        return "   Partners";
      case 3:
        return "   Journey Tracker";
      case 4:
        return "   Rewards";
      case 5:
        return "   Profile";
      default:
        return "";
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
      title: Stack(
  alignment: Alignment.center,
  children: [
    // The Logo aligned to the left
    Align(
      alignment: Alignment.centerLeft,
      child: Image.asset(
        'assets/images/4727_Logo_V2.png',
        height: 35,
        fit: BoxFit.contain,
      ),
    ).pOnly(left: 4),
    
    // The Text perfectly in the center
    _getAppBarTitle().text.color(gold).semiBold.lg.make(),
  ],
),
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
        items: [
          BottomNavigationBarItem(
            // Replacing the auto_awesome icon with your custom logo
            icon: Image.asset(
              'assets/images/sunburst.png', // Or use your specific logo path
              height: 28, // Standard size for bottom bar icons
              fit: BoxFit.contain,
              color: _currentIndex == 0 ? null : Colors.white24, //
            ),
            // Optional: Add a 'activeIcon' to show a different version when selected
            activeIcon: Image.asset(
              'assets/images/sunburst.png',
              height: 28,
              color: gold, // This will tint the logo to your gold theme color
            ),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Explore",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: "Sponsors",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Reports",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: "Rewards",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
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
    {
      "name": "Hokkaido",
      "region": "Hokkaido",
      "img":
          "https://images.pexels.com/photos/5195410/pexels-photo-5195410.jpeg",
      "jp": "北海道",
      "status": "active",
    },
    {
      "name": "Tokyo",
      "region": "Kantō",
      "img": "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf",
      "jp": "東京都",
      "status": "active",
    },
    {
      "name": "Chiba",
      "region": "Kantō",
      "img":
          "https://images.pexels.com/photos/31461527/pexels-photo-31461527.jpeg",
      "jp": "千葉県",
      "status": "active",
    },
    {
      "name": "Aomori",
      "region": "Tohoku",
      "img":
          "https://images.pexels.com/photos/5195410/pexels-photo-5195410.jpeg",
      "jp": "青森県",
      "status": "coming_soon",
    },
  ];

  // Infinite loop constant
  final int _infinitePageCount = 10000;

  @override
  void initState() {
    super.initState();
    // Start the controller in the middle of the large number so the user can swipe left immediately
    int initialPage =
        (_infinitePageCount ~/ 2) -
        ((_infinitePageCount ~/ 2) % _activePrefectures.length);
    _pageController = PageController(initialPage: initialPage);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = null;
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
          // 2. Wrap PageView with NotificationListener
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              // Check if the scroll started because of a user touch (drag)
              if (notification is ScrollStartNotification ) {
                _stopAutoSlide(); // Kill the timer permanently
              }
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              itemCount: _infinitePageCount,
              physics: const BouncingScrollPhysics(),
              // 3. REMOVE the restart logic from here to keep it stopped
              onPageChanged: (_) {},
              itemBuilder: (context, index) {
                final actualIndex = index % _activePrefectures.length;
                return PrefectureDetail(
                  data: _activePrefectures[actualIndex],
                  isStandalone: true,
                );
              },
            ),
          ),

          // LEFT ARROW (Visible with background)
          Align(
            alignment: Alignment.centerLeft,
            child: _buildNavButton(
              icon: Icons.arrow_back_ios_new,
              isLeft: true,
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
              isLeft: false,
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

  Widget _buildNavButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isLeft,
  }) {
    return GestureDetector(
      onTap: () {
        _stopAutoSlide(); // Also stop auto-slide if buttons are clicked
        onPressed();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 100,
        width: 60,
        // Adding a very light gradient so the arrow sits on a "hint" of a shadow
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
            colors: [Colors.black.withOpacity(0.3), Colors.transparent],
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(0.35), // Much subtler opacity
          size: 30, // Slightly smaller and more elegant
        ).centered(),
      ),
    );
  }
}
