class CategoryModel {
  String? status;
  List<Categories>? categories;

  CategoryModel({this.status, this.categories});

  CategoryModel.fromJson(Map<String, dynamic> json) {
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
}

class Products {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
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
    prevPageUrl = json['prev_page_url'];
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
  Null? soldOut;
  int? averageRating;

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
    soldOut = json['sold_out'];
    averageRating = json['average_rating'];
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


// class CategoryModel {
//   String? status;
//   List<Categories>? categories;
//
//   CategoryModel({this.status, this.categories});
//
//   CategoryModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'].toString();
//     if (json['categories'] != null) {
//       categories = <Categories>[];
//       json['categories'].forEach((v) {
//         categories!.add(new Categories.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.categories != null) {
//       data['categories'] = this.categories!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
//   CategoryModel copyWith({
//     String? status,
//     List<Categories>? categories,
// }){
//     return CategoryModel(
//       status: status ?? this.status,
//       categories: categories ?? this.categories,
//     );
//   }
// }
//
// class Categories {
//   int? id;
//   String? categoryName;
//   String? slug;
//   String? image;
//   String? bannerImage;
//   List<Products>? products;
//   List<Subcategory>? subcategory;
//
//   Categories(
//       {this.id,
//         this.categoryName,
//         this.slug,
//         this.image,
//         this.bannerImage,
//         this.products,
//         this.subcategory});
//
//   Categories.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     categoryName = json['category_name'].toString();
//     slug = json['slug'].toString();
//     image = json['image'].toString();
//     bannerImage = json['banner_image'].toString();
//     if (json['products'] != null) {
//       products = <Products>[];
//       json['products'].forEach((v) {
//         products!.add(new Products.fromJson(v));
//       });
//     }
//     if (json['subcategory'] != null) {
//       subcategory = <Subcategory>[];
//       json['subcategory'].forEach((v) {
//         subcategory!.add(new Subcategory.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['category_name'] = this.categoryName;
//     data['slug'] = this.slug;
//     data['image'] = this.image;
//     data['banner_image'] = this.bannerImage;
//     if (this.products != null) {
//       data['products'] = this.products!.map((v) => v.toJson()).toList();
//     }
//     if (this.subcategory != null) {
//       data['subcategory'] = this.subcategory!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
//
//   Categories copyWith({
//
//     int? id,
//     String? categoryName,
//     String? slug,
//     String? image,
//     String? bannerImage,
//     List<Products>? products,
//     List<Subcategory>? subcategory,
// }){
//     return Categories(
//       id: id ?? this.id,
//       categoryName: categoryName ?? this.categoryName,
//       slug: slug ?? this.slug,
//       image: image ?? this.image,
//       bannerImage: bannerImage ?? this.bannerImage,
//       products: products ?? this.products,
//       subcategory: subcategory ?? this.subcategory,
//     );
//   }
// }
// class Products {
//   int? id;
//   String? productName;
//   String? slug;
//   String? featureImage;
//   String? quantity;
//   String? regularPrice;
//   String? salePrice;
//   ProductDetails? productDetails;
//   String? productType;
//   bool? inWishlist;
//   String? discountPercent;
//   bool? loading;
//
//   Products(
//       {this.id,
//         this.productName,
//         this.slug,
//         this.featureImage,
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
//     slug = json['slug'];
//     featureImage = json['feature_image'];
//     quantity = json['quantity'].toString();
//     regularPrice = json['regular_price'];
//     salePrice = json['sale_price'];
//     productDetails = json['product_details'] != null
//         ? new ProductDetails.fromJson(json['product_details'])
//         : null;
//     productType = json['product_type'];
//     inWishlist = json['in_wishlist'];
//     discountPercent = json['discount_percent'].toString();
//     loading = json['loading'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['product_name'] = this.productName;
//     data['slug'] = this.slug;
//     data['feature_image'] = this.featureImage;
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
//
//     int? id,
//     String? productName,
//     String? slug,
//     String? featureImage,
//     String? quantity,
//     String? regularPrice,
//     String? salePrice,
//     ProductDetails? productDetails,
//     String? productType,
//     bool? inWishlist,
//     String? discountPercent,
//     bool? loading,
// }){
//     return Products(
//       id: id ?? this.id,
//       productName: productName ?? this.productName,
//       slug: slug ?? this.slug,
//       featureImage: featureImage ?? this.featureImage,
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
//   String? capacity;
//   String? sku;
//   String? totalStockQuantity;
//   String? regularPrice;
//   String? salePrice;
//   String? color;
//
//   ProductDetails(
//       {this.capacity,
//         this.sku,
//         this.totalStockQuantity,
//         this.regularPrice,
//         this.salePrice,
//         this.color});
//
//   ProductDetails.fromJson(Map<String, dynamic> json) {
//     capacity = json['Capacity'].toString();
//     sku = json['sku'].toString();
//     totalStockQuantity = json['total_stock_quantity'].toString();
//     regularPrice = json['regular_price'].toString();
//     salePrice = json['sale_price'].toString();
//     color = json['Color'].toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Capacity'] = this.capacity;
//     data['sku'] = this.sku;
//     data['total_stock_quantity'] = this.totalStockQuantity;
//     data['regular_price'] = this.regularPrice;
//     data['sale_price'] = this.salePrice;
//     data['Color'] = this.color;
//     return data;
//   }
//   ProductDetails copyWith({
//
//     String? capacity,
//     String? sku,
//     String? totalStockQuantity,
//     String? regularPrice,
//     String? salePrice,
//     String? color,
// }){
//     return ProductDetails(
//       capacity: capacity ?? this.capacity,
//       sku: sku ?? this.sku,
//       totalStockQuantity: totalStockQuantity ?? this.totalStockQuantity,
//       regularPrice: regularPrice ?? this.regularPrice,
//       salePrice: salePrice ?? this.salePrice,
//       color: color ?? this.color
//     );
//   }
// }
//
// class Subcategory {
//   int? id;
//   String? categoryName;
//   int? parentId;
//   String? image;
//   List<Products>? products;
//
//   Subcategory(
//       {this.id, this.categoryName, this.parentId, this.image, this.products});
//
//   Subcategory.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     categoryName = json['category_name'].toString();
//     parentId = json['parent_id'];
//     image = json['image'].toString();
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
//     data['id'] = this.id;
//     data['category_name'] = this.categoryName;
//     data['parent_id'] = this.parentId;
//     data['image'] = this.image;
//     if (this.products != null) {
//       data['products'] = this.products!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
//
//   Subcategory copyWith({
//
//     int? id,
//     String? categoryName,
//     int? parentId,
//     String? image,
//     List<Products>? products,
// }){
//     return Subcategory(
//       id: id ?? this.id,
//       categoryName: categoryName ?? this.categoryName,
//       parentId: parentId ?? this.parentId,
//       image: image ?? this.image,
//       products: products ?? this.products,
//     );
//   }
// }

/*class CategoryModel {
  String? status;
  List<Categories>? categories;

  CategoryModel({this.status, this.categories});

  CategoryModel.fromJson(Map<String, dynamic> json) {
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
}

class Categories {
  int? id;
  String? categoryName;
  String? image;
  String? bannerImage;
  List<Subcategory>? subcategory;

  Categories(
      {this.id,
        this.categoryName,
        this.image,
        this.bannerImage,
        this.subcategory});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    image = json['image'];
    bannerImage = json['banner_image'];
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
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory!.map((v) => v.toJson()).toList();
    }
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
}*/
