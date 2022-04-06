class InOut {
  final String docId;
  final String email;
  final String inTime;
  final bool isOut;
  final String outTime;
  final String duration;
  final bool isReachedLimit;
  final String storename;

  InOut({
    required this.docId,
    required this.email,
    required this.inTime,
    required this.isOut,
    required this.outTime,
    required this.duration,
    required this.isReachedLimit,
    required this.storename,
  });

  Map<String, dynamic> toJson() => {
        'docId': docId,
        'email': email,
        'inTime': inTime,
        'outTime': outTime,
        'duration': duration,
        'isReachedLimit': isReachedLimit,
        'storename': storename,
        'isOut': isOut
      };
  static InOut fromJson(Map<String, dynamic> json) => InOut(
        docId: json['docId'],
        email: json['email'],
        inTime: json['inTime'],
        outTime: json['outTime'],
        duration: json['duration'],
        isReachedLimit: json['isReachedLimit'],
        storename: json['storename'],
        isOut: json['isOut'],
      );
}
