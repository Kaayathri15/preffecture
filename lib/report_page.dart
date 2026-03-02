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

  bool _sortByMostPrefectures = true;

  // Participant list remains unchanged as requested
  final List<Participant> _participants = [
    Participant(name: "Takeshi K.", prefectures: 20),
    Participant(name: "Rothman Haron", prefectures: 19, isUser: true),
    Participant(name: "Syed Hussein", prefectures: 10),
    Participant(name: "Yu Ying Fong", prefectures: 9),
    Participant(name: "John Labu", prefectures: 5),
  ];

  // Data mapping for specific prefectures to match PrefectureDetail requirements
  final Map<String, Map<String, dynamic>> _prefectureData = {
    "Hokkaido": {
      "name": "Hokkaido",
      "region": "Hokkaido",
      "img": "https://images.pexels.com/photos/5195410/pexels-photo-5195410.jpeg",
      "jp": "北海道",
      "status": "active"
    },
    "Tokyo": {
      "name": "Tokyo",
      "region": "Kantō",
      "img": "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf",
      "jp": "東京都",
      "status": "active"
    },
    "Sendai": {
      "name": "Sendai",
      "region": "Tōhoku",
      "img": "https://images.unsplash.com/photo-1542931287-023b922fa89b?q=80&w=800",
      "jp": "仙台市",
      "status": "active"
    }
  };

  List<Participant> get _sortedParticipants {
    List<Participant> list = List.from(_participants);
    if (_sortByMostPrefectures) {
      list.sort((a, b) => b.prefectures.compareTo(a.prefectures));
    } else {
      list.sort((a, b) => b.points.compareTo(a.points));
    }
    return list;
  }

  void _navigateToDetail(BuildContext context, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrefectureDetail(
          data: data,
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
      body: VStack([
        "Tap a red marker to explore the prefecture"
            .text
            .gray500
            .italic
            .size(12)
            .make()
            .pOnly(left: 16, bottom: 4, top: 16),

        // Map Section
        SizedBox(
          height: 400,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(36.2048, 138.2529),
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
                  _buildMapMarker(context, const LatLng(43.0641, 141.3469), "Hokkaido"),
                  _buildMapMarker(context, const LatLng(38.2682, 140.8694), "Sendai"),
                  _buildMapMarker(context, const LatLng(35.6762, 139.6503), "Tokyo"),
                ],
              ),
            ],
          ),
        ).box.border(color: Colors.white10).withRounded(value: 16).clip(Clip.antiAlias).make().p16(),

        HStack([
          "Top 5 Participants".text.color(gold).semiBold.make(),
          const Spacer(),
          TextButton.icon(
            onPressed: () => setState(() => _sortByMostPrefectures = !_sortByMostPrefectures),
            icon: Icon(Icons.sort, color: gold, size: 16),
            label: (_sortByMostPrefectures ? "By Prefecture" : "By Points")
                .text.color(gold).size(12).make(),
          ),
        ]).pSymmetric(h: 16, v: 8),

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

  Marker _buildMapMarker(BuildContext context, LatLng point, String key) {
    return Marker(
      point: point,
      width: 40,
      height: 40,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Retrieves the full data map based on the key
          final data = _prefectureData[key] ?? {"name": key, "img": "https://via.placeholder.com/800"};
          _navigateToDetail(context, data);
        },
        child: Center(
          child: VxBox()
              .roundedFull
              .color(red)
              .border(color: Colors.white.withOpacity(0.5), width: 1.5)
              .size(12, 12)
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
        VxBox(child: (index + 1).text.white.bold.xl.makeCentered())
            .width(50)
            .height(50)
            .color(isFirst ? red : gold)
            .withRounded(value: 10)
            .make(),
        15.widthBox,
        VStack([
          HStack([
            person.name.text.white.bold.lg.make(),
            if (person.isUser) " (You)".text.gray500.sm.make(),
          ]),
          "Status: Active Journey".text.gray500.size(10).make(),
        ]).expand(),
        VStack([
          if (_sortByMostPrefectures)
            person.prefectures.toString().text.color(gold).semiBold.xl2.make()
          else
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