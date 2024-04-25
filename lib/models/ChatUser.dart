

class ChatUser {

  ChatUser({
    required this.image,
    required this.instaid,
    required this.username,
    required this.instruments,
    required this.location,
    required this.id,
    required this.email,
    required this.group,
    required this.followers,
    required this.following,
  });
  late String image;
  late String instaid;
  late String username;
  late String instruments;
  late String location;
  late String id;
  late String email;
  late List group;
  late List followers;
  late List following;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    username = json['username'] ?? '';
    instruments = json['instruments'] ?? '';
    location = json['location'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    instaid=json['instaid']?? '';
    group=json['group']?? [];
    followers=json['followers']?? [];
    following=json['following']?? [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['instaid'] = instaid;
    data['username'] = username;
    data['instruments'] = instruments;
    data['location'] = location;
    data['id'] = id;
    data['email'] = email;
    data['group'] = group;
    data['followers'] = followers;
    data['following'] = following;
    return data;
  }

  static Future<ChatUser> fromMap(Map<String, dynamic> data) {
    return Future.value(ChatUser.fromJson(data));
  }
}