import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorsPage extends StatelessWidget {
  const SponsorsPage({super.key});

  final List<Map<String, String>> sponsors = const [
    {"name": "Sony", "logo": "https://logo.clearbit.com/sony.com", "url": "https://www.sony.com"},
    {"name": "Toyota", "logo": "https://logo.clearbit.com/toyota.jp", "url": "https://www.toyota.com"},
    {"name": "Uniqlo", "logo": "https://logo.clearbit.com/uniqlo.com", "url": "https://www.uniqlo.com"},
    {"name": "Nintendo", "logo": "https://logo.clearbit.com/nintendo.com", "url": "https://www.nintendo.com"},
    {"name": "Suntory", "logo": "https://logo.clearbit.com/suntory.com", "url": "https://www.suntory.com"},
    {"name": "Asics", "logo": "https://logo.clearbit.com/asics.com", "url": "https://www.asics.com"},
  ];

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xFFC5A059);

    return Scaffold(
      backgroundColor: Colors.black,
      // REMOVED AppBar since it's now in MainWrapper
      body: VStack([
        // Header Section
        VStack([
          "Official Partners".text.color(gold).extraBold.xl3.make(),
          "Supporting the Golden Journey 2026".text.gray500.medium.make(),
        ]).p16().pOnly(top: 20),

        // Grid
        GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2, // Slightly wider cards
          ),
          itemCount: sponsors.length,
          itemBuilder: (context, index) => _buildSponsorCard(sponsors[index], index, gold),
        ).expand(),
      ]),
    );
  }

  Widget _buildSponsorCard(Map<String, String> sponsor, int index, Color gold) {
    return TweenAnimationBuilder<double>(
      // Staggered delay: index * 100ms
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutQuart,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)), // Slide up effect
            child: child,
          ),
        );
      },
      child: VxBox(
        child: ZStack([
          // Brand Name background (Subtle)
          sponsor['name']!
              .text
              .uppercase
              .extraBlack
              .size(10)
              .color(Colors.white.withOpacity(0.03))
              .make()
              .positioned(bottom: 5, right: 8),
          
          // The Logo
          Image.network(
            sponsor['logo']!,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => 
                sponsor['name']!.text.white.bold.makeCentered(),
          ).p24(),
        ]),
      )
      .color(Colors.white.withOpacity(0.07)) // Glassy look
      .roundedLg
      .border(color: Colors.white.withOpacity(0.1), width: 0.5)
      .make()
      .onTap(() => _launchURL(sponsor['url']!)),
    );
  }
}