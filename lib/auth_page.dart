import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:preffecture/main.dart';
import 'package:google_sign_in/google_sign_in.dart'; // New Import
import 'package:preffecture/services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool termsAccepted = false;
  final Color gold = const Color(0xFFC5A059);
  final Color red = const Color(0xFFE50914);
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? selectedNationality;
  String? selectedGender;

  final List<Map<String, String>> partners = const [
    {"name": "TOHO", "logo": "assets/images/toho-logo.png"},
    {"name": "CASIO", "logo": "assets/images/casio-logo.png"},
    {"name": "UNIQLO", "logo": "assets/images/uniqlo-logo.png"},
    {"name": "G-SHOCK", "logo": "assets/images/g-shock.png"},
    {"name": "HOUSE", "logo": "assets/images/suntory-logo.png"},
    {"name": "JAPAN AIRLINE", "logo": "assets/images/japan-airline.png"},
    {"name": "SHISEIDO", "logo": "assets/images/shisheido-logo.png"},
    {"name": "MITSUBISHI", "logo": "assets/images/mitsubishi-logo.webp"},
  ];

  Future<void> _handleAuth() async {
    if (!isLogin && !termsAccepted) {
      VxToast.show(
        context,
        msg: "Please accept terms & conditions",
        bgColor: red,
      );
      return;
    }

    VxToast.show(context, msg: "Connecting...", bgColor: gold);

    final Map<String, dynamic> userData = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
      if (!isLogin) ...{
        "first_name": _firstNameController.text.trim(),
        "last_name": _lastNameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "nationality": selectedNationality,
        "gender": selectedGender,
        "password_confirmation": _confirmPasswordController.text.trim(),
      },
    };

    final result = await AuthService.authenticate(
      body: userData,
      isLogin: isLogin,
    );

    if (result["success"]) {
      VxToast.show(
        context,
        msg: isLogin ? "Welcome back!" : "Account Created!",
        bgColor: gold,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainWrapper()),
      );
    } else {
      VxToast.show(
        context,
        msg: result["data"]["message"] ?? "Auth failed",
        bgColor: red,
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      // 1. Check if the platform supports manual authentication
      if (await signIn.supportsAuthenticate()) {
        await signIn.authenticate();
      } else {
        debugPrint("Platform does not support manual authentication.");
        return;
      }

      // 2. Listen for the successful sign-in event reactively
      final event = await signIn.authenticationEvents.firstWhere(
        (e) => e is GoogleSignInAuthenticationEventSignIn,
      );

      // 3. Type-safe cast to access the user and their authentication tokens
      if (event is GoogleSignInAuthenticationEventSignIn) {
        final auth = event.user.authentication;

        final Map<String, dynamic> data = {
          "id_token": auth.idToken,
          "provider": "google",
        };

        // 4. Authenticate via your Laravel Service
        // Change this in your _handleGoogleSignIn:
        final result = await AuthService.socialAuthenticate(
          provider: "google",
          token: auth.idToken!, // Send only the token
        );

        if (result["success"] && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainWrapper()),
          );
        } else {
          debugPrint("AuthService failed: ${result["data"]}");
        }
      }
    } on GoogleSignInException catch (e) {
      debugPrint("Google Sign-In Exception: ${e.code}");
    } catch (e) {
      debugPrint("General Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // FIX: Lock Marquee to the bottom professionally
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.only(bottom: 30, top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            "OUR PARTNERS".text
                .color(gold.withOpacity(0.4))
                .widest
                .xs
                .bold
                .makeCentered(),
            15.heightBox,
            SizedBox(height: 50, child: MarqueeBrands(partners: partners)),
          ],
        ),
      ),
      body: Stack(
        children: [
          _buildGradientHeader(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  40.heightBox,
                  Image.asset(
                    'assets/images/4727_with_border_Logo.png',
                    height: 80,
                  ).centered(),
                  30.heightBox,
                  _buildTabs(),
                  30.heightBox,

                  // Professional Form Arrangement
                  if (isLogin) ..._buildLoginForm() else ..._buildSignupForm(),

                  30.heightBox,
                  _buildSubmitButton(),
                  24.heightBox,
                  "OR CONTINUE WITH".text.gray600.xs.bold.makeCentered(),
                  20.heightBox,
                  _socialBtn(
                    FontAwesomeIcons.google,
                    Colors.white,
                    onTap: _handleGoogleSignIn,
                  ).centered(),
                  40.heightBox, // Space before the fixed bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLoginForm() => [
    _inputField("Email Address", Icons.email_outlined, _emailController),
    16.heightBox,
    _inputField(
      "Password",
      Icons.lock_outline,
      _passwordController,
      isPass: true,
    ),
    Align(
      alignment: Alignment.centerRight,
      child: "Forgot Password?".text.color(gold).make().p8().onTap(() {}),
    ),
  ];

  List<Widget> _buildSignupForm() => [
    Row(
      children: [
        Expanded(
          child: _inputField(
            "First Name",
            Icons.person_outline,
            _firstNameController,
          ),
        ),
        12.widthBox,
        Expanded(
          child: _inputField(
            "Last Name",
            Icons.person_outline,
            _lastNameController,
          ),
        ),
      ],
    ),
    16.heightBox,
    _inputField("Email Address", Icons.email_outlined, _emailController),
    16.heightBox,
    _inputField("Phone Number", Icons.phone_outlined, _phoneController),
    16.heightBox,
    Row(
      children: [
        Expanded(
          child: _buildDropdown("Nationality", [
            "Malaysia",
            "Japan",
            "Singapore",
          ]),
        ),
        12.widthBox,
        Expanded(child: _buildDropdown("Gender", ["Male", "Female", "Other"])),
      ],
    ),
    16.heightBox,
    _inputField(
      "Password",
      Icons.lock_outline,
      _passwordController,
      isPass: true,
    ),
    16.heightBox,
    _inputField(
      "Confirm Password",
      Icons.lock_reset_outlined,
      _confirmPasswordController,
      isPass: true,
    ),
    10.heightBox,
    Row(
      children: [
        Checkbox(
          value: termsAccepted,
          activeColor: gold,
          side: const BorderSide(color: Colors.white24),
          onChanged: (v) => setState(() => termsAccepted = v!),
        ),
        "I agree to Terms & Conditions".text.white.xs.make(),
      ],
    ),
  ];

  // UI Helpers
  Widget _buildGradientHeader() => Container(
    height: 300,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [red.withOpacity(0.15), Colors.transparent],
      ),
    ),
  );

  Widget _buildTabs() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      "LOGIN".text
          .color(isLogin ? gold : Colors.white24)
          .bold
          .xl
          .make()
          .onTap(() => setState(() => isLogin = true)),
      Container(
        width: 1,
        height: 20,
        color: Colors.white12,
        margin: const EdgeInsets.symmetric(horizontal: 20),
      ),
      "SIGN UP".text
          .color(!isLogin ? gold : Colors.white24)
          .bold
          .xl
          .make()
          .onTap(() => setState(() => isLogin = false)),
    ],
  );

  Widget _inputField(
    String hint,
    IconData icon,
    TextEditingController controller, {
    bool isPass = false,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white10),
    ),
    child: TextField(
      controller: controller,
      obscureText: isPass,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        icon: Icon(icon, color: gold.withOpacity(0.6), size: 18),
        border: InputBorder.none,
      ),
    ),
  );

  Widget _buildDropdown(String hint, List<String> items) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white10),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        hint: hint.text.color(Colors.white24).xs.make(),
        value: hint == "Nationality" ? selectedNationality : selectedGender,
        isExpanded: true,
        dropdownColor: Colors.black,
        items: items
            .map(
              (e) => DropdownMenuItem(value: e, child: e.text.white.sm.make()),
            )
            .toList(),
        onChanged: (v) => setState(
          () => hint == "Nationality"
              ? selectedNationality = v
              : selectedGender = v,
        ),
      ),
    ),
  );

  Widget _buildSubmitButton() => SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: gold,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: _handleAuth,
      child: (isLogin ? "LOG IN" : "CREATE ACCOUNT").text.black.bold.xl.make(),
    ),
  );

  // UPDATED Helper: Added onTap logic
  Widget _socialBtn(
    IconData icon,
    Color color, {
    required VoidCallback onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white10),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Icon(icon, color: color, size: 20),
    ),
  );
}

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
    final list = [...widget.partners, ...widget.partners, ...widget.partners];

    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final partner = list[index];
        final String name = partner['name']!;

        // --- COLOR LOGIC ---
        // Default color is white.
        // If name is G-SHOCK, SHISEIDO, or HOUSE OF SUNTORY, set to black.
        final bool isBlackBrand =
            name == "G-SHOCK" || name == "SHISEIDO" || name == "HOUSE";

        final Color bgColor = isBlackBrand ? Colors.black : Colors.white;
        final Color borderColor = isBlackBrand
            ? Colors.white24
            : Colors.transparent;

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
