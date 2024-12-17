class VideoModelMaster {
  bool? status;
  List<Message>? message;

  VideoModelMaster({this.status, this.message});

  VideoModelMaster.fromJson(Map<String, dynamic> json) {
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
  int? docno;
  String? date;
  int? courseid;
  String? coursename;
  String? videourl;
  String? description;
  int? createdby;
  int? status;

  Message(
      {this.docno,
      this.date,
      this.courseid,
      this.coursename,
      this.videourl,
      this.description,
      this.createdby,
      this.status});

  Message.fromJson(Map<String, dynamic> json) {
    docno = json['docno'];
    date = json['date'];
    courseid = json['courseid'];
    coursename = json['coursename'];
    videourl = json['videourl'];
    description = json['description'];
    createdby = json['createdby'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['docno'] = this.docno;
    data['date'] = this.date;
    data['courseid'] = this.courseid;
    data['coursename'] = this.coursename;
    data['videourl'] = this.videourl;
    data['description'] = this.description;
    data['createdby'] = this.createdby;
    data['status'] = this.status;
    return data;
  }
}