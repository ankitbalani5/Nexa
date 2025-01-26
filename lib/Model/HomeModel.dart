class HomeModel {
  String? status;
  List<HomeBanner>? homeBanner;
  List<Categories>? categories;
  List<FlashDeals>? flashDeals;
  List<Products>? products;

  HomeModel({this.status, this.homeBanner, this.categories,
    this.flashDeals, this.products});

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['home_banner'] != null) {
      homeBanner = <HomeBanner>[];
      json['home_banner'].forEach((v) {
        homeBanner!.add(new HomeBanner.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    if (json['flash_deals'] != null) {
      flashDeals = <FlashDeals>[];
      json['flash_deals'].forEach((v) {
        flashDeals!.add(new FlashDeals.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.homeBanner != null) {
      data['home_banner'] = this.homeBanner!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.flashDeals != null) {
      data['flash_deals'] = this.flashDeals!.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  HomeModel copyWith({
    String? status,
    List<HomeBanner>? homeBanner,
    List<Categories>? categories,
    List<Products>? products
}){
    return HomeModel(
        status: status ?? this.status,
        homeBanner: homeBanner ?? this.homeBanner,
        categories: categories ?? this.categories,
        products: products ?? this.products
    );
  }
}

class HomeBanner {
  int? id;
  String? image;

  HomeBanner({this.id, this.image});

  HomeBanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}

class FlashDeals {
  int? id;
  String? productName;
  int? availableQuantity;
  String? featureImage;
  String? regularPrice;
  String? salePrice;
  int? flashDeal;
  String? startFlashDeal;
  String? endFlashDeal;
  int? discountPercent;
  int? soldOut;

  FlashDeals(
      {this.id,
        this.productName,
        this.availableQuantity,
        this.featureImage,
        this.regularPrice,
        this.salePrice,
        this.flashDeal,
        this.startFlashDeal,
        this.endFlashDeal,
        this.discountPercent,
        this.soldOut});

  FlashDeals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    availableQuantity = json['available_quantity'];
    featureImage = json['feature_image'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    flashDeal = json['flash_deal'];
    startFlashDeal = json['start_flash_deal'];
    endFlashDeal = json['end_flash_deal'];
    discountPercent = json['discount_percent'];
    soldOut = json['sold_out'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['available_quantity'] = this.availableQuantity;
    data['feature_image'] = this.featureImage;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['flash_deal'] = this.flashDeal;
    data['start_flash_deal'] = this.startFlashDeal;
    data['end_flash_deal'] = this.endFlashDeal;
    data['discount_percent'] = this.discountPercent;
    data['sold_out'] = this.soldOut;
    return data;
  }
}

class Categories {
  int? id;
  String? categoryName;
  String? slug;
  String? image;

  Categories({this.id, this.categoryName, this.slug, this.image});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    slug = json['slug'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['slug'] = this.slug;
    data['image'] = this.image;
    return data;
  }
}

class Products {
  int? id;
  String? productName;
  String? slug;
  String? featureImage;
  String? quantity;
  String? regularPrice;
  String? salePrice;
  ProductDetails? productDetails;
  String? productType;
  bool? inWishlist;
  String? discountPercent;
  bool? loading;
  int? soldOut;
  bool? loadingcart;
  bool? loadinglike;

  Products(
      {this.id,
        this.productName,
        this.slug,
        this.featureImage,
        this.quantity,
        this.regularPrice,
        this.salePrice,
        this.productDetails,
        this.productType,
        this.inWishlist,
        this.discountPercent,
        this.loading,
        this.soldOut,
        this.loadingcart,
        this.loadinglike});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    slug = json['slug'];
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
    soldOut = json['sold_out'];
    loadingcart = json['loadingcart'];
    loadinglike = json['loadinglike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['slug'] = this.slug;
    data['feature_image'] = this.featureImage;
    data['quantity'] = this.quantity;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    if (this.productDetails != null) {
      data['product_details'] = this.productDetails!.toJson();
    }
    data['product_type'] = this.productType;
    data['in_wishlist'] = this.inWishlist;
    data['discount_percent'] = this.discountPercent;
    data['loading'] = this.loading;
    data['sold_out'] = this.soldOut;
    data['loadingcart'] = this.loadingcart;
    data['loadinglike'] = this.loadinglike;
    return data;
  }

  Products copyWith({
    int? id,
    String? productName,
    String? slug,
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
    return Products(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      slug: slug ?? this.slug,
      featureImage: featureImage ?? this.featureImage,
      quantity: quantity ?? this.quantity,
      regularPrice: regularPrice ?? this.regularPrice,
      salePrice: salePrice ?? this.salePrice,
      productDetails: productDetails ?? this.productDetails,
      productType: productType ?? this.productType,
      inWishlist: inWishlist ?? this.inWishlist,
      discountPercent: discountPercent ?? this.discountPercent,
      loading: loading ?? this.loading,
      loadingcart: loadingcart ?? this.loadingcart,
      loadinglike: loadinglike ?? this.loadinglike
    );
  }
}

class ProductDetails {
  String? capacity;
  String? sku;
  String? totalStockQuantity;
  String? regularPrice;
  String? salePrice;
  String? color;

  ProductDetails(
      {this.capacity,
        this.sku,
        this.totalStockQuantity,
        this.regularPrice,
        this.salePrice,
        this.color});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    capacity = json['Capacity'];
    sku = json['sku'];
    totalStockQuantity = json['total_stock_quantity'].toString();
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Capacity'] = this.capacity;
    data['sku'] = this.sku;
    data['total_stock_quantity'] = this.totalStockQuantity;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['Color'] = this.color;
    return data;
  }

  ProductDetails copyWith({
    String? capacity,
    String? sku,
    String? totalStockQuantity,
    String? regularPrice,
    String? salePrice,
    String? color,
}){
    return ProductDetails(
      capacity: capacity ?? this.capacity,
      sku: sku ?? this.sku,
      totalStockQuantity: totalStockQuantity ?? this.totalStockQuantity,
      regularPrice: regularPrice ?? this.regularPrice,
      salePrice: salePrice ?? this.salePrice,
      color: color ?? this.color
    );
  }
}