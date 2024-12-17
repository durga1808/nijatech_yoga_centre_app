class ProfileModel {
  bool? status;
  List<Message>? message;
  List<Usercourse>? usercourse;
  List<Useraddress>? useraddress;
  List<Wishesmaster>? wishesmaster;

  ProfileModel(
      {this.status,
      this.message,
      this.usercourse,
      this.useraddress,
      this.wishesmaster});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
    if (json['usercourse'] != null) {
      usercourse = <Usercourse>[];
      json['usercourse'].forEach((v) {
        usercourse!.add(Usercourse.fromJson(v));
      });
    }
    if (json['useraddress'] != null) {
      useraddress = <Useraddress>[];
      json['useraddress'].forEach((v) {
        useraddress!.add(Useraddress.fromJson(v));
      });
    }
    if (json['wishesmaster'] != null) {
      wishesmaster = <Wishesmaster>[];
      json['wishesmaster'].forEach((v) {
        wishesmaster!.add(Wishesmaster.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    if (usercourse != null) {
      data['usercourse'] = usercourse!.map((v) => v.toJson()).toList();
    }
    if (useraddress != null) {
      data['useraddress'] = useraddress!.map((v) => v.toJson()).toList();
    }
    if (wishesmaster != null) {
      data['wishesmaster'] = wishesmaster!.map((v) => v.toJson()).toList();
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

class Usercourse {
  int? id;
  int? headerdocno;
  String? courseid;
  String? coursename;
  String? level;

  Usercourse(
      {this.id, this.headerdocno, this.courseid, this.coursename, this.level});

  Usercourse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    headerdocno = json['headerdocno'];
    courseid = json['courseid'];
    coursename = json['coursename'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['headerdocno'] = headerdocno;
    data['courseid'] = courseid;
    data['coursename'] = coursename;
    data['level'] = level;
    return data;
  }
}

class Useraddress {
  int? id;
  int? headerdocno;
  String? type;
  String? address;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? zipcode;

  Useraddress(
      {this.id,
      this.headerdocno,
      this.type,
      this.address,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.country,
      this.zipcode});

  Useraddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    headerdocno = json['headerdocno'];
    type = json['type'];
    address = json['address'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipcode = json['zipcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['headerdocno'] = headerdocno;
    data['type'] = type;
    data['address'] = address;
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['zipcode'] = zipcode;
    return data;
  }
}

class Wishesmaster {
  int? id;
  int? headerdocno;
  String? wishesdate;
  String? relation;
  String? wishesname;

  Wishesmaster(
      {this.id,
      this.headerdocno,
      this.wishesdate,
      this.relation,
      this.wishesname});

  Wishesmaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    headerdocno = json['headerdocno'];
    wishesdate = json['wishesdate'];
    relation = json['relation'];
    wishesname = json['wishesname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['headerdocno'] = headerdocno;
    data['wishesdate'] = wishesdate;
    data['relation'] = relation;
    data['wishesname'] = wishesname;
    return data;
  }
}
