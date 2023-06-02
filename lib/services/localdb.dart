import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {
  static final uidkey = "adlajahfuhe";
  static final lkey = "5654asfe";
  static final rkey = "asfaasdfasfaff";
  static final nkey = "48484fas77";
  static final mkey = "safafdas";
  static final pkey = "affefe";
  static final Audkey = "asdf";
  static final Jokkey = "asfadsfawe";
  static final F50key = "asdfefas";
  static final Expkey = "ewrersfsd";

  static Future<bool> saveUserId(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(uidkey, uid);
  }

  static Future<String?> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(uidkey);
  }

  ///////////////////////////////////////////////////////
  static Future<bool> saveLevel(String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(lkey, level);
  }

  static Future<String?> getLevel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(lkey);
  }
  ////////////////////////////////////////////////////////////////

  static Future<bool> saveRank(String rank) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(rkey, rank);
  }

  static Future<String?> getRank() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(rkey);
  }

  ////////////////////////////////////////////////////////////////

  static Future<bool> saveMoney(String money) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(mkey, money);
  }

  static Future<String?> getMoney() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(mkey);
  }

  ////////////////////////////////////////////////////////////////

  static Future<bool> saveName(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(nkey, name);
  }

  static Future<String?> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(nkey);
  }
  ////////////////////////////////////////////////////////////////

  static Future<bool> saveUrl(String prourl) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(pkey, prourl);
  }

  static Future<String?> getUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(pkey);
  }
  ////////////////////////////////////////////////////////////////

  static Future<bool> saveAud(bool isAvail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(Audkey, isAvail);
  }

  static Future<bool?> getAud() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(Audkey);
  }
  ////////////////////////////////////////////////////////////////

  static Future<bool> saveJoker(bool isAvail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(Jokkey, isAvail);
  }

  static Future<bool?> getJoker() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(Jokkey);
  }
  ////////////////////////////////////////////////////////////////

  static Future<bool> save50(bool isAvail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(F50key, isAvail);
  }

  static Future<bool?> get50() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(F50key);
  }
  ////////////////////////////////////////////////////////////////

  static Future<bool> saveExp(bool isAvail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(Expkey, isAvail);
  }

  static Future<bool?> getExp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(Expkey);
  }
}
