class WareHouseModel {
  String? status;
  List<Warehouse>? warehouse;

  WareHouseModel({this.status, this.warehouse});

  WareHouseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['warehouse'] != null) {
      warehouse = <Warehouse>[];
      json['warehouse'].forEach((v) {
        warehouse!.add(new Warehouse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.warehouse != null) {
      data['warehouse'] = this.warehouse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Warehouse {
  int? id;
  String? warehouseName;
  String? streetAddress;
  String? country;
  String? state;
  String? city;
  String? zipCode;

  Warehouse(
      {this.id,
        this.warehouseName,
        this.streetAddress,
        this.country,
        this.state,
        this.city,
        this.zipCode});

  Warehouse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warehouseName = json['warehouse_name'];
    streetAddress = json['street_address'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    zipCode = json['zip_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warehouse_name'] = this.warehouseName;
    data['street_address'] = this.streetAddress;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    return data;
  }
}
