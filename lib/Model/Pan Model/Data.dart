class Data {
  Data({
     required this.name,
    required this.number,
    required this.typeOfHolder,
    required  this.typeOfHolderCode,
    required this.isIndividual,
    required  this.isValid,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.title,
    required this.panStatus,
    required this.panStatusCode,
    required this.lastUpdatedOn,
    required this.aadhaarSeedingStatus,
    required  this.aadhaarSeedingStatusCode,});

  Data.fromJson(dynamic json) {
    name = json['name'];
    number = json['number'];
    typeOfHolder = json['type_of_holder'];
    typeOfHolderCode = json['type_of_holder_code'];
    isIndividual = json['is_individual'];
    isValid = json['is_valid'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    title = json['title'];
    panStatus = json['pan_status'];
    panStatusCode = json['pan_status_code'];
    lastUpdatedOn = json['last_updated_on'];
    aadhaarSeedingStatus = json['aadhaar_seeding_status'];
    aadhaarSeedingStatusCode = json['aadhaar_seeding_status_code'];
  }
  String name="";
  String number="";
  String typeOfHolder="";
  String typeOfHolderCode="";
  bool isIndividual=false;
  bool isValid=false;
  String firstName="";
  String middleName="";
  String lastName="";
  String title="";
  String panStatus="";
  String panStatusCode="";
  String lastUpdatedOn="";
  String aadhaarSeedingStatus="";
  String aadhaarSeedingStatusCode="";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['number'] = number;
    map['type_of_holder'] = typeOfHolder;
    map['type_of_holder_code'] = typeOfHolderCode;
    map['is_individual'] = isIndividual;
    map['is_valid'] = isValid;
    map['first_name'] = firstName;
    map['middle_name'] = middleName;
    map['last_name'] = lastName;
    map['title'] = title;
    map['pan_status'] = panStatus;
    map['pan_status_code'] = panStatusCode;
    map['last_updated_on'] = lastUpdatedOn;
    map['aadhaar_seeding_status'] = aadhaarSeedingStatus;
    map['aadhaar_seeding_status_code'] = aadhaarSeedingStatusCode;
    return map;
  }

}