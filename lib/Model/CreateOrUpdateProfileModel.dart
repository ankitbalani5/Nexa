class CreateOrUpdateProfileModel {
  String? status;
  String? message;
  String? currentStep;

  CreateOrUpdateProfileModel({this.status, this.message, this.currentStep});

  CreateOrUpdateProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    currentStep = json['current_step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['current_step'] = this.currentStep;
    return data;
  }
}
