class InOut {
  final String docId;
  final String email;
  final String inTime;
  final bool isOut;
  final String outTime;
  final String duration;
  final bool isReachedLimit;
  final String storename;
  final String date;
  final String riskstatus;
  final String username;

  InOut(
      {required this.docId,
      required this.email,
      required this.inTime,
      required this.isOut,
      required this.outTime,
      required this.duration,
      required this.isReachedLimit,
      required this.storename,
      required this.date,
      required this.riskstatus,
      required this.username});

  Map<String, dynamic> toJson() => {
        'docId': docId,
        'email': email,
        'inTime': inTime,
        'date': date,
        'outTime': outTime,
        'duration': duration,
        'isReachedLimit': isReachedLimit,
        'storename': storename,
        'isOut': isOut,
        'riskstatus': riskstatus,
        'username': username
      };
  static InOut fromJson(Map<String, dynamic> json) => InOut(
      docId: json['docId'],
      email: json['email'],
      inTime: json['inTime'],
      date: json['date'],
      outTime: json['outTime'],
      duration: json['duration'],
      isReachedLimit: json['isReachedLimit'],
      storename: json['storename'],
      isOut: json['isOut'],
      riskstatus: json['riskstatus'],
      username: json['username']);
}
