import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:preffecture/main.dart';
import 'package:google_sign_in/google_sign_in.dart'; // New Import
import 'package:preffecture/services/auth_service.dart';
import 'package:preffecture/edit_profile.dart';

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
    {"name": "KAMPACHI", "logo": "assets/images/kampachi-logo.png"},
    {"name": "IPPUDO", "logo": "assets/images/ippudo_black.png"},
    {"name": "MAISEN", "logo": "assets/images/MAiSEN-Logo.avif"},
  ];

  /// Shows the T&C bottom sheet. Returns true if user agreed.
  Future<bool> _showTermsBottomSheet() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TermsBottomSheet(gold: gold, red: red),
    );
    return result == true;
  }

  @override
  void initState() {
    super.initState();

    _initializeGoogle();
  }

  Future<void> _initializeGoogle() async {
    await _googleSignIn.initialize(
      serverClientId:
          "809799025977-4rnij5e580t9henqgjfp3tdj198vr57h.apps.googleusercontent.com",
    );
  }

  Future<void> _handleAuth() async {
    if (!isLogin) {
      final agreed = await _showTermsBottomSheet();
      if (!agreed) return;
    }

    VxToast.show(context, msg: "Connecting...", bgColor: gold);
    // Aligning keys with AuthController validation rules
    final Map<String, dynamic> userData = isLogin
        ? {
            "email": _emailController.text.trim(),
            "password": _passwordController.text.trim(),
          }
        : {
            "first_name": _firstNameController.text.trim(),
            "last_name": _lastNameController.text.trim(),
            "email": _emailController.text.trim(),
            "phone_number": _phoneController.text
                .trim(), // Matches 'phone_number' in Controller
            "nationality": selectedNationality,
            "gender": selectedGender,
            "password": _passwordController.text.trim(),
            "password_confirmation": _confirmPasswordController.text
                .trim(), // Required for 'confirmed' rule
          };

    final result = await AuthService.authenticate(
      body: userData,
      isLogin: isLogin,
    );

    if (result["success"] && mounted) {
      VxToast.show(
        context,
        msg: isLogin ? "Welcome back!" : "Account created!",
        bgColor: gold,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainWrapper()),
      );
    } else {
      VxToast.show(
        context,
        msg: result["data"]["message"] ?? "Authentication failed",
        bgColor: red,
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    try {
      final GoogleSignInAccount account = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication auth = await account.authentication;

      final String? idToken = auth.idToken;

      if (idToken == null) {
        debugPrint("Google ID token is null");
        return;
      }

      final result = await AuthService.googleLogin(token: idToken);

      if (result["success"] && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainWrapper()),
        );
      } else {
        VxToast.show(
          context,
          msg: result["data"]["message"] ?? "Google login failed",
          bgColor: red,
        );
      }
    } catch (e) {
      debugPrint("Google Login Error: $e");
    }
  }

  Future<void> _handleGoogleRegister() async {
    try {
      final agreed = await _showTermsBottomSheet();
      if (!agreed) return;

      final GoogleSignInAccount account = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication auth = await account.authentication;

      final String? idToken = auth.idToken;

      if (idToken == null) {
        debugPrint("Google ID token is null");
        return;
      }

      final result = await AuthService.googleRegister(token: idToken);

      if (result["success"]) {
        final bool profileCompleted =
            result["data"]["profile_completed"] ?? false;

        if (!profileCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const EditProfilePage(isRequired: true),
            ),
          );
        } else {
          VxToast.show(
            context,
            msg: result["data"]["message"] ?? "Google login failed",
            bgColor: red,
          );
        }
      }
    } catch (e) {
      debugPrint("Google Register Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.only(bottom: 50, top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            25.heightBox,
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
                  if (isLogin) ..._buildLoginForm() else ..._buildSignupForm(),
                  30.heightBox,
                  _buildSubmitButton(),
                  24.heightBox,
                  "OR CONTINUE WITH".text.gray600.xs.bold.makeCentered(),
                  20.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// GOOGLE LOGIN
                      isLogin
                          ? Column(
                              children: [
                                _socialBtn(
                                  FontAwesomeIcons.google,
                                  Colors.white,
                                  onTap: _handleGoogleLogin,
                                ),
                                6.heightBox,
                                "Login with Google".text.gray400.xs.make(),
                              ],
                            ).centered()
                          : Column(
                              children: [
                                _socialBtn(
                                  FontAwesomeIcons.google,
                                  Colors.white,
                                  onTap: _handleGoogleRegister,
                                ),
                                6.heightBox,
                                "Sign Up with Google".text.gray400.xs.make(),
                              ],
                            ).centered(),
                    ],
                  ),
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
  ];

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

// ─────────────────────────────────────────────
//  T&C Bottom Sheet Widget
// ─────────────────────────────────────────────
class _TermsBottomSheet extends StatefulWidget {
  final Color gold;
  final Color red;
  const _TermsBottomSheet({required this.gold, required this.red});

  @override
  State<_TermsBottomSheet> createState() => _TermsBottomSheetState();
}

class _TermsBottomSheetState extends State<_TermsBottomSheet> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 14, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Icon(Icons.article_outlined, color: widget.gold, size: 20),
                const SizedBox(width: 10),
                "Terms & Conditions".text.color(widget.gold).bold.xl.make(),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: "Please read carefully before creating your account.".text
                .color(Colors.white38)
                .xs
                .make(),
          ),
          const SizedBox(height: 16),

          const Divider(color: Colors.white10, height: 1),

          // Scrollable T&C content
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TcSection(
                    title: "1. Acceptance of Terms",
                    body:
                        "By creating an account and using our services, you agree to be bound by these Terms & Conditions. If you do not agree to these terms, please do not use our services.",
                  ),
                  _TcSection(
                    title: "2. Membership & Account",
                    body:
                        "You must provide accurate and complete information when registering. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.",
                  ),
                  _TcSection(
                    title: "3. Loyalty Points & Rewards",
                    body:
                        "Points earned through our partner network are subject to individual partner terms. Points have no cash value and cannot be transferred. We reserve the right to modify or discontinue the rewards programme at any time.",
                  ),
                  _TcSection(
                    title: "4. Privacy & Data",
                    body:
                        "We collect and process your personal data in accordance with our Privacy Policy. Your data may be shared with our partner restaurants and brands to provide you with personalised rewards and offers.",
                  ),
                  _TcSection(
                    title: "5. Partner Dining & Offers",
                    body:
                        "Offers and promotions are subject to availability and individual partner policies. We do not guarantee the availability of any specific offer. Partners may change their participation at any time.",
                  ),
                  _TcSection(
                    title: "6. Prohibited Conduct",
                    body:
                        "You agree not to misuse our platform, engage in fraudulent activity, or attempt to exploit our rewards system. Violation of these terms may result in immediate account termination.",
                  ),
                  _TcSection(
                    title: "7. Limitation of Liability",
                    body:
                        "To the fullest extent permitted by law, we shall not be liable for any indirect, incidental, or consequential damages arising from your use of our services.",
                  ),
                  _TcSection(
                    title: "8. Amendments",
                    body:
                        "We reserve the right to update these terms at any time. Continued use of the app following any changes constitutes your acceptance of the new terms.",
                  ),
                  _TcSection(
                    title: "9. Governing Law",
                    body:
                        "These terms are governed by the laws of Malaysia. Any disputes shall be subject to the exclusive jurisdiction of the courts of Malaysia.",
                  ),
                ],
              ),
            ),
          ),

          const Divider(color: Colors.white10, height: 1),

          // Agree checkbox + CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _agreed,
                      activeColor: widget.gold,
                      side: const BorderSide(color: Colors.white24),
                      onChanged: (v) => setState(() => _agreed = v!),
                    ),
                    Expanded(
                      child: "I have read and agree to the Terms & Conditions"
                          .text
                          .white
                          .xs
                          .make(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _agreed ? widget.gold : Colors.white12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _agreed
                        ? () => Navigator.pop(context, true)
                        : null,
                    child: "AGREE & CONTINUE".text
                        .color(_agreed ? Colors.black : Colors.white38)
                        .bold
                        .sm
                        .make(),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: "Decline".text.color(Colors.white38).xs.make(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TcSection extends StatelessWidget {
  final String title;
  final String body;
  const _TcSection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Marquee Brands (unchanged)
// ─────────────────────────────────────────────
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
