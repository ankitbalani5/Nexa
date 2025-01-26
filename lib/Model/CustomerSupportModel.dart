// class CustomerSupportModel {
//   String? status;
//   CustomerSupport? customerSupport;
//
//   CustomerSupportModel({this.status, this.customerSupport});
//
//   CustomerSupportModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     customerSupport = json['CustomerSupport'] != null
//         ? new CustomerSupport.fromJson(json['CustomerSupport'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.customerSupport != null) {
//       data['CustomerSupport'] = this.customerSupport!.toJson();
//     }
//     return data;
//   }
// }
//
// class CustomerSupport {
//   int? id;
//   String? image1;
//   String? heading1;
//   String? description1;
//   String? image2;
//   String? heading2;
//   String? description2;
//   Null? createdAt;
//   String? updatedAt;
//
//   CustomerSupport(
//       {this.id,
//         this.image1,
//         this.heading1,
//         this.description1,
//         this.image2,
//         this.heading2,
//         this.description2,
//         this.createdAt,
//         this.updatedAt});
//
//   CustomerSupport.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     image1 = json['image1'];
//     heading1 = json['heading1'];
//     description1 = json['description1'];
//     image2 = json['image2'];
//     heading2 = json['heading2'];
//     description2 = json['description2'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['image1'] = this.image1;
//     data['heading1'] = this.heading1;
//     data['description1'] = this.description1;
//     data['image2'] = this.image2;
//     data['heading2'] = this.heading2;
//     data['description2'] = this.description2;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }


class CustomerSupportModel {
  String? status;
  String? page;
  CustomerSupport? customerSupport;

  CustomerSupportModel({this.status, this.page, this.customerSupport});

  CustomerSupportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    page = json['page'];
    customerSupport = json['CustomerSupport'] != null
        ? new CustomerSupport.fromJson(json['CustomerSupport'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['page'] = this.page;
    if (this.customerSupport != null) {
      data['CustomerSupport'] = this.customerSupport!.toJson();
    }
    return data;
  }
}

class CustomerSupport {
  int? id;
  String? image1;
  String? description1;
  String? image2;
  String? description2;
  String? page;
  Null? createdAt;
  String? updatedAt;

  CustomerSupport(
      {this.id,
        this.image1,
        this.description1,
        this.image2,
        this.description2,
        this.page,
        this.createdAt,
        this.updatedAt});

  CustomerSupport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image1 = json['image1'];
    description1 = json['description1'];
    image2 = json['image2'];
    description2 = json['description2'];
    page = json['page'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image1'] = this.image1;
    data['description1'] = this.description1;
    data['image2'] = this.image2;
    data['description2'] = this.description2;
    data['page'] = this.page;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
