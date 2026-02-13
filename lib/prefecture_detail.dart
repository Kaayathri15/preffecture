import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class PrefectureDetail extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onBack;

  const PrefectureDetail({super.key, required this.data, required this.onBack});

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
        {"loc": "Kampachi EQ KL", "url": "https://www.sevenrooms.com/reservations/kampachieqkl"},
        {"loc": "Kampachi Plaza 33", "url": "https://www.sevenrooms.com/reservations/kampachiplaza33"},
      ],
    },
    {
      "name": "IPPUDO",
      "outlets": [
        {"loc": "Ippudo Pavilion KL", "url": "https://www.ippudo.com.my/"},
      ],
    },
  ];

  final List<String> foodImages = [
    "https://images.unsplash.com/photo-1583953623787-ada99d338235?q=80&w=800",
    "https://images.unsplash.com/photo-1553621042-f6e147245754?q=80&w=800",
    "https://images.unsplash.com/photo-1569050278824-640c74471824?q=80&w=800",
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
  
  // v17 uses a single positional argument for initSettings
  await _notificationsPlugin.initialize(initSettings);
}
Future<void> _handleReminderToggle() async {
  HapticFeedback.mediumImpact();
  setState(() => _isReminded = !_isReminded);

  if (_isReminded) {
    final scheduleDate = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

    await _notificationsPlugin.zonedSchedule(
      widget.data.hashCode,                 // 1. Positional ID
      'New Journey Begins!',                // 2. Positional Title
      'The ${widget.data['name']} event!',  // 3. Positional Body
      scheduleDate,                         // 4. Positional Date
      const NotificationDetails(            // 5. Positional Details
        android: AndroidNotificationDetails(
          'prefecture_reminders',
          'Event Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // THESE MUST BE NAMED:
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    VxToast.show(context, msg: "Reminder set for 10s!");
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
                    widget.data['name'].toString().text.color(themeColor).xl4.bold.make(),
                    if (isUpcoming)
                      "Available on March 20, 2026".text.color(gold).semiBold.make()
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
                      _detailItem(Icons.calendar_month, "Feb 12 - Mar 12, 2026", themeColor),
                      _detailItem(Icons.access_time_filled, "10:00 AM - 10:00 PM", themeColor),
                      _detailItem(Icons.confirmation_number, "Entry: ¥2,500", themeColor),
                    ],
                  ).pSymmetric(h: 16),

                32.heightBox,
                "Sponsors".text.color(themeColor).xl.bold.make().pSymmetric(h: 16),
                12.heightBox,
                _buildSponsorList(isUpcoming),

                32.heightBox,
                "Event Description".text.color(themeColor).xl.bold.make().pSymmetric(h: 16),
                8.heightBox,
                (isUpcoming
                        ? "We are currently preparing an exclusive cultural experience for this region. Details revealed soon."
                        : "Experience a curated selection of authentic Japanese flavors.")
                    .text.white.heightRelaxed.make().pSymmetric(h: 16),

                24.heightBox,
                "Culinary Highlights".text.color(themeColor).lg.semiBold.make().pSymmetric(h: 16),
                12.heightBox,
                HStack(
                  foodImages.asMap().entries.map((entry) => VxBox()
                    .bgImage(DecorationImage(
                      image: NetworkImage(entry.value),
                      fit: BoxFit.cover,
                      colorFilter: isUpcoming ? const ColorFilter.mode(Colors.grey, BlendMode.saturation) : null,
                    ))
                    .size(200, 150).rounded.margin(const EdgeInsets.only(right: 12)).make()
                    .onTap(isUpcoming ? null : () => _openGallery(entry.key)),
                  ).toList(),
                ).pSymmetric(h: 16).scrollHorizontal(),

                if (!isUpcoming && !isPast) ...[
                  32.heightBox,
                  _buildNoticeCard(themeColor),
                  32.heightBox,
                  "Select a Venue to Book".text.color(themeColor).xl.bold.make().pSymmetric(h: 16),
                  16.heightBox,
                  _buildVenueSelector(themeColor),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _selectedVenue != null
                        ? Column(
                            key: ValueKey(_selectedVenue),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              24.heightBox,
                              ...venues.firstWhere((v) => v['name'] == _selectedVenue)['outlets']
                                  .map<Widget>((outlet) => _buildOutletButton(outlet, themeColor)).toList(),
                            ],
                          ).pOnly(bottom: 20)
                        : const SizedBox(height: 100),
                  ),
                ],

                if (isPast)
                  VxBox(child: "This event has ended.".text.center.gray500.italic.make())
                    .p32.makeCentered(),

                100.heightBox,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
    ).pOnly(right: 8);
  }

  Widget _detailItem(IconData icon, String label, Color color) {
    return HStack([
      Icon(icon, color: color, size: 20),
      8.widthBox,
      label.text.color(color).semiBold.make(),
    ]);
  }

  Widget _buildPointsBadge(Color color) {
    return VStack(
      ["2,500".text.black.bold.xl.make(), "PTS".text.black.bold.xs.make()],
      alignment: MainAxisAlignment.center,
      crossAlignment: CrossAxisAlignment.center,
    ).p8().box.color(color).roundedLg.make();
  }

  Widget _buildSponsorList(bool grayscale) {
    return HStack([
      _partnerLogo("JFC", "https://via.placeholder.com/100x60", grayscale),
      _partnerLogo("Kampachi", "https://via.placeholder.com/100x60", grayscale),
      _partnerLogo("Kansai Exporter", "https://via.placeholder.com/100x60", grayscale),
    ]).pSymmetric(h: 16).scrollHorizontal();
  }

  Widget _partnerLogo(String name, String imageUrl, bool grayscale) {
    return VStack([
      VxBox().bgImage(DecorationImage(
        image: NetworkImage(imageUrl),
        fit: BoxFit.contain,
        colorFilter: grayscale ? const ColorFilter.mode(Colors.grey, BlendMode.saturation) : null,
      )).size(100, 60).p8.color(Colors.white.withOpacity(0.05)).rounded.make(),
      4.heightBox,
      name.text.color(grayscale ? Colors.grey : Colors.white).xs.makeCentered(),
    ]).pOnly(right: 16);
  }

  Widget _buildNoticeCard(Color color) {
    return VxBox(
      child: HStack([
        Icon(Icons.info_outline, color: color, size: 24),
        16.widthBox,
        VStack([
          "NOTICE TO BOOK".text.color(color).bold.make(),
          "Reservations are required. Tap a brand below to book.".text.white.sm.make(),
        ]).expand(),
      ]),
    ).p16.border(color: color, width: 1.5).rounded.margin(const EdgeInsets.symmetric(horizontal: 16)).make();
  }

  Widget _buildVenueSelector(Color color) {
    return Row(
      children: venues.map((venue) {
        bool isSelected = _selectedVenue == venue['name'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedVenue = venue['name']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? Colors.white : Colors.white10, width: isSelected ? 2 : 1),
              ),
              child: venue['name'].toString().text.color(isSelected ? Colors.black : Colors.white70).bold.center.make(),
            ),
          ),
        );
      }).toList(),
    ).pSymmetric(h: 12);
  }

  Widget _buildOutletButton(Map<String, dynamic> outlet, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: OutlinedButton(
        onPressed: () => _launchURL(outlet['url']),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: HStack([
          Icon(Icons.location_on, color: color, size: 20),
          12.widthBox,
          "Book Now: ${outlet['loc']}".text.color(color).bold.make().expand(),
          Icon(Icons.arrow_forward_ios, color: color, size: 14),
        ]).pSymmetric(h: 12),
      ),
    );
  }

  Widget _buildSliverAppBar(bool isUpcoming) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: widget.onBack,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey,
                isUpcoming ? BlendMode.saturation : BlendMode.dst,
              ),
              child: Image.network(widget.data['img'], fit: BoxFit.cover),
            ),
            if (isUpcoming)
              Center(
                child: FadeTransition(
                  opacity: _pulseController,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: "COMING SOON...".text.white.xl2.widest.bold.make(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

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

  const _FoodGallerySlider({required this.images, required this.initialIndex, required this.gold});

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
              child: Image.network(widget.images[index], fit: BoxFit.contain),
            ),
          ),
          Positioned(top: 50, right: 20, child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 30), onPressed: () => Navigator.pop(context))),
          Positioned(left: 10, child: IconButton(icon: Icon(Icons.arrow_back_ios, color: widget.gold), onPressed: () => _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut))),
          Positioned(right: 10, child: IconButton(icon: Icon(Icons.arrow_forward_ios, color: widget.gold), onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut))),
        ],
      ),
    );
  }
}