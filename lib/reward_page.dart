import 'dart:async';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:preffecture/allvoucher.dart';
import 'package:preffecture/voucher_detail.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final Color gold = const Color(0xFFC5A059);
  final int currentPoints = 3000;

  // --- Slider Logic ---
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;
  final List<Map<String, String>> _promoData = [
   
    {
      "url":
          "https://www.eqkualalumpur.equatorial.com/wp-content/uploads/sites/10/2019/04/2020-09-11_etoile-featured-image.jpg",
      "tag": "ÉTOILE",
    },
    {
      "url":
          "https://www.eqkualalumpur.equatorial.com/wp-content/uploads/sites/10/2019/04/2019-12-10_eq_kampachi_restaurant.jpg",
      "tag": "KAM EQ",
    },
     {
      "url":
          "assets/images/kampachi-1.jpeg", // Local asset image
      "tag": "KAM PAV",
    },
     {
      "url":
          "assets/images/kampachi-2.jpeg", // Local asset image
      "tag": "KAM PLA",
    },
    {
      "url":
          "https://www.eqkualalumpur.equatorial.com/wp-content/uploads/sites/10/2019/04/2020-01-13_eq_nipah_private-room.jpg",
      "tag": "NIPAH",
    },
    {
      "url":
          "assets/images/sky51.jpg", // Local asset image
      "tag": "SKY51",
    },
     {
      "url":
          "assets/images/IPPUDO.jpg", 
      "tag": "IPPUDO",
    },
     {
      "url":
          "assets/images/MAiSEN.jpg", // Local asset image
      "tag": "MAiSEN",
    },

    
  ];

  @override
  void initState() {
    super.initState();
    // Auto-slide logic: changes every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _promoData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
      ),
      body: VStack([
        // 1. AUTO PROMOTION SLIDER
        _buildAutoSlider(context, _currentPage),

        20.heightBox,

        // 2. POINTS HEADER
        _buildPointsHeader().pSymmetric(h: 16),

        25.heightBox,

        // 3. CATEGORIES
        _buildCategorySection("Dining", diningData),
        30.heightBox,
        _buildCategorySection("Kampachi", kampachiData),
        30.heightBox,
        _buildCategorySection("Ippudo / Maisen", ramenData),
        30.heightBox,
        _buildCategorySection("Others", otherData),

        40.heightBox,
      ]).scrollVertical(),
    );
  }

  // --- UI WIDGETS ---

  Widget _buildAutoSlider(context, index) {
    String imagePath = _promoData[index]['url']!;
  bool isNetwork = imagePath.startsWith('http');
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        VxBox(
              child: SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() => _currentPage = page);
                  },
                  itemCount: _promoData.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        VxBox()
                            .bgImage(
                              DecorationImage(
            // Logic to choose between Network or Asset
            image: isNetwork 
                ? NetworkImage(imagePath) 
                : AssetImage(imagePath) as ImageProvider,
            fit: BoxFit.cover,
          ))
          .withRounded(value: 12)
          .make(),

                        // Dynamic Top Right Tag
                        // Updated Tag Styling
                        Positioned(
                          top: 12,
                          right: 12,
                          child:
                              VxBox(
                                    child: Center(
                                      // Centers the text within the box
                                      child: _promoData[index]['tag']!
                                          .text
                                          .white
                                          .size(10)
                                          .bold
                                          .make(),
                                    ),
                                  )
                                  .withGradient(
                                    const LinearGradient(
                                      colors: [Colors.black54, Colors.black87],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  )
                                  .border(color: gold, width: 1.0)
                                  .width(
                                    74,
                                  ) // Fix the width to maintain a consistent size
                                  .height(30) // Fix the height
                                  .roundedSM
                                  .make(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
            .padding(const EdgeInsets.symmetric(horizontal: 16))
            .withRounded(value: 12)
            .clip(Clip.antiAlias)
            .make(),

        // Indicator Dots
        HStack(
          List.generate(
            _promoData.length,
            (index) => VxBox()
                .size(index == _currentPage ? 20 : 8, 8)
                .withRounded(value: 10)
                .color(index == _currentPage ? gold : Colors.white24)
                .make()
                .p4(),
          ),
        ).pOnly(bottom: 16),
      ],
    );
  }

  Widget _buildPointsHeader() {
    return VxBox(
          child: HStack([
            VStack([
              "Current Points".text.white.xs.make(),
              "3,000".text.color(gold).xl2.bold.make(),
            ]).expand(),
          ]),
        ).p16
        .color(const Color(0xFF1A1A1A))
        .rounded
        .border(color: gold.withOpacity(0.3))
        .make();
  }

  Widget _buildCategorySection(String title, List<Map<String, String>> data) {
    return VStack([
      _buildCategoryHeader(title, data, context).pSymmetric(h: 16),
      _buildHorizontalList(data, context),
    ]);
  }

  Widget _buildCategoryHeader(
    String title,
    List<Map<String, String>> fullList,
    BuildContext context,
  ) {
    return HStack([
      title.text.white.lg.bold.make().expand(),
      "View All".text.color(gold).xs.semiBold.make().onTap(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllVouchersPage(
              category: title,
              vouchers: fullList,
              userPoints: currentPoints,
              gold: gold,
            ),
          ),
        );
      }),
    ]).pOnly(bottom: 10);
  }

  Widget _buildHorizontalList(
    List<Map<String, String>> data,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: HStack(
        data.map((v) => _buildVoucherCard(v, context)).toList(),
      ).pOnly(left: 16),
    );
  }

  Widget _buildVoucherCard(Map<String, String> voucher, BuildContext context) {
    int requiredPts = int.parse(voucher['pts']!.replaceAll(",", ""));
    bool canAfford = currentPoints >= requiredPts;

    return VxBox(
          child: Stack(
            children: [
              Positioned.fill(
                child: VxBox()
                    .bgImage(
                      DecorationImage(
                        image: NetworkImage(voucher['bg'] ?? ""),
                        fit: BoxFit.cover,
                      ),
                    )
                    .withRounded(value: 12)
                    .make(),
              ),
              Positioned.fill(
                child: VxBox()
                    .withGradient(
                      LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black.withOpacity(0.85),
                          Colors.transparent,
                        ],
                      ),
                    )
                    .withRounded(value: 12)
                    .make(),
              ),
              if (!canAfford)
                Positioned.fill(
                  child:
                      VxBox(
                            child: Icon(
                              Icons.lock_outline,
                              color: Colors.white.withOpacity(0.9),
                              size: 36,
                            ).centered(),
                          )
                          .color(Colors.black.withOpacity(0.75))
                          .withRounded(value: 12)
                          .make(),
                ),
              VStack([
                HStack([
                  voucher['shop']!.text.white
                      .size(8)
                      .bold
                      .uppercase
                      .letterSpacing(1)
                      .make()
                      .box
                      .padding(
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      )
                      .color(
                        const Color.fromARGB(215, 85, 85, 85).withOpacity(0.4),
                      )
                      .roundedSM
                      .make(),
                ]),
                const Spacer(),
                voucher['deal']!.text.white.lg.bold
                    .maxLines(2)
                    .shadow(1, 1, 3, Colors.black)
                    .make(),
                8.heightBox,
                HStack([
                  "${voucher['pts']} pts".text
                      .color(canAfford ? gold : Colors.white38)
                      .bold
                      .lg
                      .make()
                      .expand(),
                  Icon(
                    canAfford
                        ? Icons.arrow_circle_right_outlined
                        : Icons.lock_outline,
                    color: canAfford ? Colors.white : Colors.white38,
                    size: 24,
                  ),
                ]),
              ]).p(16).opacity(value: canAfford ? 1.0 : 0.5),
            ],
          ),
        )
        .width(280)
        .height(150)
        .withRounded(value: 12)
        .margin(const EdgeInsets.only(right: 16, bottom: 10, top: 10))
        .border(
          color: canAfford ? Colors.white.withOpacity(0.6) : Colors.white12,
          width: 1.5,
        )
        .make()
        .onTap(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VoucherDetailPage(
                voucher: voucher,
                gold: gold,
                userPoints: currentPoints,
              ),
            ),
          );
        });
  }
}

// --- DUMMY DATA ---
final List<Map<String, String>> diningData = [
  {
    "shop": "Sabayon",
    "deal": "3-Course Dinner Set",
    "pts": "5,000",
    "bg":
        "https://www.eqkualalumpur.equatorial.com/wp-content/uploads/sites/10/2022/09/WebsiteThumbnail_SabayonBrunch.jpg",
  },
  {
    "shop": "SKY51",
    "deal": "Signature Cocktail",
    "pts": "1,200",
    "bg":
        "https://www.eqkualalumpur.equatorial.com/wp-content/uploads/sites/10/2019/04/2020-01-13_blue-lounge.jpg",
  },
  {
    "shop": "Etoile",
    "deal": "Pastry & Coffee Set",
    "pts": "800",
    "bg":
        "https://www.eqkualalumpur.equatorial.com/wp-content/uploads/sites/10/2023/05/2023-05-16_Etoile-poke-salmon-scaled.jpg",
  },
];

final List<Map<String, String>> kampachiData = [
  {
    "shop": "Kampachi",
    "deal": "Reunion Delights Set",
    "pts": "1,500",
    "bg": "https://www.kampachi.com.my/images/promotions/2026IFTAR_PROMO.jpg",
  },
  {
    "shop": "Kampachi",
    "deal": "RM100 Cash Voucher",
    "pts": "2,500",
    "bg": "https://www.kampachi.com.my/images/promotions/Cny2025_Promo.jpg",
  },
];

final List<Map<String, String>> ramenData = [
  {
    "shop": "Ippudo",
    "deal": "RM50 Cash Voucher",
    "pts": "1,250",
    "bg":
        "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=500",
  },
  {
    "shop": "Maisen",
    "deal": "Kurobuta Set Voucher",
    "pts": "1,800",
    "bg":
        "https://images.pexels.com/photos/29160666/pexels-photo-29160666.jpeg",
  },
];

final List<Map<String, String>> otherData = [
  {
    "shop": "Spa",
    "deal": "60-min Massage",
    "pts": "4,000",
    "bg":
        "https://www.eqkualalumpur.equatorial.com/wp-content/uploads/sites/10/2019/04/2019-10-03_eq_sanctum-facial_op.jpg",
  },
  {
    "shop": "ROOM",
    "deal": "Deluxe Room Stay",
    "pts": "15,000",
    "bg":
        "https://www.eqkualalumpur.equatorial.com/wp-content/uploads/sites/10/2019/04/Premier-King.jpg",
  },
];
