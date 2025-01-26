class CountryModel {
  String? status;
  List<Country>? country;

  CountryModel({this.status, this.country});

  CountryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['Country'] != null) {
      country = <Country>[];
      json['Country'].forEach((v) {
        country!.add(new Country.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.country != null) {
      data['Country'] = this.country!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Country {
  String? id;
  String? shortname;
  String? name;

  // @override
  // String toString() {
  //   return '${name}';
  // }

  int? phonecode;

  Country({this.id, this.shortname, this.name, this.phonecode});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    shortname = json['shortname'];
    name = json['name'];
    phonecode = json['phonecode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['shortname'] = this.shortname;
    data['name'] = this.name;
    data['phonecode'] = this.phonecode;
    return data;
  }
}
