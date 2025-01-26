class LoginModel {
  String? status;
  String? message;
  String? token;
  int? tokenId;
  UserData? userData;

  LoginModel(
      {this.status, this.message, this.token, this.tokenId, this.userData});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    tokenId = json['token_id'];
    userData = json['user_data'] != null
        ? new UserData.fromJson(json['user_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    data['token_id'] = this.tokenId;
    if (this.userData != null) {
      data['user_data'] = this.userData!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? country;
  String? countryCode;
  String? phone;
  String? image;
  String? currentSteps;

  UserData(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.country,
        this.countryCode,
        this.phone,
        this.image,
        this.currentSteps});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    country = json['country'];
    countryCode = json['country_code'];
    phone = json['phone'];
    image = json['image'];
    currentSteps = json['current_steps'];
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
    data['current_steps'] = this.currentSteps;
    return data;
  }
}
