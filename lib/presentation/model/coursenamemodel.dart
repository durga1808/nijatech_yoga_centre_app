class CourseMasterModel {
  bool? status;
  List<Course>? message;

  CourseMasterModel({this.status, this.message});

  CourseMasterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['message'] != null) {
      message = <Course>[];
      json['message'].forEach((v) {
        message!.add(new Course.fromJson(v));
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

class Course {
  int? id;
  int? courseid;
  String? coursename;
  int? createdby;
  String? createddatetime;
  int? status;

  Course(
      {this.id,
      this.courseid,
      this.coursename,
      this.createdby,
      this.createddatetime,
      this.status});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseid = json['courseid'];
    coursename = json['coursename'];
    createdby = json['createdby'];
    createddatetime = json['createddatetime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['courseid'] = this.courseid;
    data['coursename'] = this.coursename;
    data['createdby'] = this.createdby;
    data['createddatetime'] = this.createddatetime;
    data['status'] = this.status;
    return data;
  }
}