//
// class CartProductsModel {
//   String? status;
//   int? viewCartTotal;
//   int? subTotalPrice;
//   int? totalPrice;
//   String? message;
//   List<ViewCart>? viewCart;
//
//   CartProductsModel(
//       {this.status,
//         this.viewCartTotal,
//         this.subTotalPrice,
//         this.totalPrice,
//         this.message,
//         this.viewCart});
//
//   CartProductsModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     viewCartTotal = json['view_cart_total'];
//     subTotalPrice = json['sub_total_price'];
//     totalPrice = json['total_price'];
//     message = json['message'];
//     if (json['view_cart'] != null) {
//       viewCart = <ViewCart>[];
//       json['view_cart'].forEach((v) {
//         viewCart!.add(new ViewCart.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['view_cart_total'] = this.viewCartTotal;
//     data['sub_total_price'] = this.subTotalPrice;
//     data['total_price'] = this.totalPrice;
//     data['message'] = this.message;
//     if (this.viewCart != null) {
//       data['view_cart'] = this.viewCart!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
//
//   CartProductsModel copyWith({
//     String? status,
//     int? viewCartTotal,
//     int? subTotalPrice,
//     int? totalPrice,
//     String? message,
//     List<ViewCart>? viewCart,
// }){
//     return CartProductsModel(
//       status: status ?? this.status,
//       viewCartTotal: viewCartTotal ?? this.viewCartTotal,
//       subTotalPrice: subTotalPrice ?? this.subTotalPrice,
//       totalPrice: totalPrice ?? this.totalPrice,
//       message: message ?? this.message,
//       viewCart: viewCart ?? this.viewCart,
//     );
//   }
//
// }
//
// class ViewCart {
//   int? id;
//   int? userId;
//   int? productId;
//   int? categoryId;
//   String? productDetails;
//   int? quantity;
//   String? price;
//   String? totalPrice;
//   bool? available;
//   String? image;
//   String? availableQuantity;
//   String? salePrice;
//   String? regularPrice;
//   String? productName;
//   bool? loadinglike;
//   bool? selectVariable;
//
//   ViewCart(
//       {this.id,
//         this.userId,
//         this.productId,
//         this.categoryId,
//         this.productDetails,
//         this.quantity,
//         this.price,
//         this.totalPrice,
//         this.available,
//         this.image,
//         this.availableQuantity,
//         this.salePrice,
//         this.regularPrice,
//         this.productName,
//         this.loadinglike,
//         this.selectVariable});
//
//   ViewCart.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     productId = json['product_id'];
//     categoryId = json['category_id'];
//     productDetails = json['product_details'];
//     quantity = json['quantity'];
//     price = json['price'];
//     totalPrice = json['total_price'];
//     available = json['available'];
//     image = json['image'];
//     availableQuantity = json['available_quantity'];
//     salePrice = json['sale_price'];
//     regularPrice = json['regular_price'];
//     productName = json['product_name'];
//     loadinglike = json['loadinglike'];
//     selectVariable = json['select_variable'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['product_id'] = this.productId;
//     data['category_id'] = this.categoryId;
//     data['product_details'] = this.productDetails;
//     data['quantity'] = this.quantity;
//     data['price'] = this.price;
//     data['total_price'] = this.totalPrice;
//     data['available'] = this.available;
//     data['image'] = this.image;
//     data['available_quantity'] = this.availableQuantity;
//     data['sale_price'] = this.salePrice;
//     data['regular_price'] = this.regularPrice;
//     data['product_name'] = this.productName;
//     data['loadinglike'] = this.loadinglike;
//     data['select_variable'] = this.selectVariable;
//     return data;
//   }
//
//   ViewCart copyWith({
//     int? id,
//     int? userId,
//     int? productId,
//     int? categoryId,
//     String? productDetails,
//     int? quantity,
//     String? price,
//     String? totalPrice,
//     bool? available,
//     String? image,
//     String? availableQuantity,
//     String? salePrice,
//     String? regularPrice,
//     String? productName,
//     bool? loadinglike,
//     bool? selectVariable,
// }){
//     return ViewCart(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       productId: productId ?? this.productId,
//       categoryId: categoryId ?? this.categoryId,
//       productDetails: productDetails ?? this.productDetails,
//       quantity: quantity ?? this.quantity,
//       price: price ??  this.price,
//       totalPrice: totalPrice ?? this.totalPrice,
//       available: available ?? this.available,
//       image: image ?? this.image,
//       availableQuantity: availableQuantity ?? this.availableQuantity,
//       salePrice: salePrice ?? this.salePrice,
//       regularPrice: regularPrice ?? this.regularPrice,
//       productName: productName ?? this.productName,
//       loadinglike: loadinglike ?? this.loadinglike,
//       selectVariable: selectVariable ?? this.selectVariable,
//     );
//   }
//
// }
//

class CartProductsModel {
  String? status;
  int? viewCartTotal;
  int? subTotalPrice;
  String? totalPrice;
  String? discount;
  String? message;
  bool? loading;
  List<ViewCart>? viewCart;
  List<DeliveryAddress>? deliveryAddress;

  CartProductsModel(
      {this.status,
        this.viewCartTotal,
        this.subTotalPrice,
        this.totalPrice,
        this.discount,
        this.message,
        this.loading,
        this.viewCart,
        this.deliveryAddress});

  CartProductsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    viewCartTotal = json['view_cart_total'];
    subTotalPrice = json['sub_total_price'];
    totalPrice = json['total_price'].toString();
    discount = json['discount'].toString();
    message = json['message'];
    loading = json['loading'];
    if (json['view_cart'] != null) {
      viewCart = <ViewCart>[];
      json['view_cart'].forEach((v) {
        viewCart!.add(new ViewCart.fromJson(v));
      });
    }
    if (json['delivery_address'] != null) {
      deliveryAddress = <DeliveryAddress>[];
      json['delivery_address'].forEach((v) {
        deliveryAddress!.add(new DeliveryAddress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['view_cart_total'] = this.viewCartTotal;
    data['sub_total_price'] = this.subTotalPrice;
    data['total_price'] = this.totalPrice;
    data['discount'] = this.discount;
    data['message'] = this.message;
    data['loading'] = this.loading;
    if (this.viewCart != null) {
      data['view_cart'] = this.viewCart!.map((v) => v.toJson()).toList();
    }
    if (this.deliveryAddress != null) {
      data['delivery_address'] =
          this.deliveryAddress!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  CartProductsModel copyWith({
    String? status,
    int? viewCartTotal,
    int? subTotalPrice,
    String? totalPrice,
    String? discount,
    String? message,
    bool? loading,
    List<ViewCart>? viewCart,
    List<DeliveryAddress>? deliveryAddress,
  }){
    return CartProductsModel(
      status: status ?? this.status,
      viewCartTotal: viewCartTotal ?? this.viewCartTotal,
      subTotalPrice: subTotalPrice ?? this.subTotalPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      discount: discount ?? this.discount,
      message: message ?? this.message,
      loading: loading ?? this.loading,
      viewCart: viewCart ?? this.viewCart,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }
}

class ViewCart {
  int? id;
  int? userId;
  int? productId;
  int? categoryId;
  int? subCatId;
  String? productName;
  String? featureImg;
  int? quantity;
  String? price;
  String? minOrder;
  String? regularPrice;
  String? salePrice;
  String? totalPrice;
  String? discount;
  bool? available;
  String? availableQuantity;
  bool? loadinglike;
  bool? select;

  ViewCart(
      {this.id,
        this.userId,
        this.productId,
        this.categoryId,
        this.subCatId,
        this.productName,
        this.featureImg,
        this.quantity,
        this.price,
        this.minOrder,
        this.regularPrice,
        this.salePrice,
        this.totalPrice,
        this.discount,
        this.available,
        this.availableQuantity,
        this.loadinglike,
        this.select});

  ViewCart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    categoryId = json['category_id'];
    subCatId = json['sub_Cat_id'];
    productName = json['product_name'];
    featureImg = json['feature_img'];
    quantity = json['quantity'];
    price = json['price'];
    minOrder = json['min_order'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    totalPrice = json['total_price'].toString();
    discount = json['discount'].toString();
    available = json['available'];
    availableQuantity = json['available_quantity'];
    loadinglike = json['loadinglike'];
    select = json['select'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['category_id'] = this.categoryId;
    data['sub_Cat_id'] = this.subCatId;
    data['product_name'] = this.productName;
    data['feature_img'] = this.featureImg;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['min_order'] = this.minOrder;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['total_price'] = this.totalPrice;
    data['discount'] = this.discount;
    data['available'] = this.available;
    data['available_quantity'] = this.availableQuantity;
    data['loadinglike'] = this.loadinglike;
    data['select'] = this.select;
    return data;
  }

  ViewCart copyWith({
    int? id,
    int? userId,
    int? productId,
    int? categoryId,
    int? subCatId,
    String? productName,
    String? featureImg,
    int? quantity,
    String? regularPrice,
    String? price,
    String? minOrder,
    String? salePrice,
    String? totalPrice,
    String? discount,
    bool? available,
    String? availableQuantity,
    bool? loadinglike,
    bool? select,
  }){
    return ViewCart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      subCatId: subCatId ?? this.subCatId,
      productName: productName ?? this.productName,
      featureImg: featureImg ?? this.featureImg,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      minOrder: minOrder ?? this.minOrder,
      regularPrice: regularPrice ?? this.regularPrice,
      salePrice: salePrice ?? this.salePrice,
      totalPrice: totalPrice ?? this.totalPrice,
      discount: discount ?? this.discount,
      available: available ?? this.available,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      loadinglike: loadinglike ?? this.loadinglike,
      select: select ?? this.select,
    );
  }
}

class DeliveryAddress {
  int? id;
  int? userId;
  String? name;
  String? address;
  String? city;
  String? country;
  String? state;
  String? zipCode;
  String? countryCode;
  String? phone;
  int? primaryAddress;
  String? createdAt;
  String? updatedAt;

  DeliveryAddress(
      {this.id,
        this.userId,
        this.name,
        this.address,
        this.city,
        this.country,
        this.state,
        this.zipCode,
        this.countryCode,
        this.phone,
        this.primaryAddress,
        this.createdAt,
        this.updatedAt});

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    zipCode = json['zip_code'];
    countryCode = json['country_code'];
    phone = json['phone'];
    primaryAddress = json['primary_address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['zip_code'] = this.zipCode;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['primary_address'] = this.primaryAddress;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
