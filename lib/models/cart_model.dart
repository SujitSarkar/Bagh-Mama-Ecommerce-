class CartModel{
  String _id;
  String _pId;
  String _pSize;
  String _pColor;
  String _pQuantity;
  String _pImageLink;
  CartModel(this._pId, this._pSize, this._pColor, this._pQuantity, this._pImageLink);

  String get id => _id;
  String get pId => _pId;
  String get pSize => _pSize;
  String get pImageLink => _pImageLink;
  String get pQuantity => _pQuantity;
  String get pColor => _pColor;

  set pImageLink(String value) {
    _pImageLink = value;
  }
  set pQuantity(String value) {
    _pQuantity = value;
  }
  set pColor(String value) {
    _pColor = value;
  }
  set pSize(String value) {
    _pSize = value;
  }
  set pId(String value) {
    _pId = value;
  }

  //Convert a note object to mop object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }
    map['pId'] = _pId;
    map['pSize'] = _pSize;
    map['pColor'] = _pColor;
    map['pQuantity'] = _pQuantity;
    map['pImageLink'] = _pImageLink;
    return map;
  }

  //Extract a note object from a map object
  CartModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._pId = map['pId'];
    this._pSize = map['pSize'];
    this._pColor = map['pColor'];
    this._pQuantity = map['pQuantity'];
    this._pImageLink = map['pImageLink'];
  }
}