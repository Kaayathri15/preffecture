// lib/widgets/marquee_brands.dart
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MarqueeBrands extends StatefulWidget {
  final List<Map<String, String>> partners;
  const MarqueeBrands({super.key, required this.partners});

  @override
  State<MarqueeBrands> createState() => _MarqueeBrandsState();
}

class _MarqueeBrandsState extends State<MarqueeBrands> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scroll());
  }

  void _scroll() {
    if (!_scrollController.hasClients) return;
    double maxExtent = _scrollController.position.maxScrollExtent;
    double distance = maxExtent - _scrollController.offset;
    int durationInMs = (distance * 40).toInt();

    _scrollController
        .animateTo(
          maxExtent,
          duration: Duration(milliseconds: durationInMs),
          curve: Curves.linear,
        )
        .then((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0);
            _scroll();
          }
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Logic: Triple the list for a seamless loop effect
    final list = [...widget.partners, ...widget.partners, ...widget.partners];

    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final partner = list[index];
        final String name = partner['name']!;

        final bool isBlackBrand =
            name == "G-SHOCK" || name == "SHISEIDO" || name == "HOUSE";

        final Color bgColor = isBlackBrand ? Colors.black : Colors.white;
        final Color borderColor = isBlackBrand ? Colors.white24 : Colors.transparent;

        return Container(
          width: 120,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Image.asset(
            partner['logo']!,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return name.text
                  .color(isBlackBrand ? Colors.white : Colors.black)
                  .xs
                  .semiBold
                  .makeCentered();
            },
          ),
        );
      },
    );
  }
}