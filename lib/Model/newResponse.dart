class AadhaarVerificationResponse {
  final String refId;
  final String status;
  final String message;
  final String careOf;
  final String address;
  final String dob;
  final String gender;
  final String name;
  final SplitAddress splitAddress;
  final String yearOfBirth;
  final String mobileHash;
  final String photoLink;

  AadhaarVerificationResponse({
    required this.refId,
    required this.status,
    required this.message,
    required this.careOf,
    required this.address,
    required this.dob,
    required this.gender,
    required this.name,
    required this.splitAddress,
    required this.yearOfBirth,
    required this.mobileHash,
    required this.photoLink,
  });

  factory AadhaarVerificationResponse.fromJson(Map<String, dynamic> json) {
    return AadhaarVerificationResponse(
      refId: json['ref_id'],
      status: json['status'],
      message: json['message'],
      careOf: json['care_of'],
      address: json['address'],
      dob: json['dob'],
      gender: json['gender'],
      name: json['name'],
      splitAddress: SplitAddress.fromJson(json['split_address']),
      yearOfBirth: json['year_of_birth'],
      mobileHash: json['mobile_hash'],
      photoLink: json['photo_link'],
    );
  }
}

class SplitAddress {
  final String country;
  final String dist;
  final String house;
  final String landmark;
  final String pincode;
  final String po;
  final String state;
  final String street;
  final String subdist;
  final String vtc;

  SplitAddress({
    required this.country,
    required this.dist,
    required this.house,
    required this.landmark,
    required this.pincode,
    required this.po,
    required this.state,
    required this.street,
    required this.subdist,
    required this.vtc,
  });

  factory SplitAddress.fromJson(Map<String, dynamic> json) {
    return SplitAddress(
      country: json['country'],
      dist: json['dist'],
      house: json['house'],
      landmark: json['landmark'],
      pincode: json['pincode'],
      po: json['po'],
      state: json['state'],
      street: json['street'],
      subdist: json['subdist'],
      vtc: json['vtc'],
    );
  }
}
