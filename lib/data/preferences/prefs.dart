import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('token') ?? null;
  } 

  Future<bool> setToken(String value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString('token', value);
  }

  Future<String> getUserId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('userId') ?? null;
  } 

  Future<bool> setUserId(String value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString('userId', value);
  }

  Future<String> getUserName() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('name') ?? null;
  } 

  Future<bool> setUserName(String value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString('name', value);
  }
  
  Future<bool> clearToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.clear();
  }

  Future<bool> clearID() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.remove('userId');
  }
 }

Prefs prefs = Prefs();