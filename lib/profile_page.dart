import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:preffecture/services/auth_service.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color gold = const Color(0xFFC5A059);

  bool _sendNotifications = true;
  bool loading = true;

  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final result = await AuthService.getUser();

    if (result["success"]) {
      setState(() {
        user = result["data"]["user"];
        loading = false;
      });
    }
  }

  String get userName =>
      "${user?["first_name"] ?? ""} ${user?["last_name"] ?? ""}";

  String get phoneNumber => user?["phone_number"] ?? "";

  String get userId {
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    return digitsOnly.length >= 6
        ? digitsOnly.substring(digitsOnly.length - 6)
        : digitsOnly;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: VStack([
          /// HEADER
          VStack([
            30.heightBox,

            VxBox(child: Icon(Icons.person, size: 50, color: gold))
                .width(100)
                .height(100)
                .roundedFull
                .border(color: gold, width: 2)
                .makeCentered(),

            16.heightBox,

            userName.text.white.xl2.bold.makeCentered(),

            4.heightBox,

            userId.text.color(gold).semiBold.size(14).makeCentered(),
          ]).p24().wFull(context),

          /// PERSONAL DETAILS
          "Personal Details".text
              .color(gold)
              .semiBold
              .make()
              .pOnly(left: 16, bottom: 8),

          VStack([
                _buildInfoTile("User ID", userId, Icons.fingerprint),

                _divider(),

                _buildInfoTile(
                  "First Name",
                  user?["first_name"] ?? "",
                  Icons.person_outline,
                ),

                _divider(),

                _buildInfoTile(
                  "Last Name",
                  user?["last_name"] ?? "",
                  Icons.person_outline,
                ),

                _divider(),

                _buildInfoTile(
                  "Email Address",
                  user?["email"] ?? "",
                  Icons.email_outlined,
                ),

                _divider(),

                _buildPhoneTile("+60", phoneNumber),

                _divider(),

                _buildInfoTile(
                  "Nationality",
                  user?["nationality"] ?? "",
                  Icons.public_outlined,
                ),

                _divider(),

                _buildInfoTile(
                  "Gender",
                  user?["gender"] ?? "",
                  Icons.wc_outlined,
                ),
              ]).box
              .color(Colors.white.withOpacity(0.05))
              .roundedLg
              .margin(const EdgeInsets.symmetric(horizontal: 16))
              .make(),

          24.heightBox,

          /// STATS
          HStack([
                _buildStatItem("27", "Prefectures"),
                _buildStatItem("3,000", "Current Points"),
                _buildStatItem("0", "Vouchers"),
              ], alignment: MainAxisAlignment.spaceEvenly).box
              .border(color: gold.withOpacity(0.3))
              .roundedLg
              .p16
              .width(double.infinity)
              .margin(const EdgeInsets.symmetric(horizontal: 16))
              .make(),

          24.heightBox,

          /// PRIVACY & SECURITY
          "Privacy & Security".text
              .color(gold)
              .semiBold
              .make()
              .pOnly(left: 16, bottom: 8),

          VStack([
                _buildActionItem(Icons.edit, "Edit Profile", () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfilePage(user: user),
                    ),
                  );

                  if (result == true) {
                    loadUser();
                  }
                }),

                _divider(),

                _buildActionItem(Icons.lock_outline, "Change Password", () {
                  debugPrint("Change password");
                }),

                _divider(),

                HStack([
                  Icon(
                    Icons.notifications_none_outlined,
                    color: gold,
                    size: 22,
                  ),
                  20.widthBox,
                  "Push Notifications".text.white.lg.make().expand(),
                  Switch(
                    value: _sendNotifications,
                    activeColor: gold,
                    onChanged: (val) =>
                        setState(() => _sendNotifications = val),
                  ),
                ]).pSymmetric(h: 16, v: 8),
              ]).box
              .color(Colors.white.withOpacity(0.05))
              .roundedLg
              .margin(const EdgeInsets.symmetric(horizontal: 16))
              .make(),

          32.heightBox,

          /// LOGOUT
          "Logout".text.red500.bold
              .makeCentered()
              .box
              .border(color: Colors.red.withOpacity(0.3))
              .roundedLg
              .p12
              .margin(const EdgeInsets.symmetric(horizontal: 16))
              .make()
              .onTap(() {
                debugPrint("Logout tapped");
              }),

          40.heightBox,
        ]).scrollVertical(),
      ),
    );
  }

  /// HELPERS

  Widget _divider() =>
      Divider(color: Colors.white.withOpacity(0.05), indent: 50, height: 1);

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

        HStack([12.widthBox, number.text.white.lg.semiBold.make()]),
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

  Widget _buildStatItem(String value, String label) {
    return VStack([
      value.text.white.xl.bold.make(),
      label.text.gray500.size(10).make(),
    ], crossAlignment: CrossAxisAlignment.center);
  }
}
