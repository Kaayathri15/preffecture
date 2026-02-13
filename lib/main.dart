import 'package:flutter/material.dart';
import 'package:preffecture/prefecture_detail.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:preffecture/sponsors_page.dart'; // Change 'preffecture' to your project name
import 'package:preffecture/report_page.dart';
import 'package:preffecture/profile_page.dart';
import 'package:preffecture/PrefectureRegionPage.dart';
import 'package:preffecture/reward_page.dart';

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
          MaterialPageRoute(builder: (context) => const MainWrapper()),
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

// --- 2. MAIN WRAPPER (Handles Navigation State) ---

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  final Color gold = const Color(0xFFC5A059);
  final Color red = const Color(0xFFE50914);

  Map<String, dynamic>? _selectedPrefecture;

  @override
  Widget build(BuildContext context) {
    // 1. Logic for Home Tab (Prefecture List vs Detail)
    Widget homeTabContent = _selectedPrefecture == null
        ? PrefectureHome(
            onSelect: (data) => setState(() => _selectedPrefecture = data),
          )
        : PrefectureDetail(
            data: _selectedPrefecture!,
            onBack: () => setState(() => _selectedPrefecture = null),
          );

    // 2. The List of Pages
    final List<Widget> _pages = [
      homeTabContent,
PrefectureRegionPage(key: ValueKey('region_page_$_currentIndex')),
      const SponsorsPage(),
      const ReportPage(),
      const RewardsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      // --- PERSISTENT LOGO TOP BAR ---
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        title: HStack([
          "47で27".text.color(red).bold.xl3.make(),
          20.widthBox,
          "The Golden Journey".text.color(gold).semiBold.lg.make(),
        ]).pOnly(left: 4),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: gold.withOpacity(0.5), height: 1),
        ),
      ),

      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // Optional: Reset detail view if user clicks Home tab icon
            if (index == 0) _selectedPrefecture = null;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: gold,
        unselectedItemColor: Colors.white24,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Preffectures"),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.campaign),
          //   label: "Promotion",
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: "Sponsors",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Report",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: "Reward",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// --- 3. HOME PAGE (CONTENT ONLY) ---
class PrefectureHome extends StatefulWidget {
  final Function(Map<String, dynamic>) onSelect;
  const PrefectureHome({super.key, required this.onSelect});

  @override
  State<PrefectureHome> createState() => _PrefectureHomeState();
}

class _PrefectureHomeState extends State<PrefectureHome> {
  final Color gold = const Color(0xFFC5A059);
  final Color red = const Color(0xFFE50914);
  String _selectedStatus = "All";

  final List<Map<String, dynamic>> _allPrefectures = [
    {"name": "Hokkaido", "region": "Hokkaido", "img": "https://images.pexels.com/photos/5195410/pexels-photo-5195410.jpeg", "jp": "北海道", "status": "active"},
    {"name": "Aomori", "region": "Tōhoku", "img": "https://images.unsplash.com/photo-1545569341-9eb8b30979d9", "jp": "青森県", "status": "active"},
    {"name": "Yamagata", "region": "Tōhoku", "img": "https://images.pexels.com/photos/10232969/pexels-photo-10232969.jpeg", "jp": "山形県", "status": "coming_soon"},
    {"name": "Iwate", "region": "Tōhoku", "img": "https://images.pexels.com/photos/12156225/pexels-photo-12156225.jpeg", "jp": "岩手県", "status": "coming_soon"},
    {"name": "Akita", "region": "Tōhoku", "img": "https://images.pexels.com/photos/31365953/pexels-photo-31365953.jpeg", "jp": "秋田県", "status": "past"},
    {"name": "Miyagi", "region": "Tōhoku", "img": "https://images.pexels.com/photos/17052297/pexels-photo-17052297.jpeg", "jp": "宮城県", "status": "past"},
    {"name": "Fukushima", "region": "Tōhoku", "img": "https://images.pexels.com/photos/13841247/pexels-photo-13841247.jpeg", "jp": "福島県", "status": "past"},
    {"name": "Tokyo", "region": "Kantō", "img": "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf", "jp": "東京都", "status": "active"},
    {"name": "Chiba", "region": "Kantō", "img": "https://images.pexels.com/photos/31461527/pexels-photo-31461527.jpeg", "jp": "千葉県", "status": "active"},
    {"name": "Kanagawa", "region": "Kantō", "img": "https://images.pexels.com/photos/8536359/pexels-photo-8536359.jpeg", "jp": "神奈川県", "status": "coming_soon"},
    {"name": "Saitama", "region": "Kantō", "img": "https://images.pexels.com/photos/20547197/pexels-photo-20547197.jpeg", "jp": "埼玉県", "status": "coming_soon"},
    {"name": "Ibaraki", "region": "Kantō", "img": "https://images.pexels.com/photos/34885502/pexels-photo-34885502.jpeg", "jp": "茨城県", "status": "past"},
    {"name": "Tochigi", "region": "Kantō", "img": "https://images.unsplash.com/photo-1622383563227-04401ab4e5ea", "jp": "栃木県", "status": "past"},
  ];

  List<Map<String, dynamic>> _displayList = [];

  @override
  void initState() {
    super.initState();
    _displayList = List.from(_allPrefectures);
  }

  void _applyFilters() {
    setState(() {
      _displayList = _allPrefectures.where((p) {
        return _selectedStatus == "All" || p["status"] == _selectedStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: VStack([
        // 1. Banner Carousel
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
          ),
          items: [1, 2, 3].map((i) => _buildBannerCard(i)).toList(),
        ).pOnly(top: 10, bottom: 20),

        // 2. Status Filters (Centered horizontally)
        HStack([
          _filterChip("All"),
          _filterChip("active", label: "Active"),
          _filterChip("past", label: "Past"),
          _filterChip("coming_soon", label: "Soon"),
        ]).centered().pSymmetric(v: 10),

        20.heightBox,

        // 3. Grid View
        _displayList.isEmpty
            ? "No results found".text.gray500.makeCentered().p20()
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: _displayList.length,
                itemBuilder: (context, index) => HoverCard(
                  data: _displayList[index],
                  gold: gold,
                  red: red,
                  onTap: () => widget.onSelect(_displayList[index]),
                ),
              ),
        40.heightBox,
      ]).scrollVertical(),
    );
  }

  Widget _buildBannerCard(int index) {
    return VxBox(child: "Promotion $index".text.white.bold.make().centered())
        .bgImage(
          const DecorationImage(
            image: NetworkImage("https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        )
        .rounded
        .border(color: gold)
        .make();
  }

  Widget _filterChip(String status, {String? label}) {
    bool isSelected = _selectedStatus == status;
    return (label ?? status).text.xs
        .color(isSelected ? Colors.black : Colors.white)
        .make()
        .box
        .color(isSelected ? gold : Colors.white10)
        .roundedLg
        .padding(const EdgeInsets.symmetric(horizontal: 16, vertical: 10))
        .make()
        .onTap(() {
          setState(() => _selectedStatus = status);
          _applyFilters();
        })
        .pOnly(right: 8);
  }
}

// --- 4. HOVER CARD ---
class HoverCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final Color gold;
  final Color red;
  final VoidCallback onTap; // Added callback
  const HoverCard({
    super.key,
    required this.data,
    required this.gold,
    required this.red,
    required this.onTap,
  });
  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    String status = widget.data['status'];
    bool isSoon = status == "coming_soon";
    bool isPast = status == "past";
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        children: [
          VxBox()
              .bgImage(
                DecorationImage(
                  image: NetworkImage(widget.data['img']),
                  fit: BoxFit.cover,
                  colorFilter: isSoon
                      ? const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        )
                      : null,
                ),
              )
              .rounded
              .border(
                color: isSoon ? Colors.white10 : widget.gold.withOpacity(0.3),
              )
              .make(),
          AnimatedOpacity(
            duration: 200.milliseconds,
            opacity: _isHovered ? 0.0 : 1.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
          if (isSoon)
            VxBox(
              child: const Icon(
                Icons.lock_outline,
                color: Colors.white,
              ).centered(),
            ).color(Colors.black45).rounded.make(),
          Positioned(
            top: 8,
            left: 8,
            child:
                (isSoon
                        ? "SOON"
                        : isPast
                        ? "PAST"
                        : widget.data['region'].toString())
                    .text
                    .white
                    .xs
                    .bold
                    .make()
                    .box
                    .color(
                      isSoon
                          ? Colors.blueGrey
                          : isPast
                          ? Colors.grey
                          : widget.red,
                    )
                    .padding(
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    )
                    .roundedSM
                    .make(),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: VStack([
              widget.data['name']
                  .toString()
                  .text
                  .color(isSoon ? Colors.grey : widget.gold)
                  .bold
                  .make(),
              widget.data['jp'].toString().text.white.xs.make(),
            ]),
          ),
        ],
      ).onTap(widget.onTap), // Trigger the callback here
    );
  }
}
