class AddToCartModel {
  String? status;
  String? message;
  String? cartId;

  AddToCartModel({this.status, this.message, this.cartId});

  AddToCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    cartId = json['cart_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['cart_id'] = this.cartId;
    return data;
  }
}
