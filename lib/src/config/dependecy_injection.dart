import 'package:flutter_community_ibague/src/data/api/member_api.dart';
import 'package:flutter_community_ibague/src/domain/repository/member_repository.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

class DependecyInjection {
  static void registerInjections() {
    locator.registerSingleton<MemberApi>(MemberApiAdapter());
    locator.registerSingleton<MemberRepository>(MemberRepositoryAdapter());
  }
}
