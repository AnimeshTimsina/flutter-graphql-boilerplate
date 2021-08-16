import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:omsnepal/models/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as Encryption;

class SharedPreferenceService {
  final iv = Encryption.IV.fromLength(16);
  Encryption.Encrypter encrypter = Encryption.Encrypter(Encryption.AES(
      Encryption.Key.fromUtf8('ABSFGHFYUTEUIOPLHTRY&^%9(BC-#@O(')));

  String encrypt(String toEncrypt) {
    return encrypter.encrypt(toEncrypt, iv: iv).base16;
  }

  String decrypt(String toDecrypt) {
    return encrypter.decrypt16(toDecrypt, iv: iv);
  }
  // final _storage = SharedPreferences.getInstance();

  Future setToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token != null) await prefs.setString(TOKEN, encrypt(token));
  }

  Future clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // await _storage.delete(key: TOKEN);
  }

  Future setThemeMode(ThemeMode? mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mode != null)
      await prefs.setString(THEME_MODE, EnumToString.convertToString(mode));
    // await _storage.write(
    //     key: THEME_MODE, value: EnumToString.convertToString(mode));
  }

  Future<ThemeMode?> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? theme = prefs.getString(THEME_MODE);
    if (theme != null) {
      try {
        ThemeMode? defaultMode =
            EnumToString.fromString(ThemeMode.values, theme);
        return defaultMode;
      } catch (err) {
        return null;
      }
    } else
      return null;
  }

  Future<String?> get token async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenFromPref = prefs.getString(TOKEN);
    if (tokenFromPref == null) {
      return null;
    }
    return decrypt(tokenFromPref);
  }
}

SharedPreferenceService sharedPreferenceService = SharedPreferenceService();
