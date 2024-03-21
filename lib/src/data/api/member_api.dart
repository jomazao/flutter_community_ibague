import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_community_ibague/src/data/firebase_collections.dart';
import 'package:flutter_community_ibague/src/models/member.dart';
import 'package:flutter_community_ibague/src/models/server_exception.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class MemberApi {
  Future<Result<Member, Exception>> manageMember(Member member);

  Future<Result<Member, Exception>> getMemberByEmail({String? email});

  Future<Result<Member, Exception>> getCurrentUserLogged();

  Future<Result<Member, Exception>> createMember();
}

class MemberApiAdapter extends MemberApi {
  final _firebaseDb = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Result<Member, Exception>> manageMember(Member member) async {
    try {
      var collectionRef = _firebaseDb.collection(FirebaseCollections.user);
      await collectionRef.doc(member.uid).set(member.toJson());
      return Result.success(member);
    } on FirebaseAuthException catch (e) {
      return Result.error(
        ServerException(
          message: e.message,
          codeError: e.code,
        ),
      );
    } catch (e) {
      return Result.error(
        ServerException(
          //TODO CHANGE THIS IN THE FUTURE
          codeError: 'Ups hubo un error',
        ),
      );
    }
  }

  @override
  Future<Result<Member, Exception>> getMemberByEmail({String? email}) async {
    try {
      final userEmail = email ?? _firebaseAuth.currentUser?.email ?? '';
      final document = await _firebaseDb
          .collection(FirebaseCollections.user)
          .doc(userEmail)
          .get();
      final event = Member.fromJson(document.data()!);
      return Result.success(event);
    } on FirebaseAuthException catch (e) {
      return Result.error(
        ServerException(
          message: e.message,
          codeError: e.code,
        ),
      );
    } catch (e) {
      return Result.error(
        ServerException(
          //TODO CHANGE THIS IN THE FUTURE
          codeError: 'Ups hubo un error',
        ),
      );
    }
  }

  @override
  Future<Result<Member, Exception>> getCurrentUserLogged() async {
    try {
      final uid = _firebaseAuth.currentUser?.uid;
      final document =
          await _firebaseDb.collection(FirebaseCollections.user).doc(uid).get();
      final event = Member.fromJson(document.data()!);
      return Result.success(event);
    } on FirebaseAuthException catch (e) {
      return Result.error(
        ServerException(
          message: e.message,
          codeError: e.code,
        ),
      );
    } catch (e) {
      return Result.error(
        ServerException(
          //TODO CHANGE THIS IN THE FUTURE
          codeError: 'Ups hubo un error',
        ),
      );
    }
  }

  @override
  Future<Result<Member, Exception>> createMember() async {
    final memberToSave = Member(
      uid: _firebaseAuth.currentUser!.uid,
      email: _firebaseAuth.currentUser!.email!,
      photoURL: _firebaseAuth.currentUser?.photoURL ?? '',
    );
    return manageMember(memberToSave);
  }
}
