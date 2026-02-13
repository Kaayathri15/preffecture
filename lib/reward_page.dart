import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  final Color gold = const Color(0xFFC5A059);

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
        _buildCategoryHeader("Dining"),
        _buildHorizontalList([
          {"shop": "Sabayon", "deal": "3-Course Dinner Set", "pts": "5,000", "tag": "", "bg": "https://www.eqkualalumpur.equatorial.com/wp-content/uploads/sites/10/2022/09/WebsiteThumbnail_SabayonBrunch.jpg"},
          {"shop": "SKY51", "deal": "Signature Cocktail", "pts": "1,200", "tag": "", "bg": "https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?q=80&w=500"},
        ], showTag: true, context: context),

        // --- KAMPACHI ---
        30.heightBox,
        _buildCategoryHeader("Kampachi"),
        _buildHorizontalList([
          {"shop": "EQ", "deal": "RM100 Cash Voucher", "pts": "2,500", "tag": "", "bg": "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=500"},
          {"shop": "PAVILION", "deal": "RM100 Cash Voucher", "pts": "2,500", "tag": "", "bg": "https://images.unsplash.com/photo-1582450871972-ab5ca641643d?q=80&w=500"},
        ], showTag: false, context: context),

        // --- RETAIL ---
        30.heightBox,
        _buildCategoryHeader("Ippudo / Maisen"),
        _buildHorizontalList([
          {"shop": "Ippudo", "deal": "RM50 Cash Voucher", "pts": "1,250", "tag": "", "bg": "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=500"},
          {"shop": "Maisen", "deal": "Kurobuta Set Voucher", "pts": "1,800", "tag": "", "bg": "https://images.pexels.com/photos/29160666/pexels-photo-29160666.jpeg"},
        ], showTag: false, context: context),

        // --- OTHERS ---
        30.heightBox,
        _buildCategoryHeader("Others"),
        _buildHorizontalList([
          {"shop": "Spa", "deal": "60-min Massage", "pts": "4,000", "tag": "", "bg": "https://images.unsplash.com/photo-1544161515-4ab6ce6db874?q=80&w=500"},
          {"shop": "ROOM", "deal": "Deluxe Room Stay", "pts": "15,000", "tag": "", "bg": "https://images.unsplash.com/photo-1618773928121-c32242e63f39?q=80&w=500"},
        ], showTag: true, context: context),
        
        40.heightBox,
      ]).p16().scrollVertical(),
    );
  }

  Widget _buildPointsHeader() {
    return VxBox(
      child: HStack([
        VStack([
          "Available Points".text.white.xs.make(),
          "25,450".text.color(gold).xl2.bold.make(),
        ]).expand(),
        Icon(Icons.stars, color: gold, size: 30),
      ]),
    ).p16.color(const Color(0xFF1A1A1A)).rounded.border(color: gold.withOpacity(0.3)).make();
  }

  Widget _buildCategoryHeader(String title) {
    return HStack([
      title.text.white.lg.bold.make().expand(),
      "View All".text.color(gold).xs.semiBold.make().onTap(() {}),
    ]).pOnly(bottom: 10);
  }

  Widget _buildHorizontalList(List<Map<String, String>> data, {required bool showTag, required BuildContext context}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: HStack(
        data.map((v) => _buildVoucherCard(v, showTag, context)).toList(),
      ),
    );
  }

Widget _buildVoucherCard(Map<String, String> voucher, bool showTag, BuildContext context) {
  return VxBox(
    child: Stack(
      children: [
        // 1. Image Layer
        Positioned.fill(
          child: VxBox().bgImage(DecorationImage(
            image: NetworkImage(voucher['bg'] ?? ""),
            fit: BoxFit.cover,
          )).withRounded(value: 12).make(),
        ),

        // 2. Left-Side Gradient for text contrast
        Positioned.fill(
          child: VxBox().withGradient(LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          )).withRounded(value: 12).make(),
        ),

        // 3. Content Layer
        VStack([
        HStack([
  voucher['shop']!.text.white.size(8).bold.uppercase.letterSpacing(1).make()
      .box.padding(const EdgeInsets.symmetric(horizontal: 8, vertical: 4))
      .color(const Color.fromARGB(215, 85, 85, 85).withOpacity(0.4)).roundedSM.make(),
  const Spacer(),
  if (showTag && voucher['tag']!.isNotEmpty)
    voucher['tag']!.text.color(gold).size(8).bold.make()
        .box
        .padding(const EdgeInsets.symmetric(horizontal: 8, vertical: 4)) // Matching padding
        .border(color: gold.withOpacity(0.5)) // Slightly subtle border
        .color(Colors.black.withOpacity(0.6)) // <--- ADDED BACKGROUND COLOR
        .roundedSM
        .make(),
]),
          const Spacer(),
          voucher['deal']!.text.white.lg.bold.maxLines(2).shadow(1, 1, 3, Colors.black).make(),
          8.heightBox,
          HStack([
            "${voucher['pts']} pts".text.color(gold).bold.lg.make().expand(),
            const Icon(Icons.arrow_circle_right_outlined, color: Colors.white, size: 24),
          ]),
        ]).p(16),
      ],
    ),
  )
  .width(280)
  .height(150)
  .withRounded(value: 12) // FIXED: Replaced .rounded(12)
  .margin(const EdgeInsets.only(right: 16, bottom: 10, top: 10))
  // --- HIGH VISIBILITY BORDER ---
  .border(color: Colors.white.withOpacity(0.6), width: 1.5) 
  .make()
  .onTap(() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VoucherDetailPage(voucher: voucher, gold: gold),
      ),
    );
  });
}
}

class VoucherDetailPage extends StatelessWidget {
  final Map<String, String> voucher;
  final Color gold;

  const VoucherDetailPage({super.key, required this.voucher, required this.gold});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20)
            .onTap(() => Navigator.pop(context)),
        title: "Voucher Details".text.white.sm.semiBold.make(),
        centerTitle: true,
      ),
      body: VStack([
        Stack(
          children: [
            VxBox()
                .height(context.screenHeight * 0.4)
                .bgImage(DecorationImage(
                  image: NetworkImage(voucher['bg']!),
                  fit: BoxFit.cover,
                ))
                .make()
                .wFull(context),
            Positioned.fill(
              child: VxBox().withGradient(LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.5), Colors.transparent, Colors.black],
              )).make(),
            ),
          ],
        ),

        VStack([
          voucher['shop']!.text.color(gold).semiBold.uppercase.make()
              .box.border(color: gold.withOpacity(0.5)).roundedSM.p4.make(),
          12.heightBox,
          voucher['deal']!.text.white.xl2.bold.make(),
          24.heightBox,
          
          "Description".text.white.lg.bold.make(),
          8.heightBox,
          // --- FIX: Changed withOpacity to color(Colors.white70) ---
          "This exclusive offer from ${voucher['shop']} allows you to enjoy ${voucher['deal']}. Once redeemed, a unique QR code will be generated for outlet verification."
              .text.color(Colors.white70).lineHeight(1.5).make(),
          
          24.heightBox,
          "Terms & Conditions".text.white.lg.bold.make(),
          8.heightBox,
          VStack([
            _bulletPoint("Valid for 30 days upon redemption."),
            _bulletPoint("Non-refundable and non-exchangeable for cash."),
            _bulletPoint("Subject to availability at the outlet."),
          ]),
        ]).p24().expand().scrollVertical(),

        VxBox(
          child: HStack([
            VStack([
              "Cost".text.white.xs.make(),
              "${voucher['pts']} pts".text.color(gold).xl.bold.make(),
            ]).expand(),
            "Redeem Now".text.black.bold.make()
                .box.color(gold).roundedSM
                .padding(const EdgeInsets.symmetric(horizontal: 40, vertical: 15))
                .make()
                .onTap(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: "Success: ${voucher['deal']} redeemed!".text.make()),
                  );
                }),
          ]).p16(),
        ).color(const Color(0xFF1A1A1A)).make(),
      ]),
    );
  }

  Widget _bulletPoint(String text) {
    return HStack([
      Icon(Icons.circle, color: gold, size: 6).pOnly(right: 8, top: 4),
      // --- FIX: Changed withOpacity to color(Colors.white70) ---
      text.text.color(Colors.white70).sm.make().expand(),
    ]).pOnly(bottom: 6);
  }
}