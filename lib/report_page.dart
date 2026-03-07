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
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final Color gold = const Color(0xFFC5A059);
  final Color red = const Color(0xFFE50914);

  final List<Participant> _participants = [
    Participant(name: "Takeshi K.", prefectures: 25),
    Participant(name: "Rothman Haron", prefectures: 19, isUser: true),
    Participant(name: "Syed Hussein", prefectures: 18),
    Participant(name: "Yu Ying Fong", prefectures: 15),
    Participant(name: "John Labu", prefectures: 12),
    Participant(name: "Aisha M.", prefectures: 10),
    Participant(name: "Kenji Sato", prefectures: 8),
    Participant(name: "Li Wei", prefectures: 7),
    Participant(name: "Sarah J.", prefectures: 5),
    Participant(name: "Hiroshi T.", prefectures: 3),
  ];

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: VStack([
          "Tap a red marker to explore".text.gray500.italic.size(12).make().p16(),

          // Map Section
          SizedBox(
            height: 300,
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(36.2048, 138.2529),
                initialZoom: 4.5,
              ),
              children: [
                TileLayer(urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'),
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

          "Top 10 Participants".text.color(gold).semiBold.xl.make().pSymmetric(h: 16),
          15.heightBox,

          // Ranking List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _participants.length,
            itemBuilder: (context, index) => _rankingTile(index, _participants[index]),
          ).pSymmetric(h: 16),

          150.heightBox, // Large bottom space for guaranteed scrolling
        ]).scrollVertical(),
      ),
    );
  }

  Marker _buildMapMarker(BuildContext context, LatLng point, String key) {
    return Marker(
      point: point,
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () {
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
              .shimmer(primaryColor: red),
        ),
      ),
    );
  }

Widget _rankingTile(int index, Participant person) {
    return VxBox(
      child: HStack([
        // Rank Number Box
        VxBox(child: (index + 1).text.white.bold.makeCentered())
            .width(35)
            .height(35)
            // Logic: Red for the user, Gold for everyone else
            .color(person.isUser ? red : gold) 
            .roundedSM
            .make(),
        15.widthBox,
        
        // Participant Name & Status
        VStack([
          person.name.text.white.semiBold.lg.make(),
          "Active Journey".text.gray500.size(10).make(),
        ]).expand(),
        
        const Icon(Icons.chevron_right, color: Colors.white24, size: 16),
      ]).p12(),
    )
    .border(color: Colors.white10)
    .withRounded(value: 12)
    .margin(const EdgeInsets.only(bottom: 12))
    .make();
  }
}