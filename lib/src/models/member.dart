import 'package:flutter_community_ibague/src/models/timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'member.freezed.dart';

part 'member.g.dart';

@freezed
class Member with _$Member {
  const factory Member({
    String? uid,
    @Default('') String displayName,
    String? photoURL,
    required String email,
    @Default('') String cellPhone,
    @Default('') String gender,
    @TimestampConverter() DateTime? dateOfBirth,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}

extension MemberExtension on Member {
  bool get hasAllInformationCompleted {
    return cellPhone.isNotEmpty &&
        gender.isNotEmpty &&
        dateOfBirth != null &&
        displayName.isNotEmpty;
  }
}
