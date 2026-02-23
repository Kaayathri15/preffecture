
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:preffecture/voucher_detail.dart';


class AllVouchersPage extends StatelessWidget {
  final String category;
  final List<Map<String, String>> vouchers;
  final int userPoints;
  final Color gold;

  const AllVouchersPage({super.key, required this.category, required this.vouchers, required this.userPoints, required this.gold});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: category.text.white.bold.make(),
        leading: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20).onTap(() => Navigator.pop(context)),
      ),
     body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vouchers.length,
        itemBuilder: (context, index) {
          final v = vouchers[index];
          int pts = int.parse(v['pts']!.replaceAll(",", ""));
          bool canAfford = userPoints >= pts;

          return VxBox(
            child: HStack([
              // --- UPDATED THUMBNAIL WITH LOCK ---
              Stack(
                alignment: Alignment.center,
                children: [
                  VxBox()
                      .width(80)
                      .height(80)
                      .bgImage(DecorationImage(
                        image: NetworkImage(v['bg']!),
                        fit: BoxFit.cover,
                      ))
                      .withRounded(value: 8)
                      .make(),
                  
                  // Dark overlay and Lock icon for insufficient points
                  if (!canAfford)
                    VxBox(
                      child: const Icon(Icons.lock, color: Colors.white, size: 24),
                    )
                    .width(80)
                    .height(80)
                    .color(Colors.black.withOpacity(0.6)) // Semi-transparent black
                    .withRounded(value: 8)
                    .make(),
                ],
              ),
              // ------------------------------------

              15.widthBox,
              VStack([
                v['shop']!.text.color(gold).xs.bold.uppercase.make(),
                v['deal']!.text.white.bold.make(),
                5.heightBox,
                "${v['pts']} pts".text.color(canAfford ? Colors.white : Colors.redAccent).size(12).make(),
              ]).expand(),
              Icon(canAfford ? Icons.arrow_forward_ios : Icons.arrow_forward_ios, color: Colors.white38, size: 14),
            ]).p12(),
          ).color(const Color(0xFF1A1A1A)).rounded.margin(const EdgeInsets.only(bottom: 12))
          .border(color: canAfford ? Colors.transparent : Colors.redAccent.withOpacity(0.2))
          .make()
          .onTap(() {
             Navigator.push(context, MaterialPageRoute(builder: (context) => VoucherDetailPage(voucher: v, gold: gold, userPoints: userPoints)));
          });
        },
      ),
    );
  }
}