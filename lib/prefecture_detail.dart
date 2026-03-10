import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PrefectureDetail extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onBack;
  final bool isStandalone;

  const PrefectureDetail({
    super.key,
    required this.data,
    this.onBack,
    this.isStandalone = false,
  });

  @override
  State<PrefectureDetail> createState() => _PrefectureDetailState();
}

class _PrefectureDetailState extends State<PrefectureDetail>
    with TickerProviderStateMixin {
  final Color gold = const Color(0xFFC5A059);
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? _selectedVenue;
  late AnimationController _pulseController;
  bool _isReminded = false;

  final List<Map<String, dynamic>> venues = [
    {
      "name": "Kampachi",
      "outlets": [
        {
          "loc": "Kampachi EQ KL",
          "url": "https://www.sevenrooms.com/explore/kampachieq/reservations",
        },
        {
          "loc": "Kampachi Plaza 33",
          "url":
              "https://www.sevenrooms.com/explore/kampachiplaza33/reservations",
        },
        {
          "loc": "Kampachi Pavilion KL",
          "url":
              "https://www.sevenrooms.com/explore/kampachipavilionkl/reservations",
        },
      ],
    },
    {
      "name": "IPPUDO",
      "outlets": [
        {"loc": "Ippudo", "url": "https://wa.link/9s2g50"},
      ],
    },
     {
      "name": "MAiSEN",
      "outlets": [
        {"loc": "MAiSEN", "url": "https://wa.link/z6nu4b"},
      ],
    },
  ];

  final List<String> foodImages = [
    "assets/food/12.jpg",
    "assets/food/14.jpg",
    "assets/food/15.jpeg",
  ];

  @override
  void initState() {
    super.initState();
    _initNotifications();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  Future<void> _initNotifications() async {
    tz.initializeTimeZones();
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> _handleReminderToggle() async {
    HapticFeedback.mediumImpact();
    setState(() => _isReminded = !_isReminded);

    if (_isReminded) {
      final scheduleDate = tz.TZDateTime.now(
        tz.local,
      ).add(const Duration(seconds: 10));
      await _notificationsPlugin.zonedSchedule(
        widget.data.hashCode,
        'Your Journey Awaits!',
        'The ${widget.data['name']} experience is now available!',
        scheduleDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'prefecture_reminders',
            'Event Reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      VxToast.show(context, msg: "Reminder set for 10 seconds!");
    } else {
      await _notificationsPlugin.cancel(widget.data.hashCode);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String status = widget.data['status'] ?? 'active';
    final bool isPast = status == 'past';
    final bool isUpcoming = status == 'coming_soon';
    final Color themeColor = isUpcoming ? Colors.grey : gold;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(isUpcoming),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HStack([
                  VStack([
                    widget.data['name']
                        .toString()
                        .text
                        .color(themeColor)
                        .xl4
                        .bold
                        .make(),
                    if (isUpcoming)
                      "Launch Date: March 20, 2026".text
                          .color(gold)
                          .semiBold
                          .make()
                    else if (isPast)
                      "Past Journey (Event Concluded)".text.gray500.lg.make()
                    else
                      "The Golden Journey Edition".text.white.lg.make(),
                  ]).expand(),
                  if (isUpcoming)
                    _buildReminderButton()
                  else if (!isPast)
                    _buildPointsBadge(themeColor),
                ]).p16(),

                if (!isUpcoming && !isPast)
                  Wrap(
                    spacing: 24,
                    runSpacing: 12,
                    children: [
                      _detailItem(
                        Icons.calendar_month,
                        "Feb 12 - Mar 12, 2026",
                        themeColor,
                      ),
                      _detailItem(
                        Icons.access_time_filled,
                        "10:00 AM - 10:00 PM",
                        themeColor,
                      ),
                      _detailItem(
                        Icons.confirmation_number,
                        "Entry Fee: RM 2,500",
                        themeColor,
                      ),
                    ],
                  ).pSymmetric(h: 16),

                32.heightBox,
                "About the Event".text
                    .color(themeColor)
                    .xl
                    .bold
                    .make()
                    .pSymmetric(h: 16),
                8.heightBox,
                (isUpcoming
                        ? "We are currently curating an exclusive cultural experience for this region. Full details will be revealed soon."
                        : "Discover a masterfully curated selection of authentic Japanese flavors and traditions.")
                    .text
                    .white
                    .heightRelaxed
                    .make()
                    .pSymmetric(h: 16),

                24.heightBox,
                12.heightBox,
                HStack(
                  foodImages
                      .asMap()
                      .entries
                      .map(
                        (entry) => VxBox()
                            .bgImage(
                              DecorationImage(
                                image: AssetImage(entry.value),
                                fit: BoxFit.cover,
                                colorFilter: isUpcoming
                                    ? const ColorFilter.mode(
                                        Colors.grey,
                                        BlendMode.saturation,
                                      )
                                    : null,
                              ),
                            )
                            .size(200, 150)
                            .rounded
                            .margin(const EdgeInsets.only(right: 12))
                            .make()
                            .onTap(
                              isUpcoming ? null : () => _openGallery(entry.key),
                            ),
                      )
                      .toList(),
                ).pSymmetric(h: 16).scrollHorizontal(),

                if (!isPast) ...[
                  32.heightBox,
                  _buildNoticeCard(themeColor),
                  32.heightBox,
                  _buildVenueSelector(themeColor),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _selectedVenue != null
                        ? Column(
                            key: ValueKey(_selectedVenue),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              24.heightBox,
                              ...venues
                                  .firstWhere(
                                    (v) => v['name'] == _selectedVenue,
                                  )['outlets']
                                  .map<Widget>(
                                    (outlet) =>
                                        _buildOutletButton(outlet, themeColor),
                                  )
                                  .toList(),
                            ],
                          ).pOnly(bottom: 20)
                        : const SizedBox(height: 100),
                  ),
                ],

                if (isPast)
                  VxBox(
                    child: "This event has concluded."
                        .text
                        .center
                        .gray500
                        .italic
                        .make(),
                  ).p32.makeCentered(),
                100.heightBox,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(bool isUpcoming) {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      leading: widget.isStandalone
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: widget.onBack,
            ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            // 1. Background photo
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey,
                isUpcoming ? BlendMode.saturation : BlendMode.dst,
              ),
              child: Image.network(widget.data['img'], fit: BoxFit.cover),
            ),

            // 3. SCROLLING LOGO MARQUEE BANNER
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _MarqueeBanner(gold: gold, grayscale: isUpcoming),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderButton() => Column(
    children: [
      IconButton(
        onPressed: _handleReminderToggle,
        icon: Icon(
          _isReminded ? Icons.notifications_active : Icons.notifications_none,
          color: _isReminded ? gold : Colors.white,
          size: 32,
        ),
      ),
      "Remind Me".text.color(_isReminded ? gold : Colors.white).xs.bold.make(),
    ],
  );

  Widget _detailItem(IconData icon, String label, Color color) => HStack([
    Icon(icon, color: color, size: 20),
    8.widthBox,
    label.text.color(color).semiBold.make(),
  ]);

  Widget _buildPointsBadge(Color color) => VStack(
    ["2,500".text.black.bold.xl.make(), "     PTS".text.black.bold.xs.make()],
    alignment: MainAxisAlignment.center,
  ).p8().box.color(color).roundedLg.make();

  Widget _buildSponsorList(bool grayscale) => HStack([
    _partnerLogo("", "assets/images/casio-logo.png", grayscale),
    _partnerLogo("", "assets/images/toho-logo.png", grayscale),
    _partnerLogo("", "assets/images/uniqlo-logo.png", grayscale),
  ]).pSymmetric(h: 16).scrollHorizontal();

  Widget _partnerLogo(String name, String assetPath, bool grayscale) => VStack([
    VxBox()
        .bgImage(
          DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.contain,
            colorFilter: grayscale
                ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                : null,
          ),
        )
        .size(100, 60)
        .p8
        .color(Colors.black)
        .rounded
        .border(color: Colors.white10, width: 1)
        .make(),
    4.heightBox,
    name.text.color(grayscale ? Colors.grey : Colors.white).xs.makeCentered(),
  ]).pOnly(right: 16);

  Widget _buildNoticeCard(Color color) =>
      VxBox(
            child: HStack([
              Icon(Icons.info_outline, color: color, size: 24),
              16.widthBox,
              VStack([
                "Reservations are mandatory. Please select a venue below."
                    .text
                    .white
                    .sm
                    .make(),
              ]).expand(),
            ]),
          ).p16
          .border(color: color, width: 1.5)
          .rounded
          .margin(const EdgeInsets.symmetric(horizontal: 16))
          .make();

  Widget _buildVenueSelector(Color color) => Row(
    children: venues.map((venue) {
      bool isSelected = _selectedVenue == venue['name'];
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _selectedVenue = venue['name']),
          child: AnimatedContainer(
            duration: 300.milliseconds,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white10,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: venue['name']
                .toString()
                .text
                .color(isSelected ? Colors.black : Colors.white70)
                .bold
                .center
                .make(),
          ),
        ),
      );
    }).toList(),
  ).pSymmetric(h: 12);

  Widget _buildOutletButton(Map<String, dynamic> outlet, Color color) =>
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: OutlinedButton(
          onPressed: () => _launchURL(outlet['url']),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: color, width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: HStack([
            Icon(Icons.location_on, color: color, size: 20),
            12.widthBox,
            "Book Now: ${outlet['loc']}".text.color(color).bold.make().expand(),
            Icon(Icons.arrow_forward_ios, color: color, size: 14),
          ]).pSymmetric(h: 12),
        ),
      );

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _openGallery(int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => _FoodGallerySlider(
        images: foodImages,
        initialIndex: initialIndex,
        gold: gold,
      ),
    );
  }
}

class _FoodGallerySlider extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final Color gold;
  const _FoodGallerySlider({
    required this.images,
    required this.initialIndex,
    required this.gold,
  });
  @override
  State<_FoodGallerySlider> createState() => _FoodGallerySliderState();
}

class _FoodGallerySliderState extends State<_FoodGallerySlider> {
  late PageController _controller;
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            itemBuilder: (context, index) => InteractiveViewer(
              child: Image.asset(widget.images[index], fit: BoxFit.contain),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: widget.gold),
              onPressed: () => _controller.previousPage(
                duration: 300.milliseconds,
                curve: Curves.easeInOut,
              ),
            ),
          ),
          Positioned(
            right: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: widget.gold),
              onPressed: () => _controller.nextPage(
                duration: 300.milliseconds,
                curve: Curves.easeInOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarqueeBanner extends StatefulWidget {
  final Color gold;
  final bool grayscale;

  const _MarqueeBanner({required this.gold, required this.grayscale});

  @override
  State<_MarqueeBanner> createState() => _MarqueeBannerState();
}

class _MarqueeBannerState extends State<_MarqueeBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<String> _logos = [
    'assets/images/kampachi_white.png',
    'assets/images/ippudo.avif',
    'assets/images/MAiSEN-Logo.avif',
    'assets/images/logo-eq.png'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Setup Items
    final List<Widget> marqueeItems = widget.grayscale
        ? List.generate(
            6,
            (index) => "COMING SOON ".text
                .color(widget.gold)
                .bold
                .widest
                .size(16)
                .make()
                .pSymmetric(h: 40),
          )
        : _logos
              .map(
                (logo) => Image.asset(
                  logo,
                  width: 100,
                  fit: BoxFit.contain,
                ).pSymmetric(h: 30),
              )
              .toList();

    final items = [...marqueeItems, ...marqueeItems];

    return Container(
      height: 65,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.black.withOpacity(0.5), Colors.black],
        ),
      ),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black, // Fully hidden at the very edge
              Colors.transparent, // Fully visible very quickly
              Colors.transparent, // Stay visible
              Colors.black, // Fade out at the very end
            ],
            // Changing 0.05 to 0.02 makes the "fade" area much thinner/lighter
            stops: [0.0, 0.02, 0.98, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstOut,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // We use a simpler translation logic to avoid layout jumps
            return FractionalTranslation(
              translation: Offset(-_controller.value, 0),
              child: child,
            );
          },
          child: OverflowBox(
            maxWidth: double.infinity, // FIXES THE OVERFLOW ERROR
            alignment: Alignment.centerLeft,
            child: Row(mainAxisSize: MainAxisSize.min, children: items),
          ),
        ),
      ),
    );
  }
}
