class AllShippingAddressModel {
  String? status;
  List<ShippingAddress>? shippingAddress;

  AllShippingAddressModel({this.status, this.shippingAddress});

  AllShippingAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['ShippingAddress'] != null) {
      shippingAddress = <ShippingAddress>[];
      json['ShippingAddress'].forEach((v) {
        shippingAddress!.add(new ShippingAddress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.shippingAddress != null) {
      data['ShippingAddress'] =
          this.shippingAddress!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShippingAddress {
  int? id;
  int? userId;
  String? name;
  String? address;
  String? city;
  String? country;
  String? state;
  String? zipCode;
  String? countryCode;
  String? phone;
  int? primaryAddress;
  String? createdAt;
  String? updatedAt;
  int? cityId;
  int? countryId;
  int? stateId;

  ShippingAddress(
      {this.id,
        this.userId,
        this.name,
        this.address,
        this.city,
        this.country,
        this.state,
        this.zipCode,
        this.countryCode,
        this.phone,
        this.primaryAddress,
        this.createdAt,
        this.updatedAt,
        this.cityId,
        this.countryId,
        this.stateId});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    zipCode = json['zip_code'];
    countryCode = json['country_code'];
    phone = json['phone'];
    primaryAddress = json['primary_address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    cityId = json['city_id'];
    countryId = json['country_id'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['zip_code'] = this.zipCode;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['primary_address'] = this.primaryAddress;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['city_id'] = this.cityId;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    return data;
  }
}
