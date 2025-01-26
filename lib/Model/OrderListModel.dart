class OrderListModel {
  String? status;
  String? message;
  List<Orders>? orders;

  OrderListModel({this.status, this.message, this.orders});

  OrderListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? id;
  String? orderStatus;
  String? netAmount;
  String? orderId;
  List<ProductsToReview>? productsToReview;
  int? quantity;
  String? orderDate;

  Orders(
      {this.id,
        this.orderStatus,
        this.netAmount,
        this.orderId,
        this.productsToReview,
        this.quantity,
        this.orderDate});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderStatus = json['order_status'];
    netAmount = json['net_amount'];
    orderId = json['order_id'];
    if (json['products_to_review'] != null) {
      productsToReview = <ProductsToReview>[];
      json['products_to_review'].forEach((v) {
        productsToReview!.add(new ProductsToReview.fromJson(v));
      });
    }
    quantity = json['Quantity'];
    orderDate = json['order_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_status'] = this.orderStatus;
    data['net_amount'] = this.netAmount;
    data['order_id'] = this.orderId;
    if (this.productsToReview != null) {
      data['products_to_review'] =
          this.productsToReview!.map((v) => v.toJson()).toList();
    }
    data['Quantity'] = this.quantity;
    data['order_date'] = this.orderDate;
    return data;
  }
}

class ProductsToReview {
  int? productId;
  String? productName;
  String? featureImage;
  String? purchasePrice;
  int? purchaseQuantity;
  String? totalPrice;

  ProductsToReview(
      {this.productId,
        this.productName,
        this.featureImage,
        this.purchasePrice,
        this.purchaseQuantity,
        this.totalPrice});

  ProductsToReview.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    featureImage = json['feature_image'];
    purchasePrice = json['purchase_price'];
    purchaseQuantity = json['purchase_quantity'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['feature_image'] = this.featureImage;
    data['purchase_price'] = this.purchasePrice;
    data['purchase_quantity'] = this.purchaseQuantity;
    data['total_price'] = this.totalPrice;
    return data;
  }
}
