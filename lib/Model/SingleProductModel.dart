//
// class SingleProductModel {
//   String? status;
//   Product? product;
//
//   SingleProductModel({this.status, this.product});
//
//   SingleProductModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     product =
//     json['product'] != null ? new Product.fromJson(json['product']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.product != null) {
//       data['product'] = this.product!.toJson();
//     }
//     return data;
//   }
// }
//
// class Product {
//   int? id;
//   String? productName;
//   String? description;
//   String? featureImage;
//   int? childCategory;
//   String? quantity;
//   String? regularPrice;
//   String? salePrice;
//   List<ProductDetails>? productDetails;
//   String? productType;
//   List<String>? galleryImage;
//   int? discountPercent;
//   int? cartProductQuantity;
//   int? cartId;
//   bool? wishlist;
//   bool? loading;
//
//   Product(
//       {this.id,
//         this.productName,
//         this.description,
//         this.featureImage,
//         this.childCategory,
//         this.quantity,
//         this.regularPrice,
//         this.salePrice,
//         this.productDetails,
//         this.productType,
//         this.galleryImage,
//         this.discountPercent,
//         this.cartProductQuantity,
//         this.cartId,
//         this.wishlist,
//         this.loading});
//
//   Product.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productName = json['product_name'];
//     description = json['description'];
//     featureImage = json['feature_image'];
//     childCategory = json['child_category'];
//     quantity = json['quantity'].toString();
//     regularPrice = json['regular_price'];
//     salePrice = json['sale_price'];
//     if (json['product_details'] != null) {
//       productDetails = <ProductDetails>[];
//       json['product_details'].forEach((v) {
//         productDetails!.add(new ProductDetails.fromJson(v));
//       });
//     }
//     productType = json['product_type'];
//     galleryImage = json['gallery_image'].cast<String>();
//     discountPercent = json['discount_percent'];
//     cartProductQuantity = json['cart_product_quantity'];
//     cartId = json['cart_id'];
//     wishlist = json['wishlist'];
//     loading = json['loading'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['product_name'] = this.productName;
//     data['description'] = this.description;
//     data['feature_image'] = this.featureImage;
//     data['child_category'] = this.childCategory;
//     data['quantity'] = this.quantity;
//     data['regular_price'] = this.regularPrice;
//     data['sale_price'] = this.salePrice;
//     if (this.productDetails != null) {
//       data['product_details'] =
//           this.productDetails!.map((v) => v.toJson()).toList();
//     }
//     data['product_type'] = this.productType;
//     data['gallery_image'] = this.galleryImage;
//     data['discount_percent'] = this.discountPercent;
//     data['cart_product_quantity'] = this.cartProductQuantity;
//     data['cart_id'] = this.cartId;
//     data['wishlist'] = this.wishlist;
//     data['loading'] = this.loading;
//     return data;
//   }
// }
//
// class ProductDetails {
//   String? color;
//   String? sku;
//   String? totalStockQuantity;
//   String? regularPrice;
//   String? salePrice;
//   String? colorName;
//   ColorImages? colorImages;
//   int? discountPercent;
//
//   ProductDetails(
//       {this.color,
//         this.sku,
//         this.totalStockQuantity,
//         this.regularPrice,
//         this.salePrice,
//         this.colorName,
//         this.colorImages,
//         this.discountPercent});
//
//   ProductDetails.fromJson(Map<String, dynamic> json) {
//     color = json['Color'];
//     sku = json['sku'];
//     totalStockQuantity = json['total_stock_quantity'].toString();
//     regularPrice = json['regular_price'];
//     salePrice = json['sale_price'];
//     colorName = json['Color_name'];
//     colorImages = json['color_images'] != null
//         ? new ColorImages.fromJson(json['color_images'])
//         : null;
//     discountPercent = json['discount_percent'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Color'] = this.color;
//     data['sku'] = this.sku;
//     data['total_stock_quantity'] = this.totalStockQuantity;
//     data['regular_price'] = this.regularPrice;
//     data['sale_price'] = this.salePrice;
//     data['Color_name'] = this.colorName;
//     if (this.colorImages != null) {
//       data['color_images'] = this.colorImages!.toJson();
//     }
//     data['discount_percent'] = this.discountPercent;
//     return data;
//   }
// }
//
// class ColorImages {
//   String? featureImage;
//   List<String>? colorGallery;
//
//   ColorImages({this.featureImage, this.colorGallery});
//
//   ColorImages.fromJson(Map<String, dynamic> json) {
//     featureImage = json['feature_image'];
//     colorGallery = json['color_gallery'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['feature_image'] = this.featureImage;
//     data['color_gallery'] = this.colorGallery;
//     return data;
//   }
// }


class SingleProductModel {
  String? status;
  Product? product;

  SingleProductModel({this.status, this.product});

  SingleProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }

  SingleProductModel copyWith({
    String? status,
    Product? product,
}){
    return SingleProductModel(
      status: status ?? this.status,
      product: product ?? this.product,
    );
  }
}

class Product {
  int? productId;
  String? productName;
  String? description;
  String? featureImage;
  List<String>? galleryImage;
  String? regularPrice;
  String? salePrice;
  int? availableQuantity;
  int? cartProductQuantity;
  int? cartId;
  bool? cart;
  bool? like;
  int? discountPercent;
  bool? available;
  String? soldOut;
  bool? loading;
  bool? cartloading;
  int? counter;
  int? minOrder;
  String? averageRating;
  List<Reviews>? reviews;

  Product(
      {this.productId,
        this.productName,
        this.description,
        this.featureImage,
        this.galleryImage,
        this.regularPrice,
        this.salePrice,
        this.availableQuantity,
        this.cartProductQuantity,
        this.cartId,
        this.cart,
        this.like,
        this.discountPercent,
        this.available,
        this.soldOut,
        this.loading,
        this.cartloading,
        this.counter,
        this.minOrder,
        this.averageRating,
        this.reviews
      });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    description = json['description'];
    featureImage = json['feature_image'];
    galleryImage = json['gallery_image'].cast<String>();
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    availableQuantity = json['available_quantity'];
    cartProductQuantity = json['cart_product_quantity'];
    cartId = json['cart_id'];
    cart = json['cart'];
    like = json['like'];
    discountPercent = json['discount_percent'];
    available = json['available'];
    soldOut = json['sold_out'].toString();
    loading = json['loading'];
    cartloading = json['cartloading'];
    counter = json['counter'];
    minOrder = json['min_order'];
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
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['description'] = this.description;
    data['feature_image'] = this.featureImage;
    data['gallery_image'] = this.galleryImage;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['available_quantity'] = this.availableQuantity;
    data['cart_product_quantity'] = this.cartProductQuantity;
    data['cart_id'] = this.cartId;
    data['cart'] = this.cart;
    data['like'] = this.like;
    data['discount_percent'] = this.discountPercent;
    data['available'] = this.available;
    data['sold_out'] = this.soldOut;
    data['loading'] = this.loading;
    data['cartloading'] = this.cartloading;
    data['counter'] = this.counter;
    data['min_order'] = this.minOrder;
    data['average_rating'] = this.averageRating;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Product copyWith({
    int? productId,
    String? productName,
    String? description,
    String? featureImage,
    List<String>? galleryImage,
    String? regularPrice,
    String? salePrice,
    int? availableQuantity,
    int? cartProductQuantity,
    int? cartId,
    bool? like,
    bool? cart,
    int? discountPercent,
    bool? available,
    String? soldOut,
    bool? loading,
    bool? cartloading,
    int? counter,
    int? minOrder,
    String? averageRating,
    List<Reviews>? reviews,
}){
    return Product(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      featureImage: featureImage ?? this.featureImage,
      galleryImage: galleryImage ?? this.galleryImage,
      regularPrice: regularPrice ?? this.regularPrice,
      salePrice: salePrice ?? this.salePrice,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      cartProductQuantity: cartProductQuantity ?? this.cartProductQuantity,
      cartId: cartId ?? this.cartId,
      like: like ?? this.like,
      cart: cart ?? this.cart,
      discountPercent: discountPercent ?? this.discountPercent,
      available: available ?? this.available,
      soldOut: soldOut ?? this.soldOut,
      loading: loading ?? this.loading,
      cartloading: cartloading ?? this.cartloading,
      counter: counter ?? this.counter,
      minOrder: minOrder ?? this.minOrder,
      averageRating: averageRating ?? this.averageRating,
      reviews: reviews ?? this.reviews,
    );
  }
}
class Reviews {
  int? id;
  int? userId;
  String? userName;
  String? description;
  String? rating;
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
    rating = json['rating'].toString();
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
    String? rating,
    int? productId,
    int? helpfulVotesCount,
    bool? helpful,
    String? userImage,
    List<String>? media,
    String? date,
  }){
    return Reviews(
      id: id ??  this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      productId: productId ?? this.productId,
      helpfulVotesCount: helpfulVotesCount ?? this.helpfulVotesCount,
      helpful: helpful ?? this.helpful,
      userImage: userImage ?? this.userImage,
      media: media ?? this.media,
      date: date ?? this.date
    );
  }
}