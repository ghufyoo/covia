class User {
  String id;
  final String fullname;
  final String nickname;
  final num phone;
  final num NRIC;
  final bool isVaccine;

  User(
      {this.id = '',
      required this.fullname,
      required this.nickname,
      required this.phone,
      required this.NRIC,
      required this.isVaccine});

  Map<String, dynamic> toJson() => {
        'uid': id,
        'fullname': fullname,
        'nickname': nickname,
        'phonenumber': phone,
        'NRIC': NRIC,
        'isVaccine': isVaccine
      };

  static User fromJson(Map<String, dynamic> json) => User(
      id: json['uid'],
      fullname: json['fullname'],
      nickname: json['nickname'],
      phone: json['phonenumber'],
      NRIC: json['NRIC'],
      isVaccine: json['isVaccine']);
}
