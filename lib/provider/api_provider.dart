import 'dart:io';

import 'package:bagh_mama/models/basic_contact_info_model.dart';
import 'package:bagh_mama/models/new_support_ticket_model.dart';
import 'package:bagh_mama/models/product_category_model.dart';
import 'package:bagh_mama/models/product_info_model.dart';
import 'package:bagh_mama/models/products_model.dart';
import 'package:bagh_mama/models/register_user_model.dart';
import 'package:bagh_mama/models/social_contact_info_model.dart';
import 'package:bagh_mama/models/upluad_image_model.dart';
import 'package:bagh_mama/models/user_info_model.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class APIProvider extends ChangeNotifier{

  final Uri _baseUri = Uri.parse('https://baghmama.com.bd/graph/api/v3');
  final String _apiToken = 'aHR0cHN+YmFnaG1hbWEuY29tLmJkfmFwaQ';
  final String _xAuthKey = 'aHR0cHN+YmFnaG1hbWEuY29tLmJkfmFwaQ';
  final String _contentType='application/json';
  final String _xAuthEmail='info@baghmama.com.bd';

  List<String> _bannerImageList=[];
  List<NetworkImage> _networkImageList=[];
  ProductCategoriesModel _productCategoriesModel;
  List<String> _productCategoryList=[];
  ProductsModel _productsModel;
  ProductInfoModel _productInfoModel;
  UserInfoModel _userInfoModel;
  SocialContactInfo _socialContactInfo;
  BasicContactInfo _basicContactInfo;
  String _profileImageLink;

  get bannerImageList => _bannerImageList;
  get networkImageList => _networkImageList;
  get productsModel => _productsModel;
  get productInfoModel => _productInfoModel;
  get userInfoModel => _userInfoModel;
  get productCategoriesModel => _productCategoriesModel;
  get productCategoryList => _productCategoryList;
  get socialContactInfo => _socialContactInfo;
  get basicContactInfo => _basicContactInfo;
  get profileImageLink => _profileImageLink;

  set userInfoModel(UserInfoModel value){
    _userInfoModel = value;
    notifyListeners();
  }

  void getProfileImage()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    _profileImageLink= pref.getString('profileImageLink');
    notifyListeners();
  }

  Future<bool> updateProfileImage(File imageFile)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var imageBytes = imageFile.readAsBytesSync();
    String baseImage = base64Encode(imageBytes);
    //print('imageBytes: $imageBytes');
    var response = await http.post(
      Uri.parse('https://baghmama.com.bd/graph/api/v4/profilePicUpdate'),
      headers: {
        'X-Auth-Key': _xAuthKey,
        'X-Auth-Email': _xAuthEmail,
      }, body: {
        "id": pref.getString('userId'),
        'ppic': '$baseImage',
      }
    );
    final String responseString = response.body;
    UploadImageResponseModel model= uploadImageResponseModelFromJson(responseString);
    if(model.status=='SUCCESS'){
      return model.content.success;
    }else{
      return model.content.success;
    }
  }

  Future<void> getBannerImageList()async{
     Map data = {"banner_type":"home page banners"};
     var body = json.encode(data);

    await http.post(
      Uri.parse('https://baghmama.com.bd/graph/api/v4/bannerSlider'),
      headers: {
        'Content-Type': _contentType,
        'X-Auth-Key': _xAuthKey,
        'X-Auth-Email': _xAuthEmail,
      },
      body:body,
    ).then((response){
      var jsonData = jsonDecode(response.body);
      if(jsonData['status']=='SUCCESS'){
        _bannerImageList.clear();
        jsonData['content'].forEach((element){
          _bannerImageList.add(element['image']);
        });
        _networkImageList = _bannerImageList
            .map<NetworkImage>((item) => NetworkImage('https://baghmama.com.bd/$item')
        ).toList();
        notifyListeners();
      }
      else showInfo('failed to get banner image');
    });
  }

  Future<void> getProductCategories()async{
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/productCategories'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail,
        },
        );
    if(response.statusCode==200){
       String responseString = response.body;
       Set _categorySet=Set();
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
    var response = await http.post(
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

  Future<bool> validateUser(String email, String password)async{
    Map map = {"username":"$email","password":"$password"};
    var body = json.encode(map);

    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/userValidate'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail,
        },
        body: body
    );
    if(response.statusCode==200){
      var jsonData = jsonDecode(response.body);
      return jsonData['content']['valid'];
    }
    else return false;
  }

  Future<bool> getUserInfo(String username)async{
     SharedPreferences pref = await SharedPreferences.getInstance();
     Map map = {"column_type": "username", "field": "$username"};
     var body = json.encode(map);

    var response = await http.post(
      Uri.parse('https://baghmama.com.bd/graph/api/v4/userInfo'),
      headers: {
        'Content-Type': _contentType,
        'X-Auth-Key': _xAuthKey,
        'X-Auth-Email': _xAuthEmail,
      },
      body: body
    );
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

  Future<bool> updateUserInfo(Map map)async{
    var body = json.encode(map);
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/updadeMyAccount'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail,
        },
        body: body
    );
    var jsonData = jsonDecode(response.body);
    if(jsonData['status']=='SUCCESS'){
      return jsonData['content']['success'];
    }
    else return false;
  }

  Future<void> getSocialContactInfo()async{
    var response = await http.post(
      Uri.parse('https://baghmama.com.bd/graph/api/v4/socialContactInfo'),
      headers: {
        'Content-Type': _contentType,
        'X-Auth-Key': _xAuthKey,
        'X-Auth-Email': _xAuthEmail
      },
        );
    if(response.statusCode==200){
      String responseString = response.body;
      _socialContactInfo= socialContactInfoFromJson(responseString);
      notifyListeners();
    }else showInfo('failed to get Social Data');
  }

  Future<void> getBasicContactInfo()async{
    var response = await http.post(
      Uri.parse('https://baghmama.com.bd/graph/api/v4/basicContactInfo'),
      headers: {
        'Content-Type': _contentType,
        'X-Auth-Key': _xAuthKey,
        'X-Auth-Email': _xAuthEmail
      },
        );
    if(response.statusCode==200){
      String responseString = response.body;
      _basicContactInfo= basicContactInfoFromJson(responseString);
      notifyListeners();
    }else showInfo('failed to get Social Data');
  }

  Future<String> getNewSupportTicket(String email, String message,String fullName,
      String mobileNumber, String subject)async{
      var response = await http.post(
        _baseUri,
        body: {
          'api_token': _apiToken,
          'determiner': 'newSupportTicket',
          'email': email,
          'message': message,
          'fullName': fullName,
          'mobileNumber':mobileNumber,
          'subject': subject,
        });
    if(response.statusCode==200){
      final String responseString = response.body;
      final NewSupportTicketModel _newSupportTicketModel=
      newSupportTicketModelFromJson(responseString);

      return _newSupportTicketModel.content.success;
    }
    else return 'Failed! try again later';
  }
  
  Future<RegisterUserModel> registerUser(Map data)async{
    var body = json.encode(data);
    var response = await http.post(
      Uri.parse('https://baghmama.com.bd/graph/api/v4/registerUser'),
      headers: {
        'Content-Type': _contentType,
        'X-Auth-Key': _xAuthKey,
        'X-Auth-Email': _xAuthEmail,
      },
      body: body,
    );
    String responseString= response.body;
    return registerUserModelFromJson(responseString);
  }



}

