class PanCardModel {
  PanCardModel({
    required this.pan,
    required this.type,
    required this.referenceId,
    required this.nameProvided,
    required this.registeredName,
    required this.fatherName,
    required this.valid,
    required this.message,
  });

  PanCardModel.fromJson(Map<String, dynamic> json)
      : pan = json['pan'] ?? '',
        type = json['type'] ?? '',
        referenceId = json['reference_id'] ?? 0,
        nameProvided = json['name_provided'] ?? '',
        registeredName = json['registered_name'] ?? '',
        fatherName = json['father_name'] ?? '',  // Default to empty string if not provided
        valid = json['valid'] ?? false,
        message = json['message'] ?? '';

  String pan;
  String type;
  int referenceId;
  String nameProvided;
  String registeredName;
  String fatherName;
  bool valid;
  String message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pan'] = pan;
    map['type'] = type;
    map['reference_id'] = referenceId;
    map['name_provided'] = nameProvided;
    map['registered_name'] = registeredName;
    map['father_name'] = fatherName;
    map['valid'] = valid;
    map['message'] = message;
    return map;
  }
}
