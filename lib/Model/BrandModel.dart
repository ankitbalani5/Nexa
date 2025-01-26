class BrandModel {
  String? status;
  List<Brands>? brands;

  BrandModel({this.status, this.brands});

  BrandModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(new Brands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brands {
  int? id;
  String? brandName;
  String? slug;
  bool? check;

  Brands({this.id, this.brandName, this.slug, this.check});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandName = json['brand_name'];
    slug = json['slug'];
    check = json['check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brand_name'] = this.brandName;
    data['slug'] = this.slug;
    data['check'] = this.check;
    return data;
  }
}
