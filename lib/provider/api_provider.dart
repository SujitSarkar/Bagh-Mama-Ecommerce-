import 'dart:io';
import 'package:bagh_mama/models/all_product_model.dart';
import 'package:bagh_mama/models/basic_contact_info_model.dart';
import 'package:bagh_mama/models/category_product_model.dart';
import 'package:bagh_mama/models/create_support_ticket_model.dart';
import 'package:bagh_mama/models/new_arrival_products_model.dart';
import 'package:bagh_mama/models/popular_product_model.dart';
import 'package:bagh_mama/models/product_category_model.dart';
import 'package:bagh_mama/models/product_info_model.dart';
import 'package:bagh_mama/models/register_user_model.dart';
import 'package:bagh_mama/models/related_product_model.dart';
import 'package:bagh_mama/models/social_contact_info_model.dart';
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

  int _selectedIndex=0;
  List<String> _bannerImageList=[];
  List<NetworkImage> _networkImageList=[];
  List<ProductCategoryModel> _allCategoryList=[];
  List<String> _mainCategoryList=[];
  List<ProductCategoryModel> _subCategoryList=[];
  List<WishListModel> _wishList=[];
  AllProductModel _allProductModel;
  NewArrivalProductModel _newArrivalProductModel;
  PopularProductModel _popularProductModel;
  CategoryProductModel _categoryProductModel;
  RelatedProductModel _relatedProductModel;
  ProductInfoModel _productInfoModel;
  List<ProductReviewModel> _productReviewList=[];
  List<ProductQuestionModel> _productQuestionList=[];
  UserInfoModel _userInfoModel;
  SocialContactInfo _socialContactInfo;
  BasicContactInfo _basicContactInfo;
  String _profileImageLink;
  List<String> _wishListIdList=[];
  List<Notifications> _notificationList=[];

  get selectedIndex => _selectedIndex;
  get bannerImageList => _bannerImageList;
  get networkImageList => _networkImageList;
  get allProductModel => _allProductModel;
  get newArrivalProductModel => _newArrivalProductModel;
  get popularProductModel => _popularProductModel;
  get categoryProductModel => _categoryProductModel;
  get relatedProductModel => _relatedProductModel;
  get productInfoModel => _productInfoModel;
  get productReviewList => _productReviewList;
  get productQuestionList => _productQuestionList;
  get userInfoModel => _userInfoModel;
  get allCategoryList => _allCategoryList;
  get mainCategoryList => _mainCategoryList;
  get subCategoryList => _subCategoryList;
  get socialContactInfo => _socialContactInfo;
  get basicContactInfo => _basicContactInfo;
  get profileImageLink => _profileImageLink;
  get wishListIdList => _wishListIdList;
  get wishList => _wishList;
  get notificationList=> _notificationList;

  set userInfoModel(UserInfoModel value){
    _userInfoModel = value;
    notifyListeners();
  }
  set selectedIndex(int value){
    _selectedIndex = value;
    notifyListeners();
  }
  set categoryProductModel(var model){
    _categoryProductModel = model;
    notifyListeners();
  }

  void clearWishlist(){
    _wishList.clear();
  }
  void clearNotificationList(){
    _notificationList.clear();
  }
  void clearOrderList(){

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
      },
        body: {
        "id": pref.getString('userId'),
        'ppic': baseImage,
      }
    );
    var jsonData = json.decode(response.body);
    if(jsonData['status']=='SUCCESS'){
      return jsonData['content']['success'];
    }else{
      return jsonData['content']['success'];
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
    final Map map= {"fetch_all":"true"};
    var body= json.encode(map);
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/productCategories'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail,
        },
      body: body
        );
    if(response.statusCode==200){
       var jsonData = jsonDecode(response.body);
       Set _categorySet=Set.from({'All'});

      jsonData['content'].forEach((element) {
        ProductCategoryModel model = ProductCategoryModel(
          id: element['id'],
          main: element['main'],
          header: element['header'],
          sub: element['sub'],
          position: element['position'],
          categoryIcon: element['category_icon']
        );
        _allCategoryList.add(model);
        _categorySet.add(element['main']);
      });
      _subCategoryList.addAll(_allCategoryList);
      _categorySet.forEach((element) {
        _mainCategoryList.add(element);
      });
      notifyListeners();
    }
  }

  void updateSubCategoryList(String mainCategory){
    _categoryProductModel=null;
    _subCategoryList.clear();
    if(mainCategory=='All'){
      _subCategoryList.addAll(_allCategoryList);
      notifyListeners();
      print(_subCategoryList.length);
    }else{
      for(int i=0;i<_allCategoryList.length;i++){
        if(_allCategoryList[i].main.contains(mainCategory)){
          _subCategoryList.add(_allCategoryList[i]);
        }
      }
      notifyListeners();
    }
  }

  Future<void> getAllProducts()async{
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/products'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail,
        },
    );
    if(response.statusCode==200){
      final String responseString = response.body;
      _allProductModel= allProductModelFromJson(responseString);
      notifyListeners();
    }
  }

  Future<void> getNewArrivalProducts()async{
    Map map = {"sort":"2"};
    var body = json.encode(map);

    var response = await http.post(
      Uri.parse('https://baghmama.com.bd/graph/api/v4/products'),
      headers: {
        'Content-Type': _contentType,
        'X-Auth-Key': _xAuthKey,
        'X-Auth-Email': _xAuthEmail,
      },
      body: body
      );
    if(response.statusCode==200){
      final String responseString = response.body;
      _newArrivalProductModel= newArrivalProductModelFromJson(responseString);
      notifyListeners();
    }
  }

  Future<void> getPopularProducts()async{
    Map map = {"sort":"1"};
    var body = json.encode(map);

    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/products'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail,
        },
        body: body
    );
    if(response.statusCode==200){
      final String responseString = response.body;
      _popularProductModel= popularProductModelFromJson(responseString);
      notifyListeners();
    }
  }

  Future<void> getCategoryProducts(Map map)async{
    var body = json.encode(map);
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/products'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail,
        },
        body: body
    );
    if(response.statusCode==200){
      final String responseString = response.body;
      _categoryProductModel= categoryProductModelFromJson(responseString);
      notifyListeners();
    }
  }

  Future<void> getRelatedProducts(int categoryId)async{
    Map map = {"category_id":"$categoryId"};
    var body = json.encode(map);
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/products'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail,
        },
        body: body
    );
    if(response.statusCode==200){
      final String responseString = response.body;
      _relatedProductModel= relatedProductModelFromJson(responseString);
      notifyListeners();
    }
  }

  Future<void> getProductInfo(int id)async{
    Map map = {"product_id":"$id"};
    var body = json.encode(map);
    var response = await http.post(
      Uri.parse('https://baghmama.com.bd/graph/api/v4/productInfo'),
      headers: {
        'Content-Type': _contentType,
        'X-Auth-Key': _xAuthKey,
        'X-Auth-Email': _xAuthEmail,
      },
      body: body
    );
    if(response.statusCode==200){
       String responseString = response.body;
      _productInfoModel= productInfoModelFromJson(responseString);

      ///get product review
      var jsonData = jsonDecode(response.body);
      if(jsonData['content']['product_reviews'].isNotEmpty){
        _productReviewList.clear();
        jsonData['content']['product_reviews'].forEach((element){
          ProductReviewModel model = ProductReviewModel(
            reviewId: element['reviewId'],
            date: element['date'],
            username: element['username'],
            reviewText: element['reviewText'],
            rating: element['rating'],
            status: element['status'],
          );
          _productReviewList.add(model);
        });
      }else _productReviewList.clear();
       ///get product Question
      if(jsonData['content']['product_questions'].isNotEmpty){
        _productQuestionList = productQuestionModelFromJson(jsonEncode(jsonData['content']['product_questions']));
      }else _productQuestionList.clear();

      notifyListeners();
    }
  }

  Future<bool> replyProductQuestion(Map map)async{
    var body = json.encode(map);
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/productQuestion'),
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
    else return jsonData['content']['success'];
  }

  Future<bool> writeProductReview(Map map)async{
    var body = json.encode(map);
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/productReview'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail,
        },
        body: body
    );
    if(response.statusCode==200){
      var jsonData = response.body;
      return true;
    }else return false;
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
      var jsonData = jsonDecode(response.body);
      _userInfoModel = userInfoModelFromJson(responseString);
      _userInfoModel.content.profilePic;
      await pref.setString('username', _userInfoModel.content.username);
      await pref.setString('userId', _userInfoModel.content.id.toString());
      await pref.setString('mobile', _userInfoModel.content.mobileNumber.toString());
      await pref.setString('address', _userInfoModel.content.address.toString());
      await pref.setString('name', '${_userInfoModel.content.firstName} ${_userInfoModel.content.lastName}');
      ///Get Wishlist ID
      if(_userInfoModel.content.wishlists.isNotEmpty){
        _wishListIdList.clear();
        _userInfoModel.content.wishlists.forEach((element) {
          _wishListIdList.add(element);
        });
      }else _wishListIdList.clear();

      ///Get Notifications
      if(jsonData['content']['notifications'].isNotEmpty){
        _notificationList.clear();
        jsonData['content']['notifications'].forEach((element){
          Notifications notifications = Notifications(
            notificationType: element['notificationType'],
            notificationText: element['notificationText'],
            link: element['link'],
            status: element['status']
          );
          _notificationList.add(notifications);
        });
      }else _notificationList.clear();
      notifyListeners();
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
    Map map = {
      "sort":"1"
    };
    var body= json.encode(map);
    var response = await http.post(
      Uri.parse('https://baghmama.com.bd/graph/api/v4/socialContactInfo'),
      headers: {
        'Content-Type': _contentType,
        'X-Auth-Key': _xAuthKey,
        'X-Auth-Email': _xAuthEmail
      },
      body: body
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

  Future<String> createSupportTicket(Map map)async{
    var body = jsonEncode(map);
    var response = await http.post(
      Uri.parse('https://baghmama.com.bd/graph/api/v4/newSupportTicket'),
      headers: {
        'Content-Type': _contentType,
        'X-Auth-Key': _xAuthKey,
        'X-Auth-Email': _xAuthEmail
      },
      body: body
    );
    final String responseString = response.body;
    final CreateSupportTokenModel _createSupportTokenModel=
    createSupportTokenModelFromJson(responseString);
    if(_createSupportTokenModel.status=='SUCCESS'){
      return 'Token no: ${_createSupportTokenModel.content.tokenNo.toString()}';
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

  Future<bool> addProductToWishlist(Map map)async{
    var body = jsonEncode(map);
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/addItemToWishlist'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail
        },
        body: body
    );
    var jsonData = jsonDecode(response.body);
    if(jsonData['status']=='SUCCESS'){
      return jsonData['content']['success'];
    }
    else return jsonData['content']['success'];
  }

  Future<void> getWishListProduct()async{
    _wishList.clear();
    _wishListIdList.forEach((element) async{
      Map map = {"product_id":element};
      var body = jsonEncode(map);
      var response = await http.post(
          Uri.parse('https://baghmama.com.bd/graph/api/v4/productInfo'),
          headers: {
            'Content-Type': _contentType,
            'X-Auth-Key': _xAuthKey,
            'X-Auth-Email': _xAuthEmail
          },
          body: body
      );
      var jsonData = jsonDecode(response.body);
      WishListModel wishListModel = WishListModel(
        pId: jsonData['content']['product_id'].toString(),
        pName: jsonData['content']['name'],
        pPrice: jsonData['content']['price_stock']['price'].toString(),
        pImageLink:jsonData['content']['thumnail_image']
      );
      _wishList.add(wishListModel);
      notifyListeners();
    });

  }

  Future<bool> removeItemFromWishList(Map map)async{
    var body = jsonEncode(map);
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/removeItemFromWishlist'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail
        },
        body: body
    );
    var jsonData = jsonDecode(response.body);
    if(jsonData['status']=='SUCCESS'){
      return jsonData['content']['success'];
    }
    else return jsonData['content']['success'];
  }


}

