class ApplyCouponModel {
  bool? status;
  String? message;
  String? discountPrice;
  String? totalPrice;
  String? couponCode;

  ApplyCouponModel(
      {this.status,
        this.message,
        this.discountPrice,
        this.totalPrice,
        this.couponCode});

  ApplyCouponModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    discountPrice = json['discount_price'].toString();
    totalPrice = json['total_price'].toString();
    couponCode = json['coupon_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['discount_price'] = this.discountPrice;
    data['total_price'] = this.totalPrice;
    data['coupon_code'] = this.couponCode;
    return data;
  }
}
