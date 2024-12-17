class VideoModel {
  bool? status;
  List<Message>? message;

  VideoModel({this.status, this.message});

  VideoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  String? videourl;
  String? description;
  String? date;
  String? coursename;

  Message({this.videourl, this.description, this.date, this.coursename});

  Message.fromJson(Map<String, dynamic> json) {
    videourl = json['videourl'];
    description = json['description'];
    date = json['date'];
    coursename = json['coursename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['videourl'] = this.videourl;
    data['description'] = this.description;
    data['date'] = this.date;
    data['coursename'] = this.coursename;
    return data;
  }
}