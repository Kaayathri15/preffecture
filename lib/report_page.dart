import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:velocity_x/velocity_x.dart';
import 'prefecture_detail.dart';

class Participant {
  final String name;
  final int prefectures;
  final bool isUser;

  Participant({
    required this.name,
    required this.prefectures,
    this.isUser = false,
  });

  // 1 Prefecture = 2000 Points
  int get points => prefectures * 2000;
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  final Color gold = const Color(0xFFC5A059);
  final Color red = const Color(0xFFE50914);

  // State variable for filtering
  bool _sortByMostPrefectures = true;

  final List<Participant> _participants = [
    Participant(name: "Takeshi K.", prefectures: 20),
    Participant(name: "Rothman Haron", prefectures: 19, isUser: true),
    Participant(name: "Syed Hussein", prefectures: 10),
    Participant(name: "Yu Ying Fong", prefectures: 9),
    Participant(name: "John Labu", prefectures: 5),
  ];

  List<Participant> get _sortedParticipants {
    List<Participant> list = List.from(_participants);
    if (_sortByMostPrefectures) {
      list.sort((a, b) => b.prefectures.compareTo(a.prefectures));
    } else {
      list.sort((a, b) => b.points.compareTo(a.points));
    }
    return list;
  }

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
        "Tap a red marker to explore the prefecture".text.gray500.italic
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
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
              MarkerLayer(
                markers: [
                  _buildMapMarker(context, LatLng(43.0641, 141.3469), "Hokkaido", "https://images.unsplash.com/photo-1590483739741-418088009b0a?q=80&w=800"),
                  _buildMapMarker(context, LatLng(38.2682, 140.8694), "Sendai", "https://images.unsplash.com/photo-1542931287-023b922fa89b?q=80&w=800"),
                  _buildMapMarker(context, LatLng(35.6762, 139.6503), "Tokyo", "https://images.unsplash.com/photo-1503899036084-c55cdd92da26?q=80&w=800"),
                  _buildMapMarker(context, LatLng(34.6937, 135.5023), "Osaka", "https://images.unsplash.com/photo-1590559899731-a3828df9a954?q=80&w=800"),
                  _buildMapMarker(context, LatLng(33.5904, 130.4017), "Fukuoka", "https://images.unsplash.com/photo-1571212411030-4e448b36878b?q=80&w=800"),
                ],
              ),
            ],
          ),
        ).box.border(color: Colors.white10).withRounded(value: 16).clip(Clip.antiAlias).make().p16(),

        // Ranking Title & Sort Filter
        HStack([
          "Top 5 Participants".text.color(gold).semiBold.make(),
          const Spacer(),
          // Toggle sorting
          TextButton.icon(
            onPressed: () => setState(() => _sortByMostPrefectures = !_sortByMostPrefectures),
            icon: Icon(Icons.sort, color: gold, size: 16),
            label: (_sortByMostPrefectures ? "By Prefecture" : "By Points")
                .text.color(gold).size(10).make(),
          ),
        ]).pSymmetric(h: 16, v: 8),

        // Ranking List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _sortedParticipants.length,
          itemBuilder: (context, index) => _rankingTile(index, _sortedParticipants[index]),
        ).pSymmetric(h: 16),

        40.heightBox,
      ]).scrollVertical(),
    );
  }

  Marker _buildMapMarker(BuildContext context, LatLng point, String name, String imgUrl) {
    return Marker(
      point: point,
      width: 40,
      height: 40,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _navigateToDetail(context, name, imgUrl),
        child: Center(
          child: VxBox().roundedFull
              .color(red)
              .border(color: Colors.white.withOpacity(0.5), width: 1.5)
              .size(10, 10)
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

  Widget _rankingTile(int index, Participant person) {
    bool isFirst = index == 0;

    return VxBox(
      child: HStack([
        // Rank Indicator
        VxBox(child: (index + 1).text.white.bold.xl.makeCentered())
            .width(50).height(50)
            .color(isFirst ? red : gold)
            .withRounded(value: 10).make(),
        
        15.widthBox,
        
        // Name and Statistics
        VStack([
          HStack([
            person.name.text.white.bold.lg.make(),
            if (person.isUser) " (You)".text.gray500.sm.make(),
          ]),
          // Always show this secondary info
          "Participant Status: Active".text.gray500.size(9).make(),
        ]).expand(),
        
        // DYNAMIC DATA DISPLAY
        VStack([
          if (_sortByMostPrefectures) 
            // Show Prefecture Count
            person.prefectures.toString().text.color(gold).semiBold.xl2.make()
          else 
            // Show Points
            person.points.toString().numCurrency.text.color(gold).semiBold.xl.make(),
          
          (_sortByMostPrefectures ? "Prefectures" : "Points")
              .text.gray500.size(10).make(),
        ], crossAlignment: CrossAxisAlignment.end),
      ]).p12(),
    )
    .width(double.infinity)
    .border(color: isFirst ? gold.withOpacity(0.6) : Colors.white10, width: 1)
    .withRounded(value: 12)
    .margin(const EdgeInsets.only(bottom: 12))
    .make();
  }
}