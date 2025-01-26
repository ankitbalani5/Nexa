// class CategoryWiseProductModel {
//   String? status;
//   Products? products;
//
//   CategoryWiseProductModel({this.status, this.products});
//
//   CategoryWiseProductModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     products = json['products'] != null
//         ? new Products.fromJson(json['products'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.products != null) {
//       data['products'] = this.products!.toJson();
//     }
//     return data;
//   }
//
//   CategoryWiseProductModel copyWith({
//     String? status,
//     Products? products,
//   }){
//     return CategoryWiseProductModel(
//       status: status ?? this.status,
//       products: products ?? this.products
//     );
//   }
// }
//
// class Products {
//   int? currentPage;
//   List<Data>? data;
//   String? firstPageUrl;
//   int? from;
//   int? lastPage;
//   String? lastPageUrl;
//   List<Links>? links;
//   String? nextPageUrl;
//   String? path;
//   int? perPage;
//   String? prevPageUrl;
//   int? to;
//   int? total;
//
//   Products(
//       {this.currentPage,
//         this.data,
//         this.firstPageUrl,
//         this.from,
//         this.lastPage,
//         this.lastPageUrl,
//         this.links,
//         this.nextPageUrl,
//         this.path,
//         this.perPage,
//         this.prevPageUrl,
//         this.to,
//         this.total});
//
//   Products.fromJson(Map<String, dynamic> json) {
//     currentPage = json['current_page'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//     firstPageUrl = json['first_page_url'];
//     from = json['from'];
//     lastPage = json['last_page'];
//     lastPageUrl = json['last_page_url'];
//     if (json['links'] != null) {
//       links = <Links>[];
//       json['links'].forEach((v) {
//         links!.add(new Links.fromJson(v));
//       });
//     }
//     nextPageUrl = json['next_page_url'].toString();
//     path = json['path'];
//     perPage = json['per_page'];
//     prevPageUrl = json['prev_page_url'].toString();
//     to = json['to'];
//     total = json['total'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['current_page'] = this.currentPage;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['first_page_url'] = this.firstPageUrl;
//     data['from'] = this.from;
//     data['last_page'] = this.lastPage;
//     data['last_page_url'] = this.lastPageUrl;
//     if (this.links != null) {
//       data['links'] = this.links!.map((v) => v.toJson()).toList();
//     }
//     data['next_page_url'] = this.nextPageUrl;
//     data['path'] = this.path;
//     data['per_page'] = this.perPage;
//     data['prev_page_url'] = this.prevPageUrl;
//     data['to'] = this.to;
//     data['total'] = this.total;
//     return data;
//   }
//
//   Products copyWith({
//     int? currentPage,
//     List<Data>? data,
//     String? firstPageUrl,
//     int? from,
//     int? lastPage,
//     String? lastPageUrl,
//     List<Links>? links,
//     String? nextPageUrl,
//     String? path,
//     int? perPage,
//     String? prevPageUrl,
//     int? to,
//     int? total,
//   }){
//     return Products(
//       currentPage: currentPage ?? this.currentPage,
//       data: data ?? this.data,
//       firstPageUrl: firstPageUrl ?? this.firstPageUrl,
//       from: from ?? this.from,
//       lastPage: lastPage ?? this.lastPage,
//       lastPageUrl: lastPageUrl ?? this.lastPageUrl,
//       links: links ?? this.links,
//       nextPageUrl: nextPageUrl ?? this.nextPageUrl,
//       path: path ?? this.path,
//       perPage: perPage ?? this.perPage,
//       prevPageUrl: prevPageUrl ?? this.prevPageUrl,
//       to: to ?? this.to,
//       total: total ?? this.total,
//     );
//   }
// }
//
// class Data {
//   int? id;
//   String? productName;
//   int? availableQuantity;
//   String? featureImage;
//   String? regularPrice;
//   String? salePrice;
//   bool? inWishlist;
//   int? discountPercent;
//   bool? loading;
//   Null? soldOut;
//
//   Data(
//       {this.id,
//         this.productName,
//         this.availableQuantity,
//         this.featureImage,
//         this.regularPrice,
//         this.salePrice,
//         this.inWishlist,
//         this.discountPercent,
//         this.loading,
//         this.soldOut});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productName = json['product_name'];
//     availableQuantity = json['available_quantity'];
//     featureImage = json['feature_image'];
//     regularPrice = json['regular_price'];
//     salePrice = json['sale_price'];
//     inWishlist = json['in_wishlist'];
//     discountPercent = json['discount_percent'];
//     loading = json['loading'];
//     soldOut = json['sold_out'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['product_name'] = this.productName;
//     data['available_quantity'] = this.availableQuantity;
//     data['feature_image'] = this.featureImage;
//     data['regular_price'] = this.regularPrice;
//     data['sale_price'] = this.salePrice;
//     data['in_wishlist'] = this.inWishlist;
//     data['discount_percent'] = this.discountPercent;
//     data['loading'] = this.loading;
//     data['sold_out'] = this.soldOut;
//     return data;
//   }
//    Data copyWith({
//      int? id,
//      String? productName,
//      int? availableQuantity,
//      String? featureImage,
//      String? regularPrice,
//      String? salePrice,
//      bool? inWishlist,
//      int? discountPercent,
//      bool? loading,
//      Null? soldOut,
//    }){
//     return Data(
//       id: id ?? this.id,
//       productName: productName ?? this.productName,
//       availableQuantity: availableQuantity ?? this.availableQuantity,
//       featureImage: featureImage ?? this.featureImage,
//       regularPrice: regularPrice ?? this.regularPrice,
//       salePrice: salePrice ?? this.salePrice,
//       inWishlist: inWishlist ?? this.inWishlist,
//       discountPercent: discountPercent ?? this.discountPercent,
//       loading: loading ?? this.loading,
//       soldOut: soldOut ?? this.soldOut,
//     );
//    }
// }
//
// class Links {
//   String? url;
//   String? label;
//   bool? active;
//
//   Links({this.url, this.label, this.active});
//
//   Links.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//     label = json['label'];
//     active = json['active'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['url'] = this.url;
//     data['label'] = this.label;
//     data['active'] = this.active;
//     return data;
//   }
// }

class CategoryWiseProductModel {
  String? status;
  List<Categories>? categories;

  CategoryWiseProductModel({this.status, this.categories});

  CategoryWiseProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  CategoryWiseProductModel copyWith({
    String? status,
    List<Categories>? categories,
  }){
    return CategoryWiseProductModel(
      status: status ?? this.status,
      categories: categories ?? this.categories,
    );
  }
}

class Categories {
  int? id;
  String? categoryName;
  String? image;
  String? bannerImage;
  Products? products;
  List<Subcategory>? subcategory;

  Categories(
      {this.id,
        this.categoryName,
        this.image,
        this.bannerImage,
        this.products,
        this.subcategory});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    image = json['image'];
    bannerImage = json['banner_image'];
    products = json['products'] != null
        ? new Products.fromJson(json['products'])
        : null;
    if (json['subcategory'] != null) {
      subcategory = <Subcategory>[];
      json['subcategory'].forEach((v) {
        subcategory!.add(new Subcategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['image'] = this.image;
    data['banner_image'] = this.bannerImage;
    if (this.products != null) {
      data['products'] = this.products!.toJson();
    }
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Categories copyWith({
    int? id,
    String? categoryName,
    String? image,
    String? bannerImage,
    Products? products,
    List<Subcategory>? subcategory,
  }){
    return Categories(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      image: image ?? this.image,
      bannerImage: bannerImage ?? this.bannerImage,
      products: products ?? this.products,
      subcategory: subcategory ?? this.subcategory,
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
    nextPageUrl = json['next_page_url'];
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
    Null? prevPageUrl,
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
      total: total ?? this.total,
    );
  }
}

class Data {
  int? id;
  String? productName;
  int? availableQuantity;
  String? featureImage;
  String? regularPrice;
  String? salePrice;
  bool? inWishlist;
  int? discountPercent;
  bool? loading;
  String? soldOut;
  String? averageRating;

  Data(
      {this.id,
        this.productName,
        this.availableQuantity,
        this.featureImage,
        this.regularPrice,
        this.salePrice,
        this.inWishlist,
        this.discountPercent,
        this.loading,
        this.soldOut,
        this.averageRating});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    availableQuantity = json['available_quantity'];
    featureImage = json['feature_image'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    inWishlist = json['in_wishlist'];
    discountPercent = json['discount_percent'];
    loading = json['loading'];
    soldOut = json['sold_out'].toString();
    averageRating = json['average_rating'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['available_quantity'] = this.availableQuantity;
    data['feature_image'] = this.featureImage;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['in_wishlist'] = this.inWishlist;
    data['discount_percent'] = this.discountPercent;
    data['loading'] = this.loading;
    data['sold_out'] = this.soldOut;
    data['average_rating'] = this.averageRating;
    return data;
  }

  Data copyWith({
    int? id,
    String? productName,
    int? availableQuantity,
    String? featureImage,
    String? regularPrice,
    String? salePrice,
    bool? inWishlist,
    int? discountPercent,
    bool? loading,
    String? soldOut,
    String? averageRating,
  }){
    return Data(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      featureImage: featureImage ?? this.featureImage,
      regularPrice: regularPrice ?? this.regularPrice,
      salePrice: salePrice ?? this.salePrice,
      inWishlist: inWishlist ?? this.inWishlist,
      discountPercent: discountPercent ?? this.discountPercent,
      loading: loading ?? this.loading,
      soldOut: soldOut ?? this.soldOut,
      averageRating: averageRating ?? this.averageRating,
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

class Subcategory {
  int? id;
  String? categoryName;
  int? parentId;
  String? image;

  Subcategory({this.id, this.categoryName, this.parentId, this.image});

  Subcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    parentId = json['parent_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['parent_id'] = this.parentId;
    data['image'] = this.image;
    return data;
  }
}
