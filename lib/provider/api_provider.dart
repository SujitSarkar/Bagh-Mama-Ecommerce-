import 'package:bagh_mama/models/product_category_model.dart';
import 'package:bagh_mama/models/product_info_model.dart';
import 'package:bagh_mama/models/products_model.dart';
import 'package:bagh_mama/models/user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class APIProvider extends ChangeNotifier{

  final Uri _baseUri = Uri.parse('https://baghmama.com.bd/graph/api/v3');
  final String _apiToken = 'aHR0cHN+YmFnaG1hbWEuY29tLmJkfmFwaQ';
  List<String> _bannerImageList=[];
  List<dynamic> _networkImageList=[];
  ProductCategoriesModel _productCategoriesModel;
  List<String> _productCategoryList=[];
  ProductsModel _productsModel;
  ProductInfoModel _productInfoModel;
  UserInfoModel _userInfoModel;
  get bannerImageList => _bannerImageList;
  get networkImageList => _networkImageList;
  get productsModel => _productsModel;
  get productInfoModel => _productInfoModel;
  get userInfoModel => _userInfoModel;
  get productCategoriesModel => _productCategoriesModel;
  get productCategoryList => _productCategoryList;

  set userInfoModel(UserInfoModel value){
    _userInfoModel = value;
    notifyListeners();
  }

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
      }
    });
  }

  Future<void> getProductCategories()async{
    final response = await http.post(
        _baseUri,
        body: {
          'api_token': _apiToken,
          'determiner': 'productCategories',
          'fetch_scope': 'main'
        });
    if(response.statusCode==200){
      final String responseString = response.body;
      final Set _categorySet=Set();
      _productCategoriesModel= productCategoriesModelFromJson(responseString);
      _productCategoriesModel.content.forEach((element) {
        _categorySet.add(element.main);
      });
      _categorySet.forEach((element) {
        _productCategoryList.add(element);
      });
      notifyListeners();
    }
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
      pref.setString('userId', _userInfoModel.content.id.toString());
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

  Future<bool> updateUserInfo(String firstName, String lastName, String email,
      String phone, String address, String state, String city, String postalCode)async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final response = await http.post(
        _baseUri,
        body: {
          'api_token': _apiToken,
          'determiner': 'updadeMyAccount',
          'id': pref.getString('userId'),
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'address_line_1': address,
          'city': city,
          'state': state,
          'postalcode': postalCode,
          'phone': phone
        });
    if(response.statusCode==200){
      // var jsonData = jsonDecode(response.body);
      return true;
    }
    else return false;
  }



}

