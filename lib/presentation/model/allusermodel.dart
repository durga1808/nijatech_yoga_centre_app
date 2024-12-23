import 'package:intl/intl.dart';  


class AllUserModel {
  bool? status;
  List<Message>? message;

  AllUserModel({this.status, this.message});

  AllUserModel.fromJson(Map<String, dynamic> json) {
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
  String? username;
  String? phoneno;
  int? occurance;
  String? remarks;
  String? coursename;
  DateTime? date;

  Message(
      {this.username,
      this.phoneno,
      this.occurance,
      this.remarks,
      this.coursename,
      this.date});

  Message.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    phoneno = json['phoneno'];
    occurance = json['occurance'];
    remarks = json['remarks'];
    coursename = json['coursename'];
     String dateStr = json['date'] ?? "";
    
 
    try {
     date = DateFormat("dd/MM/yyyy").parse(dateStr);  
    } catch (e) {
      print("Error parsing date: $dateStr");
     date = null; 
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['phoneno'] = this.phoneno;
    data['occurance'] = this.occurance;
    data['remarks'] = this.remarks;
    data['coursename'] = this.coursename;
data['date'] = date != null ? DateFormat("dd/MM/yyyy").format(date!) : null; 
    return data;
  }
}