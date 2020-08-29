import 'package:chater/pages/login/login.dart';
import 'package:chater/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:chater/services/database.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailControl = new TextEditingController();
  final TextEditingController _namaControl = new TextEditingController();
  final TextEditingController _passwdControl = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isHidePassword = true;
  var db = new Database();

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(height: 50),
                    _formWidget(),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                    ),
                    SizedBox(height: height * .055),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ),
            //Positioned(top: 35, left: 0, child: backButton()),
          ],
        ),
      ),
    );
  }

  Widget _entryField(
    String title,
    TextEditingController controller, {
    bool isPassword = false,
    String hint = "",
    TextInputType keyboardType,
    String warningText,
    Widget suffixIcon,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: keyboardType,
            controller: controller,
            obscureText: isPassword,
            validator: (value) => value.isEmpty ? warningText : null,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              hintText: hint,
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();
        if (_formKey.currentState.validate()) {
          //auth
          final auth = new Auth();
          User user;

          try {
            user = await auth.registerUser(
              _emailControl.text,
              _passwdControl.text,
              _namaControl.text,
            );
          } catch (e) {
            print(e);
          }

          db.insertUser(
            id: user.uid,
            email: user.email,
            name: _namaControl.text,
          );

          Get.to(LoginPage());
          Get.snackbar(
            'Register successfully!',
            'Login to access your account!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black,
            colorText: Colors.white,
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColor],
          ),
        ),
        child: Text(
          'Register',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sudah punya akun? ',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Get.off(LoginPage());
            },
            child: Text(
              'Login disini',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Register',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _formWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _entryField(
            'Name',
            _namaControl,
            hint: "Diplo xp.",
            keyboardType: TextInputType.text,
            warningText: 'Name cannot be empty!',
          ),
          _entryField(
            'Email',
            _emailControl,
            hint: "john@mayer.me",
            keyboardType: TextInputType.emailAddress,
            warningText: 'Email cannot be empty!',
          ),
          _entryField(
            'Password',
            _passwdControl,
            isPassword: _isHidePassword,
            warningText: 'Password cannot be empty!',
            suffixIcon: GestureDetector(
              onTap: () {
                _togglePasswordVisibility();
              },
              child: Icon(
                _isHidePassword ? Icons.visibility_off : Icons.visibility,
                color: _isHidePassword ? Colors.grey : Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 20),
          _submitButton(),
        ],
      ),
    );
  }
}
