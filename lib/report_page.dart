import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:velocity_x/velocity_x.dart';
import 'prefecture_detail.dart'; // Ensure this matches your filename

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  final Color gold = const Color(0xFFC5A059);
  final Color red = const Color(0xFFE50914);

  void _navigateToDetail(BuildContext context, String name, String imgUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrefectureDetail(
          data: {'name': name, 'img': imgUrl},
          onBack: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final japanBounds = LatLngBounds(LatLng(24.0, 123.0), LatLng(46.0, 149.0));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        title: "Prefecture Coverage".text.color(gold).bold.make(),
      ),
      body: VStack([
        "Tap a red marker to explore the preffecture".text.gray500.italic
            .size(10)
            .make()
            .pOnly(left: 16, bottom: 4),

        // Map Section
        SizedBox(
          height: 400,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(36.2048, 138.2529),
              initialZoom: 5.0,
              minZoom: 4.5,
              maxZoom: 7.0,
              maxBounds: japanBounds,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
              MarkerLayer(
                markers: [
                  _buildMapMarker(
                    context,
                    LatLng(43.0641, 141.3469),
                    "Hokkaido",
                    "https://images.unsplash.com/photo-1590483739741-418088009b0a?q=80&w=800",
                  ),
                  _buildMapMarker(
                    context,
                    LatLng(38.2682, 140.8694),
                    "Sendai",
                    "https://images.unsplash.com/photo-1542931287-023b922fa89b?q=80&w=800",
                  ),
                  _buildMapMarker(
                    context,
                    LatLng(35.6762, 139.6503),
                    "Tokyo",
                    "https://images.unsplash.com/photo-1503899036084-c55cdd92da26?q=80&w=800",
                  ),
                  _buildMapMarker(
                    context,
                    LatLng(34.6937, 135.5023),
                    "Osaka",
                    "https://images.unsplash.com/photo-1590559899731-a3828df9a954?q=80&w=800",
                  ),
                  _buildMapMarker(
                    context,
                    LatLng(33.5904, 130.4017),
                    "Fukuoka",
                    "https://images.unsplash.com/photo-1571212411030-4e448b36878b?q=80&w=800",
                  ),
                ],
              ),
            ],
          ),
        ).box.border(color: Colors.white10).withRounded(value: 16).clip(Clip.antiAlias).make().p16(),

        // Ranking Title
        HStack([
          "Yearly Grand Prize Ranking".text.color(gold).semiBold.make(),
          const Spacer(),
          "Global Top 5".text.gray500.size(10).make(),
        ]).pSymmetric(h: 16, v: 8),

        // Ranking List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) => _rankingTile(index, gold, red),
        ).pSymmetric(h: 16),

        40.heightBox,
      ]).scrollVertical(),
    );
  }

  Marker _buildMapMarker(
    BuildContext context,
    LatLng point,
    String name,
    String imgUrl,
  ) {
    return Marker(
      point: point,
      width: 40, // Sufficient width for the hit area
      height: 40, // Sufficient height for the hit area
      child: GestureDetector(
        behavior:
            HitTestBehavior.opaque, // Makes the entire 40x40 area tappable
        onTap: () => _navigateToDetail(context, name, imgUrl),
        child: Center(
          child: VxBox().roundedFull
              .color(red)
              .border(color: Colors.white.withOpacity(0.5), width: 1.5)
              .size(10, 10) // Slightly larger dot for better visibility
              .make()
              .shimmer(
                primaryColor: red,
                secondaryColor: Colors.white.withOpacity(0.4),
                duration: const Duration(milliseconds: 1500),
              ),
        ),
      ),
    );
  }

  Widget _rankingTile(int index, Color gold, Color red) {
    final List<String> names = [
      "Takeshi K.",
      "Rothman Haron",
      "Syed Hussein",
      "Yu Ying Fong",
      "John Labu",
    ];
    final List<int> vouchers = [42, 36, 30, 28, 20];
    final List<String> pointsList = [
      "12,450",
      "10,510",
      "9,430",
      "8,551",
      "7,254",
    ];

    bool isFirst = index == 0;
    bool isUser = index == 1;

    return VxBox(
          child: HStack([
            VxBox(child: (index + 1).text.white.bold.xl.makeCentered())
                .width(50)
                .height(50)
                .color(isFirst ? red : gold)
                .withRounded(value: 10)
                .make(),
            15.widthBox,
            VStack([
              HStack([
                names[index].text.white.bold.lg.make(),
                if (isUser) " (You)".text.gray500.sm.make(),
              ]),
              "${vouchers[index]} Vouchers Collected".text.gray400
                  .size(10)
                  .make(),
            ]).expand(),
            VStack([
              pointsList[index].text.color(gold).semiBold.xl.make(),
              "Points".text.gray500.size(10).make(),
            ], crossAlignment: CrossAxisAlignment.end),
          ]).p12(),
        )
        .width(double.infinity)
        .border(
          color: isFirst ? gold.withOpacity(0.6) : Colors.white10,
          width: 1,
        )
        .withRounded(value: 12)
        .margin(const EdgeInsets.only(bottom: 12))
        .make();
  }
}
