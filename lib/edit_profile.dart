import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:country_picker/country_picker.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:preffecture/services/auth_service.dart';
import 'package:preffecture/main.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic>? user;
  final bool isRequired;

  const EditProfilePage({super.key, this.user, this.isRequired = false});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Color gold = const Color(0xFFC5A059);

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _nationality;
  String? _gender;
  String? _countryCode;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    _firstNameController.text = widget.user?["first_name"] ?? "";
    _lastNameController.text = widget.user?["last_name"] ?? "";
    _phoneController.text = widget.user?["phone_number"] ?? "";

    _nationality = widget.user?["nationality"];
    _gender = widget.user?["gender"];

    if (widget.isRequired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        VxToast.show(
          context,
          msg: "Please complete your profile before using the app",
        );
      });
    }
  }

  Future<bool> validatePhone() async {
    try {
      final phone = PhoneNumber.parse(
        _phoneController.text,
        callerCountry: IsoCode.values.firstWhere(
          (e) => e.name == (_countryCode ?? "MY"),
          orElse: () => IsoCode.MY,
        ),
      );

      return phone.isValid();
    } catch (e) {
      return false;
    }
  }

  Future<void> updateProfile() async {
    if (_nationality == null) {
      VxToast.show(context, msg: "Select nationality");
      return;
    }

    if (_gender == null) {
      VxToast.show(context, msg: "Select gender");
      return;
    }

    bool valid = await validatePhone();

    if (!valid) {
      VxToast.show(context, msg: "Invalid phone number");
      return;
    }

    setState(() {
      loading = true;
    });

    final result = await AuthService.updateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      nationality: _nationality!,
      gender: _gender!,
    );

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    if (result["success"]) {
      VxToast.show(context, msg: "Profile updated");
      print(result);
      if (widget.isRequired) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainWrapper()),
          (Route<dynamic> route) => false,
        );
      }
      /// NORMAL EDIT PROFILE
      else {
        Navigator.pop(context, true);
      }
    } else {
      VxToast.show(context, msg: result["data"]["message"]);
    }
  }

  Widget _label(String text) {
    return text.text.white.semiBold.size(14).make();
  }

  Widget _inputField(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget _countrySelector() {
    return GestureDetector(
      onTap: () {
        showCountryPicker(
          context: context,
          showPhoneCode: false,
          countryListTheme: const CountryListThemeData(
            backgroundColor: Colors.black,
            textStyle: TextStyle(color: Colors.white),
          ),
          onSelect: (Country country) {
            setState(() {
              _nationality = country.name;
              _countryCode = country.countryCode;
            });
          },
        );
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(Icons.public, color: gold),

            12.widthBox,

            (_nationality ?? "Select nationality").text.white.make(),
          ],
        ),
      ),
    );
  }

  Widget _genderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.black,
          value: _gender,
          hint: "Select gender".text.white.make(),
          isExpanded: true,
          items: ["Male", "Female", "Other"]
              .map(
                (e) => DropdownMenuItem(value: e, child: e.text.white.make()),
              )
              .toList(),
          onChanged: (v) {
            setState(() {
              _gender = v;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      /// disable back when google signup
      onWillPop: () async => !widget.isRequired,

      child: Scaffold(
        backgroundColor: Colors.black,

        appBar: AppBar(
          backgroundColor: Colors.black,
          title: "Edit Profile".text.white.make(),
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              30.heightBox,

              _label("First Name"),
              6.heightBox,
              _inputField(_firstNameController),

              16.heightBox,

              _label("Last Name"),
              6.heightBox,
              _inputField(_lastNameController),

              16.heightBox,

              _label("Nationality"),
              6.heightBox,
              _countrySelector(),

              16.heightBox,

              _label("Phone Number"),
              6.heightBox,
              _inputField(_phoneController),

              16.heightBox,

              _label("Gender"),
              6.heightBox,
              _genderDropdown(),

              30.heightBox,

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onPressed: loading ? null : updateProfile,

                  child: loading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : "UPDATE PROFILE".text.black.bold.xl.make(),
                ),
              ),

              40.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
