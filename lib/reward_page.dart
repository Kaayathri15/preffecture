import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:preffecture/allvoucher.dart';
import 'package:preffecture/voucher_detail.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  final Color gold = const Color(0xFFC5A059);
  final int currentPoints = 3000; // The user's current balance

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        title: "Exclusive Rewards".text.color(gold).bold.make(),
      ),
      body: VStack([
        _buildPointsHeader(),

        25.heightBox,

        // --- DINING ---
        _buildCategoryHeader("Dining", [
          {
            "shop": "Sabayon",
            "deal": "3-Course Dinner Set",
            "pts": "5,000",
            "tag": "",
            "bg":
                "https://www.eqkualalumpur.equatorial.com/wp-content/uploads/sites/10/2022/09/WebsiteThumbnail_SabayonBrunch.jpg",
          },
          {
            "shop": "SKY51",
            "deal": "Signature Cocktail",
            "pts": "1,200",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?q=80&w=500",
          },
          {
            "shop": "Etoile",
            "deal": "Pastry & Coffee Set",
            "pts": "800",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=500",
          },
          {
            "shop": "Global",
            "deal": "Premium Seafood Platter",
            "pts": "4,500",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1551731359-2b34fc5d0d26?q=80&w=500",
          },
        ], context),
        _buildHorizontalList([
          {
            "shop": "Sabayon",
            "deal": "3-Course Dinner Set",
            "pts": "5,000",
            "tag": "",
            "bg":
                "https://www.eqkualalumpur.equatorial.com/wp-content/uploads/sites/10/2022/09/WebsiteThumbnail_SabayonBrunch.jpg",
          },
          {
            "shop": "SKY51",
            "deal": "Signature Cocktail",
            "pts": "1,200",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?q=80&w=500",
          },
          {
            "shop": "Ètoile",
            "deal": "Pastry & Coffee Set",
            "pts": "800",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=500",
          },
        ], context),

        // --- KAMPACHI (Japanese Restaurant) ---
        // --- KAMPACHI (Japanese Restaurant) ---
        30.heightBox,
        _buildCategoryHeader("Kampachi", [
          {
            "shop": "Kampachi",
            "deal": "Reunion Delights Set",
            "pts": "1,500",
            "tag": "",
            "bg":
                "https://www.kampachi.com.my/images/promotions/Cny2025_Promo.jpg",
          },
          {
            "shop": "Kampachi",
            "deal": "RM100 Cash Voucher",
            "pts": "2,500",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=500",
          },
          {
            "shop": "Kampachi",
            "deal": "Omakase Experience",
            "pts": "8,000",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1534422298391-e4f8c170db06?q=80&w=500",
          },
        ], context),
        _buildHorizontalList([
          {
            "shop": "Kampachi",
            "deal": "Reunion Delights Set",
            "pts": "1,500",
            "tag": "",
            "bg":
                "https://www.kampachi.com.my/images/promotions/Cny2025_Promo.jpg",
          },
          {
            "shop": "Kampachi",
            "deal": "RM100 Cash Voucher",
            "pts": "2,500",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=500",
          },
        ], context),

        // --- IPPUDO / MAISEN ---
        30.heightBox,
        _buildCategoryHeader("Ippudo / Maisen", [
          {
            "shop": "Ippudo",
            "deal": "RM50 Cash Voucher",
            "pts": "1,250",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=500",
          },
          {
            "shop": "Maisen",
            "deal": "Kurobuta Set Voucher",
            "pts": "1,800",
            "tag": "",
            "bg":
                "https://images.pexels.com/photos/29160666/pexels-photo-29160666.jpeg",
          },
          {
            "shop": "Ippudo",
            "deal": "Gyoza Voucher",
            "pts": "500",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?q=80&w=500",
          },
          {
            "shop": "Ippudo",
            "deal": "Special Ramen Bowl",
            "pts": "1,100",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1591814447921-7cf7a5c6ad24?q=80&w=500",
          },
        ], context),
        _buildHorizontalList([
          {
            "shop": "Ippudo",
            "deal": "RM50 Cash Voucher",
            "pts": "1,250",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=500",
          },
          {
            "shop": "Maisen",
            "deal": "Kurobuta Set Voucher",
            "pts": "1,800",
            "tag": "",
            "bg":
                "https://images.pexels.com/photos/29160666/pexels-photo-29160666.jpeg",
          },
          {
            "shop": "Ippudo",
            "deal": "Gyoza Voucher",
            "pts": "500",
            "tag": "",
            "bg":
                "https://images.Premiumunsplash.com/photo-1541696432-82c6da8ce7bf?q=80&w=500",
          },
        ], context),

        // --- OTHERS ---
        30.heightBox,
        _buildCategoryHeader("Others", [
          {
            "shop": "Spa",
            "deal": "60-min Massage",
            "pts": "4,000",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1544161515-4ab6ce6db874?q=80&w=500",
          },
          {
            "shop": "ROOM",
            "deal": "Deluxe Room Stay",
            "pts": "15,000",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1618773928121-c32242e63f39?q=80&w=500",
          },
          {
            "shop": "Gym",
            "deal": "Day Pass",
            "pts": "1,000",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=500",
          },
          {
            "shop": "Lounge",
            "deal": "Afternoon Tea Set",
            "pts": "2,200",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1517686469429-8bdb88b9f907?q=80&w=500",
          },
        ], context),
        _buildHorizontalList([
          {
            "shop": "Spa",
            "deal": "60-min Massage",
            "pts": "4,000",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1544161515-4ab6ce6db874?q=80&w=500",
          },
          {
            "shop": "ROOM",
            "deal": "Deluxe Room Stay",
            "pts": "15,000",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1618773928121-c32242e63f39?q=80&w=500",
          },
          {
            "shop": "Gym",
            "deal": "Day Pass",
            "pts": "1,000",
            "tag": "",
            "bg":
                "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=500",
          },
        ], context),

        40.heightBox,
      ]).p16().scrollVertical(),
    );
  }

  Widget _buildPointsHeader() {
    return VxBox(
          child: HStack([
            VStack([
              "Available Points".text.white.xs.make(),
              "$currentPoints".text.color(gold).xl2.bold.make(),
            ]).expand(),
            Icon(Icons.stars, color: gold, size: 30),
          ]),
        ).p16
        .color(const Color(0xFF1A1A1A))
        .rounded
        .border(color: gold.withOpacity(0.3))
        .make();
  }

  Widget _buildCategoryHeader(
    String title,
    List<Map<String, String>> fullList,
    BuildContext context,
  ) {
    return HStack([
      title.text.white.lg.bold.make().expand(),
      "View All".text.color(gold).xs.semiBold.make().onTap(() {
        if (fullList.isNotEmpty) {
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
        }
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
      child: HStack(data.map((v) => _buildVoucherCard(v, context)).toList()),
    );
  }

  Widget _buildVoucherCard(Map<String, String> voucher, BuildContext context) {
    int requiredPts = int.parse(voucher['pts']!.replaceAll(",", ""));
    bool canAfford = currentPoints >= requiredPts;

    return VxBox(
          child: Stack(
            children: [
              // 1. Background Image Layer
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

              // 2. Left-Side Gradient for text contrast
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

              // 3. ENHANCED "NOT ENOUGH POINTS" OVERLAY (Matches your screenshot)
              if (!canAfford)
                Positioned.fill(
                  child:
                      VxBox(
                            child: VStack(
                              [
                                Icon(
                                  Icons.lock_outline,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 36,
                                ),
                                10.heightBox,
                                "".text.white.bold
                                    .letterSpacing(1.2)
                                    .size(12)
                                    .make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                            ).centered(),
                          )
                          .color(
                            Colors.black.withOpacity(0.75),
                          ) // Darkened for high visibility
                          .withRounded(value: 12)
                          .make(),
                ),

              // 4. Content Layer (Always visible but slightly dimmed if locked)
              VStack([
                    HStack([
                      // Shop Label
                      voucher['shop']!.text.white
                          .size(8)
                          .bold
                          .uppercase
                          .letterSpacing(1)
                          .make()
                          .box
                          .padding(
                            const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          )
                          .color(
                            const Color.fromARGB(
                              215,
                              85,
                              85,
                              85,
                            ).withOpacity(0.4),
                          )
                          .roundedSM
                          .make(),
                      const Spacer(),
                      // Premium/Tag Label
                      if (voucher['tag']!.isNotEmpty)
                        voucher['tag']!.text
                            .color(gold)
                            .size(8)
                            .bold
                            .uppercase
                            .make()
                            .box
                            .padding(
                              const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                            )
                            .color(Colors.black.withOpacity(0.6))
                            .roundedSM
                            .border(color: gold.withOpacity(0.5))
                            .make(),
                    ]),
                    const Spacer(),
                    // Voucher Deal Name
                    voucher['deal']!.text.white.lg.bold
                        .maxLines(2)
                        .shadow(1, 1, 3, Colors.black)
                        .make(),
                    8.heightBox,
                    HStack([
                      // Point Cost
                      "${voucher['pts']} pts".text
                          .color(canAfford ? gold : Colors.white38)
                          .bold
                          .lg
                          .make()
                          .expand(),
                      // Status Icon
                      Icon(
                        canAfford
                            ? Icons.arrow_circle_right_outlined
                            : Icons.lock_outline,
                        color: canAfford ? Colors.white : Colors.white38,
                        size: 24,
                      ),
                    ]),
                  ])
                  .p(16)
                  .opacity(
                    value: canAfford ? 1.0 : 0.5,
                  ), // Dim the content layer if locked
            ],
          ),
        )
        .width(280)
        .height(150)
        .withRounded(value: 12)
        .margin(const EdgeInsets.only(right: 16, bottom: 10, top: 10))
        // Border changes based on affordability
        .border(
          color: canAfford ? Colors.white.withOpacity(0.6) : Colors.white12,
          width: 1.5,
        )
        .make()
        .onTap(() {
          // Still allow viewing details even if locked (good for motivation),
          // but the Detail Page button will be disabled.
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
