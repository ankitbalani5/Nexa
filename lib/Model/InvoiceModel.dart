class InvoiceModel {
  String? message;
  String? pdfUrl;

  InvoiceModel({this.message, this.pdfUrl});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    pdfUrl = json['pdf_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['pdf_url'] = this.pdfUrl;
    return data;
  }
}
