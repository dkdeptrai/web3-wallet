import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TransactionModel {
  String? blockNum;
  String? uniqueId;
  String? hash;
  String? from;
  String? to;
  double? value;
  String? asset;
  String? category;
  RawContract? rawContract;
  Metadata? metadata;
  TransactionModel({
    this.blockNum,
    this.uniqueId,
    this.hash,
    this.from,
    this.to,
    this.value,
    this.asset,
    this.category,
    this.rawContract,
    this.metadata,
  });

  TransactionModel copyWith({
    String? blockNum,
    String? uniqueId,
    String? hash,
    String? from,
    String? to,
    double? value,
    String? asset,
    String? category,
    RawContract? rawContract,
    Metadata? metadata,
  }) {
    return TransactionModel(
      blockNum: blockNum ?? this.blockNum,
      uniqueId: uniqueId ?? this.uniqueId,
      hash: hash ?? this.hash,
      from: from ?? this.from,
      to: to ?? this.to,
      value: value ?? this.value,
      asset: asset ?? this.asset,
      category: category ?? this.category,
      rawContract: rawContract ?? this.rawContract,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'blockNum': blockNum,
      'uniqueId': uniqueId,
      'hash': hash,
      'from': from,
      'to': to,
      'value': value,
      'asset': asset,
      'category': category,
      'rawContract': rawContract?.toMap(),
      'metadata': metadata?.toMap(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      blockNum: map['blockNum'] != null ? map['blockNum'] as String : null,
      uniqueId: map['uniqueId'] != null ? map['uniqueId'] as String : null,
      hash: map['hash'] != null ? map['hash'] as String : null,
      from: map['from'] != null ? map['from'] as String : null,
      to: map['to'] != null ? map['to'] as String : null,
      value: map['value']?.toDouble(),
      asset: map['asset'] != null ? map['asset'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      rawContract: map['rawContract'] != null ? RawContract.fromMap(map['rawContract'] as Map<String, dynamic>) : null,
      metadata: map['metadata'] != null ? Metadata.fromMap(map['metadata'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) => TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class RawContract {
  String? value;
  String? decimal;
  RawContract({
    this.value,
    this.decimal,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'decimal': decimal,
    };
  }

  factory RawContract.fromMap(Map<String, dynamic> map) {
    return RawContract(
      value: map['value'] != null ? map['value'] as String : null,
      decimal: map['decimal'] != null ? map['decimal'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RawContract.fromJson(String source) => RawContract.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Metadata {
  DateTime? blockTimestamp;

  Metadata({this.blockTimestamp});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'blockTimestamp': blockTimestamp,
    };
  }

  factory Metadata.fromMap(Map<String, dynamic> map) {
    return Metadata(
      blockTimestamp: map['blockTimestamp'] != null ? DateTime.parse(map['blockTimestamp']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Metadata.fromJson(String source) => Metadata.fromMap(json.decode(source) as Map<String, dynamic>);
}
