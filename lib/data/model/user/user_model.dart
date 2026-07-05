




class User {
  // constructor
  User(this.userId, this.username, this.name, this.pictureUrl);

  // fields
  String userId;
  String username;
  String name;
  String pictureUrl;

  // from json
  User.fromJson(String userId, Map<String, dynamic> json)
    : this.userId = userId,
      username = json["username"] as String,
      name = json["name"] as String,
      pictureUrl = json["pictureUrl"] as String;
}