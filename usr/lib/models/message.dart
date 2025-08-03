import 'package:couldai_user_app/models/profile.dart';

class Message {
  final String id;
  final String profileId;
  final String content;
  final DateTime createdAt;
  final Profile? profile;

  Message({
    required this.id,
    required this.profileId,
    required this.content,
    required this.createdAt,
    this.profile,
  });

  Message.fromMap({required Map<String, dynamic> map})
      : id = map['id'],
        profileId = map['profile_id'],
        content = map['content'],
        createdAt = DateTime.parse(map['created_at']),
        profile =
            map['profiles'] != null ? Profile.fromMap(map['profiles']) : null;
}
