import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class VoucherDetailPage extends StatefulWidget {
  final Map<String, String> voucher;
  final Color gold;
  final int userPoints;

  const VoucherDetailPage({
    super.key,
    required this.voucher,
    required this.gold,
    required this.userPoints,
  });

  @override
  State<VoucherDetailPage> createState() => _VoucherDetailPageState();
}

class _VoucherDetailPageState extends State<VoucherDetailPage> {
  // Track if the voucher has been redeemed during this session
  bool _isInProgress = false;

  // Helper function to show the Serial Code Modal
  void _showRedemptionSuccess(BuildContext context) {
    final String serialCode =
        "VX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: VStack([
          VxBox().gray700.rounded.height(4).width(40).make().centered(),
          20.heightBox,

          "Redemption Successful!".text.white.xl2.bold.make().centered(),
          8.heightBox,
          "Present this code at the counter".text
              .color(Colors.white60)
              .sm
              .make()
              .centered(),
          40.heightBox,

          // Large Serial Code Display (Barcode removed)
          VxBox(
            child: serialCode.text
                .color(widget.gold)
                .letterSpacing(6)
                .xl4
                .bold
                .make()
                .centered(),
          )
              .p32
              .color(Colors.white.withOpacity(0.05))
              .rounded
              .border(color: widget.gold.withOpacity(0.3))
              .make(),

          40.heightBox,

          ElevatedButton(
            onPressed: () {
              // Set status to In Progress after closing
              setState(() {
                _isInProgress = true;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.gold,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: "Done".text.black.bold.make(),
          ),
          20.heightBox,
        ], axisSize: MainAxisSize.min),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int requiredPts = int.parse(widget.voucher['pts']!.replaceAll(",", ""));
    bool canAfford = widget.userPoints >= requiredPts;

    // Logic for button appearance
    String buttonText = "Redeem Now";
    Color buttonColor = widget.gold;
    Color textColor = Colors.black;

    if (_isInProgress) {
      buttonText = "In Progress";
      buttonColor = Colors.blueGrey.withOpacity(0.5);
      textColor = Colors.white;
    } else if (!canAfford) {
      buttonText = "Insufficient Points";
      buttonColor = Colors.grey.withOpacity(0.3);
      textColor = Colors.white54;
    }

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
        // Header Image Section
        Stack(
          children: [
            VxBox()
                .height(context.screenHeight * 0.4)
                .bgImage(
                  DecorationImage(
                    image: NetworkImage(widget.voucher['bg']!),
                    fit: BoxFit.cover,
                  ),
                )
                .make()
                .wFull(context),
            Positioned.fill(
              child: VxBox()
                  .withGradient(
                    LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                        Colors.black,
                      ],
                    ),
                  )
                  .make(),
            ),
          ],
        ),

        // Main Content Section
        VStack([
          widget.voucher['shop']!.text
              .color(widget.gold)
              .semiBold
              .uppercase
              .make()
              .box
              .border(color: widget.gold.withOpacity(0.5))
              .roundedSM
              .p4
              .make(),
          12.heightBox,
          widget.voucher['deal']!.text.white.xl2.bold.make(),
          24.heightBox,
          "Description".text.white.lg.bold.make(),
          8.heightBox,
          "This exclusive offer from ${widget.voucher['shop']} allows you to enjoy ${widget.voucher['deal']}. Once redeemed, a unique serial code will be generated for outlet verification."
              .text
              .color(Colors.white70)
              .lineHeight(1.5)
              .make(),
          24.heightBox,
          "Terms & Conditions".text.white.lg.bold.make(),
          8.heightBox,
          VStack([
            _bulletPoint("Lorem ipsum dolor sit amet consectetur adipiscing elit. "),
            _bulletPoint("Consectetur adipiscing elit quisque faucibus ex sapien vitae"),
            _bulletPoint("Ex sapien vitae pellentesque sem placerat in id"),
          ]),
        ]).p24().expand().scrollVertical(),

        // Bottom Action Bar
        VxBox(
          child: HStack([
            VStack([
              "Cost".text.white.xs.make(),
              "${widget.voucher['pts']} pts".text
                  .color(canAfford ? widget.gold : Colors.redAccent)
                  .xl
                  .bold
                  .make(),
            ]).expand(),

            // UPDATED BUTTON
            buttonText.text
                .color(textColor)
                .bold
                .make()
                .box
                .color(buttonColor)
                .roundedSM
                .padding(const EdgeInsets.symmetric(horizontal: 30, vertical: 15))
                .make()
                .onTap(
                  (canAfford && !_isInProgress) 
                      ? () => _showRedemptionSuccess(context) 
                      : null,
                ),
          ]).p16(),
        ).color(const Color(0xFF1A1A1A)).make(),
      ]),
    );
  }

  Widget _bulletPoint(String text) {
    return HStack([
      Icon(Icons.circle, color: widget.gold, size: 6).pOnly(right: 8, top: 4),
      text.text.color(Colors.white70).sm.make().expand(),
    ]).pOnly(bottom: 6);
  }
}