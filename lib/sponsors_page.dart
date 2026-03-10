import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorsPage extends StatelessWidget {
  const SponsorsPage({super.key});

  // These paths are verified against your VS Code sidebar screenshot
  final List<Map<String, String>> sponsors = const [
    // {"name": "TOHO", "logo": "assets/images/toho-logo.png", "url": "https://www.toho.co.jp"},
    {"name": "CASIO", "logo": "assets/images/casio-logo.png", "url": "https://www.casio.com"},
    // {"name": "UNIQLO", "logo": "assets/images/uniqlo-logo.png", "url": "https://www.uniqlo.com"},
    {"name": "G-SHOCK", "logo": "assets/images/g-shock.png", "url": "https://www.g-shock.com"},
    // FIXED: Using exact name from your 'General Info' screenshot
    {"name": "SUNTORY", "logo": "assets/images/suntory-logo.png", "url": "https://www.suntory.com"},
    // FIXED: Filename in your sidebar is 'japan-airline.png' (no 's')
    {"name": "JAPAN AIRLINE", "logo": "assets/images/japan-airline.png", "url": "https://www.jal.co.jp"},
    {"name": "SHISEIDO", "logo": "assets/images/shisheido-logo.png", "url": "https://www.shiseido.com"},
    {"name": "MITSUBISHI", "logo": "assets/images/mitsubishi-logo.webp", "url": "https://www.mitsubishi.com"},
  ];

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: sponsors.length,
        itemBuilder: (context, index) => _buildSponsorCard(sponsors[index], index),
      ),
    );
  }

 Widget _buildSponsorCard(Map<String, String> sponsor, int index) {
  return VxBox(
    child: ZStack([
      // 1. Logo Container with Padding and Containment
      Padding(
        padding: const EdgeInsets.all(24.0), // Provides ample space around the logo
        child: Image.asset(
          sponsor['logo']!,
          fit: BoxFit.contain, // FIX: Ensures the logo is fully visible without being cropped
          errorBuilder: (context, error, stackTrace) =>
              sponsor['name']!.text.white.semiBold.makeCentered(),
        ),
      ).centered(),

      // 2. Branding Watermark
      sponsor['name']!
          .text
          .extraBlack
          .size(10)
          .color(Colors.white.withOpacity(0.15))
          .make()
          .positioned(bottom: 12, right: 12),
    ]),
  )
  .color(Colors.black) // FIX: Sets the specific card background to pure black
  .withRounded(value: 24)
  .border(color: Colors.white.withOpacity(0.1), width: 1.5) // Adds a subtle border for definition
  .make()
  .onTap(() => _launchURL(sponsor['url']!));
}
}




