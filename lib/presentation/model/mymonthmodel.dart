import 'package:intl/intl.dart';  

class MyMonthModel {
  bool? status;
  List<Message>? message;

  MyMonthModel({this.status, this.message});

  MyMonthModel.fromJson(Map<String, dynamic> json) {
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
  int? occurance;
  String? coursename;
  String? remarks;
  DateTime? date;  


  Message({this.occurance, this.coursename, this.remarks, this.date});

 
  Message.fromJson(Map<String, dynamic> json) {
    occurance = json['occurance'];
    coursename = json['coursename'];
    remarks = json['remarks'];

    String dateStr = json['date'] ?? "";
    
 
    try {
     date = DateFormat("dd/MM/yyyy").parse(dateStr);  
    } catch (e) {
      print("Error parsing date: $dateStr");
     date = null; 
    }
  }

 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occurance'] = occurance;
    data['coursename'] = coursename;
    data['remarks'] = remarks;
    data['date'] = date != null ? DateFormat("dd/MM/yyyy").format(date!) : null; 
    return data;
  }
}
