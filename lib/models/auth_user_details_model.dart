class AuthUserDetails {
  AuthUserDetails({
    this.id,
    this.personId,
    this.firstName,
    this.lastName,
    this.username,
    this.jwtToken,
    this.refreshToken,
    this.expiresUtc,
  });

  String id;
  int personId;
  String firstName;
  String lastName;
  String username;
  String jwtToken;
  String refreshToken;
  DateTime expiresUtc;

  factory AuthUserDetails.fromJson(Map<String, dynamic> json) =>
      AuthUserDetails(
        id: json["id"],
        personId: json["personID"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        username: json["username"],
        jwtToken: json["jwtToken"],
        refreshToken: json["refreshToken"],
        expiresUtc: DateTime.parse(json["expiresUTC"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "personID": personId,
        "firstName": firstName,
        "lastName": lastName,
        "username": username,
        "jwtToken": jwtToken,
        "refreshToken": refreshToken,
        "expiresUTC": expiresUtc.toIso8601String(),
      };
}
