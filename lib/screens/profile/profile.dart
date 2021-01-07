import 'package:chater/provider/theme_service.dart';
import 'package:chater/screens/login/login.dart';
import 'package:chater/widgets/loading.dart';
import 'package:chater/data/auth/auth.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User user;

  Future<User> currentUser() async {
    try {
      user = _firebaseAuth.currentUser;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile'),
      ),
      body: Consumer<ThemeService>(
        builder: (context, theme, widget) {
          return theme.isAnimated
              ? CircularRevealAnimation(
                  child: _screenBody(),
                  animation: _animation,
                  centerOffset: Offset(0, 0),
                )
              : _screenBody();
        },
      ),
    );
  }

  Widget _screenBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<User>(
        future: currentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.hasData) {
            var dataUser = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 45.0,
                        backgroundImage: NetworkImage(
                            'https://ui-avatars.com/api/?size=128&name=${dataUser.displayName}'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            dataUser.displayName ?? 'unknown',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            dataUser.email ?? '',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Divider(),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidMoon,
                            size: 16.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Dark Mode',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      Consumer<ThemeService>(
                        builder: (context, theme, widget) {
                          return Switch(
                            value: theme.isDarkTheme,
                            onChanged: (value) {
                              theme.setAnimated(true);
                              theme.setDarkTheme(value);
                              theme.setAnimated(false);

                              if (_animationController.status ==
                                      AnimationStatus.forward ||
                                  _animationController.status ==
                                      AnimationStatus.completed) {
                                _animationController.reset();
                                _animationController.forward();
                              } else {
                                _animationController.forward();
                              }
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.dialog(
                      AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure?'),
                        actions: [
                          FlatButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'No',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          FlatButton(
                            onPressed: () async {
                              await auth.signOut();
                              Get.off(LoginPage());
                              Get.snackbar(
                                'Login successfullly!',
                                'Thanks for using apps!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black,
                                colorText: Colors.white,
                              );
                            },
                            child: Text('Yes'),
                          )
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 10.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.signOutAlt,
                          size: 16.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return Loading();
        },
      ),
    );
  }
}
