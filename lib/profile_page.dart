import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _sendNotifications = true;
  final Color gold = const Color(0xFFC5A059);

  // Sample Data
  final String _userName = "Rothman Haron";
  final String _phoneNumber = "+60 12-345 6789";

  // Logic: Extract only the last 6 numeric digits
  String get _userId {
    // 1. Remove all non-numeric characters (removes +, -, spaces, and letters)
    String digitsOnly = _phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    // 2. Return the last 6 digits, or the whole string if shorter than 6
    return digitsOnly.length >= 6 
        ? digitsOnly.substring(digitsOnly.length - 6) 
        : digitsOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: VStack([
          // --- 1. HEADER SECTION ---
          VStack([
            30.heightBox,
            VxBox(child: Icon(Icons.person, size: 50, color: gold))
                .width(100)
                .height(100)
                .roundedFull
                .border(color: gold, width: 2)
                .makeCentered(),
            16.heightBox,
            _userName.text.white.xl2.bold.makeCentered(),
            4.heightBox,
            // Displaying only the 6-digit numeric ID
            ""
                .text.color(gold).semiBold.size(14).makeCentered(),
          ]).p24().wFull(context),

          // --- 2. PERSONAL DETAILS ---
          "Personal Details".text.color(gold).semiBold.make().pOnly(left: 16, bottom: 8),
          VStack([
            _buildInfoTile("User ID", _userId, Icons.fingerprint),
            _divider(),
            _buildInfoTile("First Name", "Rothman", Icons.person_outline),
            _divider(),
            _buildInfoTile("Last Name", "Haron", Icons.person_outline),
            _divider(),
            _buildInfoTile("Email Address", "rothman.h@example.com", Icons.email_outlined),
            _divider(),
            _buildPhoneTile("+60", _phoneNumber),
            _divider(),
            _buildInfoTile("Nationality", "Malaysian", Icons.public_outlined),
            _divider(),
            _buildInfoTile("Gender", "Male", Icons.wc_outlined),
          ])
          .box.color(Colors.white.withOpacity(0.05)).roundedLg
          .margin(const EdgeInsets.symmetric(horizontal: 16)).make(),

          24.heightBox,

          // --- 3. STATS SECTION ---
          HStack([
            _buildStatItem("27", "Prefectures", gold),
            _buildStatItem("3,000", "Current Points", gold),
            _buildStatItem("0", "Vouchers", gold),
          ], alignment: MainAxisAlignment.spaceEvenly)
          .box.border(color: gold.withOpacity(0.3)).roundedLg.p16
          .width(double.infinity).margin(const EdgeInsets.symmetric(horizontal: 16)).make(),

          24.heightBox,

          // --- 4. PRIVACY & SECURITY ---
          "Privacy & Security".text.color(gold).semiBold.make().pOnly(left: 16, bottom: 8),
          VStack([
            _buildActionItem(Icons.lock_outline, "Change Password", () {
              debugPrint("Navigate to Change Password");
            }),
            _divider(),
            HStack([
              Icon(Icons.notifications_none_outlined, color: gold, size: 22),
              20.widthBox,
              "Push Notifications".text.white.lg.make().expand(),
              Switch(
                value: _sendNotifications,
                activeColor: gold,
                onChanged: (val) => setState(() => _sendNotifications = val),
              ),
            ]).pSymmetric(h: 16, v: 8),
          ])
          .box.color(Colors.white.withOpacity(0.05)).roundedLg
          .margin(const EdgeInsets.symmetric(horizontal: 16)).make(),

          32.heightBox,

          // --- 5. LOGOUT ---
          "Logout".text.red500.bold.makeCentered()
              .box.border(color: Colors.red.withOpacity(0.3)).roundedLg.p12
              .margin(const EdgeInsets.symmetric(horizontal: 16)).make()
              .onTap(() => debugPrint("User Logged Out")),
          
          40.heightBox,
        ]).scrollVertical(),
      ),
    );
  }

  // --- HELPERS ---

  Widget _divider() => Divider(color: Colors.white.withOpacity(0.05), indent: 50, height: 1);

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return HStack([
      Icon(icon, color: gold.withOpacity(0.7), size: 20),
      16.widthBox,
      VStack([
        label.text.gray500.size(10).make(),
        value.text.white.lg.semiBold.make(),
      ]),
    ]).p12();
  }

  Widget _buildPhoneTile(String code, String number) {
    return HStack([
      Icon(Icons.phone_outlined, color: gold.withOpacity(0.7), size: 20),
      16.widthBox,
      VStack([
        "Phone Number".text.gray500.size(10).make(),
        HStack([
          // code.text.color(gold).bold.make()
          //     .box.p4.roundedSM.color(Colors.white.withOpacity(0.1)).make(),
          12.widthBox,
          number.text.white.lg.semiBold.make(),
        ]),
      ]),
    ]).p12();
  }

  Widget _buildActionItem(IconData icon, String title, VoidCallback onTap) {
    return HStack([
      Icon(icon, color: gold, size: 22),
      20.widthBox,
      title.text.white.lg.make().expand(),
      const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
    ]).p16().onTap(onTap);
  }

  Widget _buildStatItem(String value, String label, Color goldColor) {
    return VStack([
      value.text.white.xl.bold.make(),
      label.text.gray500.size(10).make(),
    ], crossAlignment: CrossAxisAlignment.center);
  }
}