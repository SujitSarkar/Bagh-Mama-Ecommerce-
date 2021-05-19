import 'package:bagh_mama/models/product_info_model.dart';
import 'package:bagh_mama/models/products_model.dart';
import 'package:bagh_mama/models/user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class APIProvider extends ChangeNotifier{

  Uri _baseUri = Uri.parse('https://baghmama.com.bd/graph/api/v3');
  String _apiToken = 'aHR0cHN+YmFnaG1hbWEuY29tLmJkfmFwaQ';
  List<String> _bannerImageList = [];
  List<dynamic> _networkImageList=[];
  ProductsModel _productsModel;
  ProductInfoModel _productInfoModel;
  UserInfoModel _userInfoModel;
  get bannerImageList => _bannerImageList;
  get networkImageList => _networkImageList;
  get productsModel => _productsModel;
  get productInfoModel => _productInfoModel;
  get userInfoModel => _userInfoModel;

  Future<void> getBannerImageList()async{
    await http.post(
      _baseUri,
      body: {
        'api_token': _apiToken,
        'determiner': 'bannerSlider',
        'field': 'home_page_top'
      },
    ).then((response){
      var jsonData = jsonDecode(response.body);
      if(jsonData['status']=='SUCCESS'){
        _bannerImageList.clear();
        jsonData['content'].forEach((element){
          _bannerImageList.add(element['image']);
        });
        _networkImageList = _bannerImageList
            .map((item) => NetworkImage('https://baghmama.com.bd/$item')
        ).toList();
        notifyListeners();
      }else{
        print('cant get Banner Image');
      }
    },onError: (error){
      print(error.toString());
    });
  }

  Future<void> getProducts()async{
    final response = await http.post(
      _baseUri,
      body: {
        'api_token': _apiToken,
        'determiner': 'products',
        'fetch_scope': 'main'
      });
    if(response.statusCode==200){
      final String responseString = response.body;
      _productsModel= productsModelFromJson(responseString);
      notifyListeners();
    }
  }

  Future<void> getProductInfo(int id)async{
    final response = await http.post(
      _baseUri,
      body: {
        'api_token': _apiToken,
        'determiner': 'productInfo',
        'field': id.toString()
      });
    if(response.statusCode==200){
       String responseString = response.body;
      _productInfoModel= productInfoModelFromJson(responseString);
      notifyListeners();
    }
  }

  Future<bool> getUserInfo(String username)async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        _baseUri,
        body: {
          'api_token': _apiToken,
          'determiner': 'userInfo',
          'column_type': 'username',
          'field': username
        });
    if(response.statusCode==200){
      String responseString = response.body;
      _userInfoModel = userInfoModelFromJson(responseString);
      notifyListeners();
      pref.setString('username', username);
      return true;
    }else{
      return false;
    }
  }

  Future<bool> validateUser(String email, String password)async{
    final response = await http.post(
        _baseUri,
        body: {
          'api_token': _apiToken,
          'determiner': 'userValidate',
          'username': email,
          'password': password
        });
    if(response.statusCode==200){
      var jsonData = jsonDecode(response.body);
      return jsonData['content'];
    }
    else return false;
  }

}

