class GetCouponModel {
  bool? status;
  List<AvailableCoupon>? availableCoupon;

  GetCouponModel({this.status, this.availableCoupon});

  GetCouponModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['available_coupon'] != null) {
      availableCoupon = <AvailableCoupon>[];
      json['available_coupon'].forEach((v) {
        availableCoupon!.add(new AvailableCoupon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.availableCoupon != null) {
      data['available_coupon'] =
          this.availableCoupon!.map((v) => v.toJson()).toList();
    }
    return data;
  }
  GetCouponModel copyWith({
    bool? status,
    List<AvailableCoupon>? availableCoupon,
  }){
    return GetCouponModel(
      status: status ?? this.status,
      availableCoupon: availableCoupon ?? this.availableCoupon
    );
  }
}

class AvailableCoupon {
  int? id;
  String? code;
  String? title;
  String? couponType;
  String? productId;
  String? categoryId;
  String? userId;
  String? applyUserId;
  String? amountType;
  String? amount;
  String? productMinAmount;
  Null? maxUses;
  String? remainUses;
  int? mainCategory;
  int? subCategory;
  int? status;
  String? couponStartDate;
  String? couponEndDate;
  String? createdAt;
  String? updatedAt;
  int? expire;
  bool? loading;

  AvailableCoupon(
      {this.id,
        this.code,
        this.title,
        this.couponType,
        this.productId,
        this.categoryId,
        this.userId,
        this.applyUserId,
        this.amountType,
        this.amount,
        this.productMinAmount,
        this.maxUses,
        this.remainUses,
        this.mainCategory,
        this.subCategory,
        this.status,
        this.couponStartDate,
        this.couponEndDate,
        this.createdAt,
        this.updatedAt,
        this.expire,
        this.loading
      });

  AvailableCoupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    title = json['title'];
    couponType = json['coupon_type'];
    productId = json['product_id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    applyUserId = json['apply_user_id'];
    amountType = json['amount_type'];
    amount = json['amount'];
    productMinAmount = json['product_min_amount'];
    maxUses = json['max_uses'];
    remainUses = json['remain_uses'];
    mainCategory = json['main_category'];
    subCategory = json['sub_category'];
    status = json['status'];
    couponStartDate = json['coupon_start_date'];
    couponEndDate = json['coupon_end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    loading = json['loading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['title'] = this.title;
    data['coupon_type'] = this.couponType;
    data['product_id'] = this.productId;
    data['category_id'] = this.categoryId;
    data['user_id'] = this.userId;
    data['apply_user_id'] = this.applyUserId;
    data['amount_type'] = this.amountType;
    data['amount'] = this.amount;
    data['product_min_amount'] = this.productMinAmount;
    data['max_uses'] = this.maxUses;
    data['remain_uses'] = this.remainUses;
    data['main_category'] = this.mainCategory;
    data['sub_category'] = this.subCategory;
    data['status'] = this.status;
    data['coupon_start_date'] = this.couponStartDate;
    data['coupon_end_date'] = this.couponEndDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['expire'] = this.expire;
    data['loading'] = this.loading;
    return data;
  }

  AvailableCoupon copyWith({
  int? id,
  String? code,
  String? title,
  String? couponType,
  String? productId,
  String? categoryId,
  String? userId,
  String? applyUserId,
  String? amountType,
  String? amount,
  String? productMinAmount,
  Null? maxUses,
  String? remainUses,
  int? mainCategory,
  int? subCategory,
  int? status,
  String? couponStartDate,
  String? couponEndDate,
  String? createdAt,
  String? updatedAt,
  int? expire,
  bool? loading,
  }){
    return AvailableCoupon(
    id: id ?? this.id,
    code: code ?? this.code,
    title: title ?? this.title,
    productId: productId ?? this.productId,
    couponType: couponType ?? this.couponType,
    categoryId: categoryId ?? this.categoryId,
    userId: userId ?? this.userId,
    applyUserId: applyUserId ?? this.applyUserId,
    amountType: amountType ?? this.amountType,
    amount: amount ?? this.amount,
    productMinAmount: productMinAmount ?? this.productMinAmount,
    maxUses: maxUses ?? this.maxUses,
    remainUses: remainUses ?? this.remainUses,
    mainCategory: mainCategory ?? this.mainCategory,
    subCategory: subCategory ?? this.subCategory,
    status: status ?? this.status,
    couponStartDate: couponStartDate ?? this.couponStartDate,
    couponEndDate: couponEndDate ?? this.couponEndDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    expire: expire ?? this.expire,
    loading: loading ?? this.loading,
    );
  }
}
