import 'package:bagh_mama/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DatabaseHelper extends ChangeNotifier{

  List<CartModel> _cartList=[];
  get cartList=> _cartList;

  static DatabaseHelper _databaseHelper; // singleton DatabaseHelper
  static Database _database; // singleton Database

  String cartTable = 'cart_table';
  String colId = 'id';
  String colPId = 'pId';
  String colPSize = 'pSize';
  String colPColor = 'pColor';
  String colPQuantity = 'pQuantity';
  String colPImageLink= 'pImageLink';

  DatabaseHelper._createInstance(); //Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $cartTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colPId TEXT, $colPSize TEXT,'
            '$colPColor TEXT, $colPQuantity TEXT, $colPImageLink TEXT)');
  }

  Future<Database> initializeDatabase() async {
    //Get the directory path for both android and iOS
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'cart.db';
    var noteDatabase =
    await openDatabase(path, version: 1, onCreate: _createDB);
    return noteDatabase;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  //Fetch Map list from DB
  Future<List<Map<String, dynamic>>> getCartMapList() async {
    Database db = await this.database;
    var result = await db.query(cartTable, orderBy: '$colId ASC');
    return result;
  }
  //Get the 'Map List' and convert it to 'Cart List
  Future<void> getCartList() async {
    _cartList.clear();
    var cartMapList = await getCartMapList();
    int count = cartMapList.length;
    for (int i = 0; i < count; i++) {
      _cartList.add(CartModel.fromMapObject(cartMapList[i]));
    }
    notifyListeners();
  }

  //update operation
  Future<int> updateCart(CartModel cartModel) async {
    Database db = await this.database;
    var result = await db.update(cartTable, cartModel.toMap(),
        where: '$colId = ?', whereArgs: [cartModel.id]);
    return result;
  }

  //Insert operation
  Future<int> insertCart(CartModel cartModel) async {
    Database db = await this.database;
    var result = await db.insert(cartTable, cartModel.toMap());
    return result;
  }

  //Delete operation
  Future<int> deleteCart(int id) async {
    Database db = await this.database;
    var result =
    await db.rawDelete('DELETE FROM $cartTable WHERE $colId = $id');
    return result;
  }
}