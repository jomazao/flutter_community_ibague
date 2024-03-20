import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_community_ibague/src/config/dependecy_injection.dart';
import 'package:flutter_community_ibague/src/data/events_repository.dart';
import 'package:flutter_community_ibague/src/domain/repository/member_repository.dart';
import 'package:flutter_community_ibague/src/models/event.dart';
import 'package:flutter_community_ibague/src/models/member.dart';
import 'package:multiple_result/multiple_result.dart';

class EventNotifier extends ChangeNotifier {
  final EventsRepository _eventsRepository;
  final MemberRepository _memberRepository = locator<MemberRepository>();
  final FirebaseAuth _auth;

  Event event;

  bool get attending => event.attendees.any((uid) => uid == _user?.uid);
  late final StreamSubscription _eventSubscription;

  User? get _user => _auth.currentUser;

  EventNotifier({
    required this.event,
    EventsRepository? eventsRepository,
    FirebaseAuth? auth,
  })  : _eventsRepository = eventsRepository ?? EventsRepository(),
        _auth = auth ?? FirebaseAuth.instance {
    _eventSubscription =
        _eventsRepository.eventStream(id: event.id).listen((event) {
      this.event = event;
      notifyListeners();
    });
  }

  void attendEvent() {
    if (_user != null) {
      _eventsRepository.attendToEvent(event.id, _user!.uid);
    }
  }

  void notAttendEvent() async {
    if (_user != null) {
      _eventsRepository.notAttendToEvent(event.id, _user!.uid);
    }
  }

  Future<Result<Member, Exception>> getCurrentUser() async {
    final currentUser = await _memberRepository.getCurrentUserLogged();
    notifyListeners();
    return currentUser;
  }

  Future<Result<Member, Exception>> updateMember(Member member) async {
    final currentUser = await _memberRepository.manageMember(member);
    notifyListeners();
    return currentUser;
  }

  //TODO move this to the Data layer
  Future<void> updateName(Member member) async {
    await _auth.currentUser?.updateDisplayName(member.displayName);
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    super.dispose();
  }
}
