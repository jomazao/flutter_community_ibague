import 'package:flutter/cupertino.dart';
import 'package:flutter_community_ibague/src/config/dependecy_injection.dart';
import 'package:flutter_community_ibague/src/domain/repository/member_repository.dart';
import 'package:flutter_community_ibague/src/models/member.dart';
import 'package:flutter_community_ibague/src/ui/utils/string_utils.dart';
import 'package:multiple_result/multiple_result.dart';

enum FieldToUpdate {
  dateOfBirth,
  cellphone,
  gender,
  name,
}

class PersonNotifier extends ChangeNotifier {
  final MemberRepository _memberRepository = locator<MemberRepository>();
  Result<Member, Exception>? currentUser;
  bool isLoading = false;

  Future<void> init() async {
    isLoading = true;
    await getCurrentUser();
    isLoading = false;
    notifyListeners();
  }

  Future<Result<Member, Exception>> createMember() async {
    isLoading = true;
    final result = await _memberRepository.createMember();
    if (result.isSuccess()) {
      currentUser = result;
    }
    notifyListeners();
    isLoading = false;
    return result;
  }

  Future<void> getCurrentUser() async {
    currentUser = await _memberRepository.getCurrentUserLogged();
    notifyListeners();
  }

  Future<void> updateUser(FieldToUpdate fieldToUpdate, String value) async {
    await getCurrentUser();
    if (currentUser != null && currentUser!.isSuccess()) {
      final user = currentUser!.whenSuccess((member) => member);
      if (user != null) {
        final options = {
          FieldToUpdate.cellphone: () {
            return user.copyWith(
              cellPhone: value,
            );
          },
          FieldToUpdate.dateOfBirth: () {
            return user.copyWith(
              dateOfBirth: value.convertDMYToDate(),
            );
          },
          FieldToUpdate.name: () {
            return user.copyWith(
              displayName: value,
            );
          },
          FieldToUpdate.gender: () {
            return user.copyWith(
              gender: value,
            );
          },
        };
        final userToUpdate = options[fieldToUpdate]!();
        manageUser(userToUpdate);
      }
    }
  }

  Future<Result<Member, Exception>> manageUser(Member user) async {
    final result = await _memberRepository.manageMember(user);
    notifyListeners();
    return result;
  }

  void signedOut() {
    currentUser = null;
    notifyListeners();
  }
}
