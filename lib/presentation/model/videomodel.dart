class VideoModel {
  bool? status;
  String? message;
  List<Data>? data;

  VideoModel({this.status, this.message, this.data});

  VideoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? content;
  String? coursename;
  String? youtubelink;
  String? active;
  int? status;

  Data(
      {this.id,
      this.content,
      this.coursename,
      this.youtubelink,
      this.active,
      this.status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    coursename = json['coursename'];
    youtubelink = json['youtubelink'];
    active = json['active'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['coursename'] = this.coursename;
    data['youtubelink'] = this.youtubelink;
    data['active'] = this.active;
    data['status'] = this.status;
    return data;
  }
}