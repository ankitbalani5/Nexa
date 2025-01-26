class PlaceOrderModel {
  bool? status;
  String? message;
  String? orderId;
  String? totalAmount;

  PlaceOrderModel({this.status, this.message, this.orderId, this.totalAmount});

  PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    orderId = json['order_id'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['order_id'] = this.orderId;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}
