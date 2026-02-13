  
  
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color gold = const Color(0xFFC5A059);

    return Scaffold(
      backgroundColor: Colors.black,
      body: VStack([
        // --- 1. HEADER SECTION (AVATAR & NAME) ---
        VStack([
          30.heightBox,
          VxBox(
            child: Icon(Icons.person, size: 50, color: gold),
          )
          .width(100)
          .height(100)
          .roundedFull
          .border(color: gold, width: 2)
          .makeCentered(),
          
          16.heightBox,
          "Rothman Haron".text.white.xl2.bold.makeCentered(),
          "@rothman_travels".text.gray500.sm.makeCentered(),
          8.heightBox,
          "Platinum Member".text.color(gold).semiBold.makeCentered(),
        ]).p24().wFull(context),

        // --- 2. ACCOUNT INFORMATION SECTION ---
        "Account Information".text.color(gold).semiBold.make().pOnly(left: 16, bottom: 8),
        
        VStack([
          _buildInfoTile("Username", "Rothman Haron", Icons.alternate_email, gold),
          Divider(color: Colors.white.withOpacity(0.05), indent: 50),
          _buildInfoTile("Email Address", "rothman.h@example.com", Icons.email_outlined, gold),
        ])
        .box
        .color(Colors.white.withOpacity(0.05))
        .roundedLg
        .width(double.infinity) // Correct: width inside the box config
        .margin(const EdgeInsets.symmetric(horizontal: 16))
        .make(),

        24.heightBox,

        // --- 3. STATS SECTION ---
        HStack([
          _buildStatItem("27", "Prefectures", gold),
          _buildStatItem("10,510", "Total Points", gold),
          _buildStatItem("36", "Vouchers", gold),
        ], alignment: MainAxisAlignment.spaceEvenly)
        .box
        .border(color: gold.withOpacity(0.3))
        .roundedLg
        .p16
        .width(double.infinity)
        .margin(const EdgeInsets.symmetric(horizontal: 16))
        .make(),

        24.heightBox,

        // --- 4. SETTINGS & LOGOUT ---
        VStack([
          _buildMenuItem(Icons.settings, "Privacy Settings", gold),
          
          32.heightBox,
          
          // Logout Button
          "Logout".text.red500.bold.makeCentered()
              .box
              .border(color: Colors.red.withOpacity(0.3))
              .roundedLg
              .p12
              .width(double.infinity)
              .make()
              .onTap(() {
                // Add your logout logic here
                print("User Logged Out");
              }),
        ]).p16(),
        
        20.heightBox,
      ]).scrollVertical(),
    );
  }

  // Helper for Email/Username Tiles
  Widget _buildInfoTile(String label, String value, IconData icon, Color gold) {
    return HStack([
      Icon(icon, color: gold.withOpacity(0.7), size: 20),
      16.widthBox,
      VStack([
        label.text.gray500.size(10).make(),
        value.text.white.lg.semiBold.make(),
      ]),
    ]).p12();
  }

  // Helper for Stats
  Widget _buildStatItem(String value, String label, Color gold) {
    return VStack([
      value.text.white.xl.bold.make(),
      label.text.gray500.size(10).make(),
    ], crossAlignment: CrossAxisAlignment.center);
  }

  // Helper for Menu Items
  Widget _buildMenuItem(IconData icon, String title, Color gold) {
    return HStack([
      Icon(icon, color: gold, size: 22),
      20.widthBox,
      title.text.white.lg.make().expand(),
      const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
    ])
    .p16()
    .box
    .border(color: Colors.white10)
    .withRounded(value: 12)
    .margin(const EdgeInsets.only(bottom: 12))
    .make();
  }
}