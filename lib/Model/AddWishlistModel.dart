class AddWishlistModel {
  String? status;
  String? message;
  bool? addFavourite;

  AddWishlistModel({this.status, this.message, this.addFavourite});

  AddWishlistModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    addFavourite = json['add_favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['add_favourite'] = this.addFavourite;
    return data;
  }
}
