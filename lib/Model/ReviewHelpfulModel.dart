class ReviewHelpfulModel {
  String? status;
  String? message;
  bool? addHelpful;

  ReviewHelpfulModel({this.status, this.message, this.addHelpful});

  ReviewHelpfulModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    addHelpful = json['add_helpful'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['add_helpful'] = this.addHelpful;
    return data;
  }
}
