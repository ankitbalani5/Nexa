class AllWishlistModel {
  String? status;
  List<WishlistProducts>? wishlistProducts;

  AllWishlistModel({this.status, this.wishlistProducts});

  AllWishlistModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['wishlist_products'] != null) {
      wishlistProducts = <WishlistProducts>[];
      json['wishlist_products'].forEach((v) {
        wishlistProducts!.add(new WishlistProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.wishlistProducts != null) {
      data['wishlist_products'] =
          this.wishlistProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  AllWishlistModel copyWith({
    String? status,
    List<WishlistProducts>? wishlistProducts
}){
    return AllWishlistModel(
      status: status ?? this.status,
      wishlistProducts: wishlistProducts ?? this.wishlistProducts
    );
  }
}

class WishlistProducts {
  String? id;
  String? productName;
  String? featureImage;
  String? quantity;
  String? regularPrice;
  String? salePrice;
  ProductDetails? productDetails;
  String? productType;
  bool? inWishlist;
  String? discountPercent;
  bool? loading;
  bool? loadingcart;
  bool? loadinglike;

  WishlistProducts(
      {this.id,
        this.productName,
        this.featureImage,
        this.quantity,
        this.regularPrice,
        this.salePrice,
        this.productDetails,
        this.productType,
        this.inWishlist,
        this.discountPercent,
        this.loading,
        this.loadingcart,
        this.loadinglike});

  WishlistProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    productName = json['product_name'];
    featureImage = json['feature_image'];
    quantity = json['quantity'].toString();
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    productDetails = json['product_details'] != null
        ? new ProductDetails.fromJson(json['product_details'])
        : null;
    productType = json['product_type'];
    inWishlist = json['in_wishlist'];
    discountPercent = json['discount_percent'].toString();
    loading = json['loading'];
    loadingcart = json['loadingcart'];
    loadinglike = json['loadinglike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['product_name'] = this.productName;
    data['feature_image'] = this.featureImage;
    data['quantity'] = this.quantity.toString();
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    if (this.productDetails != null) {
      data['product_details'] = this.productDetails!.toJson();
    }
    data['product_type'] = this.productType;
    data['in_wishlist'] = this.inWishlist;
    data['discount_percent'] = this.discountPercent.toString();
    data['loading'] = this.loading;
    data['loadingcart'] = this.loadingcart;
    data['loadinglike'] = this.loadinglike;
    return data;
  }

  WishlistProducts copyWith({
    String? id,
    String? productName,
    String? featureImage,
    String? quantity,
    String? regularPrice,
    String? salePrice,
    ProductDetails? productDetails,
    String? productType,
    bool? inWishlist,
    String? discountPercent,
    bool? loading,
    bool? loadingcart,
    bool? loadinglike,
}){
    return WishlistProducts(
        id: id ?? this.id.toString(),
        productName: productName ?? this.productName,
        featureImage: featureImage ?? this.featureImage,
        quantity: quantity ?? this.quantity.toString(),
        regularPrice: regularPrice ?? this.regularPrice,
        salePrice: salePrice ?? this.salePrice,
        productDetails: productDetails ?? this.productDetails,
        productType: productType ?? this.productType,
        inWishlist: inWishlist ?? this.inWishlist,
        discountPercent: discountPercent ?? this.discountPercent.toString(),
        loading: loading ?? this.loading,
        loadingcart: loadingcart ?? this.loadingcart,
        loadinglike: loadinglike ?? this.loadinglike,
    );
  }
}
class ProductDetails {
  String? color;
  String? sku;
  String? totalStockQuantity;
  String? regularPrice;
  String? salePrice;

  ProductDetails(
      {this.color,
        this.sku,
        this.totalStockQuantity,
        this.regularPrice,
        this.salePrice});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    color = json['Color'];
    sku = json['sku'];
    totalStockQuantity = json['total_stock_quantity'].toString();
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Color'] = this.color;
    data['sku'] = this.sku;
    data['total_stock_quantity'] = this.totalStockQuantity;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    return data;
  }

  ProductDetails copyWith({
    String? color,
    String? sku,
    String? totalStockQuantity,
    String? regularPrice,
    String? salePrice,
}){
    return ProductDetails(
      color: color ?? this.color,
      sku: sku ?? this.sku,
      totalStockQuantity: totalStockQuantity ?? this.totalStockQuantity,
      regularPrice: regularPrice ?? this.regularPrice,
      salePrice: salePrice ?? this.salePrice,
    );
  }
}