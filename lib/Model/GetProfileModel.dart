class GetProfileModel {
  String? status;
  Profile? profile;

  GetProfileModel({this.status, this.profile});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? country;
  String? countryCode;
  String? phone;
  String? image;

  Profile(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.country,
        this.countryCode,
        this.phone,
        this.image});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    country = json['country'];
    countryCode = json['country_code'];
    phone = json['phone'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['country'] = this.country;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['image'] = this.image;
    return data;
  }
}
