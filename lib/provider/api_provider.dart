import 'dart:io';
import 'package:bagh_mama/models/all_product_model.dart';
import 'package:bagh_mama/models/basic_contact_info_model.dart';
import 'package:bagh_mama/models/category_product_model.dart';
import 'package:bagh_mama/models/coupon_discount_model.dart';
import 'package:bagh_mama/models/create_support_ticket_model.dart';
import 'package:bagh_mama/models/new_arrival_products_model.dart';
import 'package:bagh_mama/models/popular_product_model.dart';
import 'package:bagh_mama/models/product_category_model.dart';
import 'package:bagh_mama/models/product_info_model.dart';
import 'package:bagh_mama/models/register_user_model.dart';
import 'package:bagh_mama/models/related_product_model.dart';
import 'package:bagh_mama/models/shipping_location_model.dart';
import 'package:bagh_mama/models/shipping_methods_model.dart';
import 'package:bagh_mama/models/social_contact_info_model.dart';
import 'package:bagh_mama/models/user_info_model.dart';
import 'package:bagh_mama/widget/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class APIProvider extends ChangeNotifier{

  final String _xAuthKey = 'aHR0cHN+YmFnaG1hbWEuY29tLmJkfmFwaQ';
  final String _contentType='application/json';
  final String _xAuthEmail='info@baghmama.com.bd';

  int _selectedIndex=0;
  List<String> _bannerImageList=[];
  List<NetworkImage> _networkImageList=[];
  List<ProductCategoryModel> _allCategoryList=[];
  List<MainCategoryWithId> _mainCategoryWithId = [];
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
  ShippingLocationsModel _shippingLocationsModel;
  List<ShippingMethodsModel> _shippingMethodsList=<ShippingMethodsModel>[];
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
  get mainCategoryWithId=> _mainCategoryWithId;
  get socialContactInfo => _socialContactInfo;
  get basicContactInfo => _basicContactInfo;
  get profileImageLink => _profileImageLink;
  get wishListIdList => _wishListIdList;
  get wishList => _wishList;
  get notificationList=> _notificationList;
  get shippingLocationsModel=> _shippingLocationsModel;
  get shippingMethodsList=> _shippingMethodsList;

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

  Future<void> getMainCategoryWithId()async{
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/productCategories'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail,
        },
    );
    if(response.statusCode==200){
      var jsonData = jsonDecode(response.body);
      jsonData['content'].forEach((element) {
        MainCategoryWithId model = MainCategoryWithId(
            id: element['id'],
            main: element['main'],
            position: element['position'],
            categoryIcon: element['category_icon']
        );
        _mainCategoryWithId.add(model);
      });
      print(_mainCategoryWithId.length);
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
      await pref.setString('username', _userInfoModel.content.username);
      await pref.setString('userId', _userInfoModel.content.id.toString());
      await pref.setString('mobile', _userInfoModel.content.mobileNumber.toString());
      await pref.setString('fullAddress',
          '${_userInfoModel.content.address},${_userInfoModel.content.postalcode},'
              '${_userInfoModel.content.city},${_userInfoModel.content.state},'
              '${_userInfoModel.content.country}');
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
      _basicContactInfo.content.email;
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

  Future<bool> updatePassword(Map map)async{
    var body = jsonEncode(map);
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/updateUserPassword'),
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

  Future<String> sendVerificationCode(Map map)async{
    var body = jsonEncode(map);
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/forgotPasswordSendVerification'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail
        },
        body: body
    );
    var jsonData = jsonDecode(response.body);
    if(jsonData['status']=='SUCCESS'){
      return jsonData['content']['session_token'];
    }
    else return '';
  }

  Future<bool> resetPassword(Map map)async{
    var body = jsonEncode(map);
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/forgotPasswordSubmitPasword'),
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

  Future<CouponDiscountModel> getCouponDiscount(Map map)async{
    var body = jsonEncode(map);
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/couponDiscount'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail
        },
        body: body
    );
    String responseString = response.body;
    CouponDiscountModel _couponDiscountModel = couponDiscountModelFromJson(responseString);
    return _couponDiscountModel;
  }

  Future<bool> getShippingLocations()async{
    var response = await http.post(
        Uri.parse('https://baghmama.com.bd/graph/api/v4/shippingLocations'),
        headers: {
          'Content-Type': _contentType,
          'X-Auth-Key': _xAuthKey,
          'X-Auth-Email': _xAuthEmail
        },
    );
    String responseString = response.body;
     _shippingLocationsModel = shippingLocationsModelFromJson(responseString);
     notifyListeners();
     if(_shippingLocationsModel.status=='SUCCESS'){
       return true;
     } else return false;
  }

  Future<bool> getShippingMethods(Map map)async{
    var body = jsonEncode(map);
    var response = await http.post(
      Uri.parse('https://baghmama.com.bd/graph/api/v4/shippingMethods'),
      headers: {
        'Content-Type': _contentType,
        'X-Auth-Key': _xAuthKey,
        'X-Auth-Email': _xAuthEmail
      },
      body: body
    );
    var jsonData = json.decode(response.body);
    if(jsonData['status']=='SUCCESS'){
      _shippingMethodsList.clear();
      jsonData['content'].forEach((element){
        ShippingMethodsModel model = ShippingMethodsModel(
          id: element['id'],
          methodLogo: element['method_logo'],
          methodName: element['method_name'],
          location: element['location'],
          cost: element['cost'],
          estimateTime: element['estimate_time'],
          status: element['status'],
        );
        _shippingMethodsList.add(model);
      });
      notifyListeners();
      print('Method length: ${_shippingMethodsList.length}');
      return true;
    } else return false;
  }

}

