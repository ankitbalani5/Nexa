
  class OrderDetailModel {
  String? status;
  OrderInformation? orderInformation;
  List<OrderItemInformation>? orderItemInformation;
  ShippingAddress? shippingAddress;
  String? pdfUrl;

  OrderDetailModel(
  {this.status,
  this.orderInformation,
  this.orderItemInformation,
  this.shippingAddress,
    this.pdfUrl});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
  status = json['status'];
  orderInformation = json['order_information'] != null
  ? new OrderInformation.fromJson(json['order_information'])
      : null;
  if (json['order_item_information'] != null) {
  orderItemInformation = <OrderItemInformation>[];
  json['order_item_information'].forEach((v) {
  orderItemInformation!.add(new OrderItemInformation.fromJson(v));
  });
  }
  shippingAddress = json['shipping_address'] != null
  ? new ShippingAddress.fromJson(json['shipping_address'])
      : null;
  pdfUrl = json['pdf_url'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = this.status;
  if (this.orderInformation != null) {
  data['order_information'] = this.orderInformation!.toJson();
  }
  if (this.orderItemInformation != null) {
  data['order_item_information'] =
  this.orderItemInformation!.map((v) => v.toJson()).toList();
  }
  if (this.shippingAddress != null) {
  data['shipping_address'] = this.shippingAddress!.toJson();
  }
  data['pdf_url'] = this.pdfUrl;
  return data;
  }
  }

  class OrderInformation {
  int? id;
  String? orderId;
  int? quantity;
  String? orderStatus;
  String? orderDate;
  String? subTotal;
  String? couponDiscount;
  String? totalAmount;

  OrderInformation(
  {this.id,
  this.orderId,
  this.quantity,
  this.orderStatus,
  this.orderDate,
  this.subTotal,
  this.couponDiscount,
  this.totalAmount});

  OrderInformation.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  orderId = json['order_id'];
  quantity = json['quantity'];
  orderStatus = json['order_status'];
  orderDate = json['order_date'];
  subTotal = json['sub_total'];
  couponDiscount = json['coupon_discount'];
  totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['order_id'] = this.orderId;
  data['quantity'] = this.quantity;
  data['order_status'] = this.orderStatus;
  data['order_date'] = this.orderDate;
  data['sub_total'] = this.subTotal;
  data['coupon_discount'] = this.couponDiscount;
  data['total_amount'] = this.totalAmount;
  return data;
  }
  }

  class OrderItemInformation {
  String? productName;
  String? price;
  String? salePrice;
  String? regularPrice;
  String? totalPrice;
  int? totalQuantity;
  String? featureImage;

  OrderItemInformation(
  {this.productName,
  this.price,
  this.salePrice,
  this.regularPrice,
  this.totalPrice,
  this.totalQuantity,
  this.featureImage});

  OrderItemInformation.fromJson(Map<String, dynamic> json) {
  productName = json['product_name'];
  price = json['price'];
  salePrice = json['sale_price'];
  regularPrice = json['regular_price'];
  totalPrice = json['total_price'];
  totalQuantity = json['total_quantity'];
  featureImage = json['feature_image'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['product_name'] = this.productName;
  data['price'] = this.price;
  data['sale_price'] = this.salePrice;
  data['regular_price'] = this.regularPrice;
  data['total_price'] = this.totalPrice;
  data['total_quantity'] = this.totalQuantity;
  data['feature_image'] = this.featureImage;
  return data;
  }
  }

  class ShippingAddress {
  String? serviceType;
  String? shipingDate;
  String? address;
  String? city;
  String? state;
  String? country;
  String? zipCode;

  ShippingAddress(
  {this.serviceType,
  this.shipingDate,
  this.address,
  this.city,
  this.state,
  this.country,
  this.zipCode});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
  serviceType = json['service_type'];
  shipingDate = json['shiping_date'];
  address = json['address'];
  city = json['city'];
  state = json['state'];
  country = json['country'];
  zipCode = json['zip_code'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['service_type'] = this.serviceType;
  data['shiping_date'] = this.shipingDate;
  data['address'] = this.address;
  data['city'] = this.city;
  data['state'] = this.state;
  data['country'] = this.country;
  data['zip_code'] = this.zipCode;
  return data;
  }
  }