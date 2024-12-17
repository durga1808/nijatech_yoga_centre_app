// class CourseModelMaster {
//   bool? status;
//   List<Message>? message;

//   CourseModelMaster({this.status, this.message});

//   CourseModelMaster.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['message'] != null) {
//       message = <Message>[];
//       json['message'].forEach((v) {
//         message!.add(new Message.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.message != null) {
//       data['message'] = this.message!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Message {
//   int? docno;
//   String? date;
//   int? courseid;
//   String? coursename;
//   int? occurance;
//   String? remarks;
//   String? createdby;

//   Message(
//       {this.docno,
//       this.date,
//       this.courseid,
//       this.coursename,
//       this.occurance,
//       this.remarks,
//       this.createdby});

//   Message.fromJson(Map<String, dynamic> json) {
//     docno = json['docno'];
//     date = json['date'];
//     courseid = json['courseid'];
//     coursename = json['coursename'];
//     occurance = json['occurance'];
//     remarks = json['remarks'];
//     createdby = json['createdby'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['docno'] = this.docno;
//     data['date'] = this.date;
//     data['courseid'] = this.courseid;
//     data['coursename'] = this.coursename;
//     data['occurance'] = this.occurance;
//     data['remarks'] = this.remarks;
//     data['createdby'] = this.createdby;
//     return data;
//   }
// }