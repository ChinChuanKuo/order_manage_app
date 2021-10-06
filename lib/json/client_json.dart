class ClientJson {
  String clientid;
  String accesstoken;
  String email;

  ClientJson({
    required this.clientid,
    required this.accesstoken,
    required this.email,
  });

  static Map<String, dynamic> initialState(ClientJson clientJson) => {
        "clientid": clientJson.clientid,
        "accesstoken": clientJson.accesstoken,
        "email": clientJson.email,
      };

  factory ClientJson.fromJson(Map<String, dynamic> json) {
    return ClientJson(
      clientid: json["clientid"] as String,
      accesstoken: json["accesstoken"] as String,
      email: json["email"] as String,
    );
  }
}
