import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:uridachi/features/auth/presentation/pages/login_register/university_list.dart';
import '../../../../../widgets/login_widgets/my_dropdown_bar.dart';
import '../../../domain/entities/authenticate_with_email_param.dart';
import '../../providers/app_auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final domainController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;
  String username = '';
  String? selectedLanguage;
  List<String> _filteredUniversities = [];
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  List<String> domainOptions = [];
  List<String> languageOptions = [
    'Korean',
    'Japanese'
  ];
  String selectedOption = ".jp";

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showSuggestions();
      } else {
        _hideSuggestions();
      }
    });

    _searchController.addListener(_filterUniversities);
  }

  void _filterUniversities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUniversities = universityList.keys.where((university) => university.toLowerCase().contains(query)).toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _showSuggestions() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideSuggestions() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _focusNode.context?.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height,
          width: size.width,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredUniversities.length,
                  itemBuilder: (context, index) {
                    final university = _filteredUniversities[index];
                    return ListTile(
                      title: Text(university, style: TextStyle(color: Colors.black)),
                      onTap: () => _selectUniversity(university),
                    );
                  },
                ),
              ),
            ),
          ),

        );
      },
    );
  }

  void _selectUniversity(String university) {
    _searchController.text = university;
    _hideSuggestions();
  }

  @override
  void dispose() {
    emailController.clear();
    domainController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _searchController.removeListener(_filterUniversities);
    _searchController.clear();
    _focusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: _buildAppBar(screenHeight),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.001093 * 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(localization, screenHeight),
                _buildUniversityField(localization, screenHeight),
                _buildEmailField(localization, screenHeight),
                _buildDomainField(screenHeight),
                _buildLanguageDropdown(localization, screenWidth, screenHeight),
                _buildPasswordField(localization, screenHeight),
                _buildConfirmPasswordField(localization, screenHeight),
                _buildSignUpButton(context, screenWidth, screenHeight, localization),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(double screenHeight) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.001093 * 26),
        child: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _buildTitle(AppLocalizations localization, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.001093 * 56),
        Text(
          localization.create_account_title,
          style: TextStyle(
            color: Color(0xff582AB2),
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: screenHeight * 0.001093 * 8),
        Text(
          localization.required_field_indicator,
          style: TextStyle(color: Color(0x7FFF0C0C), fontSize: 12),
        ),
        SizedBox(height: screenHeight * 0.001093 * 40),
      ],
    );
  }

  Widget _buildUniversityField(AppLocalizations localization, double screenHeight) {
    return FormField<String>(
      validator: (value) => _searchController.text == null ? localization.please_select_university : null,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: TextStyle(color: Colors.black),
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                labelText: "Search for a university",
                border: OutlineInputBorder(),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildEmailField(AppLocalizations localization, double screenHeight) {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.001093 * 18),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                controller: emailController,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: localization.your_email,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF89949F),
                    ),
                  ),
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'This Field is Empty';
                  }
                  return null;
                },
              ),
            ),
            const Text(
              "   @",
              style: TextStyle(color: Color(0xff582AB2), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDomainField(double screenHeight) {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.001093 * 18),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                controller: domainController,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Your Domain',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF89949F),
                    ),
                  ),
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'This Field is Empty';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(0xFF89949F),
                  width: 1,
                ),
              ),
              child: DropdownButton<String>(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                dropdownColor: Colors.white,
                value: selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue!;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: ".jp",
                    child: Center(
                      child: Text(
                        ".jp",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: ".ac.jp",
                    child: Center(
                      child: Text(
                        ".ac.jp",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
                style: TextStyle(color: Colors.black),
                isExpanded: true,
                underline: SizedBox(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageDropdown(AppLocalizations localization, double screenWidth, double screenHeight) {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.001093 * 18),
        FormField<String>(
          validator: (value) => selectedLanguage == null ? localization.please_select_language : null,
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyDropdownBar(
                  hintText: localization.choose_language,
                  defaultValue: selectedLanguage,
                  options: languageOptions,
                  onChanged: (newValue) {
                    setState(() {
                      selectedLanguage = newValue;
                    });
                  },
                ),
                if (state.hasError)
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.002427 * 16.0),
                    child: Text(
                      state.errorText ?? '',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField(AppLocalizations localization, double screenHeight) {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.001093 * 18),
        TextFormField(
          style: TextStyle(color: Colors.black),
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: localization.password_hint1,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF89949F),
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localization.please_enter_password;
            } else if (value.length < 6) {
              return localization.password_min_length_error;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(AppLocalizations localization, double screenHeight) {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.001093 * 18),
        TextFormField(
          style: TextStyle(color: Colors.black),
          controller: confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: localization.confirm_password_hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF89949F),
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localization.please_confirm_password;
            } else if (value != passwordController.text) {
              return localization.passwords_do_not_match;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context, double screenWidth, double screenHeight, AppLocalizations localization) {
    final appAuthProvider = Provider.of<AppAuthProvider>(context);

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.001093 * 60),
        GestureDetector(
          onTap: _isLoading
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    final email = '${emailController.text}@${domainController.text}$selectedOption';
                    final authParam = AuthenticateWithEmailParam(
                      email,
                      passwordController.text,
                    );

                    await appAuthProvider.signUpWithEmailAndPassword(context, authParam, _searchController.text, selectedLanguage!);
                  }
                },
          child: Container(
            width: screenWidth * 0.002427 * 353.0,
            height: screenHeight * 0.001093 * 56.0,
            decoration: ShapeDecoration(
              color: _isLoading ? Colors.grey : const Color(0xff582AB2),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: screenWidth * 0.002427 * 1, color: const Color(0xFF737373)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Center(
              child: _isLoading
                  ? SizedBox(
                      width: screenWidth * 0.002427 * 24,
                      height: screenHeight * 0.001093 * 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: screenWidth * 0.002427 * 2.0,
                      ),
                    )
                  : Text(
                      localization.send_confirmation_button,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
