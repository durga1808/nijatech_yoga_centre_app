class MyDateModel {
  bool? status;
  List<Message>? message;

  MyDateModel({this.status, this.message});

  MyDateModel.fromJson(Map<String, dynamic> json) {
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
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  int? occurance;
  String? remarks;
  String? coursename;
  String? currentdate;

  Message({this.occurance, this.remarks, this.coursename, this.currentdate});

  Message.fromJson(Map<String, dynamic> json) {
    occurance = json['occurance'];
    remarks = json['remarks'];
    coursename = json['coursename'];
    currentdate = json['Currentdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occurance'] = this.occurance;
    data['remarks'] = this.remarks;
    data['coursename'] = this.coursename;
    data['Currentdate'] = this.currentdate;
    return data;
  }
}
