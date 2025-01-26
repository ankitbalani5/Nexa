// class ProductReviewModel {
//   String? status;
//   String? averageRating;
//   List<Reviews>? reviews;
//
//   ProductReviewModel({this.status, this.averageRating, this.reviews});
//
//   ProductReviewModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     averageRating = json['average_rating'].toString();
//     if (json['reviews'] != null) {
//       reviews = <Reviews>[];
//       json['reviews'].forEach((v) {
//         reviews!.add(new Reviews.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['average_rating'] = this.averageRating;
//     if (this.reviews != null) {
//       data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
//
//   ProductReviewModel copyWith({
//     String? status,
//     String? averageRating,
//     List<Reviews>? reviews,
//   }){
//     return ProductReviewModel(
//       status: status ?? this.status,
//       averageRating: averageRating ?? this.averageRating,
//       reviews: reviews ?? this.reviews
//     );
//   }
// }
//
// class Reviews {
//   int? id;
//   int? userId;
//   int? productId;
//   String? userName;
//   String? description;
//   int? rating;
//   Null? images;
//   Null? video;
//   String? createdAt;
//   String? updatedAt;
//   int? helpfulVotesCount;
//   bool? helpful;
//   String? date;
//
//   Reviews(
//       {this.id,
//         this.userId,
//         this.productId,
//         this.userName,
//         this.description,
//         this.rating,
//         this.images,
//         this.video,
//         this.createdAt,
//         this.updatedAt,
//         this.helpfulVotesCount,
//         this.helpful,
//         this.date});
//
//   Reviews.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     productId = json['product_id'];
//     userName = json['user_name'];
//     description = json['description'];
//     rating = json['rating'];
//     images = json['images'];
//     video = json['video'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     helpfulVotesCount = json['helpful_votes_count'];
//     helpful = json['helpful'];
//     date = json['date'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['product_id'] = this.productId;
//     data['user_name'] = this.userName;
//     data['description'] = this.description;
//     data['rating'] = this.rating;
//     data['images'] = this.images;
//     data['video'] = this.video;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['helpful_votes_count'] = this.helpfulVotesCount;
//     data['helpful'] = this.helpful;
//     data['date'] = this.date;
//     return data;
//   }
//
//   Reviews copyWith({
//     int? id,
//     int? userId,
//     int? productId,
//     String? userName,
//     String? description,
//     int? rating,
//     Null? images,
//     Null? video,
//     String? createdAt,
//     String? updatedAt,
//     int? helpfulVotesCount,
//     bool? helpful,
//     String? date,
//   }){
//     return Reviews(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       productId: productId ?? this.productId,
//       userName: userName ?? this.userName,
//       description: description ?? this.description,
//       rating: rating ?? this.rating,
//       images: images ?? this.images,
//       video: video ?? this.video,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       helpfulVotesCount: helpfulVotesCount ?? this.helpfulVotesCount,
//       helpful: helpful ?? this.helpful,
//       date: date ?? this.date
//     );
//   }
// }


class ProductReviewModel {
  String? status;
  String? averageRating;
  List<Reviews>? reviews;

  ProductReviewModel({this.status, this.averageRating, this.reviews});

  ProductReviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    averageRating = json['average_rating'].toString();
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['average_rating'] = this.averageRating;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  ProductReviewModel copyWith({
    String? status,
    String? averageRating,
    List<Reviews>? reviews,
  }){
    return ProductReviewModel(
      status: status ?? this.status,
      averageRating: averageRating ?? this.averageRating,
      reviews: reviews ?? this.reviews
    );
  }
}

class Reviews {
  int? id;
  int? userId;
  String? userName;
  String? description;
  int? rating;
  int? productId;
  int? helpfulVotesCount;
  bool? helpful;
  String? userImage;
  List<String>? media;
  String? date;

  Reviews(
      {this.id,
        this.userId,
        this.userName,
        this.description,
        this.rating,
        this.productId,
        this.helpfulVotesCount,
        this.helpful,
        this.userImage,
        this.media,
        this.date});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    description = json['description'];
    rating = json['rating'];
    productId = json['product_id'];
    helpfulVotesCount = json['helpful_votes_count'];
    helpful = json['helpful'];
    userImage = json['user_image'];
    media = json['media'].cast<String>();
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['product_id'] = this.productId;
    data['helpful_votes_count'] = this.helpfulVotesCount;
    data['helpful'] = this.helpful;
    data['user_image'] = this.userImage;
    data['media'] = this.media;
    data['date'] = this.date;
    return data;
  }

  Reviews copyWith({
    int? id,
    int? userId,
    String? userName,
    String? description,
    int? rating,
    int? productId,
    int? helpfulVotesCount,
    bool? helpful,
    String? userImage,
    List<String>? media,
    String? date,
  }){
    return Reviews(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      productId: productId ?? this.productId,
      helpfulVotesCount: helpfulVotesCount ?? this.helpfulVotesCount,
      helpful: helpful ?? this.helpful,
      userImage: userImage ?? this.userImage,
      media: media ?? this.media,
      date: date ?? this.date,
    );
  }
}
