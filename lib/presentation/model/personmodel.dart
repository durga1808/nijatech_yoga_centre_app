class PersonModel {
  bool? status;
  List<Message>? message;

  PersonModel({this.status, this.message});

  PersonModel.fromJson(Map<String, dynamic> json) {
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
  String? username;
  String? userpassword;
  String? firstname;
  String? middlename;
  String? lastname;
  int? issuperuser;
  int? centerid;
  String? centername;
  String? title;
  String? gender;
  String? dob;
  String? maritialstatus;
  String? mailid;
  String? phoneno;
  String? emergencycontactperson;
  String? emergencycontactno;
  int? status;

  Message(
      {this.id,
      this.username,
      this.userpassword,
      this.firstname,
      this.middlename,
      this.lastname,
      this.issuperuser,
      this.centerid,
      this.centername,
      this.title,
      this.gender,
      this.dob,
      this.maritialstatus,
      this.mailid,
      this.phoneno,
      this.emergencycontactperson,
      this.emergencycontactno,
      this.status});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    userpassword = json['userpassword'];
    firstname = json['firstname'];
    middlename = json['middlename'];
    lastname = json['lastname'];
    issuperuser = json['issuperuser'];
    centerid = json['centerid'];
    centername = json['centername'];
    title = json['title'];
    gender = json['gender'];
    dob = json['dob'];
    maritialstatus = json['maritialstatus'];
    mailid = json['mailid'];
    phoneno = json['phoneno'];
    emergencycontactperson = json['emergencycontactperson'];
    emergencycontactno = json['emergencycontactno'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['userpassword'] = userpassword;
    data['firstname'] = firstname;
    data['middlename'] = middlename;
    data['lastname'] = lastname;
    data['issuperuser'] = issuperuser;
    data['centerid'] = centerid;
    data['centername'] = centername;
    data['title'] = title;
    data['gender'] = gender;
    data['dob'] = dob;
    data['maritialstatus'] = maritialstatus;
    data['mailid'] = mailid;
    data['phoneno'] = phoneno;
    data['emergencycontactperson'] = emergencycontactperson;
    data['emergencycontactno'] = emergencycontactno;
    data['status'] = status;
    return data;
  }
}
