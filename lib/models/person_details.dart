import 'package:farmhand/models/organisation.dart';

class PersonDetails {
  PersonDetails({
    this.partyId,
    this.personTypeId,
    this.firstName,
    this.lastName,
    this.userId,
    this.organisations,
  });

  int partyId;
  int personTypeId;
  String firstName;
  String lastName;
  String userId;
  List<Organisation> organisations;

  factory PersonDetails.fromJson(Map<String, dynamic> json) => PersonDetails(
        partyId: json["partyId"],
        personTypeId: json["personTypeId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        userId: json["userId"],
        organisations: json["organisations"] == null
            ? null
            : List<Organisation>.from(
                json["organisations"].map((x) => Organisation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "partyId": partyId,
        "personTypeId": personTypeId,
        "firstName": firstName,
        "lastName": lastName,
        "userId": userId,
        "organisations":
            List<dynamic>.from(organisations.map((x) => x.toJson())),
      };
}
