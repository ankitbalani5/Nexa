class CityModel {
  String? status;
  List<Cities>? cities;

  CityModel({this.status, this.cities});

  CityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.cities != null) {
      data['cities'] = this.cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  String? id;
  String? name;
  int? stateId;

  Cities({this.id, this.name, this.stateId});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['name'] = this.name;
    data['state_id'] = this.stateId;
    return data;
  }
}
