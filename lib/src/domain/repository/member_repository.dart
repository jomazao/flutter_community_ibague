import 'package:flutter_community_ibague/src/config/dependecy_injection.dart';
import 'package:flutter_community_ibague/src/data/api/member_api.dart';
import 'package:flutter_community_ibague/src/models/member.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class MemberRepository {
  Future<Result<Member, Exception>> manageMember(Member member);

  Future<Result<Member, Exception>> createMember();

  ///If the func does not have an email, it will get the member data with the current user logged
  Future<Result<Member, Exception>> getMemberByEmail({String? email});

  Future<Result<Member, Exception>> getCurrentUserLogged();
}

class MemberRepositoryAdapter extends MemberRepository {
  final MemberApi _api = locator<MemberApi>();

  @override
  Future<Result<Member, Exception>> manageMember(Member member) {
    return _api.manageMember(member);
  }

  @override
  Future<Result<Member, Exception>> getMemberByEmail({String? email}) {
    return _api.getMemberByEmail(email: email);
  }

  @override
  Future<Result<Member, Exception>> createMember() {
    return _api.createMember();
  }

  @override
  Future<Result<Member, Exception>> getCurrentUserLogged() {
    return _api.getCurrentUserLogged();
  }
}
