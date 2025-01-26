class NotificationListModel {
  String? status;
  List<Notification>? notification;

  NotificationListModel({this.status, this.notification});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['notification'] != null) {
      notification = <Notification>[];
      json['notification'].forEach((v) {
        notification!.add(new Notification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.notification != null) {
      data['notification'] = this.notification!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notification {
  int? id;
  String? about;
  String? content;
  String? notifyTime;

  Notification({this.id, this.about, this.content, this.notifyTime});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    about = json['about'];
    content = json['content'];
    notifyTime = json['notify_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['about'] = this.about;
    data['content'] = this.content;
    data['notify_time'] = this.notifyTime;
    return data;
  }
}
