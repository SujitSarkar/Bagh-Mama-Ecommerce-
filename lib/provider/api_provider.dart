import 'package:bagh_mama/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIProvider extends ChangeNotifier{

  Uri _baseUri = Uri.parse('https://baghmama.com.bd/graph/api/v3');
  List<String> _bannerImageList = [];
  List<dynamic> _networkImageList=[];
  ProductsModel _productsModel;

  get bannerImageList => _bannerImageList;
  get networkImageList => _networkImageList;
  get productsModel => _productsModel;

  Future<void> getBannerImageList()async{
    await http.post(
      _baseUri,
      body: {
        'api_token': 'aHR0cHN+YmFnaG1hbWEuY29tLmJkfmFwaQ',
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
        'api_token': 'aHR0cHN+YmFnaG1hbWEuY29tLmJkfmFwaQ',
        'determiner': 'products',
        'fetch_scope': 'main'
      });
    if(response.statusCode==200){
      final String responseString = response.body;
      _productsModel= productsModelFromJson(responseString);
      notifyListeners();
    }
  }

}

