import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';

class PrefectureRegionPage extends StatefulWidget {
  const PrefectureRegionPage({super.key});

  @override
  State<PrefectureRegionPage> createState() => _PrefectureRegionPageState();
}

class _PrefectureRegionPageState extends State<PrefectureRegionPage> {
  final Color gold = const Color(0xFFC5A059);
  final Color red = const Color(0xFFE50914);
  
  int _activeRegionIndex = 0;
  bool _isBannerFlipped = false;
  bool _triggerTeaser = false; 
  final CarouselSliderController _carouselController = CarouselSliderController();

  final List<Map<String, dynamic>> _regionData = [
    {
      "region": "Hokkaido",
      "jp": "北海道",
      "description": "Hokkaidō, Japan’s northernmost island, is famous for its snowy winters and vast landscapes. Renowned for Sapporo Beer, fresh seafood, and vibrant seasonal festivals.",
      "bgImg": "https://images.pexels.com/photos/5195410/pexels-photo-5195410.jpeg",
      "prefectures": [
        {
          "name": "Hokkaido", 
          "jp": "札幌", 
          "details": "Japan’s northern frontier known for powdery winter snow, world-class skiing, and exceptionally fresh dairy and seafood.", 
          "img": "https://images.pexels.com/photos/5195410/pexels-photo-5195410.jpeg",
        },
      ]
    },
    {
      "region": "Kantō",
      "jp": "関東",
      "description": "The economic and political heart of Japan. From the neon lights of Tokyo to the coastal vibes of Yokohama, this region defines modern Japan.",
      "bgImg": "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf",
      "prefectures": [
        {
          "name": "Tokyo", 
          "jp": "東京", 
          "details": "The ultra-modern heart of Japan where skyscrapers meet ancient shrines. A city that never sleeps and offers endless exploration.", 
          "img": "https://images.unsplash.com/photo-1503899036084-c55cdd92da26",
        },
      ]
    },
  ];

@override
void initState() {
  super.initState();
  // We use addPostFrameCallback to ensure the UI is rendered 
  // before we start the animation timer
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _startTeaser();
  });
}

void _startTeaser() async {
  if (!mounted) return;
  
  // Wait a moment for the tab transition to finish
  await Future.delayed(const Duration(milliseconds: 300));
  if (mounted) setState(() => _triggerTeaser = true);
  
  // Keep it flipped for 2 seconds
  await Future.delayed(const Duration(seconds: 1));
  
  // Flip it back
  if (mounted) setState(() => _triggerTeaser = false);
}

  void _showFullDetailModal(String title, String content, {VoidCallback? onDismiss}) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: VxBox(
            child: VStack([
              HStack([
                title.text.color(gold).xl3.bold.make().expand(),
                Icon(Icons.close, color: gold, size: 28).onTap(() => Navigator.pop(context)),
              ]),
              20.heightBox,
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: content.text.white.lg.lineHeight(1.5).make(),
                ),
              ),
              20.heightBox,
              Center(child: "The Golden Journey".text.color(gold).italic.make()),
            ]).p24(),
          )
          .color(const Color(0xFF1A1A1A))
          .roundedLg
          .border(color: gold, width: 2)
          .width(context.screenWidth * 0.9)
          .height(context.screenHeight * 0.7)
          .make(),
        ),
      ),
    ).then((_) {
      if (onDismiss != null) onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: VStack([
        // --- BANNER SECTION ---
        TweenAnimationBuilder(
          key: ValueKey('banner_$_activeRegionIndex'),
          duration: const Duration(milliseconds: 800),
          // Reacts to both manual flips and the auto-teaser flip
          tween: Tween<double>(begin: 0, end: (_isBannerFlipped || _triggerTeaser) ? 180 : 0),
          builder: (context, double value, child) {
            final region = _regionData[_activeRegionIndex];
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(value * pi / 180),
              child: value < 90 
                ? _buildBannerFront() 
                : _buildBannerBackMirrored(region),
            );
          },
        ).h(260),

        20.heightBox,

        // --- PREFECTURE GRID ---
        GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.78,
          ),
          itemCount: _regionData[_activeRegionIndex]['prefectures'].length,
          itemBuilder: (context, index) => FlipPrefectureCard(
            key: ValueKey("${_regionData[_activeRegionIndex]['region']}_$index"), 
            data: _regionData[_activeRegionIndex]['prefectures'][index],
            gold: gold, red: red, 
            isTeasing: _triggerTeaser, // Pass the teaser state here
            onEnlarge: (title, detail, callback) => _showFullDetailModal(title, detail, onDismiss: callback),
          ),
        ).expand(),
      ]),
    );
  }

  Widget _buildBannerFront() {
    return Stack(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: _regionData.length,
          options: CarouselOptions(
            height: 260,
            viewportFraction: 1.0,
            initialPage: _activeRegionIndex,
            onPageChanged: (index, reason) {
              setState(() { 
                _activeRegionIndex = index; 
                _isBannerFlipped = false; 
                // Re-trigger the teaser when the region is changed manually
                // _startTeaser(); 
              });
            },
          ),
          itemBuilder: (context, index, realIndex) => Stack(
            alignment: Alignment.bottomLeft,
            children: [
              VxBox().bgImage(DecorationImage(image: NetworkImage(_regionData[index]['bgImg']), fit: BoxFit.cover)).make(),
              VxBox().withGradient(LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.8), Colors.transparent])).make(),
              VStack([
                _regionData[index]['region'].toString().text.white.xl3.bold.make(),
                _regionData[index]['jp'].toString().text.color(gold).lg.make(),
              ]).p24(),
            ],
          ).onTap(() => setState(() => _isBannerFlipped = true)),
        ),
        
        HStack([
          Icon(Icons.chevron_left, color: Colors.white70, size: 45).onTap(() => _carouselController.previousPage()),
          Icon(Icons.chevron_right, color: Colors.white70, size: 45).onTap(() => _carouselController.nextPage()),
        ], alignment: MainAxisAlignment.spaceBetween).w(context.screenWidth).px12().centered().h(260),
      ],
    );
  }

  Widget _buildBannerBackMirrored(Map<String, dynamic> region) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: VxBox(
        child: VStack([
          HStack([
            "About ${region['region']}".text.color(gold).xl2.bold.make().expand(),
            Icon(Icons.close, color: gold).onTap(() => setState(() => _isBannerFlipped = false)),
          ]),
          20.heightBox,
          region['description'].toString().text.white.lg.maxLines(3).ellipsis.make(),
          const Spacer(),
          Center(
            child: Icon(Icons.open_in_full, color: gold, size: 28)
                .box.color(Colors.black.withOpacity(0.5)).roundedFull.p12.make()
                .onTap(() => _showFullDetailModal(region['region'], region['description'], onDismiss: () {
                  setState(() => _isBannerFlipped = false);
                })),
          ),
          10.heightBox,
          Center(child: "Auto-flipping...".text.gray500.xs.make()),
        ]).p24(),
      ).color(const Color(0xFF121212)).border(color: gold.withOpacity(0.3)).make().onTap(() => setState(() => _isBannerFlipped = false)),
    );
  }
}

class FlipPrefectureCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final Color gold;
  final Color red;
  final bool isTeasing;
  final Function(String, String, VoidCallback) onEnlarge;

  const FlipPrefectureCard({super.key, required this.data, required this.gold, required this.red, required this.onEnlarge, this.isTeasing = false});
  @override
  State<FlipPrefectureCard> createState() => _FlipPrefectureCardState();
}

class _FlipPrefectureCardState extends State<FlipPrefectureCard> {
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      // Uses either manual flip or the parent's teaser state
      tween: Tween<double>(begin: 0, end: (_isFlipped || widget.isTeasing) ? 180 : 0),
      builder: (context, double value, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(value * pi / 180),
          child: value < 90 ? _buildFront() : _buildBackMirrored(),
        );
      },
    );
  }

  Widget _buildFront() {
    return VxBox(
      child: VStack([
        const Spacer(),
        widget.data['name'].toString().text.white.bold.lg.make(),
        widget.data['jp'].toString().text.color(widget.gold).sm.make(),
      ]).p12(),
    ).bgImage(DecorationImage(image: NetworkImage(widget.data['img']), fit: BoxFit.cover, colorFilter: const ColorFilter.mode(Colors.black38, BlendMode.darken))).roundedLg.border(color: Colors.white10).make().onTap(() => setState(() => _isFlipped = true));
  }

  Widget _buildBackMirrored() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: VxBox(
        child: VStack([
          HStack([
            widget.data['name'].toString().text.color(widget.gold).bold.lg.make().expand(), 
            Icon(Icons.close, color: widget.gold, size: 18).onTap(() => setState(() => _isFlipped = false))
          ]),
          8.heightBox,
          widget.data['details'].toString().text.white.sm.maxLines(3).ellipsis.make(),
          const Spacer(),
          Center(child: Icon(Icons.open_in_full, color: widget.gold, size: 24).p8().onTap(() {
            widget.onEnlarge(widget.data['name'], widget.data['details'], () {
              if (mounted) setState(() => _isFlipped = false);
            });
          })),
        ]).p12(),
      ).color(const Color(0xFF1A1A1A)).roundedLg.border(color: widget.red.withOpacity(0.4), width: 1).make().onTap(() => setState(() => _isFlipped = false)),
    );
  }
}