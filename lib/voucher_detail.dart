
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';


class VoucherDetailPage extends StatelessWidget {
  final Map<String, String> voucher;
  final Color gold;
  final int userPoints;

  const VoucherDetailPage({super.key, required this.voucher, required this.gold, required this.userPoints});

  @override
  Widget build(BuildContext context) {
    int requiredPts = int.parse(voucher['pts']!.replaceAll(",", ""));
    bool canAfford = userPoints >= requiredPts;

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
        // ... (Header Image part remains same as your original)
        Stack(
          children: [
            VxBox().height(context.screenHeight * 0.4).bgImage(DecorationImage(image: NetworkImage(voucher['bg']!), fit: BoxFit.cover)).make().wFull(context),
            Positioned.fill(child: VxBox().withGradient(LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(0.5), Colors.transparent, Colors.black])).make()),
          ],
        ),

        VStack([
          voucher['shop']!.text.color(gold).semiBold.uppercase.make().box.border(color: gold.withOpacity(0.5)).roundedSM.p4.make(),
          12.heightBox,
          voucher['deal']!.text.white.xl2.bold.make(),
          24.heightBox,
          "Description".text.white.lg.bold.make(),
          8.heightBox,
          "This exclusive offer from ${voucher['shop']} allows you to enjoy ${voucher['deal']}. Once redeemed, a unique QR code will be generated for outlet verification.".text.color(Colors.white70).lineHeight(1.5).make(),
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
              "${voucher['pts']} pts".text.color(canAfford ? gold : Colors.redAccent).xl.bold.make(),
            ]).expand(),
            (canAfford ? "Redeem Now" : "Insufficient Points")
                .text.color(canAfford ? Colors.black : Colors.white54).bold.make()
                .box.color(canAfford ? gold : Colors.grey.withOpacity(0.3)).roundedSM
                .padding(const EdgeInsets.symmetric(horizontal: 30, vertical: 15))
                .make()
                .onTap(canAfford ? () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: "Success: ${voucher['deal']} redeemed!".text.make()));
                } : null),
          ]).p16(),
        ).color(const Color(0xFF1A1A1A)).make(),
      ]),
    );
  }

  Widget _bulletPoint(String text) {
    return HStack([
      Icon(Icons.circle, color: gold, size: 6).pOnly(right: 8, top: 4),
      text.text.color(Colors.white70).sm.make().expand(),
    ]).pOnly(bottom: 6);
  }
}