// Course Model Classes
class CourseModel {
  bool? status;
  List<Message>? message;

  CourseModel({this.status, this.message});

  CourseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  int? id;
  String? coursename;
  int? status;

  Message({this.id, this.coursename, this.status});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coursename = json['coursename'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['coursename'] = coursename;
    data['status'] = status;
    return data;
  }
}