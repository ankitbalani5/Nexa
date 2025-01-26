//
// class AllProductModel {
//   String? status;
//   List<Products>? products;
//
//   AllProductModel({this.status, this.products});
//
//   AllProductModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['products'] != null) {
//       products = <Products>[];
//       json['products'].forEach((v) {
//         products!.add(new Products.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.products != null) {
//       data['products'] = this.products!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
//
//   AllProductModel copyWith ({
//     String? status,
//     List<Products>? products,
//   }){
//     return AllProductModel(
//       status: status ?? this.status,
//       products: products ?? this.products,
//     );
//   }
// }
//
// class Products {
//   int? id;
//   String? productName;
//   String? featureImage;
//   Null? brandId;
//   int? quantity;
//   String? regularPrice;
//   String? salePrice;
//   ProductDetails? productDetails;
//   String? productType;
//   bool? inWishlist;
//   int? discountPercent;
//   bool? loading;
//
//   Products(
//       {this.id,
//         this.productName,
//         this.featureImage,
//         this.brandId,
//         this.quantity,
//         this.regularPrice,
//         this.salePrice,
//         this.productDetails,
//         this.productType,
//         this.inWishlist,
//         this.discountPercent,
//         this.loading});
//
//   Products.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productName = json['product_name'];
//     featureImage = json['feature_image'];
//     brandId = json['brand_id'];
//     quantity = json['quantity'];
//     regularPrice = json['regular_price'];
//     salePrice = json['sale_price'];
//     productDetails = json['product_details'] != null
//         ? new ProductDetails.fromJson(json['product_details'])
//         : null;
//     productType = json['product_type'];
//     inWishlist = json['in_wishlist'];
//     discountPercent = json['discount_percent'];
//     loading = json['loading'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['product_name'] = this.productName;
//     data['feature_image'] = this.featureImage;
//     data['brand_id'] = this.brandId;
//     data['quantity'] = this.quantity;
//     data['regular_price'] = this.regularPrice;
//     data['sale_price'] = this.salePrice;
//     if (this.productDetails != null) {
//       data['product_details'] = this.productDetails!.toJson();
//     }
//     data['product_type'] = this.productType;
//     data['in_wishlist'] = this.inWishlist;
//     data['discount_percent'] = this.discountPercent;
//     data['loading'] = this.loading;
//     return data;
//   }
//
//   Products copyWith({
//     int? id,
//     String? productName,
//     String? featureImage,
//     Null? brandId,
//     int? quantity,
//     String? regularPrice,
//     String? salePrice,
//     ProductDetails? productDetails,
//     String? productType,
//     bool? inWishlist,
//     int? discountPercent,
//     bool? loading,
//   }){
//     return Products(
//       id: id ?? this.id,
//       productName: productName ?? this.productName,
//       featureImage: featureImage ?? this.featureImage,
//       brandId: brandId ?? this.brandId,
//       quantity: quantity ?? this.quantity,
//       regularPrice: regularPrice ?? this.regularPrice,
//       salePrice: salePrice ?? this.salePrice,
//       productDetails: productDetails ?? this.productDetails,
//       productType: productType ?? this.productType,
//       inWishlist: inWishlist ?? this.inWishlist,
//       discountPercent: discountPercent ?? this.discountPercent,
//       loading: loading ?? this.loading,
//     );
//   }
// }
//
// class ProductDetails {
//   String? color;
//   String? sku;
//   String? totalStockQuantity;
//   String? regularPrice;
//   String? salePrice;
//   String? capacity;
//
//   ProductDetails(
//       {this.color,
//         this.sku,
//         this.totalStockQuantity,
//         this.regularPrice,
//         this.salePrice,
//         this.capacity});
//
//   ProductDetails.fromJson(Map<String, dynamic> json) {
//     color = json['Color'];
//     sku = json['sku'];
//     totalStockQuantity = json['total_stock_quantity'].toString();
//     regularPrice = json['regular_price'];
//     salePrice = json['sale_price'];
//     capacity = json['Capacity'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Color'] = this.color;
//     data['sku'] = this.sku;
//     data['total_stock_quantity'] = this.totalStockQuantity;
//     data['regular_price'] = this.regularPrice;
//     data['sale_price'] = this.salePrice;
//     data['Capacity'] = this.capacity;
//     return data;
//   }
//
//   ProductDetails copyWith({
//     String? color,
//     String? sku,
//     String? totalStockQuantity,
//     String? regularPrice,
//     String? salePrice,
//     String? capacity,
//   }){
//     return ProductDetails(
//       color: color ?? this.color,
//       sku: sku ?? this.sku,
//       totalStockQuantity: totalStockQuantity ?? this.totalStockQuantity,
//       regularPrice: regularPrice ?? this.regularPrice,
//       salePrice: salePrice ?? this.salePrice,
//       capacity: capacity ?? this.capacity,
//     );
//   }
// }


class AllProductModel {
  String? status;
  Products? products;

  AllProductModel({this.status, this.products});

  AllProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    products = json['products'] != null
        ? new Products.fromJson(json['products'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.products != null) {
      data['products'] = this.products!.toJson();
    }
    return data;
  }

  AllProductModel copyWith({
    String? status,
    Products? products,
  }){
    return AllProductModel(
      status: status ?? this.status,
      products: products ?? this.products
    );
  }
}

class Products {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Products(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  Products.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'].toString();
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'].toString();
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }

  Products copyWith({
    int? currentPage,
    List<Data>? data,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<Links>? links,
    String? nextPageUrl,
    String? path,
    int? perPage,
    String? prevPageUr,
    int? to,
    int? total,
  }){
    return Products(
      currentPage: currentPage ?? this.currentPage,
      data: data ?? this.data,
      firstPageUrl: firstPageUrl ?? this.firstPageUrl,
      from: from ?? this.from,
      lastPage: lastPage ?? this.lastPage,
      lastPageUrl: lastPageUrl ?? this.lastPageUrl,
      links: links ?? this.links,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      path: path ?? this.path,
      perPage: perPage ?? this.perPage,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
      to: to ?? this.to,
      total: total ?? this.total
    );
  }
}

class Data {
  int? id;
  String? productName;
  int? availableQuantity;
  String? featureImage;
  int? parentCategory;
  String? regularPrice;
  String? salePrice;
  bool? inWishlist;
  int? discountPercent;
  bool? loading;
  String? soldOut;

  Data(
      {this.id,
        this.productName,
        this.availableQuantity,
        this.featureImage,
        this.parentCategory,
        this.regularPrice,
        this.salePrice,
        this.inWishlist,
        this.discountPercent,
        this.loading,
        this.soldOut});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    availableQuantity = json['available_quantity'];
    featureImage = json['feature_image'];
    parentCategory = json['parent_category'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    inWishlist = json['in_wishlist'];
    discountPercent = json['discount_percent'];
    loading = json['loading'];
    soldOut = json['sold_out'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['available_quantity'] = this.availableQuantity;
    data['feature_image'] = this.featureImage;
    data['parent_category'] = this.parentCategory;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['in_wishlist'] = this.inWishlist;
    data['discount_percent'] = this.discountPercent;
    data['loading'] = this.loading;
    data['sold_out'] = this.soldOut;
    return data;
  }

  Data copyWith({
    int? id,
    String? productName,
    int? availableQuantity,
    String? featureImage,
    int? parentCategory,
    String? regularPrice,
    String? salePrice,
    bool? inWishlist,
    int? discountPercent,
    bool? loading,
    Null? soldOut,
  }){
    return Data(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      featureImage: featureImage ?? this.featureImage,
      parentCategory: parentCategory ?? this.parentCategory,
      regularPrice: regularPrice ?? this.regularPrice,
      salePrice: salePrice ?? this.salePrice,
      inWishlist: inWishlist ?? this.inWishlist,
      discountPercent: discountPercent ?? this.discountPercent,
      loading: loading ?? this.loading,
      soldOut: soldOut ?? this.soldOut
    );
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
