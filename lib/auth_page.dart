import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:preffecture/main.dart'; 

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  final Color gold = const Color(0xFFC5A059);
  final Color red = const Color(0xFFE50914);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String dummyEmail = "user@gold.com";
  final String dummyPassword = "password123";

  void _handleAuth() {
    String email = _emailController.text.trim();
    String pass = _passwordController.text.trim();

    if (isLogin) {
      if (email == dummyEmail && pass == dummyPassword) {
        VxToast.show(context, msg: "Welcome back!", bgColor: gold, textColor: Colors.black);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
        );
      } else {
        VxToast.show(context, msg: "Invalid credentials", bgColor: red);
      }
    } else {
      VxToast.show(context, msg: "Account created! Please login.", bgColor: gold, textColor: Colors.black);
      setState(() => isLogin = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ZStack([
        // Background Glow
        Align(
          alignment: Alignment.topCenter,
          child: VxBox().size(context.screenWidth, 300).linearGradient([
            red.withValues(alpha: 0.15),
            Colors.transparent,
          ]).make(),
        ),

        VStack([
          100.heightBox,
          "47で27".text.color(red).bold.size(45).makeCentered(),
          "The Golden Journey".text.color(gold).semiBold.lg.makeCentered(),

          60.heightBox,

          // 1. Centered Toggle
          HStack([
            "Login"
                .text
                .color(isLogin ? gold : Colors.white24)
                .bold
                .xl2
                .make()
                .onTap(() => setState(() => isLogin = true))!,
            
            VxBox().size(1, 20).color(Colors.white12).make().pSymmetric(h: 30),
            
            "Sign Up"
                .text
                .color(!isLogin ? gold : Colors.white24)
                .bold
                .xl2
                .make()
                .onTap(() => setState(() => isLogin = false))!,
          ], alignment: MainAxisAlignment.center).wFull(context),

          30.heightBox,

          // 2. Input Section
          VStack([
            _buildTextField("Email", Icons.email_outlined, _emailController),
            20.heightBox,
            _buildTextField("Password", Icons.lock_outline, _passwordController, isPassword: true),

            if (isLogin)
              Align(
                alignment: Alignment.centerRight,
                child: "Forgot Password?".text
                    .color(gold.withValues(alpha: 0.7))
                    .sm
                    .make()
                    .pOnly(top: 12, right: 4),
              ),
          ]).p16().wFull(context),

          30.heightBox,

          // 3. Action Button
          ElevatedButton(
            onPressed: _handleAuth,
            style: ElevatedButton.styleFrom(
              backgroundColor: gold,
              minimumSize: Size(context.screenWidth * 0.9, 55),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: (isLogin ? "LOGIN" : "CREATE ACCOUNT").text.black.bold.xl.make(),
          ).p16(),

          // 4. Divider Section
          HStack([
            const VxDivider(color: Colors.white10).expand()!,
            " OR ".text.gray600.sm.make().p8(),
            const VxDivider(color: Colors.white10).expand()!,
          ], alignment: MainAxisAlignment.center).p16().wFull(context),

          // 5. Social Icons
          HStack([
            _socialIcon(FontAwesomeIcons.google, Colors.white, "Google"),
            25.widthBox,
            _socialIcon(FontAwesomeIcons.apple, Colors.white, "Apple"),
            25.widthBox,
            _socialIcon(FontAwesomeIcons.facebook, const Color(0xFF1877F2), "Facebook"),
          ], alignment: MainAxisAlignment.center).p16().wFull(context),

          40.heightBox,
          "Hint: user@gold.com / password123".text.gray700.xs.makeCentered(),
          20.heightBox,
        ])
        .centered() // This replaces crossAlignCenter and centers the stack
        .scrollVertical(),
      ]),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return VxBox(
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        cursorColor: gold,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white12),
          prefixIcon: Icon(icon, color: gold.withValues(alpha: 0.5), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    )
    .color(Colors.white.withValues(alpha: 0.03))
    .withRounded(value: 12)
    .border(color: Colors.white10)
    .make();
  }

  Widget _socialIcon(IconData icon, Color color, String name) {
    return VxBox(child: Icon(icon, color: color, size: 24).centered())
        .size(60, 60)
        .color(Colors.white.withValues(alpha: 0.05))
        .roundedFull
        .border(color: Colors.white10)
        .make()
        .onTap(() {
          VxToast.show(context, msg: "Logging in with $name...");
        })!;
  }
}