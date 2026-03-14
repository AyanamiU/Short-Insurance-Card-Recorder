class InsuranceRecord {
  InsuranceRecord({
    required this.id,
    required this.name,
    required this.insuranceType,
    required this.idNumber,
    required this.premium,
    required this.insuranceDate,
    required this.phone,
    this.policyHolder = '',
    this.insuredPerson = '',
    this.policyNumber = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String name;
  final String insuranceType;
  final String idNumber;
  final double premium;
  final DateTime insuranceDate;
  final String phone;
  final String policyHolder;
  final String insuredPerson;
  final String policyNumber;
  final DateTime createdAt;

  factory InsuranceRecord.fromJson(Map data) => InsuranceRecord(
        id: data['id'] as String,
        name: data['name'] as String? ?? '',
        insuranceType: data['insuranceType'] as String? ?? '',
        idNumber: data['idNumber'] as String? ?? '',
        premium: (data['premium'] as num?)?.toDouble() ?? 0,
        insuranceDate: DateTime.parse(data['insuranceDate'] as String),
        phone: data['phone'] as String? ?? '',
        policyHolder: data['policyHolder'] as String? ?? '',
        insuredPerson: data['insuredPerson'] as String? ?? '',
        policyNumber: data['policyNumber'] as String? ?? '',
        createdAt: DateTime.tryParse(data['createdAt'] as String? ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'insuranceType': insuranceType,
        'idNumber': idNumber,
        'premium': premium,
        'insuranceDate': insuranceDate.toIso8601String(),
        'phone': phone,
        'policyHolder': policyHolder,
        'insuredPerson': insuredPerson,
        'policyNumber': policyNumber,
        'createdAt': createdAt.toIso8601String(),
      };
}

