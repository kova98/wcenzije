class Token {
  String value;
  String expiration;

  Token.fromJson(Map<String, dynamic> json)
      : value = json['token'],
        expiration = json['expiration'];
}
