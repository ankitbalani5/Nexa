class DeleteShippingAddressModel {
  String? status;
  String? message;

  DeleteShippingAddressModel({this.status, this.message});

  DeleteShippingAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
