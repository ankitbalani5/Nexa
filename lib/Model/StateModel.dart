class StateModel {
  String? status;
  List<States>? states;

  StateModel({this.status, this.states});

  StateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['states'] != null) {
      states = <States>[];
      json['states'].forEach((v) {
        states!.add(new States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.states != null) {
      data['states'] = this.states!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class States {
  String? id;
  String? name;
  int? countryId;

  States({this.id, this.name, this.countryId});

  States.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['name'] = this.name;
    data['country_id'] = this.countryId;
    return data;
  }
}
